moduleCtrl.controller 'MapController', ($scope, $routeParams, Map, $mdDialog) ->
	$scope.lists = []

	$ ->
		w = $ window
		$ '.index-md-content'
			.height w.height() - 64
		w.resize ->
			$ '.index-md-content'
				.height w.height() - 64

	$ document
		.on 'click', '#addPlan', ->
			$ '.demo-tab'
				.each ->
					console.log 'good'

	$scope.addSens = (name, objId) ->
		Map.addSens name, objId, $scope