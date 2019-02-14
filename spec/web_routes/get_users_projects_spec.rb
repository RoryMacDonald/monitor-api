# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Getting project list for a user' do
  let(:project_list) {[]}
  let(:email) {''}
  let(:get_user_projects_spy) { spy(execute: {project_list: project_list}) }

  before do
    
    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: double(execute: { valid: token_valid, email: email }))
      )
      
    stub_const(
      'LocalAuthority::UseCase::GetUserProjects',
      double(new: get_user_projects_spy)
    )

    header 'API_KEY', 'superSecret'
    get "/user/projects"
  end

  context 'with no valid token' do
    let(:token_valid) { false }

    it 'Returns a 401' do
      expect(last_response.status).to eq(401)
    end
  end

  context 'with an valid id' do
    let(:token_valid) { true }
    let(:email) { 'cats@he.gov.uk' }

    context 'example one' do
      let(:project_list) do 
        [
          {
            project_id: 42,
            type: 'ac',
            status: 'Draft'
          },
          {
            project_id: 67,
            type: 'hif',
            status: 'Submitted'
          }
        ]
      end

      it 'should find the projects associated with the users email' do
        expect(get_user_projects_spy).to have_received(:execute).with(email: 'cats@he.gov.uk')
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should pass a cache-control header' do
        expect(last_response.headers['Cache-Control']).to eq('no-cache')
      end

      it 'should have projects in body with camel case' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['project_list'][0]['project_id']).to eq(42)
        expect(response_body['project_list'][0]['type']).to eq('ac')
        expect(response_body['project_list'][0]['status']).to eq('Draft')
        expect(response_body['project_list'][1]['project_id']).to eq(67)
        expect(response_body['project_list'][1]['type']).to eq('hif')
        expect(response_body['project_list'][1]['status']).to eq('Submitted')
      end
    end

    context 'example two' do
    let(:email) { 'catmaster@he.gov.uk' }

      let(:project_list) do 
        [
          {
            project_id: 1,
            type: 'cat',
            status: 'not done'
          }
        ]
      end

      it 'should find the projects associated with the users email' do
        expect(get_user_projects_spy).to have_received(:execute).with(email: 'catmaster@he.gov.uk')
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should pass a cache-control header' do
        expect(last_response.headers['Cache-Control']).to eq('no-cache')
      end

      it 'should have projects in body with camel case' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['project_list'][0]['project_id']).to eq(1)
        expect(response_body['project_list'][0]['type']).to eq('cat')
        expect(response_body['project_list'][0]['status']).to eq('not done')
      end
    end
  end
end