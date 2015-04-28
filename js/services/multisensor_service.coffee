moduleService
	.service 'MultiSens', (DB, $window) ->
		@list = ($scope, sensors, objId) ->
			sensors.forEach (id) ->
				DB.Sensor.findBy persistence, null, 'id',id, (sens)->
					sens.graphs.list (graphs)->
						graphArr = []
						l = graphs.length
						graphs.forEach (graph, ind)->
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
								$scope.updatePath Object.getOwnPropertyNames(graphArr[0].params)[0], true

			persistence.flush ->
				'flush done'
			

		return
