moduleService
	.service 'Sens', (DB) ->
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

						if Object.keys(params).length > $scope.params.length
							for k, v of params
								if k == 'mu' or k == 'eps' then continue
								$scope.params.push k

						if ind == l - 1 
							$scope.graph = graphArr
							do $scope.$apply
							console.log $scope.params
							$scope.updatePath Object.getOwnPropertyNames(graphArr[0].params)[0]



		@removeSens = (id, $scope) ->
			DB.Sensor.all().filter 'id','=',id
				.destroyAll ->

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
