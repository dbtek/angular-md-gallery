angular = require 'angular'

angular.module 'mdGallery', [
    require 'angular-route'
    require 'angular-material'
  ]
  .config ($mdThemingProvider) ->
    $mdThemingProvider.theme 'default'
      .primaryPalette 'blue'
      .accentPalette 'pink'

  ###.config ($routeProvider) ->
    $routeProvider
      .when '/gallery',
        controller: 'GalleryCtrl'
        templateUrl: 'views/gallery.html'
      .otherwise redirectTo: '/gallery'
###
module.exports = 'mdGallery'
