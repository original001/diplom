angular
	.module 'Diplom.controllers.Main', [] 

	.controller 'MainController', ($scope, Main, $mdDialog) ->
		$scope.lists = []
		Main.list $scope

		$scope.showConfirm = (e, id) ->
			confirm = $mdDialog.confirm()
				.parent angular.element document.body
				.title 'Вы уверены, что хотите удалить елемент'
				.ariaLabel 'Подтверждение удаления'
				.ok 'Да'
				.cancel 'Нет'
				.targetEvent(e)
			$mdDialog.show confirm
				.then ->
					Main.remove id, $scope

		$scope.addSens = (nameSens, nameObj) ->
			Main.addSens nameSens, nameObj, $scope

		$scope.update = (id, newname) ->
			Main.update id, newname, $scope

		$scope.addObj = (name) ->
			Main.addObj name, $scope

		$scope.remove = (id) ->
			Main.remove id, $scope

		$scope.hello = (name) ->
			Main.say name