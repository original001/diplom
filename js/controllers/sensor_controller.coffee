moduleCtrl.controller 'SensController', ($scope, $routeParams ,Sens) ->
		$scope.sensor = []
		$scope.name = ''

		Sens.list $scope, $routeParams.sensId
