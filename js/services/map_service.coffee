moduleService
	.service 'Map', (DB) ->
		@list = ($scope, objId, colors) ->
			DB.Obj.findBy persistence, null, 'id',objId,(obj)->
				if obj
					obj.maps.list (items) ->
						arr = []
						if items.length == 0 
							$scope.lazyShow = false
							$scope.tabs = []
							do $scope.$apply
							return
						items.forEach (item)->
							sensors = []
							item.sensors.list null, (sens)->
								sens.forEach (sen)->
									sen.fetch 'category', (cat) ->
										cat = if cat then cat else 4
										sensors.push
											id: sen.id
											top: sen.top
											name: sen.name
											left: sen.left
											color: colors[cat.color]
								persistence.flush ->
									arr.push
										name: item.name
										id: item.id
										img: item.img
										sensors: sensors
									$scope.mapId = arr[0].id
									$scope.tabs = arr
									$scope.lazyShow = false
									do $scope.$apply

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
						selInd = $scope.tabs[$scope.selectedIndex] || {id:0}
						$scope.mapId = if selInd.id? then selInd.id else 			
						

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

		@addSens = (sensName,sensTypeId,colors,top,left, objId,mapId, $scope) ->
			exp =
				obj: false
				map: false
				type: false
			DB.Obj.findBy persistence, null, 'id',objId,(obj)->
				exp.obj = obj if obj
			DB.Maps.findBy persistence, null, 'id',mapId,(map)->
				exp.map = map if map
			DB.SensCat.findBy persistence, null, 'id',sensTypeId,(type)->
				exp.type = type if type
			s = new DB.Sensor
				name: sensName
				top: top
				left: left
			persistence.flush ->
				if  exp.obj && exp.map && exp.type
					s.category = exp.type
					exp.obj.sensors.add(s)
					exp.map.sensors.add(s)
					persistence.flush ->
						$scope.tabs.forEach (tabs, ind) ->
							if tabs.id == exp.map.id
								$scope.tabs[ind].sensors ?= []
								$scope.tabs[ind].sensors.push
									id: s.id	
									type: sensTypeId
									name:sensName
									top: top	
									left: left
									color: colors[exp.type.color]
								do $scope.$apply

		@listCat = ($scope) ->
			DB.SensCat.all().list (cats) ->
				if cats
					arrCats = []
					cats.forEach (cat, ind, ar) ->
						arrCats.push 
							id: cat.id
							name: cat.name
							color: cat.color
						if ind == ar.length-1
							$scope.categories = arrCats
							do $scope.$apply
		return
