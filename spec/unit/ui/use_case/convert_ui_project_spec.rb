# frozen_string_literal: true

describe UI::UseCase::ConvertUIProject do
  context 'Example one' do
    let(:convert_ui_ac_project_spy) { spy(execute: { data: 'ac_converted' })}
    let(:convert_ui_ff_project_spy) { spy(execute: { data: 'ff converted' })}
    let(:convert_ui_hif_project_spy) { spy(execute: { data: 'converted' })}
    let(:use_case) do
      described_class.new(
        convert_ui_hif_project: convert_ui_hif_project_spy,
        convert_ui_ac_project: convert_ui_ac_project_spy,
        convert_ui_ff_project: convert_ui_ff_project_spy
      )
    end

    context 'HIF data' do
      let(:response) { use_case.execute(project_data: { data: 'from the ui' }, type: 'hif')}

      before { response }

      it 'Calls the convert ui hif project use case with the project data' do
        expect(convert_ui_hif_project_spy).to have_received(:execute).with(
          project_data: { data: 'from the ui' }
        )
      end

      it 'Returns the data passed from convert ui hif project usecase' do
        expect(response).to eq({ data: 'converted' })
      end
    end

    context 'AC data' do
      let(:response) { use_case.execute(project_data: { data: 'from the ui' }, type: 'ac')}

      before { response }

      it 'Calls the convert ui ac project use case with the project data' do
        expect(convert_ui_ac_project_spy).to have_received(:execute).with(
          project_data: { data: 'from the ui' }
        )
      end

      it 'Returns the data passed from convert ui ac project usecase' do
        expect(response).to eq({ data: 'ac_converted' })
      end
    end

    context 'FF data' do
      let(:response) { use_case.execute(project_data: { data: 'from the ui' }, type: 'ff')}

      before { response }

      it 'Calls the convert ui ff project use case with the project data' do
        expect(convert_ui_ff_project_spy).to have_received(:execute).with(
          project_data: { data: 'from the ui' }
        )
      end

      it 'Returns the data passed from convert ui ff project usecase' do
        expect(response).to eq({ data: 'ff converted' })
      end
    end

    context 'another type' do
      let(:response) { use_case.execute(project_data: { data: 'from the ui' }, type: 'other')}

      before { response }

      it 'Calls the convert ui hif project use case with the project data' do
        expect(convert_ui_ac_project_spy).not_to have_received(:execute)
      end

      it 'Returns the data passed from convert ui hif project usecase' do
        expect(response).to eq({ data: 'from the ui' })
      end
    end

    context 'removing nils' do
      let(:convert_ui_hif_project_spy) { spy(execute: data)}
      let(:response) { use_case.execute(project_data: data, type: 'hif')}
      before { response }
      context 'a simple hash' do
        let(:data) do
          {
            one: nil,
            two: 'nil',
            three: nil,
            four: nil
          }
        end

        it 'removes the nil values' do
          expect(response).to eq({ two: 'nil'})
        end 
      end

      context 'a nested hash' do
        let(:data) do
          {
            one: nil,
            two: 'nil',
            three: {
              five: nil,
              six: 'two'
            },
            four: nil
          }
        end

        it 'removes the nil values' do
          expect(response).to eq(
            {
              two: 'nil',
              three: {
                six: 'two'
              }
            }
          )
        end 
      end

      context 'an array' do
        let(:data) do
          [{
            one: nil,
            two: 'nil',
            three: [{
              four: nil,
              five: 'five'
            }]
          }]
        end

        it 'removes the nil values' do
          expect(response).to eq(
            [{
              two: 'nil',
              three: [{
                five: 'five'
              }]
            }]
          )
        end 
      end

      context 'an array of nils' do
        let(:data) do
          [{
            one: nil,
            two: 'nil',
            three: [ nil ],
            four: ['2']
          }]
        end

        it 'removes the nil values' do
          expect(response).to eq(
            [{
              two: 'nil',
              three: [],
              four: ['2']
            }]
          )
        end 
      end

      context 'a complex array' do
        let(:data) do
          {
            one: nil,
            two: 'nil',
            three: [{
              four: nil,
              five: 'five',
              six: {
                seven: [
                  eight: nil
                ],
                nine: 'nine'
              }
            }]
          }
        end

        it 'removes the nil values' do
          expect(response).to eq(
            {
              two: 'nil',
              three: [{
                five: 'five',
                six: {
                  nine: 'nine',
                  seven: [{}]
                }
              }]
            }
          )
        end 
      end
    end
  end

  context 'Example two' do
    let(:convert_ui_ac_project_spy) { spy(execute: { data: 'ready for the ac core' })}
    let(:convert_ui_ff_project_spy) { spy(execute: { data: 'ready for the ff core' })}
    let(:convert_ui_hif_project_spy) { spy(execute: { data: 'done for hif' })}
    let(:use_case) do
      described_class.new(
        convert_ui_hif_project: convert_ui_hif_project_spy,
        convert_ui_ac_project: convert_ui_ac_project_spy,
        convert_ui_ff_project: convert_ui_ff_project_spy
      )
    end

    context 'HIF data' do
      let(:response) { use_case.execute(project_data: { data: 'data ready to be changed' }, type: 'hif')}

      before { response }

      it 'Calls the convert ui hif project use case with the project data' do
        expect(convert_ui_hif_project_spy).to have_received(:execute).with(
          project_data: { data: 'data ready to be changed' }
        )
      end

      it 'Returns the data passed from convert ui hif project usecase' do
        expect(response).to eq({ data: 'done for hif' })
      end
    end

    context 'AC data' do
      let(:response) { use_case.execute(project_data: { data: 'data ready to be changed' }, type: 'ac')}

      before { response }

      it 'Calls the convert ui hif project use case with the project data' do
        expect(convert_ui_ac_project_spy).to have_received(:execute).with(
          project_data: { data: 'data ready to be changed' }
        )
      end

      it 'Returns the data passed from convert ui hif project usecase' do
        expect(response).to eq({ data: 'ready for the ac core' })
      end
    end

    context 'FF data' do
      let(:response) { use_case.execute(project_data: { data: 'from the ui' }, type: 'ff')}

      before { response }

      it 'Calls the convert ui ff project use case with the project data' do
        expect(convert_ui_ff_project_spy).to have_received(:execute).with(
          project_data: { data: 'from the ui' }
        )
      end

      it 'Returns the data passed from convert ui ff project usecase' do
        expect(response).to eq({ data: 'ready for the ff core' })
      end
    end

    context 'another type' do
      let(:response) { use_case.execute(project_data: { data: 'data ready to be changed' }, type: 'other')}

      before { response }

      it 'Calls the convert ui hif project use case with the project data' do
        expect(convert_ui_ac_project_spy).not_to have_received(:execute)
      end

      it 'Returns the data passed from convert ui hif project usecase' do
        expect(response).to eq({ data: 'data ready to be changed' })
      end
    end
  end
end
