moduleCtrl.controller 'ListController', ($scope, $routeParams, List) ->
	$scope.objId = $routeParams.objId
	$scope.lazyShow = false
	$scope.sensors = []
	$scope.checkboxMode = true
	$scope.selected = []

	$scope.check = ->
		$scope.checkboxMode = if $scope.checkboxMode then false else true

	$scope.build = (data) ->
		console.log data

	$scope.getData = (item, list) ->
		console.log item, list

	List.list($scope, $scope.objId)


