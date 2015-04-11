moduleService = angular.module 'Diplom.services.Main', []
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
							id: item.id
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
				id: t.id
				count: 0

		@remove = (id, $scope) ->
			DB.Obj.all().filter 'id','=',id
				.destroyAll ->
					$scope.lists.forEach (elem, ind) ->	
						if elem.id == id
							$scope.lists.splice ind, 1
							do $scope.$apply
						

		@update = (id, newName, $scope) ->
			DB.Obj.all().filter 'id','=',id
				.one (obj) ->
					obj.name = newName
					persistence.flush ->
						$scope.lists.forEach (item, ind) ->
							if item.id == obj.id
								item.name = newName
								do $scope.$apply

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

		return
