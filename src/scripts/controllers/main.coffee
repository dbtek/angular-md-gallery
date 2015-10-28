angular = require 'angular'
module.exports = 'mdGallery.controllers.main'

angular.module 'mdGallery.controllers.main', []
  .controller 'MainCtrl', ($scope) ->

    @photos = []

    addAlbum = (album) =>
      album = encodeURIComponent album
      j = 1
      while j < 11
        @photos.push
          url: "images/#{album}/#{j}.jpg"
          thumb: "images/thumbs/#{album}/#{j}.jpg"
          title: "#{j}.jpg"
        j++

    addAlbum 'Artist'
    addAlbum 'Back to Work'
    addAlbum 'Beach Getaway'

    return