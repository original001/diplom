angular.module 'Monitor', [
	'ngMaterial'
	'ngRoute'
	'mobile-angular-ui'
	'Diplom.controllers.Main'
	'Diplom.services.Main'
	'naif.base64']

	.config ($mdThemingProvider) ->
		$mdThemingProvider.theme('default')
			.primaryPalette('cyan')

	.config ($routeProvider, $locationProvider) -> 
		persistence.store.websql.config persistence, 'sensors4', 'База данных для мониторинга', 5 * 1024 * 1024
		$routeProvider.when '/', 
			templateUrl: 'view/home.html'
			controller: 'MainController'
		.when '/map/:objId',
			templateUrl:'view/map.html'
			controller: 'MapController'
		.when '/sensor/:ui/:sensId',
			templateUrl:'view/sensor.html'
			controller: 'SensController'
		.when '/multisensors/:objId',
			templateUrl:'view/multisensor.html'
			controller: 'MultiSensController'
		.when '/list/:objId',
			templateUrl:'view/list.html'
			controller: 'ListController'
		.when '/table/:sensId',
			templateUrl:'view/table.html'
			controller: 'TableController'
		.when '/help/',
			templateUrl:'view/help.html'
		$locationProvider.html5Mode
			enable: false
			requireBase: false

	.constant 'DB',
		Obj: persistence.define 'Obj',  
			name: "TEXT"
		SensCat: persistence.define 'SensCat',  
			name: "TEXT"
			ui: "INT"
			color: "INT"
		SensMany: persistence.define 'SensMany',  
			sensor: "INT",
			GroupOfSens: "INT"
		Sensor: persistence.define 'Sensor',  
			name: "TEXT",
			top: "INT"
			left: "INT"
			key: 'JSON'
			date: 'INT'
		Graph: persistence.define 'Graph',  
			date: "DATE",
			params: 'JSON'
		GroupOfSens: persistence.define 'GroupOfSens',  
			name: "TEXT",
			sensCat: "INT",
			obj: "INT"
		Maps: persistence.define 'Maps',
			name: "TEXT",
			img: "TEXT",
	.config (DB) ->
		DB.Maps.hasMany('sensors', DB.Sensor, 'map')
		DB.Obj.hasMany('maps', DB.Maps, 'obj')
		DB.Obj.hasMany('sensors', DB.Sensor, 'obj')
		DB.Sensor.hasMany('graphs',DB.Graph, 'sens')
		DB.Sensor.hasOne('category',DB.SensCat)
		persistence.schemaSync()
		
moduleCtrl = angular.module 'Diplom.controllers.Main', []
moduleService = angular.module 'Diplom.services.Main', []

angular.module 'mobile-angular-ui', [
	'mobile-angular-ui.core.activeLinks',
	'mobile-angular-ui.core.fastclick',
	'mobile-angular-ui.core.sharedState',
	'mobile-angular-ui.core.outerClick', 
	'mobile-angular-ui.components.modals',
	'mobile-angular-ui.components.switch',
	'mobile-angular-ui.components.sidebars',
	'mobile-angular-ui.components.scrollable', 
	'mobile-angular-ui.components.navbars']


cordovaApp =
	initialize: ()-> 
		@bindEvents()
	bindEvents: ()->
		document.addEventListener('deviceready', @onDeviceReady, false)
	onDeviceReady: ()->
		console.log 'deviceready fired!'
		cordovaApp.isReady = true
	isReady: false

do cordovaApp.initialize

absCeil = (number, down, count = 0, round) ->
	positive = if number >= 0 then true else false 
	if Math.abs(number) >= 1
		length = (Math.floor(number) + '').length - 1 - count - !positive
	else
		length = - (Math.floor(1/number) + '').length - count + !positive
	digit = number/Math.pow 10, length
	digit = if round then Math.round digit else if !down then Math.ceil digit else Math.floor digit
	digit /= Math.pow 10, -length
