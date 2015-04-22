moduleService
	.service 'Sens', (DB, $window) ->
		@list = ($scope, sensId) ->
			DB.Sensor.findBy persistence, null, 'id',sensId,(sens)->
				arr = []
				sens.fetch 'obj',(obj)->
					objName = obj.name
					sens.fetch 'map',(map)->
						mapName = map.name
						arr.push
							id: sens.id
							top: sens.top
							name: sens.name
							left: sens.left
							obj:objName
							map:mapName
						$scope.sensor = arr
						do $scope.$apply

				sens.graphs.list (graphs) ->
					graphArr = []
					l = graphs.length
					graphs.forEach (graph, ind) ->	
						params = JSON.parse graph.params

						graphArr.push
							date: new Date(graph.date)
							params: params 

						ar2 = Object.keys(params)
						ar1 = $scope.params	

						for el1, i in ar1
							for el2, j in ar2
								if el1 != el2 then continue
								ar2.splice j,1
						for i in ar2		
							$scope.params.push i

						if ind == l - 1 
							$scope.graph = graphArr
							do $scope.$apply
							$scope.updatePath Object.getOwnPropertyNames(graphArr[0].params)[0]



		@removeSens = (id, $scope) ->
			DB.Sensor.findBy persistence, null, 'id',id, (sens)->
				sens.fetch 'obj', (obj)->
					persistence.remove sens
					persistence.flush -> 
						$window.location.href = "#/map/#{obj.id}"	

		@removeGraph = ($scope) ->
			DB.Graph.all().destroyAll ->

		@update = (id, newName, newImg, $scope) ->
			DB.Sensor.all().filter 'id','=',id
				.one (obj) ->

		@addGraph = (date, params, $scope, sensId) ->
			DB.Sensor.findBy persistence, null, 'id',sensId,(sens)->
				t = new DB.Graph
				t.date = date
				t.params = JSON.stringify params
				sens.graphs.add t
				persistence.flush ->
					$scope.graph.push
						date: date
						params: params
					do $scope.$apply
					$scope.updatePath 'eps'
		return
