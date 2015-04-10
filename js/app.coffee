angular.module 'Monitor', [
    'ngMaterial'
    'ngRoute'
	# 'mobile-angular-ui'
	'Diplom.controllers.Main'
	'Diplom.services.Main']

	.config ($routeProvider) -> 
		@timeNow = new Date().getTime()
		persistence.store.websql.config persistence, 'sensors2', 'База данных для мониторинга', 5 * 1024 * 1024
		$routeProvider.when '/', 
			templateUrl:'home.html'
			reloadOnSearch: false

	.constant 'DB',
        Obj: persistence.define 'Obj',  
            name: "TEXT"
        SensCat: persistence.define 'SensCat',  
            name: "TEXT"
        SensMany: persistence.define 'SensMany',  
            sensor: "INT",
            GroupOfSens: "INT"
        Sensor: persistence.define 'Sensor',  
            name: "TEXT",
            sensCat: "INT",
            date: "DATE"
        Graph: persistence.define 'Graph',  
            sensor: "INT",
            date: "DATE",
            mu: "INT",
            eps: "INT"
        GroupOfSens: persistence.define 'GroupOfSens',  
            name: "TEXT",
            sensCat: "INT",
            obj: "INT"
        Maps: persistence.define 'Maps',  
            floor: "INT",
            obj: "INT",
            sensor: "INT",
            coorx: "INT",
            coory: "INT"

# angular.module 'mobile-angular-ui', [
#     'mobile-angular-ui.core.activeLinks',
#     'mobile-angular-ui.core.fastclick',
#     'mobile-angular-ui.core.sharedState',
#     'mobile-angular-ui.core.outerClick', 
#     'mobile-angular-ui.components.modals',
#     'mobile-angular-ui.components.switch',
#     'mobile-angular-ui.components.sidebars',
#     'mobile-angular-ui.components.scrollable', 
#     'mobile-angular-ui.components.navbars']


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