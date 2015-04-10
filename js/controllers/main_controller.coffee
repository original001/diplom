angular
	.module 'Diplom.controllers.Main', [] 

	.controller 'MainController', ($scope, Main) ->
		$scope.lists = []
		$scope.count = 0
		Main.list 'Obj', $scope
		# @scope.prefetch = (name)->
			# Main.prefetch 'Metro', $scope
		# Main.addSens 'newsensor3', 'waxh'
		# Main.remove 'Obj','Metro'
		# Main.prefetch $scope

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