// Generated by CoffeeScript 1.8.0
var DialogController, cordovaApp, moduleCtrl, moduleService;

angular.module('Monitor', ['ngMaterial', 'ngRoute', 'mobile-angular-ui', 'Diplom.controllers.Main', 'Diplom.services.Main', 'naif.base64']).config(function($mdThemingProvider) {
  return $mdThemingProvider.theme('default').primaryPalette('cyan');
}).config(function($routeProvider, $locationProvider) {
  persistence.store.websql.config(persistence, 'sensors2', 'База данных для мониторинга', 5 * 1024 * 1024);
  $routeProvider.when('/', {
    templateUrl: 'view/home.html',
    controller: 'MainController'
  }).when('/map/:objId', {
    templateUrl: 'view/map.html',
    controller: 'MapController'
  });
  return $locationProvider.html5Mode({
    enable: false,
    requireBase: false
  });
}).constant('DB', {
  Obj: persistence.define('Obj', {
    name: "TEXT"
  }),
  SensCat: persistence.define('SensCat', {
    name: "TEXT"
  }),
  SensMany: persistence.define('SensMany', {
    sensor: "INT",
    GroupOfSens: "INT"
  }),
  Sensor: persistence.define('Sensor5', {
    name: "TEXT",
    top: "INT",
    left: "INT"
  }),
  Graph: persistence.define('Graph', {
    date: "DATE",
    mu: "INT",
    eps: "INT"
  }),
  GroupOfSens: persistence.define('GroupOfSens', {
    name: "TEXT",
    sensCat: "INT",
    obj: "INT"
  }),
  Maps: persistence.define('Maps5', {
    name: "TEXT",
    img: "TEXT"
  })
}).config(function(DB) {
  DB.Maps.hasMany('sensors', DB.Sensor, 'map');
  DB.Obj.hasMany('maps', DB.Maps, 'obj');
  DB.Obj.hasMany('sensors', DB.Sensor, 'obj');
  return persistence.schemaSync();
});

angular.module('mobile-angular-ui', ['mobile-angular-ui.core.activeLinks', 'mobile-angular-ui.core.fastclick', 'mobile-angular-ui.core.sharedState', 'mobile-angular-ui.core.outerClick', 'mobile-angular-ui.components.modals', 'mobile-angular-ui.components.switch', 'mobile-angular-ui.components.sidebars', 'mobile-angular-ui.components.scrollable', 'mobile-angular-ui.components.navbars']);

cordovaApp = {
  initialize: function() {
    return this.bindEvents();
  },
  bindEvents: function() {
    return document.addEventListener('deviceready', this.onDeviceReady, false);
  },
  onDeviceReady: function() {
    return app.receivedEvent('deviceready');
  },
  receivedEvent: function(id) {
    var listeningElement, parentElement, receivedElement;
    parentElement = document.getElementById(id);
    listeningElement = parentElement.querySelector('.listening');
    receivedElement = parentElement.querySelector('.received');
    listeningElement.setAttribute('style', 'display:none');
    receivedElement.setAttribute('style', 'display:block');
    return console.log('Received Event: ' + id);
  }
};

cordovaApp.initialize();

moduleCtrl = angular.module('Diplom.controllers.Main', []).controller('MainController', function($scope, $routeParams, Main, $mdDialog) {
  $scope.lists = [];
  Main.list($scope);
  $scope.showConfirm = function(e, id) {
    var confirm;
    confirm = $mdDialog.confirm().parent(angular.element(document.body)).title('Вы уверены, что хотите удалить объект').ariaLabel('Подтверждение удаления').ok('Да').cancel('Нет').targetEvent(e);
    return $mdDialog.show(confirm).then(function() {
      return Main.remove(id, $scope);
    });
  };
  $scope.showModalAdd = function(e, name) {
    return $mdDialog.show({
      controller: DialogController,
      templateUrl: '/view/dialog-add.tpl.html',
      targetEvent: e
    }).then(function(answer) {
      return Main.addObj(answer, $scope);
    });
  };
  $scope.showModal = function(e, id) {
    return $mdDialog.show({
      controller: DialogController,
      templateUrl: '/view/dialog.tpl.html',
      targetEvent: e
    }).then(function(answer) {
      return Main.update(id, answer, $scope);
    });
  };
  $scope.addSens = function(nameSens, nameObj) {
    return Main.addSens(nameSens, nameObj, $scope);
  };
  $scope.update = function(id, newname) {
    return Main.update(id, newname, $scope);
  };
  $scope.addObj = function(name) {
    return Main.addObj(name, $scope);
  };
  $scope.remove = function(id) {
    return Main.remove(id, $scope);
  };
  return $scope.hello = function(name) {
    return Main.say(name);
  };
});

DialogController = function($scope, $mdDialog) {
  $scope.cancel = function() {
    return $mdDialog.cancel();
  };
  return $scope.answer = function(answer) {
    return $mdDialog.hide(answer);
  };
};

moduleCtrl.controller('MapController', function($scope, $routeParams, Map, $mdDialog, $window, $document, $mdToast, $animate) {
  var array;
  $scope.tabs = [
    {
      name: 'tab',
      img: '',
      sensors: []
    }
  ];
  $scope.mapId = 0;
  $scope.lazyShow = true;
  $scope.onTab = function(id) {
    return $scope.mapId = id;
  };
  Map.list($scope, $routeParams.objId);
  array = [
    {
      name: '1 floor',
      img: 'img/plans/plqn1.jpg',
      sensors: [
        {
          id: '58GH7ADF68',
          top: 34.4,
          left: 45.5
        }, {
          id: '79AF58GH',
          top: 64.4,
          left: 15.5
        }, {
          id: '8B7AD60FB',
          top: 24.4,
          left: 46.5
        }
      ]
    }, {
      name: '2 floor',
      img: 'img/plans/plan_doma.gif',
      sensors: [
        {
          id: '58GH7ADF68',
          top: 34.4,
          left: 45.5
        }, {
          id: '79AF58GH',
          top: 64.4,
          left: 15.5
        }, {
          id: '8B7AD60FB',
          top: 24.4,
          left: 46.5
        }
      ]
    }, {
      name: '3 floor',
      img: 'img/plans/zad_plan.png',
      sensors: [
        {
          id: '58GH7ADF68',
          top: 34.4,
          left: 45.5
        }, {
          id: '79AF58GH',
          top: 64.4,
          left: 15.5
        }, {
          id: '8B7AD60FB',
          top: 24.4,
          left: 46.5
        }
      ]
    }
  ];
  $(function() {
    var w;
    w = $(window);
    $('.index-md-content').height(w.height() - 64);
    return w.resize(function() {
      return $('.index-md-content').height(w.height() - 64);
    });
  });
  $scope.cancelAddPlan = function() {
    $('.help-screen').fadeOut(200, function() {
      return $(this).remove();
    });
    return $(document).off('click', 'md-tab-content.md-active');
  };
  $scope.addSens = function() {
    var toast;
    toast = false;
    $(".b-plan").each(function() {
      return $('<div class="help-screen" />').appendTo($(this)).fadeIn();
    });
    $(document).on('click', 'md-tab-content.md-active', function(e) {
      var $plan, h, left, sensor, top, w;
      if (!toast) {
        toast = true;
        $scope.showActionToast();
      }
      $plan = $(this).find('.b-plan');
      w = $plan.width();
      h = $plan.height();
      left = (e.offsetX / w * 100).toPrecision(3);
      top = (e.offsetY / h * 100).toPrecision(3);
      sensor = $('<a />').css({
        top: top + '%',
        left: left + '%'
      }).addClass('sensor');
      Map.addSens('sensor', top, left, $routeParams.objId, $scope.mapId, $scope);
      return $(this).find('.b-plan').append(sensor);
    });
  };
  $scope.deletePlan = function(e, id) {
    var confirm;
    confirm = $mdDialog.confirm().parent(angular.element(document.body)).title('Вы уверены, что хотите удалить карту?').ariaLabel('Подтверждение удаления').ok('Да').cancel('Нет').targetEvent(e);
    return $mdDialog.show(confirm).then(function() {
      return Map.removePlan(id, $scope);
    });
  };
  $scope.showModalAdd = function(e, name) {
    return $mdDialog.show({
      controller: DialogController,
      templateUrl: '/view/dialog-add-map.tpl.html',
      targetEvent: e
    }).then(function(answer) {
      return Map.addPlan(answer.name, answer.img, $scope, $routeParams.objId);
    });
  };
  $scope.editPlan = function(e, id) {
    return $mdDialog.show({
      controller: DialogController,
      templateUrl: '/view/dialog-edit-map.tpl.html',
      targetEvent: e
    }).then(function(answer) {
      return Map.update(id, answer.name, answer.img, $scope);
    });
  };
  $scope.toastPosition = {
    bottom: false,
    top: true,
    left: false,
    right: true
  };
  $scope.getToastPosition = function() {
    return Object.keys($scope.toastPosition).filter(function(pos) {
      return $scope.toastPosition[pos];
    }).join(' ');
  };
  return $scope.showActionToast = function() {
    var toast;
    toast = $mdToast.simple().content('Датчик добавлен').action('Сохранить').highlightAction(false).position($scope.getToastPosition());
    return $mdToast.show(toast).then(function() {
      return $scope.cancelAddPlan();
    });
  };
});

moduleService = angular.module('Diplom.services.Main', []).service('Main', function(DB) {
  this.list = function($scope) {
    return DB.Obj.all().list(function(items) {
      var arr;
      arr = [];
      return items.forEach(function(item) {
        return item.sensors.list(function(res) {
          var count;
          count = res.length;
          arr.push({
            name: item.name,
            id: item.id,
            count: count
          });
          $scope.lists = arr;
          return $scope.$apply();
        });
      });
    });
  };
  this.addObj = function(name, $scope) {
    var t;
    t = new DB.Obj;
    t.name = name;
    persistence.add(t);
    persistence.flush();
    return $scope.lists.push({
      name: name,
      id: t.id,
      count: 0
    });
  };
  this.remove = function(id, $scope) {
    return DB.Obj.all().filter('id', '=', id).destroyAll(function() {
      return $scope.lists.forEach(function(elem, ind) {
        if (elem.id === id) {
          $scope.lists.splice(ind, 1);
          return $scope.$apply();
        }
      });
    });
  };
  this.update = function(id, newName, $scope) {
    return DB.Obj.all().filter('id', '=', id).one(function(obj) {
      obj.name = newName;
      return persistence.flush(function() {
        return $scope.lists.forEach(function(item, ind) {
          if (item.id === obj.id) {
            item.name = newName;
            return $scope.$apply();
          }
        });
      });
    });
  };
  this.addSens = function(sensName, objName, $scope) {
    return DB.Obj.findBy(persistence, null, 'name', objName, function(obj) {
      var s;
      if (obj) {
        s = new DB.Sensor({
          name: sensName,
          sensCat: "1",
          date: new Date().getTime()
        });
        obj.sensors.add(s);
        return persistence.flush(function() {
          return $scope.lists.forEach(function(item, ind) {
            if (item.name === obj.name) {
              item.count += 1;
              return $scope.$apply();
            }
          });
        });
      }
    });
  };
});

moduleService.service('Map', function(DB) {
  this.list = function($scope, objId) {
    return DB.Obj.findBy(persistence, null, 'id', objId, function(obj) {
      if (obj) {
        return obj.maps.list(function(items) {
          var arr;
          arr = [];
          if (items.length !== 0) {
            return items.forEach(function(item) {
              var sensors;
              sensors = [];
              return item.sensors.list(null, function(sens) {
                sens.forEach(function(sen) {
                  return sensors.push({
                    id: sen.id,
                    top: sen.top,
                    left: sen.left
                  });
                });
                arr.push({
                  name: item.name,
                  id: item.id,
                  img: item.img,
                  sensors: sensors
                });
                $scope.mapId = arr[0].id;
                $scope.tabs = arr;
                $scope.$apply();
                return $scope.lazyShow = false;
              });
            });
          }
        });
      }
    });
  };
  this.addPlan = function(name, img, $scope, objId) {
    return DB.Obj.findBy(persistence, null, 'id', objId, function(obj) {
      var t;
      if (obj) {
        t = new DB.Maps;
        t.name = name;
        t.img = img;
        obj.maps.add(t);
        return persistence.flush(function() {
          $scope.tabs.push({
            id: t.id,
            name: name,
            img: img,
            sensors: []
          });
          $scope.mapId = t.id;
          return $scope.$apply();
        });
      }
    });
  };
  this.removePlan = function(id, $scope) {
    return DB.Maps.all().filter('id', '=', id).destroyAll(function() {
      $scope.tabs.forEach(function(elem, ind) {
        if (elem.id === id) {
          $scope.tabs.splice(ind, 1);
          return $scope.$apply();
        }
      });
      return $scope.mapId = $scope.tabs[$scope.selectedIndex].id;
    });
  };
  this.update = function(id, newName, newImg, $scope) {
    return DB.Maps.all().filter('id', '=', id).one(function(obj) {
      obj.name = newName;
      if (newImg) {
        obj.img = newImg;
      }
      return persistence.flush(function() {
        return $scope.tabs.forEach(function(item, ind) {
          if (item.id === obj.id) {
            item.name = newName;
            if (newImg) {
              item.img = newImg;
            }
            return $scope.$apply();
          }
        });
      });
    });
  };
  this.addSens = function(sensName, top, left, objId, mapId, $scope) {
    return DB.Obj.findBy(persistence, null, 'id', objId, function(obj) {
      if (obj) {
        return DB.Maps.findBy(persistence, null, 'id', mapId, function(map) {
          var s;
          if (map) {
            s = new DB.Sensor({
              name: sensName,
              top: top,
              left: left
            });
            obj.sensors.add(s);
            map.sensors.add(s);
            return persistence.flush(function() {
              return $scope.tabs.forEach(function(item, ind) {
                var _base;
                if (item.id === map.id) {
                  if ((_base = $scope.tabs).sensors == null) {
                    _base.sensors = [];
                  }
                  $scope.tabs.sensors.push({
                    id: s.id,
                    top: top,
                    left: left
                  });
                  return $scope.$apply();
                }
              });
            });
          }
        });
      }
    });
  };
});

//# sourceMappingURL=app.js.map
