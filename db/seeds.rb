# frozen_string_literal: true

admin = User.new(
         {
                    email: Rails.application.credentials.dig(:seeds, :admin_email),
                    admin: true,
                    password: Rails.application.credentials.dig(:seeds, :admin_password),
                    password_confirmation: Rails.application.credentials.dig(:seeds, :admin_password)
                  }
                )

admin.skip_confirmation_notification!
admin.save!
admin.confirm

user = User.new(
        {
                  email: Rails.application.credentials.dig(:seeds, :user_email),
                  admin: false,
                  password: Rails.application.credentials.dig(:seeds, :user_password),
                  password_confirmation: Rails.application.credentials.dig(:seeds, :user_password)
                }
              )

user.skip_confirmation_notification!
user.save!
user.confirm

Question.create!([
                   {
                     title: 'Ruby Question',
                     body: 'Is Ruby language for backend development?',
                     user: admin,
                     answers: [
                       Answer.new(body: 'Yes', user: user),
                       Answer.new(
                         body: 'Of course',
                         user: admin,
                         best: true,
                         comments: [
                           Comment.new(body: 'Correct answer', user: user)
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Good question', user: user)
                     ],
                     links: [
                       Link.new(name: 'Google Main Page', url: 'https://google.com')
                     ],
                     votes: [
                       Vote.new(value: 1, user: user)
                     ]
                   },

                   {
                     title: 'Vue.js Question',
                     body: 'Is Vue.js framework on Ruby language?',
                     user: admin,
                     answers: [
                       Answer.new(body: 'Maybe', user: user),
                       Answer.new(
                         body: 'No',
                         user: admin,
                         best: true,
                         comments: [
                           Comment.new(body: 'Correct answer', user: user)
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Excellent question', user: user)
                     ],
                     votes: [
                       Vote.new(value: 1, user: user)
                     ]
                   },

                   {
                     title: 'Rails Question',
                     body: 'Does Rails contain find_each() method?',
                     user: user,
                     answers: [
                       Answer.new(body: 'Yes, however if you require special gem.', user: user),
                       Answer.new(
                         body: 'Yes',
                         user: admin,
                         best: true,
                         comments: [
                           Comment.new(body: 'Correct answer', user: user)
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Interesting question', user: user)
                     ],
                     links: [
                       Link.new(name: 'Github Gist', url: 'https://gist.github.com/georgiybykov/b359f9638dd8ade496f80ab43eb15189')
                     ],
                     votes: [
                       Vote.new(value: 1, user: admin)
                     ]
                   },

                   {
                     title: 'Other Question',
                     body: 'Does full stack consist of backend and frontend development?',
                     user: user,
                     answers: [
                       Answer.new(body: 'It depends of specific framework.', user: user),
                       Answer.new(
                         body: 'Yes',
                         user: admin,
                         best: true,
                         comments: [
                           Comment.new(body: 'Correct answer', user: user)
                         ],
                         links: [
                           Link.new(name: 'Github Gist', url: 'https://gist.github.com/georgiybykov/198033114d4ac9d16ed16e9248b8b81e')
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Thumbs up', user: user)
                     ],
                     links: [
                       Link.new(name: 'Yandex Main Page', url: 'https://yandex.ru')
                     ]
                   },

                   {
                     title: 'Ruby on Rails Question',
                     body: 'Had Ruby on Rails been created for design applications?',
                     user: admin,
                     answers: [
                       Answer.new(body: 'It had been created for designers.', user: user),
                       Answer.new(
                         body: 'No',
                         user: admin,
                         comments: [
                           Comment.new(body: 'Correct answer', user: user)
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Excellent question', user: user)
                     ],
                     votes: [
                       Vote.new(value: 1, user: user)
                     ]
                   },

                   {
                     title: 'JavaScript in RoR Question',
                     body: 'Could you use JavaScript language in Ruby on Rails framework?',
                     user: admin,
                     answers: [
                       Answer.new(body: 'Next question :D', user: user),
                       Answer.new(
                         body: 'Yes',
                         user: admin,
                         comments: [
                           Comment.new(body: 'Correct answer', user: user)
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Excellent question', user: user)
                     ]
                   },

                   {
                     title: 'Pipeline Question',
                     body: 'What is Assets Pipeline?',
                     user: admin,
                     answers: [
                       Answer.new(body: 'It is mechanism defined for routing.', user: user),
                       Answer.new(body: 'It is engine to render Rails views.', user: user),
                       Answer.new(
                         body: 'The asset pipeline provides a framework to concatenate and minify or compress JavaScript and CSS assets.',
                         user: admin,
                         best: true,
                         comments: [
                           Comment.new(body: 'Correct answer', user: user)
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Interesting question', user: user)
                     ],
                     votes: [
                       Vote.new(value: 1, user: user)
                     ]
                   },

                   {
                     title: 'Combinatorics Question',
                     body: 'What is Permutation?',
                     user: admin,
                     answers: [
                       Answer.new(body: 'It is the technic for getting triangle square.', user: user),
                       Answer.new(body: 'A permutation is a result of combining two imaginary squared numbers.',
                                  user: user),
                       Answer.new(
                         body: 'A permutation of a set is an arrangement of its members into a sequence or linear order, or if the set is already ordered, a rearrangement of its elements.',
                         user: admin,
                         best: true,
                         comments: [
                           Comment.new(body: 'Excellent answer', user: user)
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Mind question', user: user)
                     ]
                   },

                   {
                     title: 'Gems Question',
                     body: 'What is ActionPack?',
                     user: admin,
                     answers: [
                       Answer.new(body: 'New version of ActionView gem which is not bundled in Rails by default.',
                                  user: user),
                       Answer.new(body: 'Rails Application module to define global namespace for classes.', user: user),
                       Answer.new(
                         body: 'ActionPack is a gem bundled with Rails that consists of the Action_dispatch and Action_controller modules.',
                         user: admin,
                         best: true,
                         comments: [
                           Comment.new(body: 'Excellent answer', user: user)
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Good question', user: user)
                     ],
                     votes: [
                       Vote.new(value: 1, user: user)
                     ]
                   },

                   {
                     title: 'Pattern Question',
                     body: 'What is ActiveRecord?',
                     user: admin,
                     answers: [
                       Answer.new(body: 'New model for testing Rails applications.', user: user),
                       Answer.new(body: 'ActiveRecord is a gem for create new routes in Rails applications.',
                                  user: user),
                       Answer.new(
                         body: 'ActiveRecord is a design pattern that maps your objects to a relational database.',
                         user: admin,
                         best: true,
                         comments: [
                           Comment.new(body: 'Excellent answer', user: user)
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Good question', user: user)
                     ]
                   },

                   {
                     title: 'CI/CD Question',
                     body: 'What is CI?',
                     user: admin,
                     answers: [
                       Answer.new(
                         body: 'Continuous Integration',
                         user: user,
                         best: true,
                         comments: [
                           Comment.new(body: 'Excellent answer', user: admin)
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Good question', user: user)
                     ],
                     votes: [
                       Vote.new(value: 1, user: user)
                     ]
                   },

                   {
                     title: 'GIT Question',
                     body: 'How to switch to another branch?',
                     user: admin,
                     answers: [
                       Answer.new(
                         body: '`git checkout <branch_name>`',
                         user: admin,
                         comments: [
                           Comment.new(body: 'Excellent answer', user: user)
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Good question', user: user)
                     ]
                   },

                   {
                     title: 'GIT stash Question',
                     body: 'How to get files from stash?',
                     user: admin,
                     answers: [
                       Answer.new(
                         body: '`git stash pop` OR `git stash apply`',
                         user: admin,
                         best: true,
                         comments: [
                           Comment.new(body: 'Excellent answer', user: user)
                         ]
                       )
                     ],
                     comments: [
                       Comment.new(body: 'Good question', user: user)
                     ],
                     votes: [
                       Vote.new(value: 1, user: user)
                     ]
                   }
                 ])
