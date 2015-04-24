moduleCtrl.controller 'MainController', ($scope, $routeParams ,Main, $mdDialog) ->
		$scope.lists = []
		$scope.lazyShow = false

		$ ->
			w = $ window
			$ '.index-md-content'
				.height w.height() - 64
			w.resize ->
				$ '.index-md-content'
					.height w.height() - 64

		Main.list $scope

		$scope.showConfirm = (e, id) ->
			confirm = $mdDialog.confirm()
				.parent angular.element document.body
				.title 'Вы уверены, что хотите удалить объект'
				.ariaLabel 'Подтверждение удаления'
				.ok 'Да'
				.cancel 'Нет'
				.targetEvent(e)
			$mdDialog.show confirm
				.then ->
					Main.remove id, $scope

		$scope.showModalAdd = (e, name) ->
			$mdDialog.show
				controller: DialogController
				templateUrl: 'view/dialog-add.tpl.html'
				targetEvent: e
			.then (answer) ->
				Main.addObj answer, $scope

		$scope.showModal = (e, id) ->
			$mdDialog.show
				controller: DialogController
				templateUrl: 'view/dialog.tpl.html'
				targetEvent: e
			.then (answer) ->
				Main.update id, answer, $scope

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

DialogController = ($scope, $mdDialog) ->
	$scope.cancel = ->
		do $mdDialog.cancel

	$scope.answer = (answer) ->
		$mdDialog.hide answer
