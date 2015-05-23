moduleCtrl.controller 'MultiSensController', ($rootScope, $scope, $routeParams ,MultiSens, $window, $mdDialog) ->
	$scope.sensors = [
		id: "FCC26D4350144A16841DF2C68829C718"
		name: "sensor1"
	]

	# $scope.sensors = $rootScope.multisensors
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
		w = 20*num
		if w > $g.width()
			$g.width w + 40

		kx = (maxDate - minDate)/w
		minx = minDate

		ky = (maxy - miny)/(h+50)

		if maxy == miny then paper.text 8, h - 5, maxy else for i in [0..10]
			delta = absCeil(maxy-miny)/10
			dl = absCeil delta/ky, false, 3
			console.log dl, delta
			val = miny + delta*i

			paper
				.text 8, 280-i*dl,'' + absCeil val, true, 3
				.attr
					'font-size':'12px'
			paper
				.path "M 0,#{280-i*dl}L #{w+10},#{280-i*dl}"
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
				# paper.text getx(el) - 3 , gety(el) - 10, el.params[paramY]
				paper
					.text getx(el) - 3 , h*2, el.time
					.transform 'r90,'+(getx(el)-5)+','+h*2
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
                '/storage/emulated/0/Download/svg.svg',
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

