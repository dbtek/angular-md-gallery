angular = require 'angular'

module.exports = 'mdGallery.directives.mdGallery'
angular.module 'mdGallery.directives.mdGallery', []
  .directive 'mdGallery', ->
    restrict: 'E'
    controller: 'GalleryCtrl'
    templateUrl: 'views/gallery.html'
    scope:
      photos: '='