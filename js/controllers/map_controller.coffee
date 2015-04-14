moduleCtrl.controller 'MapController', ($scope, $routeParams, Map, $mdDialog, $window, $document, $mdToast, $animate) ->
	$scope.tabs = [
		name: 'tab'
		img: ''
	]
	$scope.mapId = 0
	$scope.lazyShow = true

	$scope.onTab = (id)->	
		$scope.mapId = id

	Map.list $scope, $routeParams.objId

	array = [
		name: '1 floor'	
		img: 'img/plans/plqn1.jpg'
		sensors:[
			id: '58GH7ADF68'
			top: 34.4
			left: 45.5
		,
			id: '79AF58GH'
			top: 64.4
			left: 15.5
		,
			id: '8B7AD60FB'
			top: 24.4
			left: 46.5
		]
	,
		name: '2 floor'	
		img: 'img/plans/plan_doma.gif'
		sensors:[
			id: '58GH7ADF68'
			top: 34.4
			left: 45.5
		,
			id: '79AF58GH'
			top: 64.4
			left: 15.5
		,
			id: '8B7AD60FB'
			top: 24.4
			left: 46.5
		]
	,
		name: '3 floor'	
		img: 'img/plans/zad_plan.png'
		sensors:[
			id: '58GH7ADF68'
			top: 34.4
			left: 45.5
		,
			id: '79AF58GH'
			top: 64.4
			left: 15.5
		,
			id: '8B7AD60FB'
			top: 24.4
			left: 46.5
		]
	]

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

		$ document
			.off 'click', 'md-tab-content.md-active'

	$scope.addSens =  ->
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
				sensor = $ '<a />'
					.css
						top: top + '%'
						left: left + '%'
					.addClass 'sensor'
					$ this
						.find '.b-plan'
							.append sensor
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
			templateUrl: '/view/dialog-add-map.tpl.html'
			targetEvent: e
		.then (answer) ->
			Map.addPlan answer.name, answer.img, $scope, $routeParams.objId

	$scope.editPlan = (e, id) ->
		$mdDialog.show
			controller: DialogController
			templateUrl: '/view/dialog-edit-map.tpl.html'
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
	        .content('Датчик добавлен')
	        .action('Сохранить')
	        .highlightAction(false)
	        .position($scope.getToastPosition());
	    $mdToast.show(toast).then ->
	    	do $scope.cancelAddPlan

