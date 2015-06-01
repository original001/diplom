moduleService
	.service 'App', (DB, Sens) ->

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
							localparams.de = (E0 || E) - E
							localparams.dn = (N0 || N) - N
							localparams.dh = (H0 || H) - H 

							Sens.addGraph date, localparams, $scope, sens.id

							return false

		return
