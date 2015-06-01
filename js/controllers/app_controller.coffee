moduleCtrl.controller 'AppController', ($rootScope, $scope, $window, $document, $mdSidenav, $mdUtil,$mdDialog, App) ->

	$scope.sidenavToggle = ->
		$mdSidenav 'left'
			.toggle()

	$scope.importGeo = (e) ->
		$mdSidenav 'left'
			.toggle()
		$mdDialog.show
			controller: DialogImportController
			templateUrl: 'view/dialog-import.tpl.html'
			targetEvent: e
		.then (answer) ->
			text = atob answer.base64
			rows = text.split 'Points'
			coords = []
			begin = rows[0]
			date = begin.slice(begin.indexOf('Date/Time:'))
			date = date.slice(14,date.indexOf('Job')).replace ',',''
			date = '20' + date.split( ' ')[0].split('.').reverse().join(' ')
			date = new Date date + ' ' + begin.split( ' ')[1]
			street = begin.slice(begin.indexOf('Job			:')+7,begin.indexOf('Creator'))
			street = $.trim street
			rows.forEach (row) ->
				 coords.push row.split('\n')[3]
			coords = coords.filter (a)->
				ind = a.indexOf('_')
				if ind == -1 || isNaN Number(a.slice(0, ind)) then return false else true
			for i in coords
				sens = i.slice(0, i.indexOf('_'))
				obj = i.slice(i.indexOf('_')+1,i.indexOf(' '))
				objName = "#{street} #{obj}"
				arrCoords = i.split(' ').filter (a) -> if a == '' then false else true
				params =
					e: Number arrCoords[1]
					n: Number arrCoords[2]
					h: Number arrCoords[3]

				App.importGeo $scope, sens, objName, params, date

				# console.log "Датчик: #{sens}\nДом: #{obj}\nE: #{e}\nN: #{n}\nH: #{h}"

	DialogImportController = ($scope, $mdDialog) ->
		$scope.cancel = ->
			do $mdDialog.cancel

		$scope.answer = (answer) ->
			$mdDialog.hide answer
