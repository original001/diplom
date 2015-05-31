moduleService
	.service 'Map', (DB, Sens) ->
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
			return false if !newName and !newImg
			DB.Maps.all().filter 'id','=',id
				.one (obj) ->
					obj.name = newName if newName
					obj.img = newImg if newImg
					persistence.flush ->
						$scope.tabs.forEach (item, ind) ->
							if item.id == obj.id
								item.name = newName if newName
								item.img = newImg if newImg
								do $scope.$apply

		@addSens = (sensTypeId,colors,top,left, objId,mapId, $scope) ->
			exp =
				obj: false
				map: false
				type: false
				count: 0
			DB.Obj.findBy persistence, null, 'id',objId,(obj)->
				exp.obj = obj if obj
			DB.Maps.findBy persistence, null, 'id',mapId,(map)->
				exp.map = map if map
			DB.SensCat.findBy persistence, null, 'id',sensTypeId,(type)->
				exp.type = type if type

			persistence.flush ->
				DB.Sensor.all()
					.filter('obj','=',exp.obj.id)
					.filter('category','=',exp.type.id)
					.order('date',false)
					.list (sensors) ->
						if !sensors.length then exp.count = 1 else for sens in sensors
							console.log sens.name
							_name = Number(sens.name.split('-')[1]) + 1 
							unless isNaN _name 
								exp.count = _name
								return false

				persistence.flush ->
					catName = exp.type.name
					sp = catName.split(' ')
					l = sp.length
					sensName = sp[l-1].slice 0,6
					s = new DB.Sensor
						name: sensName.replace('-','') + '-' + exp.count
						top: top
						left: left
						date: new Date().getTime()
					if  exp.obj && exp.map && exp.type
						s.category = exp.type
						exp.obj.sensors.add(s)
						exp.map.sensors.add(s)

						$.ajax
							url:"json/ui#{exp.type.ui}.json"
							dataType: 'text'
							success: (data) ->
								s.key = data
								
						persistence.flush ->
							$scope.tabs.forEach (tabs, ind) ->
								if tabs.id == exp.map.id
									$scope.tabs[ind].sensors ?= []
									$scope.tabs[ind].sensors.push
										id: s.id	
										type: sensTypeId
										name: s.name
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
				console.log "sensor #{c.name} added with color #{color} and ui number #{ui.id}!"

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

		@importGeo = ($scope, sensName, objName, params, date) ->
			DB.Obj.findBy persistence, null, 'name',objName,(obj)->
				obj.sensors.list (sensors)->
					for sens in sensors
						if sens.name.split('-')[1] == sensName

							localparams = {}
							E = localparams.e = params.e
							N = localparams.n = params.n
							H = localparams.h = params.h
							for i in JSON.parse sens.key
								switch i.name
									when 'E0' then E0 = i.val
									when 'N0' then N0 = i.val
									when 'H0' then H0 = i.val
							localparams.de = (E0 || E) - E - 3
							localparams.dn = (N0 || N) - N - 4
							localparams.dh = (H0 || H) - H - 5 

							Sens.addGraph date.setDate(5), localparams, $scope, sens.id

							return false

		return
