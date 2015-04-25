moduleCtrl.controller 'MapController', ($scope, $routeParams, Map, $mdDialog, $window, $document, $mdToast, $animate) ->
	$scope.tabs = [
		name: 'tab'
		img: ''
		sensors: []
	]
	$scope.mapId = 0
	$scope.lazyShow = true
	$scope.objId = $routeParams.objId

	$scope.categories = []

	$scope.listCat = ->
		Map.listCat $scope

	$scope.onTab = (id)->	
		$scope.mapId = id

	Map.list $scope, $routeParams.objId

	$ ->
		w = $ window
		$ '.index-md-content'
			.height w.height() - 64
		w.resize ->
			$ '.index-md-content'
				.height w.height() - 64

	$scope.cancelAddPlan = ->
		$ '.help-screen'
			.fadeOut 200, ->
				$ this
					.remove()
		$scope.sens.type = undefined			
		$ document
			.off 'click touchstart', 'md-tab-content.md-active'

	$scope.addSens = (log)  ->
		console.log log
		do $scope.showActionToast
		$ ".b-plan"
			.each ->
				$ '<div class="help-screen" />'
					.appendTo $ this
					.fadeIn()
		$ document
			.on 'click','md-tab-content.md-active',(e) ->
				ofsX = e.pageX - 25
				ofsY = e.pageY - 136 + $(this).scrollTop()
				$plan = $ this
					.find '.b-plan'
				w = $plan.width()
				h = $plan.height()
				left = (ofsX/w*100).toPrecision 3
				top = (ofsY/h*100).toPrecision 3

				Map.addSens 'sensor',top,left,$routeParams.objId,$scope.mapId,$scope

		return

	$scope.deletePlan = (e, id) ->
		confirm = $mdDialog.confirm()
			.parent angular.element document.body
			.title 'Вы уверены, что хотите удалить карту?'
			.ariaLabel 'Подтверждение удаления'
			.ok 'Да'
			.cancel 'Нет'
			.targetEvent(e)
		$mdDialog.show confirm
			.then ->
				Map.removePlan id, $scope

	$scope.showModalAdd = (e, name) ->
		$mdDialog.show
			controller: DialogController
			templateUrl: 'view/dialog-add-map.tpl.html'
			targetEvent: e
		.then (answer) ->
			Map.addPlan answer.name, answer.img, $scope, $routeParams.objId

	$scope.editPlan = (e, id) ->
		$mdDialog.show
			controller: DialogController
			templateUrl: 'view/dialog-edit-map.tpl.html'
			targetEvent: e
		.then (answer) ->
			Map.update id, answer.name, answer.img, $scope

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
	        .content('Режим добавления датчиков')
	        .action('Выключить')
	        .highlightAction(false)
	        .position($scope.getToastPosition());
	    $mdToast.show(toast).then ->
	    	do $scope.cancelAddPlan

