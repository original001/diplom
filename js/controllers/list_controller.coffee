moduleCtrl.controller 'ListController', ($scope, $routeParams, List) ->
	$scope.objId = $routeParams.objId
	$scope.lazyShow = false
	$scope.sensors = []
	$scope.checkboxMode = true
	$scope.selected = []

	$scope.check = ->
		$scope.checkboxMode = if $scope.checkboxMode then false else true

	$scope.build =  ->
		console.log $scope.selected

	$scope.getData = (item, list) ->
		ind = list.indexOf(item.id)
		if ind > -1
			$scope.selected.splice ind, 1
		else
			$scope.selected.push item.id
			
	List.list($scope, $scope.objId)


