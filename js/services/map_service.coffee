moduleService
	.service 'Map', (DB) ->
		@list = ($scope, objId) ->
			DB.Obj.findBy persistence, null, 'id',objId,(obj)->
				if obj
					obj.maps.list (items) ->
						arr = []
						if items.length != 0
							items.forEach (item)->
								sensors = []
								item.sensors.list null, (sens)->
									sens.forEach (sen)->
										sensors.push
											id: sen.id
											top: sen.top
											left: sen.left
									arr.push
										name: item.name
										id: item.id
										img: item.img
										sensors: sensors
									$scope.mapId = arr[0].id
									$scope.tabs = arr
									do $scope.$apply
									$scope.lazyShow = false

		@addPlan = (name, img, $scope, objId) ->
			DB.Obj.findBy persistence, null, 'id',objId,(obj)->
				if obj
					t = new DB.Maps
					t.name = name
					t.img = img
					obj.maps.add t
					persistence.flush ->
						$scope.tabs.push
							id: t.id
							name: name
							img: img
							sensors: []
						$scope.mapId = t.id
						do $scope.$apply

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

		@addSens = (sensName,top,left, objId,mapId, $scope) ->
			DB.Obj.findBy persistence, null, 'id',objId,(obj)->
				if obj
					DB.Maps.findBy persistence, null, 'id',mapId,(map)->
						if map
							s = new DB.Sensor
								name: sensName
								top: top
								left: left
							obj.sensors.add(s)
							map.sensors.add(s)
							persistence.flush ->
								$scope.tabs.forEach (item, ind) ->
									if item.id == map.id
										$scope.tabs.sensors ?= []
										$scope.tabs.sensors.push
											id: s.id	
											top: top	
											left: left
										do $scope.$apply

		return
