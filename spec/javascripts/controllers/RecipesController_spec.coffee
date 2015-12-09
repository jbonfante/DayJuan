describe "SectionsController", ->
  scope = null
  ctrl = null
  location = null
  routeParams = null
  resource = null

  # access injected service later
  httpBackend = null

  setupController = (keywords, results)->
    inject( ($location, $routeParams, $rootScope, $resource, $httpBackend, $controller)->
              scope                = $rootScope.$new()
              location             = $location
              resource             = $resource
              routeParams          = $routeParams
              routeParams.keywords = keywords

              # capture the injected service
              httpBackend = $httpBackend

              if results
                request = new RegExp("\/sections.*keywords=#{keywords}")
                httpBackend.expectGET(request).respond(results)

              ctrl = $controller( 'SectionsController',
                                  $scope: scope,
                                  $location: location )
          )

  beforeEach( module( "dayjuan" ) )
  beforeEach( setupController() )

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    describe 'when no keywords present', ->
      beforeEach(setupController())

      it 'defaults to no Sections', ->
        expect( scope.sections ).toEqualData( [] )

    describe 'with keywords', ->
      keywords = 'foo'
      sections = [
        {
          id: 2
          name: 'Baked Potatoes'
        },
        {
          id: 4
          name: 'Potatoes Au Gratin'
        }
      ]
      beforeEach ->
        setupController(keywords, sections)
        httpBackend.flush()

      it 'calls the back-end', ->
        expect(scope.sections).toEqualData(sections)

  describe 'search()', ->
    beforeEach ->
      setupController()

    it 'redirects to itself with a keyword param', ->
      keywords = 'foo'
      scope.search(keywords)
      expect(location.path()).toBe('/')
      expect(location.search()).toEqualData({keywords: keywords})
