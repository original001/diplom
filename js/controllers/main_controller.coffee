angular
	.module 'Diplom.controllers.Main', [] 

	.controller 'MainController', ($scope, Main) ->
		$scope.lists = []
		Main.list 'Obj', $scope

		$scope.add =  (name) ->
			Serv.add 'Obj', 
				name: name

		$scope.remove = (id) ->
			console.log id
			Serv.remove 'Obj', id

		$scope.hello = (name) ->
			Serv.say name