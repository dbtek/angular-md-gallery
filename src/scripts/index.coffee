angular = require 'angular'

# bootstrap app
(angular.element document).ready ->
  angular.bootstrap document, [
    require './app'
    require './services'
    require './controllers'
    require './directives'
  ]
