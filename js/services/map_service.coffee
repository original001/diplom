moduleService
	.service 'Map', (DB) ->
		DB.Maps.hasMany('sensors', DB.Sensor, 'map')
		persistence.schemaSync()
		@list = ($scope) ->
			DB.Maps.all().list (items) ->
				arr = []
				items.forEach (item)->
					item.sensors.list null, (res)->
						count = res.length
						arr.push
							name: item.name
							id: item.id
							count: count
						$scope.lists = arr
						do $scope.$apply

		@addPlan = (name, img, $scope) ->
			t = new DB.Maps
			t.name = name
			t.img = img
			persistence.add t
			persistence.flush()
			$scope.tabs.push
				id: t.id
				name: name
				img: img

		@removePlan = (id, $scope) ->
			DB.Maps.all().filter 'id','=',id
				.destroyAll ->
					# $scope.tabs.forEach (elem, ind) ->	
						# if elem.id == id
							# $scope.lists.splice ind, 1
							# do $scope.$apply
						

		@update = (id, newName, $scope) ->
			DB.Obj.all().filter 'id','=',id
				.one (obj) ->
					obj.name = newName
					persistence.flush ->
						$scope.lists.forEach (item, ind) ->
							if item.id == obj.id
								item.name = newName
								do $scope.$apply

		@addSens = (sensName, objId, $scope) ->
			DB.Obj.findBy persistence, null, 'id',objId,(obj)->
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

		return
