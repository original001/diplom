moduleService.service 'Main', (DB) ->
		@list = ($scope) ->
			DB.Obj.all().list (items) ->
				if items.length
					$scope.lazyShow = true
					arr = []
					items.forEach (item, ind, itemsArray)->
						indLast = itemsArray.length - 1
						item.sensors.list (senses)->
							categories = []
							senses.forEach (sens) ->
								sens.fetch 'category', (cat) ->
									if !cat then return false else for i in categories when i.id == cat.id
										i.count += 1
										return false
									categories.push
										name: cat.name
										id: cat.id
										count: 1
										color: cat.color

							persistence.flush ->
								arr.push
									name: item.name
									id: item.id
									categories: categories
								$scope.lists = arr
								if ind == indLast
									$scope.lazyShow = false
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
			DB.Obj.findBy persistence, null, 'id',id,(obj) ->
				obj.maps.destroyAll()
				obj.sensors.list (senses) ->
					senses.forEach (sens) ->
						sens.graphs.destroyAll()
				obj.sensors.destroyAll()
			persistence.flush ->
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
