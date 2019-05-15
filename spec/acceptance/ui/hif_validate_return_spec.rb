# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Validates HIF return' do
  include_context 'dependency factory'

  context 'Invalid HIF return' do

    context do
      let(:invalid_return) do
        File.open("#{__dir__}/../../fixtures/base_return.json") do |f|
          JSON.parse(
            f.read,
            symbolize_names: true
          )
        end
      end

      let(:return_validation) do
        get_use_case(:ui_validate_return).execute(type: 'hif', return_data: invalid_return)
      end

      def given_an_invalid_return
        invalid_return
      end

      def when_validated
        return_validation
      end

      def then_it_does_not_pass_validation
        expect(return_validation[:valid]).to eq(false)
      end

      it 'should return invalid if fails validation' do
        allow(ENV).to receive(:[]).and_return(true)

        given_an_invalid_return
        when_validated
        then_it_does_not_pass_validation
      end
    end

    context do
      let(:valid_return) do
        File.open("#{__dir__}/../../fixtures/hif_mvf_valid_ui_return.json") do |f|
          JSON.parse(
            f.read,
            symbolize_names: true
          )
        end
      end

      let(:return_validation) do
        get_use_case(:ui_validate_return).execute(type: 'hif', return_data: valid_return)
      end

      def given_a_valid_return
        valid_return
      end

      def when_validated
        return_validation
      end

      def then_it_passes_validation
        expect(return_validation[:valid]).to eq(true)
      end

      it 'Should return valid given valid data' do
        given_a_valid_return
        when_validated
        then_it_passes_validation
      end
    end
  end
end
