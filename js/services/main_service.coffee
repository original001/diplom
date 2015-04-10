angular.module 'Diplom.services.Main', []
	.service 'Main', (DB) ->
		# DB.Sensor.hasOne('object', DB.Obj, '')
		DB.Obj.hasMany('sensors', DB.Sensor, 'obj')
		DB.Sensor.hasOne('obj',DB.Obj)
		persistence.schemaSync()
		@list = (dest, $scope) ->
			DB[dest].all().list (items) ->
				arr = []
				items.forEach (item)->
					item.sensors.list null, (res)->
						count = res.length
						arr.push
							name: item.name
							page: item.id
							count: count
						$scope.lists = arr
						do $scope.$apply
		@addObj = (options) ->
			t = new DB.Obj options
			persistence.add t
			persistence.flush ->
				console.log 'flush done'
		@remove = (dest, name) ->
			DB[dest].all().filter 'name','=',name
				.destroyAll ->
					console.log 'done'
		@prefetch = (name, $scope) ->
			DB.Obj.findBy persistence, null, 'name',name,(obj)->
				if obj
					arr = []
					obj.sensors.list null, (res)->
						$scope.count = res.length
						do $scope.$apply

			# DB.Sensor.all().prefetch('obj').list null, (items) ->
			# 	arr = []
			# 	count = items.length
			# 	items.forEach (item)->
			# 		arr.push
			# 			name: item.name
			# 	console.log arr
			# 	$scope.lists[0].count = arr.length
			# 	do $scope.$apply
		@update = (obj) ->

		@addSens = (s, o) ->
			s = new DB.Sensor
				name: s
				sensCat: "1"
				date: new Date().getTime()
			o = new DB.Obj
				name: o
			o.sensors.add(s)
			persistence.flush()
			o.sensors.list null, (res) ->
				console.log res	

		@say = (name) ->
			"hello #{name}"
		return
