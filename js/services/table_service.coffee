moduleService.service 'Table', (DB) ->
		@list = ($scope, sensorId) ->
			DB.Sensor.findBy persistence, null, 'id',sensorId,(sens)->
				arr = 
					name: sens.name
					key: JSON.parse sens.key
				sens.fetch 'map', (map) ->
					arr.map = map
				sens.fetch 'obj', (obj) ->
					arr.obj = obj
				sens.fetch 'category', (cat) ->
					arr.cat = cat

				sens.graphs.list (graphs) ->
					if graphs.length then graphs.forEach (graph, ind) ->
						params = JSON.parse graph.params
						arrParams = []

						for k, v of params
							arrParams.push
								name: k
								val: v
								eval: ''

						ar2 = Object.keys(params)
						ar1 = $scope.nameOfParams	

						for el1, i in ar1
							for el2, j in ar2
								if el1 != el2 then continue
								ar2.splice j,1
						for i in ar2		
							$scope.nameOfParams.push i

						params.date = graph.date

						$scope.params.push params
							# params: arrParams
							# date: date

					persistence.flush ->
						do $scope.$apply


				persistence.flush ->
					$scope.sensor = arr
					do $scope.$apply
				
		return
