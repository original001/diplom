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
		persistence.store.websql.config persistence, 'sensors2', 'База данных для мониторинга', 5 * 1024 * 1024
		$routeProvider.when '/', 
            templateUrl: 'view/home.html'
            controller: 'MainController'
        .when '/map/:objId',
            templateUrl:'view/map.html'
            controller: 'MapController'
        $locationProvider.html5Mode true

	.constant 'DB',
        Obj: persistence.define 'Obj',  
            name: "TEXT"
        SensCat: persistence.define 'SensCat',  
            name: "TEXT"
        SensMany: persistence.define 'SensMany',  
            sensor: "INT",
            GroupOfSens: "INT"
        Sensor: persistence.define 'Sensor4',  
            name: "TEXT",
            sensCat: "INT",
            top: "INT"
            left: "INT"
        Graph: persistence.define 'Graph',  
            date: "DATE",
            mu: "INT",
            eps: "INT"
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
        persistence.schemaSync()
        

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
        app.receivedEvent('deviceready')
    receivedEvent: (id) -> 
        parentElement = document.getElementById(id)
        listeningElement = parentElement.querySelector('.listening')
        receivedElement = parentElement.querySelector('.received')

        listeningElement.setAttribute('style', 'display:none')
        receivedElement.setAttribute('style', 'display:block')

        console.log('Received Event: ' + id)

do cordovaApp.initialize