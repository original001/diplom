moduleCtrl.controller 'MapController', ($scope, $routeParams, Map, $mdDialog, $window, $document) ->
	$scope.lists = []

	$ ->
		w = $ window
		$ '.index-md-content'
			.height w.height() - 64
		w.resize ->
			$ '.index-md-content'
				.height w.height() - 64

	$scope.addPlan =  ->
		$ ".b-plan"
			.each ->
				$ '<div class="help-screen" />'
					.appendTo $ this
					.fadeIn()
		$ document
			.on 'click','md-tab-content.md-active',(e) ->
				$plan = $ this
					.find '.b-plan'
				w = $plan.width()
				h = $plan.height()
				left = e.offsetX/w*100
				top = e.offsetY/h*100
				sensor = $ '<div />'
					.css
						top: top + '%'
						left: left + '%'
					.addClass 'sensor'
					$ this
						.find '.b-plan'
							.append sensor
		return

	$scope.addSens = (name, objId) ->
		Map.addSens name, objId, $scope