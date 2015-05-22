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
										unless cat
											cat =
												ui: 0
												color: 0
										sensors.push
											id: sen.id
											top: sen.top
											name: sen.name
											left: sen.left
											ui: cat.ui
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
			DB.Maps.findBy persistence, null, 'id',id,(map) ->
				map.sensors.list (senses) ->
					senses.forEach (sens) ->
						sens.graphs.destroyAll()
				map.sensors.destroyAll()
			persistence.flush ->
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

					# логика работы для тензометра СИТИС
					if exp.type.ui == 1 
						s.key = 
							JSON.stringify [
								name: 'K'
								val: 1
								eval: ''
							,
								name: 'α'
								val: 12
								eval: 'микрострейн'
							,
								name: 'ß'
								val: 10.5
								eval: 'микрострейн'
							,
								name: 'T0'
								val: 1
								eval: '˚C'
							]

				# логика работы для тензометра C-Sensor
					if exp.type.ui == 2 
						s.key = 
							JSON.stringify [
								name: 'ТСк'
								val: 12.2
								eval: 'με/˚С'
							,
								name: 'TCд'
								val: 12.2
								eval: 'με/˚С'
							,
								name: 'F0'
								val: 1
								eval: 'Гц'
							,
								name: 'T0'
								val: 1
								eval: '˚C'
							]

					# Струнный датчик давления CS-05 (C-Sensor)
					if exp.type.ui == 3 
						s.key = 
							JSON.stringify [
								name: 'A'
								val: 3.65 * Math.pow 10, -12
								eval: ''
							,
								name: 'B'
								val: 8.67 * Math.pow 10, -8
								eval: ''
							,
								name: 'C'
								val:  -2.78563 * Math.pow 10, -4
								eval: ''
							,
								name: 'D'
								val: 6.22362
								eval: ''
							,
								name: 'k'
								val: -0.002 
								eval: 'кг·˚С/см2'
							,
								name: 'S0'
								val: 1.020 
								eval: 'кг/см2'
							,
								name: 'S1'
								val: 1.001 
								eval: 'кг/см2'
							,
								name: 'T0'
								val: 1 
								eval: '˚C'
							,
								name: 'P0'
								val: 1 
								eval: 'кг/см2'
							]

					# Струнный датчик давления Спрут 1.06 (СИТИС)		
					if exp.type.ui == 4 
						s.key = 
							JSON.stringify [
								name: 'A'
								val: 1
								eval: ''
							,
								name: 'B'
								val: 1
								eval: ''
							,
								name: 'α'
								val: 1
								eval: ''
							,
								name: 'B0'
								val: 1
								eval: ''
							,
								name: 'B1'
								val: 1
								eval: ''
							,
								name: 'P0'
								val: 1
								eval: ''
							,
								name: 'T0'
								val: 1
								eval: ''
							]
							
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
									ui: exp.type.ui
									color: colors[exp.type.color]
								do $scope.$apply

		@addCat = (nameCat = ui.name, color, ui) ->
			c = new DB.SensCat
			c.name = nameCat
			c.color = color
			c.ui = ui.id
			persistence.add c
			persistence.flush ->
				console.log "sensor #{c.name} added with color #{color} and ui number #{ui}!"

		# @renameCat = (id, newcolor) ->
		# 	DB.SensCat.findBy persistence, null, 'id',id,(cat)->
		# 		cat.name = newname
		# 		cat.color = newcolor

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
