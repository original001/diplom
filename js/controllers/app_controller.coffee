moduleCtrl.controller 'AppController', ($rootScope, $scope, $window, $document, $mdSidenav, $mdUtil) ->
	$scope.sidenavToggle = ->
		$mdSidenav 'left'
			.toggle()
			.then ->
				console.log 1
