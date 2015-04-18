moduleCtrl.controller 'SensController', ($scope, $routeParams ,Sens, $window, $document, $mdDialog) ->
	$scope.sensor = []
	$scope.graph = [
		date: new Date('Sun Apr 19 2015 00:41:22 GMT+0600 (YEKT)')
		mu: 1
		eps:2
	,
		date: new Date('Sun Apr 19 2015 00:40:22 GMT+0600 (YEKT)')
		mu: 3
		eps:6
	,
		date: new Date('Sun Apr 19 2015 00:39:22 GMT+0600 (YEKT)')
		mu: 3
		eps:3
	,
		date: new Date('Sun Apr 19 2015 00:38:22 GMT+0600 (YEKT)')
		mu: 5
		eps:3
	,
		date: new Date('Sun Apr 19 2015 00:36:22 GMT+0600 (YEKT)')
		mu: 1
		eps:3
	,
		date: new Date('Sun Apr 19 2015 00:33:22 GMT+0600 (YEKT)')
		mu: 7
		eps:3
	,
		date: new Date('Sun Apr 19 2015 00:31:22 GMT+0600 (YEKT)')
		mu: 5
		eps:2
	]

	s = Snap '#graph'
	paper = s.paper

	updatePath =  (arr,paramY) ->
		do paper.clear
		num = arr.length
		h = 400/2
		w = $window.innerWidth - 50
		kx = (- arr[0].date.getTime() + arr[num - 1].date.getTime())/w
		minx = arr[0].date.getTime()
		paramArr = []
		for i in arr
			paramArr.push i.eps
		maxy = Math.max.apply Math, paramArr
		miny = Math.min.apply Math, paramArr
		ky = (maxy - miny)/h
		getx = (x) ->
			(x.date.getTime() - minx)/kx + 5
		gety = (y) ->
			h + 100 - (y[paramY] - miny)/ky
		paper.text 0,20, paramY
		for el,ind in arr
			time = [
				el.date.getSeconds()	
				el.date.getMinutes()	
				el.date.getHours()	
				].reverse().join ':'
			paper
				.circle getx(el), gety(el), 3
				.attr
					fill: '#000'
			paper.text getx(el) - 3 , gety(el) - 10, el[paramY]
			paper
				.text getx(el) - 3 , h*2, time
				.transform 'r90,'+(getx(el)-5)+','+h*2
			if ind == 0 then continue
			paper
				.path 'M '+getx(arr[ind-1])+','+gety(arr[ind-1])+'L '+getx(el)+','+gety(el)
				.attr	
					stroke: '#000'
					strokeWidth: 1

	updatePath $scope.graph, 'eps'

	$scope.updatePath = (param) ->
		updatePath $scope.graph, param

	$scope.addGraph = (e) ->
		$mdDialog.show
			controller: DialogController
			templateUrl: '/view/dialog-add-graph.tpl.html'
			targetEvent: e
		.then (answer) ->
			console.log answer
			# Map.addPlan answer.name, answer.img, $scope, $routeParams.objId

	Sens.list $scope, $routeParams.sensId
