moduleCtrl.controller 'ListController', ($rootScope, $scope, $routeParams, List, $window, $mdDialog) ->
	$scope.objId = $routeParams.objId
	$scope.categories = []
	$scope.checkboxMode = false
	$scope.selected = []
	$scope.disable = false
	$scope.empty = false
	
	$scope.lazyShow = true
	$ ->
		w = $ window
		$ '.index-md-content'
			.height w.height() - 64
		w.resize ->
			$ '.index-md-content'
				.height w.height() - 64

	$scope.check = ->
		$scope.checkboxMode = if $scope.checkboxMode then false else true

	$scope.build =  ->
		$rootScope.multisensors = $scope.selected
		$window.location.href = "#/multisensors/#{$scope.objId}"	

	$scope.getData = (item, list, ev) ->
		for i, ind in list when i.id == item.id
				$scope.selected.splice ind, 1
				return false
		if $scope.selected.length > 9
			$mdDialog.show( 
				$mdDialog.alert()
				.parent(angular.element(document.body))
				.title('Не более 10 графиков за раз')
				.ariaLabel('count of sensor')
				.ok('Окей')
				.targetEvent(ev)
				$scope.disable = true
			).then ->
				$scope.disable = false
			return false
		$scope.selected.push
			id: item.id
			name: item.name

	List.list($scope, $scope.objId)


