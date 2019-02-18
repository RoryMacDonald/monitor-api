# frozen_string_literal: true

require 'rspec'

describe LocalAuthority::UseCase::GetReturn do
  let(:return_gateway) do
    spy(find_by: return_object)
  end

  let(:return_update_gateway) do
    spy(updates_for: return_updates)
  end

  let(:get_returns_spy) do
    spy(execute: { returns: [] })
  end

  let(:use_case) do
    described_class.new(
      return_gateway: return_gateway,
      return_update_gateway: return_update_gateway,
      get_returns: get_returns_spy
    )
  end
  let(:response) { use_case.execute(id: return_id) }

  before { response }

  context 'example one' do
    let(:return_id) { 10 }

    let(:previous_return_hash) do
      {
        id: 9,
        type: 'hif',
        project_id: 0,
        status: 'Submitted',
        updates: [
          { cats: 'meow' }
        ]
      }
    end

    let(:return_hash) do
      {
        id: 10,
        type: 'hif',
        project_id: 0,
        status: 'Draft',
        updates: [
          { dogs: 'woof' }
        ]
      }
    end

    let(:get_returns_spy) do
      spy(
        execute: {
          returns: [
            previous_return_hash,
            return_hash
          ]
        }
      )
    end

    let(:return_object) do
      LocalAuthority::Domain::Return.new.tap do |r|
        r.id = 10
        r.bid_id = 'HIF/MV/26'
        r.type = 'hif'
        r.project_id = 0
      end
    end

    let(:return_updates) do
      [
        LocalAuthority::Domain::ReturnUpdate.new.tap do |u|
          u.data = { dogs: 'woof' }
        end
      ]
    end

    it 'will pass the correct id to the return gateway' do
      expect(return_gateway).to have_received(:find_by).with(id: 10)
    end

    it 'will find the updates for the correct return' do
      expect(return_update_gateway).to have_received(:updates_for).with(return_id: 10)
    end

    it 'will return the return from the gateway' do
      expect(response[:id]).to eq(10)
      expect(response[:type]).to eq('hif')
      expect(response[:bid_id]).to eq('HIF/MV/26')
      expect(response[:project_id]).to eq(0)
      expect(response[:status]).to eq('Draft')
    end

    context 'given no updates' do
      let(:return_updates) { [] }

      it 'returns an empty array' do
        expect(response[:updates]).to eq([])
      end
    end

    context 'given one update' do
      let(:return_updates) do
        [
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { dogs: 'woof' }
          end
        ]
      end

      it 'returns an array with one hash' do
        expect(response[:updates].length).to eq(1)
        expect(response[:updates].first[:dogs]).to eq('woof')
      end
    end

    context 'given two updates' do
      let(:return_updates) do
        [
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { cats: 'meow' }
          end,
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { dogs: 'woof' }
          end
        ]
      end

      it 'returns an array with two hashes' do
        expect(response[:updates].length).to eq(2)
        expect(response[:updates][0]).to eq(cats: 'meow')
        expect(response[:updates][1][:dogs]).to eq('woof')
      end
    end

    it 'will execute get_returns' do
      expect(get_returns_spy).to have_received(:execute).with(project_id: 0)
    end
    context 'given there is a previous submitted return' do
      let(:get_returns_spy) do
        spy(execute: {
          returns:
            [{
              id: 1,
              project_id: 2,
              status: 'Submitted',
              updates: [{ bird: 'squarrrkk' }, { bird: 'squarrrkk' }]
            },
            {
              id: 3,
              project_id: 2,
              status: 'Submitted',
              updates: [{ bird: 'squarrrkk' }, { bird: 'squarrrkk' }]
            },
            {
              id: 5,
              project_id: 2,
              status: 'Submitted',
              updates: [{ bird: 'squarrrkk' }, { bird: 'squarrrkk' }]
            },
            {
              id: 9,
              project_id: 2,
              status: 'Submitted',
              updates: [{ bird: 'squarrrkk' }, { bird: 'squarrrkk' }]
            },
            {
              id: 12,
              project_id: 2,
              status: 'Submitted',
              updates: [{ bird: 'squarrrkk' }, { bird: 'squarrrkk' }]
            },
            {
              id: 15,
              project_id: 2,
              status: 'Submitted',
              updates: [{ bird: 'squarrrkk' }, { bird: 'squarrrkk' }]
            }]
        })
      end
      it 'will return the number of previous returns in the response' do
        expect(response[:no_of_previous_returns]).to eq(
          4
        )
      end
    end
  end

  context 'example two' do
    let(:return_id) { 50 }
    let(:return_object) do
      return_object = LocalAuthority::Domain::Return.new.tap do |r|
        r.id = 50
        r.type = 'ac'
        r.bid_id = 'AC/MV/1'
        r.project_id = 1
        r.status = 'Submitted'
      end
    end
    let(:return_updates) { [] }
    let(:get_returns_spy) do
      spy(
        execute: {
          returns: []
        }
      )
    end

    it 'will pass the correct id to the return gateway' do
      expect(return_gateway).to have_received(:find_by).with(id: 50)
    end

    it 'find the updates for the correct return' do
      expect(return_update_gateway).to have_received(:updates_for).with(return_id: 50)
    end

    it 'will return the return from the gateway' do
      expect(response[:id]).to eq(50)
      expect(response[:type]).to eq('ac')
      expect(response[:bid_id]).to eq('AC/MV/1')
      expect(response[:project_id]).to eq(1)
      expect(response[:status]).to eq('Submitted')
    end

    context 'given no updates' do
      it 'returns an empty array' do
        expect(response[:updates]).to eq([])
      end
    end

    context 'given one update' do
      let(:return_updates) do
        [
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { dogs: 'woof' }
          end
        ]
      end

      it 'returns an array with one hash' do
        expect(response[:updates]).to eq([{ dogs: 'woof' }])
      end
    end

    context 'given two updates' do
      let(:return_updates) do
        [
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { ducks: 'quack' }
          end,
          LocalAuthority::Domain::ReturnUpdate.new.tap do |update|
            update.data = { cows: 'moo' }
          end
        ]
      end

      it 'returns an array with two hashes' do
        expect(response[:updates]).to eq([{ ducks: 'quack' }, { cows: 'moo' }])
      end
    end

    it 'will execute get_returns' do
      expect(get_returns_spy).to have_received(:execute).with(project_id: 1)
    end
    context 'given there are two previous submitted return' do
      let(:get_returns_spy) do
        spy(execute: {
          returns:
            [{
              id: 1,
              project_id: 2,
              status: 'Submitted',
              updates: [{ bird: 'squarrrkk' }, { bird: 'squarrrkk' }]
            },
            {
              id: 2,
              project_id: 2,
              status: 'Submitted',
              updates: [{ bird: 'squarrrkk' }, { bird: 'squarrrkk' }]
            }]
        })
      end

      it 'will return the number of previous returns in the response' do
        expect(response[:no_of_previous_returns]).to eq(
          2
        )
      end
    end
  end
end
