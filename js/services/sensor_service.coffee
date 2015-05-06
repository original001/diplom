moduleService
	.service 'Sens', (DB, $window) ->
		@list = ($scope, sensId) ->
			DB.Sensor.findBy persistence, null, 'id',sensId,(sens)->
				arr = []
				sens.fetch 'obj',(obj)->
					objName = obj.name
					objId = obj.id
					sens.fetch 'map',(map)->
						mapName = map.name
						arr.push
							id: sens.id
							name: sens.name
							obj:objName
							objId: objId
							map:mapName
						$scope.sensor = arr
						do $scope.$apply

				sens.graphs.list (graphs) ->
					graphArr = []
					l = graphs.length
					graphs.forEach (graph, ind) ->	
						params = JSON.parse graph.params

						graphArr.push
							date: new Date(graph.date)
							params: params 

						ar2 = Object.keys(params)
						ar1 = $scope.params	

						for el1, i in ar1
							for el2, j in ar2
								if el1 != el2 then continue
								ar2.splice j,1
						for i in ar2		
							$scope.params.push i
							$scope.addingParams.push i

						if ind == l - 1 
							$scope.graph = graphArr
							do $scope.$apply
							$scope.updatePath Object.getOwnPropertyNames(graphArr[0].params)[0]



		@removeSens = (id, $scope) ->
			DB.Sensor.findBy persistence, null, 'id',id,(sens) ->
				sens.graphs.destroyAll()
			persistence.flush ->
				DB.Sensor.findBy persistence, null, 'id',id, (sens)->
					sens.fetch 'obj', (obj)->
						persistence.remove sens
						persistence.flush -> 
							$window.location.href = "#/map/#{obj.id}"	

		@removeGraph = ($scope) ->
			DB.Graph.all().destroyAll ->

		@editSens = (newName, category, keys, id, $scope) ->
			DB.Sensor.findBy persistence, null,'id',id, (sens)->
				if sens
					if newName 
						sens.name = newName 
						persistence.flush ->
							$scope.sensor[0].name = newName
							do $scope.$apply
					if category
						DB.SensCat.findBy persistence, null, 'id',category, (cat)->
							if cat
								sens.category = cat
								persistence.flush ->
					if Object.keys(keys).length > 0
						sensKey = JSON.parse sens.key
						for k,v of keys
							for i, ind in sensKey when k == i.name
								sensKey[ind].val = v
								sens.key = JSON.stringify sensKey
								persistence.flush ->

		@addCat = (nameCat, color) ->
			c = new DB.SensCat
			c.name = nameCat
			c.color = color
			persistence.add c
			persistence.flush ->
				console.log "sensor #{c.name} added with color #{color}!"

		@loadCat = ($scope) ->		
			DB.SensCat.all().list (cats) ->
				if cats
					arrCats = []
					cats.forEach (cat, ind, ar) ->
						arrCats.push 
							id: cat.id
							name: cat.name
						if ind == ar.length-1
							$scope.categories = arrCats
							do $scope.$apply

		@addGraph = (date, params, $scope, sensId) ->
			DB.Sensor.findBy persistence, null, 'id',sensId,(sens)->
				t = new DB.Graph
				t.date = date
				t.params = JSON.stringify params
				sens.graphs.add t
				persistence.flush ->
					$scope.graph.push
						date: date
						params: params
					do $scope.$apply
					$scope.updatePath Object.keys(params)[0]

		@loadKeySens = (sensId, $scope) ->
			DB.Sensor.findBy persistence, null, 'id',sensId,(sens)->
				$scope.keys = JSON.parse sens.key if sens

		return
