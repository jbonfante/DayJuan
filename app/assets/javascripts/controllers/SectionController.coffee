controllers = angular.module('controllers')
controllers.controller("SectionController", ['$scope', '$routeParams', '$resource', '$location', 'flash',
  ($scope, $routeParams, $resource, $location, flash)->
    Recipe = $resource('/sections/:sectionId', {sectionId: "@id", format: 'json'},
      {
        'save': {method: 'PUT'},
        'create': {method: 'POST'}
      }
    )

    if $routeParams.sectionId
      Recipe.get({sectionId: $routeParams.sectionId},
        ( (section)-> $scope.section = section ),
        ( (httpResponse)->
          $scope.section = null
          flash.error = "There is no section with ID #{$routeParams.sectionId}"
        )
      )
    else
      $scope.section = {}

    $scope.back = -> $location.path("/")
    $scope.edit = -> $location.path("/sections/#{$scope.section.id}/edit")
    $scope.cancel = ->
      if $scope.section.id
        $location.path("/sections/#{$scope.section.id}")
      else
        $location.path("/")

    $scope.save = ->
      onError = (_httpResponse)-> flash.error = "Something went wrong"
      if $scope.section.id
        $scope.section.$save(
          ( ()-> $location.path("/sections/#{$scope.section.id}") ),
          onError)
      else
        Recipe.create($scope.section,
          ( (newSection)-> $location.path("/sections/#{newSection.id}") ),
          onError
        )

    $scope.delete = ->
      $scope.section.$delete()
      $scope.back()


])