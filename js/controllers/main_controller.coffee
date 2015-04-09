angular
	.module 'Diplom.controllers.Main', [] 

	.controller 'MainController', ($scope, Main) ->
		$scope.lists = []
		$scope.count = []
		Main.list 'Obj', $scope
		Main.prefetch $scope

		# Main.add 'Obj',
			# name: 'object'
			# sensCat: "1"
			# obj: "47B38F5BE4614A9BBF20114596DD3598"
			# date: new Date().getTime()

		$scope.add =  (name) ->
			Main.add 'Obj', 
				name: name

		$scope.remove = (name) ->
			console.log name
			Main.remove 'Obj', name

		$scope.hello = (name) ->
			Main.say name