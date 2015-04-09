angular.module 'Diplom.services.Main', []
	.service 'Main', (DB) ->
		DB.Sensor.hasOne('object', DB.Obj, 'obj')
		# DB.Obj.hasMany('sensors', DB.Sensor, 'obj')
		persistence.schemaSync()
		@list = (dest, $scope) ->
			DB[dest].all().list (items) ->
				arr = []
				count = items.length
				items.forEach (item)->
					arr.push
						name: item.name
						page: item.id
				$scope.lists = arr
				do $scope.$apply
		@add = (dest, options) ->
			t = new DB[dest] options
			persistence.add t
			persistence.flush ->
				console.log 'flush done'
		@remove = (dest, name) ->
			DB[dest].all().filter 'name','=',name
				.destroyAll ->
					console.log 'done'
		@prefetch = ($scope) ->
			DB.Sensor.all().prefetch('object').list null, (items) ->
				console.log arr
				arr = []
				count = items.length
				items.forEach (item)->
					arr.push
						name: item.name
				$scope.count = arr
				do $scope.$apply
			, (tx, success) ->
				console.log tx, success
			, (tx, error) ->
				console.log tx, error.message
		@update = (obj) ->
		@say = (name) ->
			"hello #{name}"
		return
