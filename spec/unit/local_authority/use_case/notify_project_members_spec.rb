describe LocalAuthority::UseCase::NotifyProjectMembers do
  let(:send_return_submission_notification_spy) { spy }
  let(:send_claim_submission_notification_spy) { spy }
  let(:emails) { [] }
  let(:get_project_users_spy) { spy(execute: { users: emails }) }
  let(:project_name) { 'project' }
  let(:find_project_spy) do
    spy(
      execute:
        {name: project_name}
    )
  end

  let(:use_case) do
    described_class.new(
      send_return_submission_notification: send_return_submission_notification_spy,
      send_claim_submission_notification: send_claim_submission_notification_spy,
      get_project_users: get_project_users_spy,
      find_project: find_project_spy
    )
  end

  context 'returns' do
    context 'single user' do
      context 'example 1' do
        let(:emails) do
          ['cat@cathouse.com']
        end
  
        let(:project_name) { 'catflap' }
  
        it 'executes the send return submission notification use case' do
          use_case.execute(project_id: 1, url: 'meow', by: 'cats')
          expect(send_return_submission_notification_spy).to have_received(:execute)
            .with(email: 'cat@cathouse.com', url: 'meow', by: 'cats', name: 'catflap')
        end
  
        it 'executes the project users use case' do
          use_case.execute(project_id: 1, url: 'meow', by: 'cats')
          expect(get_project_users_spy).to have_received(:execute)
            .with(project_id: 1)
        end
  
        it 'executes the find project use case' do
          use_case.execute(project_id: 1, url: 'meow', by: 'cats')
          expect(find_project_spy).to have_received(:execute)
            .with(id: 1)
        end
      end
  
      context 'example 2' do
        let(:emails) do
          ['dog@doghouse.com']
        end
  
        let(:project_name) { 'kennel' }
  
        it 'executes the send return submission notification use case' do
          use_case.execute(project_id: 1, url: 'woof', by: 'dogs')
          expect(send_return_submission_notification_spy).to have_received(:execute)
            .with(email: 'dog@doghouse.com', url: 'woof', by: 'dogs', name: 'kennel')
        end
  
        it 'executes the project users use case' do
          use_case.execute(project_id: 255, url: 'woof', by: 'dog')
          expect(get_project_users_spy).to have_received(:execute)
            .with(project_id: 255)
        end
  
        it 'executes the find project use case' do
          use_case.execute(project_id: 255, url: 'woof', by: 'dog')
          expect(find_project_spy).to have_received(:execute)
            .with(id: 255)
        end
      end
    end
  
    context 'multiuser' do
      context 'example 1' do
        let(:emails) do
          ['cat@cathouse.com', 'cow@cowhouse.com']
        end
  
        let(:project_name) { 'cat home' }
  
        it 'executes the send return submission notification use case' do
          use_case.execute(project_id: 1, url: 'meow', by: 'cats')
          expect(send_return_submission_notification_spy).to have_received(:execute)
            .with(email: 'cat@cathouse.com', url: 'meow', by: 'cats', name: 'cat home')
          expect(send_return_submission_notification_spy).to have_received(:execute)
            .with(email: 'cow@cowhouse.com', url: 'meow', by: 'cats', name: 'cat home')
        end
  
        it 'executes the project users use case' do
          use_case.execute(project_id: 1, url: 'meow', by: 'cats')
          expect(get_project_users_spy).to have_received(:execute)
            .with(project_id: 1)
        end
      end
  
      context 'example 2' do
        let(:emails) do
          ['mole@hole.com', 'kanga@roo.net', 'dog@doghouse.com']
        end
  
        let(:project_name) { 'dog house' }
  
        it 'executes the send return submission notification use case' do
          use_case.execute(project_id: 1, url: 'woof', by: 'dog')
          expect(send_return_submission_notification_spy).to have_received(:execute)
            .with(email: 'mole@hole.com', url: 'woof', by: 'dog', name: 'dog house')
          expect(send_return_submission_notification_spy).to have_received(:execute)
            .with(email: 'kanga@roo.net', url: 'woof', by: 'dog', name: 'dog house')
          expect(send_return_submission_notification_spy).to have_received(:execute)
            .with(email: 'dog@doghouse.com', url: 'woof', by: 'dog', name: 'dog house')
        end
      end
    end

  end

  context 'claims' do
    let(:emails) do
      ['cat@cathouse.com']
    end

    let(:project_name) { 'catflap' }

    it 'executes the send claim submission notification use case' do
      use_case.execute(project_id: 1, url: 'meow', by: 'cats', type: :claim)
      expect(send_claim_submission_notification_spy).to have_received(:execute)
        .with(email: 'cat@cathouse.com', url: 'meow', by: 'cats', name: 'catflap')
    end
  end
end
