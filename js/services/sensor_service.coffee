moduleService
	.service 'Sens', (DB) ->
		@list = ($scope, sensId) ->
			DB.Sensor.findBy persistence, null, 'id',sensId,(sens)->
				if sens?
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
							$scope.name = sens.name
							do $scope.$apply

		@removeSens = (id, $scope) ->
			DB.Sensor.all().filter 'id','=',id
				.destroyAll ->

		@update = (id, newName, newImg, $scope) ->
			DB.Sensor.all().filter 'id','=',id
				.one (obj) ->
		return
