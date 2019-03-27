describe HomesEngland::Gateway::SequelProject do
  include_context 'with database'

  let(:project_gateway) { described_class.new(database: database) }

  context 'example one' do
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.name = 'Cat project'
        p.type = 'Animals'
        p.status = 'Draft'
        p.bid_id = 'AC/MV/1'
      end
    end
    let(:project_id) { project_gateway.create(project) }

    context 'creating the project' do
      it 'creates a new project' do
        created_project = project_gateway.find_by(id: project_id)

        expect(created_project.name).to eq('Cat project')
        expect(created_project.type).to eq('Animals')
        expect(created_project.status).to eq('Draft')
        expect(created_project.bid_id).to eq('AC/MV/1')
      end
    end

    context 'updating a project' do
      let(:data) { { contact: 'name' } }

      before { project_gateway.update(id: project_id, data: data, timestamp: 1234) }
      
      let(:updated_project) { project_gateway.find_by(id: project_id) }
      
      it 'updates the saved data' do
        expect(updated_project.data).to eq(data)
      end
      
      it 'updates the timestamp' do
        expect(updated_project.timestamp).to eq(1234)
      end
    end

    context 'submitting the project' do
      it 'sets the status as submitted' do 
        project_gateway.submit(id: project_id, status: 'Submitted')
        submitted_project = project_gateway.find_by(id: project_id)

        expect(submitted_project.status).to eq('Submitted')
      end
    end
  end

  context 'example two' do
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.name = 'New project'
        p.type = 'FarmAnimals'
        p.bid_id = 'HIF/MV/5'
      end
    end
    let(:project_id) { project_gateway.create(project) }

    context 'creating a new project' do
      it 'creates a new project' do
        id = project_gateway.create(project)

        created_project = project_gateway.find_by(id: id)

        expect(created_project.name).to eq('New project')
        expect(created_project.type).to eq('FarmAnimals')
        expect(created_project.bid_id).to eq('HIF/MV/5')
      end
    end

    context 'updating a project' do
      let(:data) do
        {
          mainContact: 'myName',
          supportingContact: 'anotherNAme'
        }
      end

      before { project_gateway.update(id: project_id, data: data, timestamp: 56) }
      let(:updated_project) { project_gateway.find_by(id: project_id) }
      
      it 'updates the saved data' do
        expect(updated_project.data).to eq(data)
      end

      it 'updates the timestamp' do
        expect(updated_project.timestamp).to eq(56)
      end
    end
  end

  context 'get all projects' do
    context 'example 1' do
      let(:project) do
        HomesEngland::Domain::Project.new.tap do |p|
          p.name = 'New project'
          p.type = 'FarmAnimals'
          p.status = 'Draft'
          p.bid_id = 'HIF/MV/7'
        end
      end
      let(:second_project) do
        HomesEngland::Domain::Project.new.tap do |p|
          p.name = 'Second New project'
          p.type = 'UrbanAnimals'
          p.status = 'Submitted'
          p.bid_id = 'HIF/MV/9'
        end
      end
      it 'returns projects from database' do
        project_gateway.create(project)
        project_gateway.create(second_project)
        all_projects = project_gateway.all
        expect(all_projects[0].name).to eq('New project')
        expect(all_projects[0].type).to eq('FarmAnimals')
        expect(all_projects[0].status).to eq('Draft')
        expect(all_projects[0].bid_id).to eq('HIF/MV/7')

        expect(all_projects[1].name).to eq('Second New project')
        expect(all_projects[1].type).to eq('UrbanAnimals')
        expect(all_projects[1].status).to eq('Submitted')
        expect(all_projects[1].bid_id).to eq('HIF/MV/9')
      end
    end
    context 'example 2' do
      let(:project) do
        HomesEngland::Domain::Project.new.tap do |p|
          p.name = 'New project2'
          p.type = 'FarmAnimals2'
          p.status = 'Draft'
          p.bid_id = 'AC/MV/66'
        end
      end
      let(:second_project) do
        HomesEngland::Domain::Project.new.tap do |p|
          p.name = 'Second New project2'
          p.type = 'UrbanAnimals2'
          p.status = 'Draft'
          p.bid_id = 'AC/MV/35'
        end
      end
      it 'returns projects from database' do
        project_id_first = project_gateway.create(project)
        project_id_second = project_gateway.create(second_project)
        all_projects = project_gateway.all
        expect(all_projects[0].id).to eq(project_id_first)
        expect(all_projects[0].name).to eq('New project2')
        expect(all_projects[0].type).to eq('FarmAnimals2')
        expect(all_projects[0].status).to eq('Draft')

        expect(all_projects[0].bid_id).to eq('AC/MV/66')

        expect(all_projects[1].id).to eq(project_id_second)
        expect(all_projects[1].name).to eq('Second New project2')
        expect(all_projects[1].type).to eq('UrbanAnimals2')
        expect(all_projects[1].bid_id).to eq('AC/MV/35')
        expect(all_projects[1].status).to eq('Draft')
      end
    end
  end
end
