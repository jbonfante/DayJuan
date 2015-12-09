controllers = angular.module('controllers')
controllers.controller("SectionsController", [ '$scope', '$routeParams', '$location', '$resource',
  ($scope,$routeParams,$location, $resource)->
    $scope.search = (keywords)->  $location.path("/").search('keywords',keywords)
    Recipe = $resource('/sections/:sectionId', { sectionId: "@id", format: 'json' })
    if $routeParams.keywords
      Recipe.query(keywords: $routeParams.keywords, (results)-> $scope.sections = results)
    else
      $scope.sections = []

    $scope.view = (sectionId)->
      $location.path("/sections/#{sectionId}")

    $scope.newRecipe = -> $location.path("/sections/new")
    $scope.edit = (sectionId)-> $location.path("/sections/#{sectionId}/edit")

])