moduleCtrl.controller 'MapController', ($rootScope ,$scope, $routeParams, Map, $mdDialog, $window, $document, $mdToast, $animate) ->
	$scope.tabs = [
		name: 'tab'
		img: ''
		sensors: []
	]
	$scope.mapId = 0
	$scope.lazyShow = true
	$scope.objId = $routeParams.objId

	$scope.categories = []

	$scope.colors = ['#d11d05',"#05A3D1","#051FD1","#FF528D",'#60061E','#1d1075']
	$scope.UI = [
		name:'Транзистор СИТИС'
		id:1
	,
		name:'Транзистор C-Sensor'
		id:2
	,
		name:'Датчик давления'
		id:3
	,
		name:'Деформационная марка'
		id:4
	,
		name:'Стандартная'
		id:0
	]

	$rootScope.colors = $scope.colors
	$rootScope.UI = $scope.UI

	$scope.listCat = ->
		Map.listCat $scope 

	$scope.onTab = (id)->	
		$scope.mapId = id

	Map.list $scope, $routeParams.objId, $scope.colors

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

	$scope.addSens = (cat)  ->
		$ '.help-screen'
			.fadeOut 200, ->
				$ this
					.remove()
		$ document
			.off 'click touchstart', 'md-tab-content.md-active'
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

				Map.addSens 'sensor',cat.id, $scope.colors,top,left,$routeParams.objId,$scope.mapId,$scope

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

	$scope.addCat = (e) ->
		$mdDialog.show
			controller: CatDialogController
			templateUrl: 'view/dialog-add-category.tpl.html'
			targetEvent: e
		.then (answer) ->
			Map.addCat answer.name, answer.color, answer.ui

	CatDialogController = ($scope, $mdDialog) ->
		$scope.cancel = ->
			do $mdDialog.cancel
		$scope.answer = (answer) ->
			$mdDialog.hide answer

		$scope.colors = $rootScope.colors
		$scope.UI = $rootScope.UI

		$scope.listColor = ->
			Map.listColor $scope
