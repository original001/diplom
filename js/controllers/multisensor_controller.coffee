moduleCtrl.controller 'MultiSensController', ($rootScope, $scope, $routeParams ,MultiSens, $window) ->
	$scope.sensors = [
		id: "9024951B3FCE4B718A8420ABC9F9BEE7"
	,
		id: "AD381C763FD842D289D0237FA6D34577"
	,
		id: "162D9D16B0B54750813097443EE66A31"
	,
		id: "D1E315E1718E444EA94962869E639AD1"
	,
		id: "3801AE65A9A0462C8B446726B64F993F"
	]

	$scope.objId = $routeParams.objId
	$scope.params = []
	$scope.graph = []

	$g = $ '#graph'
	s = Snap '#graph'
	paper = s.paper

	MultiSens.list $scope, $scope.sensors, $scope.objId
	
	countColor = 0

	$scope.colors = ['#d11d05',"#05A3D1","#051FD1","#FF528D",'#60061E','#1d1075']


	updatePath =  (sensors,paramY,minDate, maxDate) ->

		# CREATE COORDS

		style =
			stroke: '#000'

		num = 0
		maxy = -999999999999
		miny = 999999999999

		for i in sensors
			num += i.graph.length
			for j in i.graph
				if j.params[paramY] > maxy then maxy = j.params[paramY]
				if j.params[paramY] < miny then miny = j.params[paramY]

		console.log maxy, miny

		h = 320/2
		w = 40*num
		if w > $g.width()
			$g.width w + 40

		kx = (maxDate - minDate)/w
		minx = minDate

		ky = (maxy - miny)/(h+50)

		paper
			.path "M 5,#{h*2-5}L #{w+10},#{h*2-5},#{w},#{h*2-10},#{w},#{h*2},#{w+10},#{h*2-5},"
			.attr style

		paper
			.path "M 5,#{h*2-5}L 5,0,10,10,0,10,5,0"
			.attr style

		paper.text 10,20, paramY
		paper.text w+15,h*2, 't'

		# CREATE COORDS END

		for sens in sensors
			arr = sens.graph

			multiColor = $scope.colors[countColor]
			countColor += 1

			style =
				stroke: multiColor 
				strokeWidth: 2

			arr = arr.filter (el, i, a) -> 
				if el.params.hasOwnProperty paramY then return true else false
			return false unless arr.length

			arr = arr.sort (a,b) -> 
				a.date.getTime() - b.date.getTime()


			getx = (x) ->
				return 5 unless kx
				(x.date.getTime() - minx)/kx + 5
			gety = (y) ->
				return h unless ky
				h + 120 - (y.params[paramY] - miny)/ky


			for el,ind in arr
				time = [
					el.date.getDate()	
					el.date.getMonth()+1	
					el.date.getFullYear()-2000	
					].join '.'
				paper
					.circle getx(el), gety(el), 4
					.attr
						fill: '#000'
				paper.text getx(el) - 3 , gety(el) - 10, el.params[paramY]
				paper
					.text getx(el) - 3 , h*2, time
					.transform 'r90,'+(getx(el)-5)+','+h*2
				if ind == 0 then continue

				# paper
				# 	.path "M #{getx(el)},#{gety(el)}L#{getx(el)},#{h*2-5}"
				# 	.attr
				# 		stroke: '#000'

				paper
					.path 'M '+getx(arr[ind-1])+','+gety(arr[ind-1])+'L '+getx(el)+','+gety(el)
					.attr style	

					
	$scope.updatePath = (param, minDate, maxDate) ->
		updatePath $scope.sensors, param, minDate, maxDate

