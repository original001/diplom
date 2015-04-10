angular
	.module 'Diplom.controllers.Main', [] 

	.controller 'MainController', ($scope, Main) ->
		$scope.lists = []
		Main.list $scope
		# @scope.prefetch = (name)->
			# Main.prefetch 'Metro', $scope
		$scope.addSens = (nameSens, nameObj) ->
			Main.addSens nameSens, nameObj, $scope

		# Main.remove 'Obj',''
		# Main.prefetch $scope

		# Main.add 'Obj',
			# name: 'object'
			# sensCat: "1"
			# obj: "47B38F5BE4614A9BBF20114596DD3598"
			# date: new Date().getTime()

		$scope.addObj = (name) ->
			Main.addObj name, $scope

		$scope.remove = (name) ->
			Main.remove 'Obj', name

		$scope.hello = (name) ->
			Main.say name