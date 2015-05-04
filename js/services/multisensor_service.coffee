moduleService
	.service 'MultiSens', (DB, $window) ->
		@list = ($scope, sensors, objId) ->
			minDate = 9999999999999
			maxDate = 0
			sensors.forEach (sensor, sensInd) ->
				DB.Sensor.findBy persistence, null, 'id',sensor.id, (sens)->
					sens.graphs.list (graphs)->
						graphArr = []
						l = graphs.length
						graphs.forEach (graph, ind)->
							params = JSON.parse graph.params
							parseDate = Date.parse(graph.date)

							graphArr.push
								date: new Date(graph.date)
								params: params 

							if parseDate < minDate then minDate = parseDate
							if parseDate > maxDate then maxDate = parseDate

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

					persistence.flush ->
						$scope.sensors[sensInd].graph = $scope.graph	
						do $scope.$apply

						if sensInd == sensors.length - 1
							firstVar = Object.getOwnPropertyNames($scope.sensors[0].graph[0].params)[0]
							$scope.updatePath firstVar, minDate, maxDate
			

		return
