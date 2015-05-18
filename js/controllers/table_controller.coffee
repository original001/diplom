moduleCtrl.controller 'TableController', ($scope, $routeParams, Table, $mdDialog) ->
	$scope.lazyShow = false
	$scope.sensor =
		name: ''

	$scope.params = []
	$scope.nameOfParams = []

	Table.list $scope, $routeParams.sensId

	$ ->
		w = $ window
		$ '.index-md-content'
			.height w.height() - 64
		w.resize ->
			$ '.index-md-content'
				.height w.height() - 64

	$scope.setName = (e) ->
		$mdDialog.show
			controller: DialogController
			templateUrl: 'view/dialog-add.tpl.html'
			targetEvent: e
		.then (answer) ->
			console.log answer
			$scope.exportTable answer

	$scope.alert = (e, title = '', content = '') ->
		$mdDialog.show(
			$mdDialog.alert()
			.parent(angular.element(document.body))
			.title(title)
			.content(content)
			.ariaLabel('Alert Dialog')
			.ok('ОК')
			.targetEvent(e)
		)

	$scope.exportTable = (name) ->
		html = document.getElementById 'table'

		serializer = new XMLSerializer()
		htmlStr = serializer.serializeToString(html)
		encodedHtmlStr = unescape(encodeURIComponent(htmlStr))
		htmlData = btoa(encodedHtmlStr)

		console.log htmlData

		downloadFile = () ->
            console.log('downloadFile')
            window.requestFileSystem(
                LocalFileSystem.PERSISTENT,
                0,
                onRequestFileSystemSuccess,
                fail)
        
        onRequestFileSystemSuccess = (fileSystem) ->
            console.log('onRequestFileSystemSuccess')
            fileSystem.root.getFile(
                '/storage/emulated/0/Download/table.html',
                {create: true, exclusive: false},
                onGetFileSuccess,
                fail)
        
        onGetFileSuccess = (fileEntry) ->
            console.log('onGetFileSuccess!')
            path = fileEntry.toURL().replace('table.html', '')
            fileTransfer = new FileTransfer()
            fileEntry.remove()
            
            fileTransfer.download(
                "data:text/html;base64," + htmlData,
                path + "#{name}.html",
                (file) ->
                    $scope.alert null, 'График успешно загружен', "Файл находится в папке Download, имя файла - #{name}.html"
                (error) ->
                    $scope.alert null, 'При загрузке возникла ошибка', "Код ошибки – #{error.code}, объект загрузки – #{error.target}")
        
        
        fail = (evt) ->
            $scope.alert null, 'При загрузке возникла ошибка', "Код ошибки – #{evt.target.error.code}"

		if cordovaApp.isReady 
			console.log 'ready and fire function'
			do downloadFile
		else 
            $scope.alert null, 'Oшибка!', "cordova.js не загружен"


