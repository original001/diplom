moduleCtrl.controller 'SensController', ($rootScope, $scope, $routeParams ,Sens, $window, $document, $mdDialog) ->
	$scope.sensor = []
	$scope.graph = []
	$scope.categories = []
	$scope.paramInput = false

	$g = $ '#graph'
	s = Snap '#graph'
	paper = s.paper

	# Sens.addCat 'Транзистор СИТИС','0'
	# Sens.addCat 'Транзистор C-Sensor','1'
	# Sens.addCat 'Датчик давления','2'
	# Sens.addCat 'Деформационная марка','2'
	# Sens.addCat 'Другой','4'
	Sens.renameCat '430AE9AA56DC4DB3AE7664401BE0EB87','3'

	updatePath =  (arr,paramY) ->
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
			paper.text getx(el) - 3 , gety(el) - 10, el.params[paramY]
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

	$scope.editSens = (e) ->
		$mdDialog.show
			controller: SensEditDialogController
			templateUrl: 'view/dialog-edit-sens.tpl.html'
			targetEvent: e
		.then (answer) ->
			Sens.editSens answer.name, answer.category, $routeParams.sensId, $scope

	$scope.removeGraph = ->
		Sens.removeGraph $scope

	$scope.addGraph = (e) ->
		$mdDialog.show
			controller: SensDialogController
			templateUrl: 'view/dialog-add-graph.tpl.html'
			targetEvent: e
		.then (answer) ->
			Sens.addGraph answer.date, answer.params, $scope, $routeParams.sensId

	Sens.list $scope, $routeParams.sensId

	$scope.params = ['mu','eps']

	$rootScope.params = $scope.params

	SensEditDialogController = ($scope, $mdDialog) ->
		$scope.cancel = ->
			do $mdDialog.cancel
		$scope.answer = (answer) ->
			$mdDialog.hide answer

		$scope.loadCat = ->
			Sens.loadCat $scope


	SensDialogController = ($rootScope, $scope, $mdDialog) ->
		$scope.cancel = ->
			do $mdDialog.cancel

		$scope.answer = (answer) ->
			$mdDialog.hide
				params: $scope.graph.val
				date: answer

		$scope.params = $rootScope.params

		$scope.graph = 
			val: {}

