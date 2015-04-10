angular.module 'Diplom.services.Main', []
	.service 'Main', (DB) ->
		DB.Obj.hasMany('sensors', DB.Sensor, 'obj')
		persistence.schemaSync()
		@list = ($scope) ->
			DB.Obj.all().list (items) ->
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
		@addObj = (name, $scope) ->
			t = new DB.Obj
			t.name = name
			persistence.add t
			persistence.flush()
			$scope.lists.push
				name: name
				page: t.id
				count: 0

		@remove = (dest, name) ->
			DB[dest].all().filter 'name','=',name
				.destroyAll ->
					console.log 'done'

		@update = (obj) ->

		@addSens = (sensName, objName, $scope) ->
			DB.Obj.findBy persistence, null, 'name',objName,(obj)->
				if obj
					s = new DB.Sensor
						name: sensName
						sensCat: "1"
						date: new Date().getTime()
					obj.sensors.add(s)
					persistence.flush ->
						$scope.lists.forEach (item, ind) ->
							if item.name == obj.name
								item.count += 1
								do $scope.$apply

		@say = (name) ->
			"hello #{name}"
		return
