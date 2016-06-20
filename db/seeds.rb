RoleName.all.each do |role|
  Role.find_or_create_by({name: role})
end

admin = User.create( email: 'admin@test.com',
                     password: 'trycatch',
                     password_confirmation: 'trycatch',
                     role_id: Role.find_by(name: RoleName.enum(:admin)).id)

user = User.create( email: 'user@test.com',
                    password: 'trycatch',
                    password_confirmation: 'trycatch',
                    role_id: Role.find_by(name: RoleName.enum(:user)).id)

guest = User.create( email: 'guest@test.com',
                     password: 'trycatch',
                     password_confirmation: 'trycatch',
                     role_id: Role.find_by(name: RoleName.enum(:guest)).id)

mindmap = Mindmap.create( title: "My mindmap",
                          user_id: user.id,
                          description: "Mindblowing test mindmap",
                          private: false)
5.times do
  Idea.create( title: Faker::Superhero.power,
               description: Faker::Hipster.sentence,
               x: rand(800 - 400).to_s,
               y: rand(800 - 400).to_s,
               size: rand(6),
               url: Faker::Internet.url,
               mindmap_id: mindmap.id)
end
