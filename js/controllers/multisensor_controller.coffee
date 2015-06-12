moduleCtrl.controller 'MultiSensController', ($rootScope, $scope, $routeParams ,MultiSens, $window, $mdDialog) ->
	# $scope.sensors = [
	# 	id: "5DAC865D329E414CB872A85EB30D8B3B"
	# 	name: "sensor1"
	# ,
	# 	id: "A01D426739F64AE8814EDD6D51E5D3A8"
	# 	name: "sensor2"
	# ,
	# 	id: "6E7B98B3795149A7827A0B7223E2673F"
	# 	name: "sensor3"
	# ,
	# 	id: "0CDF1CA6765F42ED8389C61373BF9691"
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

		# CREATE COORDS >>>

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
				if j.params[paramY]?
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
		w = 20*num
		if w > $g.width()
			$g.width w + 40

		kx = (maxDate - minDate)/w
		minx = minDate

		ky = (maxy - miny)/(h+50)

		# pretify coords

		miny = absCeil miny, true, 2, true
		maxy = absCeil maxy, true, 2, true
		delta = absCeil(maxy-miny)/10
		dl = absCeil delta/ky, false, 3

		ext = -miny + absCeil miny, true, 0
		ext = absCeil ext, true, 2

		dlExt = Math.abs absCeil ext/ky, false, 3

		# create coords

		# 	delta = (280 - 48)/10
		# 	deltaVal = (maxy - miny)/10
		# 	cur = 280 - delta*i

		# 	paper
		# 		.text 8, cur, miny + deltaVal*i
		# 		.attr
		# 			'font-size':'12px'
		# 	paper
		# 		.path "M 0,#{cur}L #{w+10},#{cur}"
		# 		.attr 
		# 			stroke: 'rgba(0,0,0,.3)'
		# 			strokeWidth: 1

		if maxy == miny then paper.text 8, h - 5, maxy else for i in [0..10]

			val = absCeil miny + ext + delta*i, false, 1, true

			dlGraph = 280+dlExt-i*dl
			continue if dlGraph < 40 or dlGraph > 320

			paper
				.text 8, 280+dlExt-i*dl,'' + absCeil val, true, 3, true
				.attr
					'font-size':'12px'
			paper
				.path "M 0,#{dlGraph}L #{w+10},#{dlGraph}"
				.attr 
					stroke: 'rgba(0,0,0,.3)'
					strokeWidth: 1

		paper
			.path "M 5,#{h*2-5}L #{w+10},#{h*2-5},#{w},#{h*2-10},#{w},#{h*2},#{w+10},#{h*2-5},"
			.attr style

		paper
			.path "M 5,#{h*2-5}L 5,0,10,10,0,10,5,0"
			.attr style

		paper.text 10,20, paramY
		paper.text w+15,h*2, 't'

		# CREATE COORDS END <<<

		sensInd = 0
		for sens in sensors when sens.graph.length > 0

			arr = sens.graph

			style =
				stroke: $scope.colors[sensInd] 
				strokeWidth: 2

			arr = arr.filter (el, i, a) -> 
				if el.params.hasOwnProperty paramY then return true else false
			continue unless arr.length

			paper
				.path "M 0,#{h*2+70+20*(sensInd+1)}L 50,#{h*2+70+20*(sensInd+1)}"
				.attr style
			paper
				.text 60,h*2+74+20*(sensInd+1), sens.name

			$g.height 380+20*(sensInd+2)


			arr = arr.sort (a,b) -> 
				a.date.getTime() - b.date.getTime()

			getx = (x) ->
				return 5 unless kx
				(x.date.getTime() - minx)/kx + 5
			gety = (y) ->
				return h unless ky
				h + 120 - (y.params[paramY] - miny)/ky

			sensInd+=1

			for el,ind in arr
				paper
					.circle getx(el), gety(el), 4
					.attr
						fill: $scope.colors[sensInd-1]
						
				# paper.text getx(el) - 3 , gety(el) - 10, absCeil el.params[paramY], true, 4, true
				paper
					.text getx(el) - 3 , h*2, el.time
					.transform 'r90,'+(getx(el)-5)+','+h*2
					.attr
						'font-size':'13px'
				if ind == 0 then continue

				paper
					.path 'M '+getx(arr[ind-1])+','+gety(arr[ind-1])+'L '+getx(el)+','+gety(el)
					.attr style	


					
	$scope.updatePath = (param) ->
		updatePath $scope.sensors, param

	$scope.alert = (e, title = '', content = '') ->
		$mdDialog.show(
			$mdDialog.alert()
			.parent(angular.element(document.body))
			.title(title)
			.content(content)
			.ariaLabel('Alert Dialog')
			.ok('ОК')
			.targetEvent(e)
		)

	$scope.setName = (e) ->
		$mdDialog.show
			controller: DialogController
			templateUrl: 'view/dialog-add.tpl.html'
			targetEvent: e
		.then (answer) ->
			$scope.render answer

	$scope.render = (name) ->
		svg = document.getElementById 'graph'

		serializer = new XMLSerializer()
		svgStr = serializer.serializeToString(svg)
		encodedSvgStr = unescape(encodeURIComponent(svgStr))
		svgData = btoa(encodedSvgStr)

		downloadFile = () ->
            console.log('downloadFile')
            window.requestFileSystem(
                LocalFileSystem.PERSISTENT,
                0,
                onRequestFileSystemSuccess,
                fail)
        
        onRequestFileSystemSuccess = (fileSystem) ->
            console.log('onRequestFileSystemSuccess')
            fileSystem.root.getFile(
                '/Download/svg.svg',
                {create: true, exclusive: false},
                onGetFileSuccess,
                fail)
        
        onGetFileSuccess = (fileEntry) ->
            console.log('onGetFileSuccess!')
            path = fileEntry.toURL().replace('svg.svg', '')
            fileTransfer = new FileTransfer()
            fileEntry.remove()
            
            fileTransfer.download(
                "data:image/svg+xml;base64," + svgData,
                path + "#{name}.svg",
                (file) ->
                    $scope.alert null, 'График успешно загружен', "Файл находится в папке Download, имя файла - #{name}.svg"
                (error) ->
                    $scope.alert null, 'При загрузке возникла ошибка', "Код ошибки – #{error.code}, объект загрузки – #{error.target}")
        
        
        fail = (evt) ->
            $scope.alert null, 'При загрузке возникла ошибка', "Код ошибки – #{evt.target.error.code}"

		if cordovaApp.isReady 
			console.log 'ready and fire function'
			do downloadFile
		else 
            $scope.alert null, 'Oшибка!', "cordova.js не загружен"

