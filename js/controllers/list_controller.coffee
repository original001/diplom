moduleCtrl.controller 'ListController', ($rootScope, $scope, $routeParams, List, $window) ->
	$scope.objId = $routeParams.objId
	$scope.lazyShow = false
	$scope.categories = []
	$scope.checkboxMode = false
	$scope.selected = []
	
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

	$scope.getData = (item, list) ->
		ind = list.indexOf(item.id)
		if ind > -1
			$scope.selected.splice ind, 1
		else
			$scope.selected.push item.id
			
	List.list($scope, $scope.objId)


