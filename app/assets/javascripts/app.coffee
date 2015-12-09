dayjuan = angular.module('dayjuan', [
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  'angular-flash.service',
  'angular-flash.flash-alert-directive'
])

dayjuan.config(['$routeProvider', 'flashProvider',
  ($routeProvider, flashProvider)->
    flashProvider.errorClassnames.push("alert-danger")
    flashProvider.warnClassnames.push("alert-warning")
    flashProvider.infoClassnames.push("alert-info")
    flashProvider.successClassnames.push("alert-success")

    $routeProvider
    .when('/',
      templateUrl: "index_ng.html"
      controller: 'SectionsController'
    )
    .when('/sections/new',
      templateUrl: 'form.html'
      controller: 'SectionController'
    )
    .when('/sections/:sectionId',
      templateUrl: "show.html"
      controller: 'SectionController'
    )
    .when('/sections/:sectionId/edit',
      templateUrl: 'form.html'
      controller: 'SectionController'

    )
])

controllers = angular.module('controllers', [])
