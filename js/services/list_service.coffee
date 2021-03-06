moduleService
	.service 'List', (DB) ->
		@list = ($scope, objId) ->
			exp = 
				obj:false
			DB.Obj.findBy persistence, null, 'id',objId,(obj)->
				exp.obj = if obj then obj else false
			DB.SensCat.all().list (cats) ->
				if cats.length then cats.forEach (cat, ind, ar) ->
					$scope.categories.push
						name: cat.name
						id: cat.id
						sensors: []
			persistence.flush ->
				exp.obj.sensors.list (senses)->
					if !senses.length 
						$scope.empty = true
						$scope.lazyShow = false 
						do $scope.$apply
					else
						senses.forEach (sens, ind, ar) ->
							sens.fetch 'category', (cat) ->
								if cat? then for i in $scope.categories
									if i.id == cat.id
										i.sensors.push
											name: sens.name
											ui: cat.ui
											id: sens.id
						persistence.flush ->
							$scope.lazyShow = false
							do $scope.$apply

		return
