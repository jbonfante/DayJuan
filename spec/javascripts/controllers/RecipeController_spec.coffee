describe "SectionController", ->
  scope = null
  ctrl = null
  routeParams = null
  httpBackend = null
  flash = null
  location = null
  sectionId = 42

  fakeSection =
    id: sectionId
    name: "Baked Potatoes"
    instructions: "Pierce potato with fork, nuke for 20 minutes"

  setupController = (sectionExists=true,sectionId=42)->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller, _flash_)->
      scope = $rootScope.$new()
      location = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.sectionId = sectionId if sectionId
      flash = _flash_

      if sectionId
        request = new RegExp("\/sections/#{sectionId}")
        results = if sectionExists
          [200, fakeSection]
        else
          [404]

        httpBackend.expectGET(request).respond(results[0], results[1])

      ctrl  = $controller('SectionController', $scope: scope)

    )

  beforeEach(module("dayjuan"))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    describe 'section is found', ->
      beforeEach(setupController())
      it 'loads the given section', ->
        httpBackend.flush()
        expect(scope.section).toEqualData(fakeSection)

    describe 'section is not found', ->
      beforeEach(setupController(false))
      it 'loads a given section', ->
        httpBackend.flush()
        expect(scope.section).toBe(null)
        expect(flash.error).toBe("There is no section with ID #{sectionId}")

  describe 'create', ->
    newSection =
      id: 42
      name: 'Toast'
      instructions: 'put in toaster, push lever, add butter'

    beforeEach ->
      setupController(false, false)
      request = new RegExp("\/sections")
      httpBackend.expectPOST(request).respond(201, newSection)

    it 'posts to the backend', ->
      scope.section.name = newSection.name
      scope.section.instructions = newSection.instructions
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/sections/#{newSection.id}")

  describe 'update', ->
    updatedSection =
      name: 'Toast'
      instructions: 'put in toaster, push lever, add butter'

    beforeEach ->
      setupController()
      httpBackend.flush()
      request = new RegExp("\/sections")
      httpBackend.expectPUT(request).respond(204)

    it 'posts to the backend', ->
      scope.section.name = updatedSection.name
      scope.section.instructions = updatedSection.instructions
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/sections/#{scope.section.id}")

  describe 'delete', ->
    beforeEach ->
      setupController()
      httpBackend.flush()
      request = new RegExp("\/sections/#{scope.section.id}")
      httpBackend.expectDELETE(request).respond(204)

    it 'posts to the backend', ->
      scope.delete()
      httpBackend.flush()
      expect(location.path()).toBe('/')