moduleService
	.service 'List', (DB) ->
		@list = ($scope, objId) ->
			DB.Obj.findBy persistence, null, 'id',objId,(obj)->
				if obj
					obj.sensors.list (senses)->
						arr = []
						senses.forEach (sens) ->
							arr.push
								name: sens.name
								id: sens.id
							$scope.sensors = arr
							do $scope.$apply

		return
