moduleCtrl.controller 'TableController', ($scope, $routeParams, Table) ->
		$scope.lazyShow = false

		$ ->
			w = $ window
			$ '.index-md-content'
				.height w.height() - 64
			w.resize ->
				$ '.index-md-content'
					.height w.height() - 64

