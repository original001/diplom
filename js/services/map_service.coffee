moduleService
	.service 'Map', (DB) ->
		DB.Maps.hasMany('sensors', DB.Sensor, 'map')
		persistence.schemaSync()
		@list = ($scope) ->
			DB.Maps.all().list (items) ->
				arr = []
				items.forEach (item)->
					# item.sensors.list null, (res)->
					# count = res.length
					arr.push
						name: item.name
						id: item.id
						img: item.img
					$scope.tabs = arr
					$scope.mapId = arr[0].id
					do $scope.$apply
					$scope.lazyShow = false

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
					$scope.tabs.forEach (elem, ind) ->	
						if elem.id == id
							$scope.tabs.splice ind, 1
							do $scope.$apply
					$scope.mapId = $scope.tabs[$scope.selectedIndex].id
						

		@update = (id, newName, newImg, $scope) ->
			DB.Maps.all().filter 'id','=',id
				.one (obj) ->
					obj.name = newName
					obj.img = newImg if newImg
					persistence.flush ->
						$scope.tabs.forEach (item, ind) ->
							if item.id == obj.id
								item.name = newName
								item.img = newImg if newImg
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
						$scope.tabs.forEach (item, ind) ->
							if item.name == obj.name
								item.count += 1
								do $scope.$apply

		return
