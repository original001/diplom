moduleCtrl.controller 'MapController', ($scope, $routeParams, Map, $mdDialog, $window, $document, $mdToast, $animate) ->
	$scope.lists = []
	$ ->
		w = $ window
		$ '.index-md-content'
			.height w.height() - 64
		w.resize ->
			$ '.index-md-content'
				.height w.height() - 64

	$scope.cancelAddPlan = ->
		$ '.help-screen'
			.fadeOut()
			.remove()

		$ document
			.off 'click', 'md-tab-content.md-active'

	$scope.addPlan =  ->
		toast = false
		$ ".b-plan"
			.each ->
				$ '<div class="help-screen" />'
					.appendTo $ this
					.fadeIn()
		$ document
			.on 'click','md-tab-content.md-active',(e) ->
				if !toast
					toast = true
					do $scope.showActionToast
				$plan = $ this
					.find '.b-plan'
				w = $plan.width()
				h = $plan.height()
				left = (e.offsetX/w*100).toPrecision 3
				top = (e.offsetY/h*100).toPrecision 3
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

	# toastController

	$scope.toastPosition =
	    bottom: false,
	    top: true,
	    left: false,
	    right: true

	$scope.getToastPosition = ->
	    Object.keys $scope.toastPosition 
	      .filter (pos) -> 
	      	$scope.toastPosition[pos]
	      .join ' '

	$scope.showActionToast = ->
	    toast = $mdToast.simple()
	        .content('Датчик добавлен')
	        .action('Сохранить')
	        .highlightAction(false)
	        .position($scope.getToastPosition());
	    $mdToast.show(toast).then ->
	    	do $scope.cancelAddPlan

