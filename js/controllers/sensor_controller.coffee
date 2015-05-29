moduleCtrl.controller 'SensController', ($rootScope, $scope, $routeParams ,Sens, $window, $document, $mdDialog) ->
	$scope.sensor = []
	$scope.graph = []
	$scope.categories = []
	$scope.paramInput = false

	$scope.keys = []
	Sens.loadKeySens $routeParams.sensId, $scope

	$g = $ '#graph'
	s = Snap '#graph'
	paper = s.paper

	updatePath =  (arr,paramY,multi) ->
		do paper.clear

		arr = arr.filter (el, i, a) -> 
			if el.params.hasOwnProperty paramY then return true else false
		return false unless arr.length

		arr = arr.sort (a,b) -> 
			a.date.getTime() - b.date.getTime()

		num = arr.length
		h = 320/2
		w = 80*num
		if w > $g.width()
			$g.width w + 40

		style =
			stroke: '#000'

		paper
			.path "M 5,#{h*2-5}L #{w+10},#{h*2-5},#{w},#{h*2-10},#{w},#{h*2},#{w+10},#{h*2-5},"
			.attr style

		paper
			.path "M 5,#{h*2-5}L 5,0,10,10,0,10,5,0"
			.attr style

		kx = (- arr[0].date.getTime() + arr[num - 1].date.getTime())/w
		minx = arr[0].date.getTime()

		paramArr = []
		for i in arr
			paramArr.push i.params[paramY]
		maxy = Math.max.apply Math, paramArr
		miny = Math.min.apply Math, paramArr
		ky = (maxy - miny)/(h+50)

		getx = (x) ->
			return 5 unless kx
			(x.date.getTime() - minx)/kx + 5
		gety = (y) ->
			return h unless ky
			h + 120 - (y.params[paramY] - miny)/ky

		paper.text 10,20, paramY
		paper.text w+15,h*2, 't'

		for el,ind in arr
			time = [
				el.date.getDate()	
				el.date.getMonth()+1	
				el.date.getFullYear()-2000	
				].join '.'
			paper
				.circle getx(el), gety(el), 3
				.attr
					fill: '#CB0000'
			paper.text getx(el) - 3 , gety(el) - 10, absCeil el.params[paramY], false, 4
			paper
				.text getx(el) - 3 , h*2, time
				.transform 'r90,'+(getx(el)-5)+','+h*2
			if ind == 0 then continue

			paper
				.path "M #{getx(el)},#{gety(el)}L#{getx(el)},#{h*2-5}"
				.attr
					stroke: '#00BCD4'

			paper
				.path 'M '+getx(arr[ind-1])+','+gety(arr[ind-1])+'L '+getx(el)+','+gety(el)
				.attr style	

					
	$scope.addParam = ->
		unless $scope.paramInput 
			$scope.paramInput  = true
		else unless $scope.paramName
			$scope.paramInput  = false
		else
			$scope.paramInput  = false
			$scope.addingParams.push $scope.paramName
			$scope.params.push $scope.paramName

	$scope.updatePath = (param) ->
		updatePath $scope.graph, param

	$scope.removeSens = (e) ->
		confirm = $mdDialog.confirm()
			.parent angular.element document.body
			.title 'Вы уверены, что хотите удалить датчик?'
			.ariaLabel 'Подтверждение удаления'
			.ok 'Да'
			.cancel 'Нет'
			.targetEvent(e)
		$mdDialog.show confirm
			.then ->
				Sens.removeSens $routeParams.sensId, $scope

	$scope.import = (e) ->
		$mdDialog.show
			controller: DialogImportController
			templateUrl: 'view/dialog-import.tpl.html'
			targetEvent: e
		.then (answer) ->
			# clear array with filter.array
			text = atob answer.base64
			textArr = text.split '--------------------'
			SensName = $scope.sensor[0].name
			sna = SensName.split '-'

			counter = 0
			for i,ind in textArr when i
				localSensName = "#{sna[0]}-#{Number(sna[1]) + counter}"
				trimText =  $.trim textArr[ind]
				trimText = trimText.replace '\n',' '

				textDate = trimText.split(' ')[0]
				textParams = trimText.split(' ')[1]
				tpa = textParams.split(';')
				textTime = tpa[0]

				counter++

				answer = 
					params: 
						t:tpa[1].replace ',','.'
						f:tpa[2].replace ',','.'

				Sens.addManyGraphs $routeParams.sensId,localSensName, new Date("#{textDate.replace('/',' ')} #{textTime}"),countParams(answer), $scope
			


	$scope.editSens = (e) ->
		$mdDialog.show
			controller: SensEditDialogController
			templateUrl: 'view/dialog-edit-sens.tpl.html'
			targetEvent: e
		.then (answer) ->
			Sens.editSens answer.name, answer.category, answer.keys , $routeParams.sensId, $scope

	$scope.removeGraph = ->
		Sens.removeGraph $scope

	$scope.addGraph = (e) ->
		$mdDialog.show
			controller: SensDialogController
			templateUrl: 'view/dialog-add-graph.tpl.html'
			targetEvent: e
		.then (answer) ->
			Sens.addGraph answer.date, countParams(answer), $scope, $routeParams.sensId

	# работа с формулами (константы для датчиков устанавливаются в файле map_service.coffee)
	countParams = (answer) ->
		switch $routeParams.ui

			# логика работы для тензометра СИТИС
			when '1' 
				for i in $scope.keys
					switch i.name
						when 'K' then k = i.val
						when 'α' then a = i.val
						when 'ß' then b = i.val
						when 'T0' then T0 = i.val
				params = {}
				if answer.params.f?
					F = params.f = absCeil answer.params.f, true, 4, true
					T = params.t = absCeil answer.params.t, true, 4, true
					T0 || T0 = T
					me = params.me = Math.pow(F,2) * 0.001 * k * 4.479 # K & G
					dme = params.dme = me + (T-T0)*(a-b)
					params.g =absCeil me * 210 * 0.001, true, 4, true
					params.dg =absCeil dme * 210 * 0.001, true, 4, true
				for k, v of answer.params when k != 'f'
					params[k] = v	

			# логика работы для тензометра C-Sensor
			when '2' 
				for i in $scope.keys
					switch i.name
						when 'ТСк' then TCk = i.val
						when 'TCд' then TCd = i.val
						when 'F0' then F0 = i.val
						when 'T0' then T0 = i.val
				params = {}
				if answer.params.f?
					F = params.f = answer.params.f
					T = params.t = answer.params.t 
					T0 || T0 = T
					F0 || F0 = F
					me = params.me = Math.pow(F,2) * 0.001 * 4.062
					dme = params.dme = Math.pow((F-F0),2)*4.062/1000-(TCk-TCd)*(T-T0)
					params.g = me * 210 * 0.001
					params.dg = dme * 210 * 0.001
				for k, v of answer.params when k != 'f'
					params[k] = v	


			# Струнный датчик давления CS-05 (C-Sensor)
			when '3' 
				for i in $scope.keys
					switch i.name
						when 'A' then A = i.val
						when 'B' then B = i.val
						when 'C' then C = i.val
						when 'D' then D = i.val
						when 'S0' then S0 = i.val
						when 'S1' then S1 = i.val
						when 'T0' then T0 = i.val
						when 'P0' then P0 = i.val
						when 'k' then k = i.val
				params = {}
				if answer.params.f?
					params.f = answer.params.f
					T1 = params.t = answer.params.t 
					T0 || T0 = T1
					R1 = Math.pow(params.f,2)/1000
					P = A*Math.pow(R1,3)+B*Math.pow(R1,2)+C*(R1)+D+k*(T1-T0)-(S1-S0)
					P0 || P0 = P
					params.dP = P0 - P

				for k, v of answer.params when k != 'f' # для дополнительных параметров
					params[k] = v	

			# Струнный датчик давления Спрут 1.06 (СИТИС)		
			when '4' 
				for i in $scope.keys
					switch i.name
						when 'A' then A = i.val
						when 'B' then B = i.val
						when 'α' then a = i.val
						when 'B0' then B0 = i.val
						when 'B1' then B1 = i.val
						when 'T0' then T0 = i.val
						when 'P0' then T0 = i.val
				params = {}
				if answer.params.f?
					Pt = a*(T1-T0)
					Pb = B - B0
					params.f = answer.params.f
					T1 = params.t = answer.params.t 
					T0 || T0 = T1
					params.dP = P0-Pt+Pb+(A*Math.pow(F,4)*10-6+B*F*F/1000)-(A*Math.pow(F0,4)*Math.pow(10,-6)+B*Math.pow(F0,2)/1000)+a*(T-T0)-(B-B0)*0.133322  

				for k, v of answer.params when k != 'f' # для дополнительных параметров
					params[k] = v	
				
			# Стандартная логика работы	
			else 
				params = {}
				if answer.params.f?
					params.f = answer.params.f
					params.me = params.f * 5
				for k, v of answer.params when k != 'f'
					params[k] = v	

		return params

	Sens.list $scope, $routeParams.sensId

	switch $routeParams.ui
		when '1' 
			$scope.params = ['f','me','dme','g','dg']
			$scope.addingParams = ['f','t']
		when '2' 
			$scope.params = ['f','me','dme','g','dg']
			$scope.addingParams = ['f','t']
		when '3' 
			$scope.params = ['f','dP']
			$scope.addingParams = ['f','t']
		when '4' 
			$scope.params = ['f','dP']
			$scope.addingParams = ['f','t']
		else 
			$scope.params = ['f','me']
			$scope.addingParams = ['f']

	$rootScope.params = $scope.params
	$rootScope.addingParams = $scope.addingParams
	$rootScope.sensor = $scope.sensor

	SensEditDialogController = ($scope, $mdDialog) ->
		$scope.cancel = ->
			do $mdDialog.cancel
		$scope.answer = (answer) ->
			$mdDialog.hide answer

		$scope.loadCat = ->
			Sens.loadCat $scope

		$scope.keys = []
		Sens.loadKeySens $routeParams.sensId, $scope

		$scope.sensor = 
			key: {}

	SensDialogController = ($rootScope, $scope, $mdDialog) ->
		$scope.cancel = ->
			do $mdDialog.cancel

		$scope.answer = (answer) ->
			$mdDialog.hide
				params: $scope.graph.val
				date: answer

		$scope.params = $rootScope.params
		$scope.addingParams = $rootScope.addingParams

		$scope.graph = 
			val: {}

	DialogImportController = ($rootScope, $scope, $mdDialog) ->
		$scope.cancel = ->
			do $mdDialog.cancel

		$scope.answer = (answer) ->
			$mdDialog.hide answer

		$scope.sensor = $rootScope.sensor
