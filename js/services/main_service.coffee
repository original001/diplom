angular.module 'Diplom.services.Main', []
	.service 'Main', (DB) ->
		@list = (dest, $scope) ->
			DB[dest].all().list (items) ->
				arr = []
				count = items.length
				items.forEach (item)->
					arr.push
						name: item.name
						page: item.id
				$scope.lists = arr
				do $scope.$apply
		@add = (dest, options) ->
			t = new DB[dest] options
			persistence.add t
			persistence.flush ->
				console.log 'flush done'
		@remove = (dest, id) ->
			DB[dest].all().filter 'id','=',id
				.destroyAll ->
					console.log 'done'
		@update = (obj) ->
		@update = (obj) ->
		@say = (name) ->
			"hello #{name}"
		return
