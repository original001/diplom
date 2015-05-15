moduleCtrl.controller 'TableController', ($scope, $routeParams, Table) ->
		$scope.lazyShow = false
		$scope.sensor =
			name: ''

		$scope.params = []
		$scope.nameOfParams = []

		Table.list $scope, $routeParams.sensId

		$ ->
			w = $ window
			$ '.index-md-content'
				.height w.height() - 64
			w.resize ->
				$ '.index-md-content'
					.height w.height() - 64

