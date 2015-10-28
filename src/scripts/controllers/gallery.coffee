angular = require 'angular'
module.exports = 'mdGallery.controllers.gallery'

angular.module 'mdGallery.controllers.gallery', [
    require 'angular-material'
  ]
  .controller 'GalleryCtrl', ($scope, $mdDialog) ->

    $scope.openPhoto = (photo, ev) ->
      $mdDialog.show
        controller: 'PhotoCtrl'
        templateUrl: 'views/photo.html'
        parent: (angular.element document.body)
        targetEvent: ev
        clickOutsideToClose: true
        photo: photo
      .then (answer) ->
          $scope.status = 'You said the information was "' + answer + '".'
          return
        , ->
          $scope.status = 'You cancelled the dialog.'
          return
      return

    return