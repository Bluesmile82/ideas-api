#README
This project is a standard rails API with basic authentication, user roles and tested with rspec

Ruby version 2.3.0

##Deployed app

The api is live at:

[http://ideas-test-api.herokuapp.com/]

###Install

`git clone git@github.com:Bluesmile82/ideas-api.git`

`cd ideas-api`
`rake db:create db:migrate db:seed`
`cp config/application-template.yml config/application.yml`

##Usage


You can test the API with the following rake task
`rake authenticate_and_test`

And run the rspec tests
`rspec`

The routes have the following structure with basic authentication:

Index mindmaps:

`http://admin:trycatch@localhost:3000/api/v1/mindmaps`

...

##Contributing

Fork it ( https://github.com/Bluesmile82/ideas-api.git/fork )
Create your feature branch (git checkout -b my-new-feature)
Commit your changes (git commit -am 'Add some feature')
Push to the branch (git push origin my-new-feature)
Create a new Pull Request

##License

ideas-api is Copyright © 2015 Alvaro Leal. It is free software, and may be redistributed under the terms specified in the LICENSE file.
