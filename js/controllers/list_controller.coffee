moduleCtrl.controller 'ListController', ($scope, $routeParams, List) ->
	$scope.objId = $routeParams.objId
	$scope.lazyShow = false

