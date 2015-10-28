angular = require 'angular'

# define controllers module
angular.module 'mdGallery.controllers', [
  require './main'
  require './gallery'
  require './photo'
]

# export module name
module.exports = 'mdGallery.controllers'
