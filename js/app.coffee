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
		persistence.store.websql.config persistence, 'sensors3', 'База данных для мониторинга', 5 * 1024 * 1024
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
        $locationProvider.html5Mode
            enable: false
            requireBase: false

	.constant 'DB',
        Obj: persistence.define 'Obj',  
            name: "TEXT"
        SensCat: persistence.define 'SensCat4',  
            name: "TEXT"
            ui: "INT"
            color: "INT"
        SensMany: persistence.define 'SensMany',  
            sensor: "INT",
            GroupOfSens: "INT"
        Sensor: persistence.define 'Sensor7',  
            name: "TEXT",
            top: "INT"
            left: "INT"
            key: 'JSON'
        Graph: persistence.define 'Graph3',  
            date: "DATE",
            params: 'JSON'
        GroupOfSens: persistence.define 'GroupOfSens',  
            name: "TEXT",
            sensCat: "INT",
            obj: "INT"
        Maps: persistence.define 'Maps5',
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
        document.addEventListener('deviceready', this.onDeviceReady, false)
    onDeviceReady: ()->
        console.log 'deviceready'

do cordovaApp.initialize