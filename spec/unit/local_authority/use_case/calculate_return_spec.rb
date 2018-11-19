describe LocalAuthority::UseCase::CalculateReturn do
  describe 'calls the calculate HIF return use case' do
    describe 'without previous return' do
      example 'example 1' do
        hif_return = {
          id: 255,
          type: 'hif',
          project_id: 64,
          status: 'Draft',
          updates: [
            {
              cats: 'meow',
              dogs: 'woof'
            }
          ]
        }

        calculate_hif_return = spy(execute: {})
        calculate_ac_return = spy(execute: {})
        usecase = described_class.new(
          calculate_hif_return: calculate_hif_return,
          calculate_ac_return: calculate_ac_return
        )
        usecase.execute(return_with_no_calculations: hif_return, previous_return: nil)
        expect(calculate_hif_return).to have_received(:execute).with(
          return_data_with_no_calculations: { cats: 'meow', dogs: 'woof' },
          previous_return: nil
        )
        expect(calculate_ac_return).to_not have_received(:execute)
      end

      example 'example 2' do
        hif_return = {
          id: 192,
          type: 'hif',
          project_id: 168,
          status: 'Draft',
          updates: [
            {
              duck: 'quack',
              cows: 'moo'
            }
          ]
        }

        calculate_hif_return = spy(execute: {})
        calculate_ac_return = spy(execute: {})
        usecase = described_class.new(
          calculate_hif_return: calculate_hif_return,
          calculate_ac_return: calculate_ac_return
        )
        usecase.execute(return_with_no_calculations: hif_return, previous_return: nil)
        expect(calculate_hif_return).to have_received(:execute).with(
          return_data_with_no_calculations: { duck: 'quack', cows: 'moo' },
          previous_return: nil
        )
        expect(calculate_ac_return).to_not have_received(:execute)
      end
    end

    describe 'with previous return' do
      describe 'with multiple updates' do
        example 'example 1' do
          previous_hif_return = {
            id: 101,
            type: 'hif',
            project_id: 64,
            status: 'Submitted',
            updates: [
              {
                beaver: 'racoon'
              },
              {
                cashews: 'fruit'
              }
            ]
          }

          hif_return = {
            id: 255,
            type: 'hif',
            project_id: 64,
            status: 'Draft',
            updates: [
              {
                racoon: 'beaver'
              },
              {
                cats: 'meow',
                dogs: 'woof'
              }
            ]
          }

          calculate_hif_return = spy(execute: {})
          calculate_ac_return = spy(execute: {})
          usecase = described_class.new(
            calculate_hif_return: calculate_hif_return,
            calculate_ac_return: calculate_ac_return
          )
          usecase.execute(return_with_no_calculations: hif_return, previous_return: previous_hif_return)
          expect(calculate_hif_return).to have_received(:execute).with(
            return_data_with_no_calculations: { cats: 'meow', dogs: 'woof' },
            previous_return: { cashews: 'fruit' }
          )
          expect(calculate_ac_return).to_not have_received(:execute)
        end

        example 'example 2' do
          previous_hif_return = {
            id: 80,
            type: 'hif',
            project_id: 168,
            status: 'Submitted',
            updates: [
              {
                badgers: 'badgers'
              }
            ]
          }

          hif_return = {
            id: 192,
            type: 'hif',
            project_id: 168,
            status: 'Draft',
            updates: [
              {
                duck: 'quack',
                cows: 'moo'
              }
            ]
          }

          calculate_hif_return = spy(execute: {})
          calculate_ac_return = spy(execute: {})
          usecase = described_class.new(
            calculate_hif_return: calculate_hif_return,
            calculate_ac_return: calculate_ac_return
          )
          usecase.execute(return_with_no_calculations: hif_return, previous_return: previous_hif_return)
          expect(calculate_hif_return).to have_received(:execute).with(
            return_data_with_no_calculations: { duck: 'quack', cows: 'moo' },
            previous_return: { badgers: 'badgers' }
          )
          expect(calculate_ac_return).to_not have_received(:execute)
        end
      end

      describe 'with single updates' do
        example 'example 1' do
          previous_hif_return = {
            id: 101,
            type: 'hif',
            project_id: 64,
            status: 'Submitted',
            updates: [
              {
                cashews: 'fruit'
              }
            ]
          }

          hif_return = {
            id: 255,
            type: 'hif',
            project_id: 64,
            status: 'Draft',
            updates: [
              {
                cats: 'meow',
                dogs: 'woof'
              }
            ]
          }

          calculate_hif_return = spy(execute: {})
          calculate_ac_return = spy(execute: {})
          usecase = described_class.new(
            calculate_hif_return: calculate_hif_return,
            calculate_ac_return: calculate_ac_return
          )
          usecase.execute(return_with_no_calculations: hif_return, previous_return: previous_hif_return)
          expect(calculate_hif_return).to have_received(:execute).with(
            return_data_with_no_calculations: { cats: 'meow', dogs: 'woof' },
            previous_return: { cashews: 'fruit' }
          )
          expect(calculate_ac_return).to_not have_received(:execute)
        end

        example 'example 2' do
          previous_hif_return = {
            id: 80,
            type: 'hif',
            project_id: 168,
            status: 'Submitted',
            updates: [
              {
                badgers: 'badgers'
              }
            ]
          }

          hif_return = {
            id: 192,
            type: 'hif',
            project_id: 168,
            status: 'Draft',
            updates: [
              {
                duck: 'quack',
                cows: 'moo'
              }
            ]
          }

          calculate_hif_return = spy(execute: {})
          calculate_ac_return = spy(execute: {})
          usecase = described_class.new(
            calculate_hif_return: calculate_hif_return,
            calculate_ac_return: calculate_ac_return
          )
          usecase.execute(return_with_no_calculations: hif_return, previous_return: previous_hif_return)
          expect(calculate_hif_return).to have_received(:execute).with(
            return_data_with_no_calculations: { duck: 'quack', cows: 'moo' },
            previous_return: { badgers: 'badgers' }
          )
          expect(calculate_ac_return).to_not have_received(:execute)
        end
      end
    end
  end

  describe 'calls the calculate AC return use case' do
    describe 'with previous return' do
      describe 'with multiple updates' do
        example 'example 1' do
          previous_ac_return = {
            id: 192,
            type: 'ac',
            project_id: 164,
            status: 'Submitted',
            updates: [
              {
                cats: 'keyboard'
              },
              {
                narwhals: 'narwhals'
              }
            ]
          }

          ac_return = {
            id: 255,
            type: 'ac',
            project_id: 164,
            status: 'Draft',
            updates: [
              {
                babies: 'laughing'
              },
              {
                cats: 'meow',
                dogs: 'woof'
              }
            ]
          }

          calculate_hif_return = spy(execute: {})
          calculate_ac_return = spy(execute: {})
          usecase = described_class.new(
            calculate_hif_return: calculate_hif_return,
            calculate_ac_return: calculate_ac_return
          )
          usecase.execute(return_with_no_calculations: ac_return, previous_return: previous_ac_return)
          expect(calculate_ac_return).to have_received(:execute).with(
            return_data_with_no_calculations: { cats: 'meow', dogs: 'woof' },
            previous_return: { narwhals: 'narwhals' }
          )
          expect(calculate_hif_return).to_not have_received(:execute)
        end

        example 'example 2' do
          previous_ac_return = {
            id: 2,
            type: 'ac',
            project_id: 164,
            status: 'Submitted',
            updates: [
              {
                jaguar: 'panther'
              },
              {
                snow_leopard: 'leopard'
              }
            ]
          }

          ac_return = {
            id: 4,
            type: 'ac',
            project_id: 164,
            status: 'Draft',
            updates: [
              {
                lion: 'mountain lion'
              },
              {
                cats: 'meow',
                dogs: 'woof'
              }
            ]
          }

          calculate_hif_return = spy(execute: {})
          calculate_ac_return = spy(execute: {})
          usecase = described_class.new(
            calculate_hif_return: calculate_hif_return,
            calculate_ac_return: calculate_ac_return
          )
          usecase.execute(return_with_no_calculations: ac_return, previous_return: previous_ac_return)
          expect(calculate_ac_return).to have_received(:execute).with(
            return_data_with_no_calculations: { cats: 'meow', dogs: 'woof' },
            previous_return: { snow_leopard: 'leopard' }
          )
          expect(calculate_hif_return).to_not have_received(:execute)
        end
      end

      describe 'with single updates' do
        example 'example 1' do
          previous_ac_return = {
            id: 192,
            type: 'ac',
            project_id: 164,
            status: 'Submitted',
            updates: [
              {
                narwhals: 'narwhals'
              }
            ]
          }

          ac_return = {
            id: 255,
            type: 'ac',
            project_id: 164,
            status: 'Draft',
            updates: [
              {
                cats: 'meow',
                dogs: 'woof'
              }
            ]
          }

          calculate_hif_return = spy(execute: {})
          calculate_ac_return = spy(execute: {})
          usecase = described_class.new(
            calculate_hif_return: calculate_hif_return,
            calculate_ac_return: calculate_ac_return
          )
          usecase.execute(return_with_no_calculations: ac_return, previous_return: previous_ac_return)
          expect(calculate_ac_return).to have_received(:execute).with(
            return_data_with_no_calculations: { cats: 'meow', dogs: 'woof' },
            previous_return: { narwhals: 'narwhals' }
          )
          expect(calculate_hif_return).to_not have_received(:execute)
        end

        example 'example 2' do
          previous_ac_return = {
            id: 2,
            type: 'ac',
            project_id: 164,
            status: 'Submitted',
            updates: [
              {
                snow_leopard: 'leopard'
              }
            ]
          }

          ac_return = {
            id: 4,
            type: 'ac',
            project_id: 164,
            status: 'Draft',
            updates: [
              {
                cats: 'meow',
                dogs: 'woof'
              }
            ]
          }

          calculate_hif_return = spy(execute: {})
          calculate_ac_return = spy(execute: {})
          usecase = described_class.new(
            calculate_hif_return: calculate_hif_return,
            calculate_ac_return: calculate_ac_return
          )
          usecase.execute(return_with_no_calculations: ac_return, previous_return: previous_ac_return)
          expect(calculate_ac_return).to have_received(:execute).with(
            return_data_with_no_calculations: { cats: 'meow', dogs: 'woof' },
            previous_return: { snow_leopard: 'leopard' }
          )
          expect(calculate_hif_return).to_not have_received(:execute)
        end
      end
    end

    describe 'without previous return' do
      example 'example 1' do
        ac_return = {
          id: 255,
          type: 'ac',
          project_id: 64,
          status: 'Draft',
          updates: [
            {
              cats: 'meow',
              dogs: 'woof'
            }
          ]
        }

        calculate_hif_return = spy(execute: {})
        calculate_ac_return = spy(execute: {})
        usecase = described_class.new(
          calculate_hif_return: calculate_hif_return,
          calculate_ac_return: calculate_ac_return
        )
        usecase.execute(return_with_no_calculations: ac_return, previous_return: nil)
        expect(calculate_ac_return).to have_received(:execute).with(
          return_data_with_no_calculations: { cats: 'meow', dogs: 'woof' },
          previous_return: nil
        )
        expect(calculate_hif_return).to_not have_received(:execute)
      end

      example 'example 2' do
        ac_return = {
          id: 192,
          type: 'ac',
          project_id: 168,
          status: 'Draft',
          updates: [
            {
              duck: 'quack',
              cows: 'moo'
            }
          ]
        }

        calculate_hif_return = spy(execute: {})
        calculate_ac_return = spy(execute: {})
        usecase = described_class.new(
          calculate_hif_return: calculate_hif_return,
          calculate_ac_return: calculate_ac_return
        )
        usecase.execute(return_with_no_calculations: ac_return, previous_return: nil)
        expect(calculate_ac_return).to have_received(:execute).with(
          return_data_with_no_calculations: { duck: 'quack', cows: 'moo' },
          previous_return: nil
        )
        expect(calculate_hif_return).to_not have_received(:execute)
      end
    end
  end
end
