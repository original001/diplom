moduleCtrl.controller 'ListController', ($scope, $routeParams, List) ->
	$scope.objId = $routeParams.objId
	$scope.lazyShow = false
	$scope.sensors = []

	List.list($scope, $scope.objId)

