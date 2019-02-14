describe LocalAuthority::UseCase::GetUserProjects do
  let(:users) do
    LocalAuthority::Domain::User.new.tap do |u|
      u.id = 1
      u.email = "mrcat@gov.uk"
      u.role = "LA"
      u.projects = project_ids
    end
  end

  let(:users_gateway_spy) { spy(find_by: users) }

  let(:use_case) do
    described_class.new(
      user_gateway: users_gateway_spy,
      project_gateway: project_gateway_spy
    )
  end

  let(:response) { use_case.execute(email: email)}

  before { response }

  context 'Example 1' do
    let(:email) { 'cats@he.gov' }
    let(:project_ids) { [12, 34]}
    let(:project_gateway_spy) do
      Class.new do
        attr_reader :called_with
        def initialize
          @called_with = []
        end

        def find_by(id:)
          @called_with << id
          if id == 12
            HomesEngland::Domain::Project.new.tap do |p|
              p.name = 'a project'
              p.type = 'cat'
              p.status = 'Not Done'
            end
          elsif id == 34
            HomesEngland::Domain::Project.new.tap do |p|
              p.name = 'another project'
              p.type = 'dog'
              p.status = 'unfinished'
            end
          else
            nil
          end
        end
      end.new
    end

    it 'Calls the users gateway' do
      expect(users_gateway_spy).to have_received(:find_by).with(email: email)
    end

    it 'Calls the project gateway' do
      expect(project_gateway_spy.called_with).to eq([12, 34])
    end

    it 'returns all the users projects' do
      expect(response[:project_list].length).to eq(2)
    end

    it 'returns each users projects with all info' do
      expect(response[:project_list]).to eq([{
        id: 12,
        name: 'a project',
        type: 'cat',
        status:  'Not Done'
      },
      {
        id: 34,
        name: 'another project',
        type: 'dog',
        status: 'unfinished'
      }])
    end

    context 'Added to the same project twice' do
    let(:project_ids) { [12, 12]}

      it 'it will only return the project once' do
        expect(response[:project_list].length).to eq(1)        
      end
    end
  end

  context 'Example 2' do
    let(:email) { 'cats@he.gov' }
    let(:project_ids) { [55]}
    let(:project_gateway_spy) do
      Class.new do
        attr_reader :called_with
        def initialize
          @called_with = []
        end

        def find_by(id:)
          @called_with << id
          if id == 55
            HomesEngland::Domain::Project.new.tap do |p|
              p.name = 'different'
              p.type = 'dog'
              p.status = 'Draft'
            end
          else
            nil
          end
        end
      end.new
    end

    it 'Calls the users gateway' do
      expect(users_gateway_spy).to have_received(:find_by).with(email: email)
    end

    it 'Calls the project gateway' do
      expect(project_gateway_spy.called_with).to eq([55])
    end

    it 'returns all the users projects' do
      expect(response[:project_list].length).to eq(1)
    end

    it 'returns each users projects with all info' do
      expect(response[:project_list]).to eq([{
        id: 55,
        name: 'different',
        type: 'dog',
        status:  'Draft'
      }])
    end

    context 'Added to the same project twice' do
      let(:project_ids) { [55, 55, 55]}
  
      it 'it will only return the project once' do
        expect(response[:project_list].length).to eq(1)        
      end
    end
  end
end