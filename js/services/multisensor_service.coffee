moduleService
	.service 'MultiSens', (DB, $window) ->
		@list = ($scope, sensors, objId) ->
			if sensors then sensors.forEach (sensor, sensInd) ->
				DB.Sensor.findBy persistence, null, 'id',sensor.id, (sens)->
					sens.graphs.list (graphs)->
						graphArr = []
						l = graphs.length
						if l > 0 then graphs.forEach (graph, ind)->
							params = JSON.parse graph.params
							
							delete params.t
							delete params.e
							delete params.n
							delete params.h

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
						else $scope.graph = []

					persistence.flush ->
						$scope.sensors[sensInd].graph = $scope.graph	
						do $scope.$apply

						if sensInd == sensors.length - 1
							firstVar = Object.getOwnPropertyNames($scope.sensors[0].graph[0].params)[0]
							$scope.updatePath firstVar
			

		return
