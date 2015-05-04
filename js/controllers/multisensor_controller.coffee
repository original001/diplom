moduleCtrl.controller 'MultiSensController', ($rootScope, $scope, $routeParams ,MultiSens, $window) ->
	# $scope.sensors = [
	# 	id: "9024951B3FCE4B718A8420ABC9F9BEE7"
	# 	name: "sensor1"
	# ,
	# 	id: "AD381C763FD842D289D0237FA6D34577"
	# 	name: "sensor2"
	# ,
	# 	id: "162D9D16B0B54750813097443EE66A31"
	# 	name: "sensor3"
	# ,
	# 	id: "3801AE65A9A0462C8B446726B64F993F"
	# 	name: "sensor4"
	# ]

	$scope.sensors = $rootScope.multisensors
	$scope.objId = $routeParams.objId
	$scope.params = []
	$scope.graph = []

	$g = $ '#graph'
	s = Snap '#graph'
	paper = s.paper

	MultiSens.list $scope, $scope.sensors, $scope.objId
	
	$scope.colors = ['#d11d05',"#05A3D1","#051FD1","#FF528D",'#60061E','#1d1075','#7183FF','#B8C1FF','#FF7967','#83E3FF']

	updatePath =  (sensors,paramY) ->
		do paper.clear

		# CREATE COORDS

		style =
			stroke: '#000'

		num = 0
		maxy = -999999999999
		miny = 999999999999
		minDate = 9999999999999
		maxDate = 0
		times = []

		for i in sensors
			for j in i.graph
				if j.params[paramY]
					num += 1
					if j.date.getTime() > maxDate then maxDate = j.date.getTime() 
					if j.date.getTime() < minDate then minDate = j.date.getTime() 
					if j.params[paramY] > maxy then maxy = j.params[paramY]

					if j.params[paramY] < miny then miny = j.params[paramY]
					j.time = [
						j.date.getDate()	
						j.date.getMonth()+1	
						j.date.getFullYear()-2000	
						].join '.'
					if times.indexOf(j.time) > -1 then j.time = '' else times.push j.time

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

		for sens, ind in sensors

			arr = sens.graph

			console.log arr

			style =
				stroke: $scope.colors[ind] 
				strokeWidth: 2

			paper
				.path "M 0,#{h*2+70+20*(ind+1)}L 50,#{h*2+70+20*(ind+1)}"
				.attr style
			paper
				.text 60,h*2+74+20*(ind+1), sens.name

			$g.height 380+20*(ind+1)

			arr = arr.filter (el, i, a) -> 
				if el.params.hasOwnProperty paramY then return true else false
			return false unless arr.length

			arr = arr.sort (a,b) -> 
				a.date.getTime() - b.date.getTime()

			console.log arr
			
			getx = (x) ->
				return 5 unless kx
				(x.date.getTime() - minx)/kx + 5
			gety = (y) ->
				return h unless ky
				h + 120 - (y.params[paramY] - miny)/ky

			for el,ind in arr
				paper
					.circle getx(el), gety(el), 4
					.attr
						fill: '#000'
				paper.text getx(el) - 3 , gety(el) - 10, el.params[paramY]
				paper
					.text getx(el) - 3 , h*2, el.time
					.transform 'r90,'+(getx(el)-5)+','+h*2
				if ind == 0 then continue

				paper
					.path 'M '+getx(arr[ind-1])+','+gety(arr[ind-1])+'L '+getx(el)+','+gety(el)
					.attr style	

					
	$scope.updatePath = (param) ->
		updatePath $scope.sensors, param

