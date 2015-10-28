angular = require 'angular'

module.exports = 'mdGallery.controllers.photo'
angular.module 'mdGallery.controllers.photo', [
    require 'angular-material'
  ]
  .controller 'PhotoCtrl', ($scope, $mdDialog, photo) ->
    $scope.photo = photo

    $scope.close = ->
      $mdDialog.hide()
