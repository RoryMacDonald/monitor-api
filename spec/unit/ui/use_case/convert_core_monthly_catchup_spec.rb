describe UI::UseCase::ConvertCoreMonthlyCatchup do
  let(:convert_core_hif_monthly_catchup_spy) { spy(execute: {id: 1, project_id: 7, data:{ some_data:'cat' }, status:'Draft'}) }
  let(:usecase) do
    described_class.new(
      convert_core_hif_monthly_catchup: convert_core_hif_monthly_catchup_spy
    )
  end
  context 'hif' do
    it 'calls the convert use case' do
      usecase.execute(type: 'hif', monthly_catchup_data: { some_data: 'data value' })
      expect(convert_core_hif_monthly_catchup_spy).to have_received(:execute).with(
        monthly_catchup_data: { some_data: 'data value' }
      )
    end

    it 'returns the created monthly_catchup' do
      new_monthly_catchup = usecase.execute(type: 'hif', monthly_catchup_data: { some_data:'cat' })
      expect(new_monthly_catchup).to eq({id: 1, project_id: 7, data:{ some_data:'cat' }, status:'Draft'})
    end
  end

  context 'not hif' do
    it 'returns nil' do
      response = usecase.execute(type: 'not hif', monthly_catchup_data: { some_data: 'data value' })
      expect(response).to eq(nil)
    end
  end
end
