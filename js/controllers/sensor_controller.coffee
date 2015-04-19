moduleCtrl.controller 'SensController', ($rootScope, $scope, $routeParams ,Sens, $window, $document, $mdDialog) ->
	$scope.sensor = []
	$scope.graph = []

	s = Snap '#graph'
	paper = s.paper

	updatePath =  (arr,paramY) ->
		do paper.clear
		return false unless arr.length
		arr = arr.filter (el, i, a) -> 
			if el.params.hasOwnProperty paramY then return true else false
		num = arr.length
		h = 400/2
		w = $window.innerWidth - 50
		kx = (- arr[0].date.getTime() + arr[num - 1].date.getTime())/w
		minx = arr[0].date.getTime()
		paramArr = []
		for i in arr
			paramArr.push i.params[paramY]
		maxy = Math.max.apply Math, paramArr
		miny = Math.min.apply Math, paramArr
		ky = (maxy - miny)/h
		getx = (x) ->
			return 5 unless kx
			(x.date.getTime() - minx)/kx + 5
		gety = (y) ->
			return h unless ky
			h + 100 - (y.params[paramY] - miny)/ky
		paper.text 0,20, paramY
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
				.path 'M '+getx(arr[ind-1])+','+gety(arr[ind-1])+'L '+getx(el)+','+gety(el)
				.attr	
					stroke: '#000'
					strokeWidth: 1

	$scope.updatePath = (param) ->
		updatePath $scope.graph, param

	$scope.removeGraph = ->
		Sens.removeGraph $scope

	$scope.addGraph = (e) ->
		$mdDialog.show
			controller: SensDialogController
			templateUrl: '/view/dialog-add-graph.tpl.html'
			targetEvent: e
		.then (answer) ->
			Sens.addGraph answer.date, answer.params, $scope, $routeParams.sensId

	Sens.list $scope, $routeParams.sensId

	$scope.params = ['mu','eps']

	$rootScope.params = $scope.params


	SensDialogController = ($rootScope, $scope, $mdDialog) ->
		$scope.cancel = ->
			do $mdDialog.cancel

		$scope.answer = (answer) ->
			o = 
				params: $scope.graph.val
				date: answer
			$mdDialog.hide o

		$scope.params = $rootScope.params

		$scope.graph = 
			val:
				'mu':null
				'eps':null

