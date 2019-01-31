describe HomesEngland::UseCase::PopulateBaseline do
  let(:use_case) { described_class.new(find_project: find_project, pcs_gateway: pcs_gateway)}

  context 'without feature flag' do
    before do
      ENV['PCS'] = nil
    end

    let(:pcs_gateway) { spy }
    let(:find_project) do
      spy(
        execute: {
          name: "A project",
          type: "HIF",
          data: {},
          status: "Draft"
        }
      )
    end

    it 'does not call the PCS gateway' do
      use_case.execute(project_id: 1)
      expect(pcs_gateway).not_to have_received(:get_project)
    end

    it 'calls the find project use case' do
      use_case.execute(project_id: 1)
      expect(find_project).to have_received(:execute).with(id: 1)
    end

    it 'is inert' do
      project = use_case.execute(project_id: 1)
      expect(project).to eq({
        name: "A project",
        type: "HIF",
        data: {},
        status: "Draft"
      })
    end
  end

  context 'with feature flag' do
    before do
      ENV['PCS'] = 'yes'
    end

    after do
      ENV['PCS'] = nil
    end

    context 'example 1' do
      let(:find_project) do
        spy(
          execute: {
            name: "A project",
            type: "HIF",
            data: {},
            status: "Draft"
          }
        )
      end

      let(:pcs_gateway) do
        spy(
          get_project: HomesEngland::Domain::PcsProject.new.tap do |p|
            p.project_manager = "Michael"
            p.sponsor = "MSPC"
          end
        )
      end

      it 'calls the pcs gateway' do
        use_case.execute(project_id: 1)
        expect(pcs_gateway).to have_received(:get_project).with(bid_id: 1)
      end

      it 'calls the find project use case' do
        use_case.execute(project_id: 1)
        expect(find_project).to have_received(:execute).with(id: 1)
      end

      it 'sets the relevant data' do
        data = use_case.execute(project_id: 1)
        expect(data).to eq({
          name: "A project",
          type: "HIF",
          data: {
            summary: {
              projectManager: "Michael",
              sponsor: "MSPC"
            }
          },
          status: "Draft"
        })
      end
    end

    context 'example 2' do
      let(:find_project) do
        spy(
          execute: {
            name: "Another project",
            type: "AC",
            data: {
              summary: {
                description: "An important project",
                misc: {}
              }
            },
            status: "Draft"
          }
        )
      end

      let(:pcs_gateway) do
        spy(
          get_project: HomesEngland::Domain::PcsProject.new.tap do |p|
            p.project_manager = "Aaron"
            p.sponsor = "LZMA"
          end
        )
      end

      it 'calls the pcs gateway' do
        use_case.execute(project_id: 13)
        expect(pcs_gateway).to have_received(:get_project).with(bid_id: 13)
      end

      it 'calls the find project use case' do
        use_case.execute(project_id: 13)
        expect(find_project).to have_received(:execute).with(id: 13)
      end

      it 'sets the relevant data' do
        data = use_case.execute(project_id: 1)
        expect(data).to eq({
          name: "Another project",
          type: "AC",
          data: {
            summary: {
              description: "An important project",
              misc: {},
              projectManager: "Aaron",
              sponsor: "LZMA"
            }
          },
          status: "Draft"
        })
      end
    end
  end
end
