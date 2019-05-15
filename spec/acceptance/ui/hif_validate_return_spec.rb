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
        expect(return_validation[:invalid_paths]).to eq([
          [:infrastructures, 0, :planning, :outlinePlanning, :planningSubmitted, :percentComplete],
          [:infrastructures, 0, :planning, :outlinePlanning, :planningGranted, :percentComplete],
          [:infrastructures, 0, :planning, :fullPlanning, :submitted, :percentComplete],
          [:infrastructures, 0, :planning, :fullPlanning, :granted, :percentComplete],
          [:infrastructures, 0, :milestones, :keyMilestones, 0, :milestonePercentCompleted],
          [:infrastructures, 0, :risks, :baselineRisks, 0, :riskMet],
          [:fundingProfiles, :changeRequired],
          [:fundingPackages, 0, :fundingStack, :totalCost, :anyChange],
          [:s151Confirmation, :hifFunding, :cashflowConfirmation],
          [:s151Confirmation, :submission, :signoff],
          [:outputsForecast, :housingStarts, :anyChanges]
        ])

        expect(return_validation[:pretty_invalid_paths]).to eq([
          ['HIF Project', 'Infrastructures', 'Infrastructure 1', 'Planning', 'Outline Planning', 'Planning Permission Submitted', 'Percent Complete'],
          ['HIF Project', 'Infrastructures', 'Infrastructure 1', 'Planning', 'Outline Planning', 'Planning Permission Granted', 'Percent Complete'],
          ['HIF Project', 'Infrastructures', 'Infrastructure 1', 'Planning', 'Full Planning', 'Planning permission Submitted', 'Percent Complete'],
          ['HIF Project', 'Infrastructures', 'Infrastructure 1', 'Planning', 'Full Planning', 'Planning Permission Granted', 'Percent Complete'],
          ['HIF Project', 'Infrastructures', 'Infrastructure 1', 'Milestones', 'Key Project Milestones', 'Key Project Milestone 1', 'Percent complete'],
          ['HIF Project', 'Infrastructures', 'Infrastructure 1', 'Risks', 'Baseline Risks', 'Risk 1', 'Risk Met?'],
          ['HIF Project', 'HIF Grant Expenditure', 'Change Required?'],
          ['HIF Project', 'Funding Packages', 'Funding for Infrastructure 1', 'Funding stack', '', 'Any change to baseline/ last return?'],
          ['HIF Project', 's151 Confirmation', 'HIF Funding and Profiles', 'Please confirm you are content with the submitted project cashflows'],
          ['HIF Project', 's151 Confirmation', 'Submission', 'Signoff'],
          ['HIF Project', 'Outputs - Forecast', 'Housing Starts', 'Any changes to baseline amounts?']
        ])

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
