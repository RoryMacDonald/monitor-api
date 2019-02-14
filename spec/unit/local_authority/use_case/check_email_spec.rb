# frozen_string_literal: true

require 'rspec'


describe LocalAuthority::UseCase::CheckEmail do
  let(:use_case) { described_class.new(users_gateway: users_gateway_spy) }

  context 'calls the users_gateway' do
    let(:users_gateway_spy) { spy }
    it 'example 1' do
      use_case.execute(email_address: 'example@example.com')
      expect(users_gateway_spy).to have_received(:find_by).with(email: 'example@example.com')
    end

    it 'example 2' do
      use_case.execute(email_address: 'hello@world.com')
      expect(users_gateway_spy).to have_received(:find_by).with(email: 'hello@world.com')
    end
  end

  context 'converts email address to lower case' do
    let(:users_gateway_spy) { spy }
    it 'example 1' do
      use_case.execute(email_address: 'ExamPLE@EXAMPLE.com')
      expect(users_gateway_spy).to have_received(:find_by).with(email: 'example@example.com')
    end

    it 'example 2' do
      use_case.execute(email_address: 'HELLO@WoRLD.cOM')
      expect(users_gateway_spy).to have_received(:find_by).with(email: 'hello@world.com')
    end
  end

  context 'returns a boolean' do
    context 'existent email' do
      context 'example 1' do
        let(:found_user) do
          LocalAuthority::Domain::User.new.tap do |u|
            u.id = 0
            u.email = 'example@example.com'
            u.projects = [0]
          end
        end
        let(:users_gateway_spy) { spy(find_by: found_user) }

        it 'returns true' do
          returned_hash = use_case.execute(email_address: 'example@example.com')
          expect(returned_hash).to eq(valid: true)
        end
      end

      context 'example 2' do
        let(:found_user) do
          LocalAuthority::Domain::User.new.tap do |u|
            u.id = 0
            u.email = 'cat@cathouse.com'
            u.projects = [8]
          end
        end
        let(:users_gateway_spy) { spy(find_by: found_user) }

        it 'returns true' do
          returned_hash = use_case.execute(email_address: 'example@example.com')
          expect(returned_hash).to eq(valid: true)
        end
      end
    end

    context 'non-existent email' do
      let(:users_gateway_spy) { spy(find_by: nil) }

      it 'returns false' do
        returned_hash = use_case.execute(email_address: 'example@example.com')
        expect(returned_hash).to eq(valid: false)
      end
    end
  end
end
