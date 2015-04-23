moduleService
	.service 'List', (DB) ->
		@list = ($scope, sensId) ->
			DB.Obj.findBy persistence, null, 'id',sensId,(sens)->
				
		return
