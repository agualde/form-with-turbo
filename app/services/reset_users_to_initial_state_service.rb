class ResetUsersToInitialStateService
  def self.call
    ActiveRecord::Base.transaction do
      User.destroy_all

      User.create!(name: 'Andrej', email: 'andrej@mail.test', city: 'Glasgow', created_at: '2013-09-19 22:20:19')
      User.create!(name: 'Juraj', email: 'juraj@mail.test', city: 'Praha', created_at: '2013-09-19 22:20:34')
      User.create!(name: 'Jožko', email: 'jozko@mail.test', city: 'Bratislava', created_at: '2013-09-19 22:21:04')
      User.create!(name: 'Peter', email: 'peter@mail.test', city: 'Brno', created_at: '2013-09-19 22:21:17')
      User.create!(name: 'Jon', email: 'jon@mail.test', city: 'New York', created_at: '2013-09-19 22:21:41')
    end
  end
end