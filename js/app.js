// Generated by CoffeeScript 1.8.0
var DialogController, cordovaApp, moduleCtrl, moduleService;

angular.module('Monitor', ['ngMaterial', 'ngRoute', 'mobile-angular-ui', 'Diplom.controllers.Main', 'Diplom.services.Main', 'naif.base64']).config(function($mdThemingProvider) {
  return $mdThemingProvider.theme('default').primaryPalette('cyan');
}).config(function($routeProvider, $locationProvider) {
  persistence.store.websql.config(persistence, 'sensors3', 'База данных для мониторинга', 5 * 1024 * 1024);
  $routeProvider.when('/', {
    templateUrl: 'view/home.html',
    controller: 'MainController'
  }).when('/map/:objId', {
    templateUrl: 'view/map.html',
    controller: 'MapController'
  }).when('/sensor/:sensId', {
    templateUrl: 'view/sensor.html',
    controller: 'SensController'
  }).when('/list/:objId', {
    templateUrl: 'view/list.html',
    controller: 'ListController'
  });
  return $locationProvider.html5Mode({
    enable: false,
    requireBase: false
  });
}).constant('DB', {
  Obj: persistence.define('Obj', {
    name: "TEXT"
  }),
  SensCat: persistence.define('SensCat4', {
    name: "TEXT",
    ui: "INT",
    color: "INT"
  }),
  SensMany: persistence.define('SensMany', {
    sensor: "INT",
    GroupOfSens: "INT"
  }),
  Sensor: persistence.define('Sensor6', {
    name: "TEXT",
    top: "INT",
    left: "INT"
  }),
  Graph: persistence.define('Graph3', {
    date: "DATE",
    params: 'JSON'
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
  DB.Sensor.hasMany('graphs', DB.Graph, 'sens');
  DB.Sensor.hasOne('category', DB.SensCat);
  return persistence.schemaSync();
});

moduleCtrl = angular.module('Diplom.controllers.Main', []);

moduleService = angular.module('Diplom.services.Main', []);

angular.module('mobile-angular-ui', ['mobile-angular-ui.core.activeLinks', 'mobile-angular-ui.core.fastclick', 'mobile-angular-ui.core.sharedState', 'mobile-angular-ui.core.outerClick', 'mobile-angular-ui.components.modals', 'mobile-angular-ui.components.switch', 'mobile-angular-ui.components.sidebars', 'mobile-angular-ui.components.scrollable', 'mobile-angular-ui.components.navbars']);

cordovaApp = {
  initialize: function() {
    return this.bindEvents();
  },
  bindEvents: function() {
    return document.addEventListener('deviceready', this.onDeviceReady, false);
  },
  onDeviceReady: function() {
    return console.log('deviceready');
  }
};

cordovaApp.initialize();

moduleCtrl.controller('ListController', function($scope, $routeParams, List) {
  $scope.objId = $routeParams.objId;
  $scope.lazyShow = false;
  $scope.categories = [];
  $scope.checkboxMode = false;
  $scope.selected = [];
  $(function() {
    var w;
    w = $(window);
    $('.index-md-content').height(w.height() - 64);
    return w.resize(function() {
      return $('.index-md-content').height(w.height() - 64);
    });
  });
  $scope.check = function() {
    return $scope.checkboxMode = $scope.checkboxMode ? false : true;
  };
  $scope.build = function() {
    return console.log($scope.selected);
  };
  $scope.getData = function(item, list) {
    var ind;
    ind = list.indexOf(item.id);
    if (ind > -1) {
      return $scope.selected.splice(ind, 1);
    } else {
      return $scope.selected.push(item.id);
    }
  };
  return List.list($scope, $scope.objId);
});

moduleCtrl.controller('MainController', function($scope, $routeParams, Main, $mdDialog) {
  $scope.lists = [];
  $scope.lazyShow = true;
  $(function() {
    var w;
    w = $(window);
    $('.index-md-content').height(w.height() - 64);
    return w.resize(function() {
      return $('.index-md-content').height(w.height() - 64);
    });
  });
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
      templateUrl: 'view/dialog-add.tpl.html',
      targetEvent: e
    }).then(function(answer) {
      return Main.addObj(answer, $scope);
    });
  };
  $scope.showModal = function(e, id) {
    return $mdDialog.show({
      controller: DialogController,
      templateUrl: 'view/dialog.tpl.html',
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

moduleCtrl.controller('MapController', function($rootScope, $scope, $routeParams, Map, $mdDialog, $window, $document, $mdToast, $animate) {
  var CatDialogController;
  $scope.tabs = [
    {
      name: 'tab',
      img: '',
      sensors: []
    }
  ];
  $scope.mapId = 0;
  $scope.lazyShow = true;
  $scope.objId = $routeParams.objId;
  $scope.categories = [];
  $scope.colors = ['#d11d05', "#05A3D1", "#051FD1", "#FF528D", '#60061E', '#1d1075'];
  $scope.UI = [
    {
      name: 'Транзистор СИТИС',
      id: 1
    }, {
      name: 'Транзистор C-Sensor',
      id: 2
    }, {
      name: 'Датчик давления',
      id: 3
    }, {
      name: 'Деформационная марка',
      id: 4
    }, {
      name: 'Другой',
      id: 5
    }
  ];
  $rootScope.colors = $scope.colors;
  $rootScope.UI = $scope.UI;
  $scope.listCat = function() {
    return Map.listCat($scope);
  };
  $scope.onTab = function(id) {
    return $scope.mapId = id;
  };
  Map.list($scope, $routeParams.objId, $scope.colors);
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
    $scope.sens.type = void 0;
    return $(document).off('click touchstart', 'md-tab-content.md-active');
  };
  $scope.addSens = function(cat) {
    $('.help-screen').fadeOut(200, function() {
      return $(this).remove();
    });
    $(document).off('click touchstart', 'md-tab-content.md-active');
    $scope.showActionToast();
    $(".b-plan").each(function() {
      return $('<div class="help-screen" />').appendTo($(this)).fadeIn();
    });
    $(document).on('click', 'md-tab-content.md-active', function(e) {
      var $plan, h, left, ofsX, ofsY, top, w;
      ofsX = e.pageX - 25;
      ofsY = e.pageY - 136 + $(this).scrollTop();
      $plan = $(this).find('.b-plan');
      w = $plan.width();
      h = $plan.height();
      left = (ofsX / w * 100).toPrecision(3);
      top = (ofsY / h * 100).toPrecision(3);
      return Map.addSens('sensor', cat.id, $scope.colors, top, left, $routeParams.objId, $scope.mapId, $scope);
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
      templateUrl: 'view/dialog-add-map.tpl.html',
      targetEvent: e
    }).then(function(answer) {
      return Map.addPlan(answer.name, answer.img, $scope, $routeParams.objId);
    });
  };
  $scope.editPlan = function(e, id) {
    return $mdDialog.show({
      controller: DialogController,
      templateUrl: 'view/dialog-edit-map.tpl.html',
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
  $scope.showActionToast = function() {
    var toast;
    toast = $mdToast.simple().content('Режим добавления датчиков').action('Выключить').highlightAction(false).position($scope.getToastPosition());
    return $mdToast.show(toast).then(function() {
      return $scope.cancelAddPlan();
    });
  };
  $scope.addCat = function(e) {
    return $mdDialog.show({
      controller: CatDialogController,
      templateUrl: 'view/dialog-add-category.tpl.html',
      targetEvent: e
    }).then(function(answer) {
      return Map.addCat(answer.name, answer.color, answer.ui);
    });
  };
  return CatDialogController = function($scope, $mdDialog) {
    $scope.cancel = function() {
      return $mdDialog.cancel();
    };
    $scope.answer = function(answer) {
      return $mdDialog.hide(answer);
    };
    $scope.colors = $rootScope.colors;
    $scope.UI = $rootScope.UI;
    return $scope.listColor = function() {
      return Map.listColor($scope);
    };
  };
});

moduleCtrl.controller('SensController', function($rootScope, $scope, $routeParams, Sens, $window, $document, $mdDialog) {
  var $g, SensDialogController, SensEditDialogController, paper, s, updatePath;
  $scope.sensor = [];
  $scope.graph = [];
  $scope.categories = [];
  $scope.paramInput = false;
  $g = $('#graph');
  s = Snap('#graph');
  paper = s.paper;
  Sens.renameCat('430AE9AA56DC4DB3AE7664401BE0EB87', '3');
  updatePath = function(arr, paramY) {
    var el, getx, gety, h, i, ind, kx, ky, maxy, minx, miny, num, paramArr, style, time, w, _i, _j, _len, _len1, _results;
    paper.clear();
    arr = arr.filter(function(el, i, a) {
      if (el.params.hasOwnProperty(paramY)) {
        return true;
      } else {
        return false;
      }
    });
    if (!arr.length) {
      return false;
    }
    arr = arr.sort(function(a, b) {
      return a.date.getTime() - b.date.getTime();
    });
    num = arr.length;
    h = 320 / 2;
    w = 80 * num;
    if (w > $g.width()) {
      $g.width(w + 40);
    }
    style = {
      stroke: '#000'
    };
    paper.path("M 5," + (h * 2 - 5) + "L " + (w + 10) + "," + (h * 2 - 5) + "," + w + "," + (h * 2 - 10) + "," + w + "," + (h * 2) + "," + (w + 10) + "," + (h * 2 - 5) + ",").attr(style);
    paper.path("M 5," + (h * 2 - 5) + "L 5,0,10,10,0,10,5,0").attr(style);
    kx = (-arr[0].date.getTime() + arr[num - 1].date.getTime()) / w;
    minx = arr[0].date.getTime();
    paramArr = [];
    for (_i = 0, _len = arr.length; _i < _len; _i++) {
      i = arr[_i];
      paramArr.push(i.params[paramY]);
    }
    maxy = Math.max.apply(Math, paramArr);
    miny = Math.min.apply(Math, paramArr);
    ky = (maxy - miny) / (h + 50);
    getx = function(x) {
      if (!kx) {
        return 5;
      }
      return (x.date.getTime() - minx) / kx + 5;
    };
    gety = function(y) {
      if (!ky) {
        return h;
      }
      return h + 120 - (y.params[paramY] - miny) / ky;
    };
    paper.text(10, 20, paramY);
    paper.text(w + 15, h * 2, 't');
    _results = [];
    for (ind = _j = 0, _len1 = arr.length; _j < _len1; ind = ++_j) {
      el = arr[ind];
      time = [el.date.getDate(), el.date.getMonth() + 1, el.date.getFullYear() - 2000].join('.');
      paper.circle(getx(el), gety(el), 3).attr({
        fill: '#CB0000'
      });
      paper.text(getx(el) - 3, gety(el) - 10, el.params[paramY]);
      paper.text(getx(el) - 3, h * 2, time).transform('r90,' + (getx(el) - 5) + ',' + h * 2);
      if (ind === 0) {
        continue;
      }
      paper.path("M " + (getx(el)) + "," + (gety(el)) + "L" + (getx(el)) + "," + (h * 2 - 5)).attr({
        stroke: '#00BCD4'
      });
      _results.push(paper.path('M ' + getx(arr[ind - 1]) + ',' + gety(arr[ind - 1]) + 'L ' + getx(el) + ',' + gety(el)).attr(style));
    }
    return _results;
  };
  $scope.addParam = function() {
    if (!$scope.paramInput) {
      return $scope.paramInput = true;
    } else if (!$scope.paramName) {
      return $scope.paramInput = false;
    } else {
      $scope.paramInput = false;
      return $scope.params.push($scope.paramName);
    }
  };
  $scope.updatePath = function(param) {
    return updatePath($scope.graph, param);
  };
  $scope.removeSens = function(e) {
    var confirm;
    confirm = $mdDialog.confirm().parent(angular.element(document.body)).title('Вы уверены, что хотите удалить датчик?').ariaLabel('Подтверждение удаления').ok('Да').cancel('Нет').targetEvent(e);
    return $mdDialog.show(confirm).then(function() {
      return Sens.removeSens($routeParams.sensId, $scope);
    });
  };
  $scope.editSens = function(e) {
    return $mdDialog.show({
      controller: SensEditDialogController,
      templateUrl: 'view/dialog-edit-sens.tpl.html',
      targetEvent: e
    }).then(function(answer) {
      return Sens.editSens(answer.name, answer.category, $routeParams.sensId, $scope);
    });
  };
  $scope.removeGraph = function() {
    return Sens.removeGraph($scope);
  };
  $scope.addGraph = function(e) {
    return $mdDialog.show({
      controller: SensDialogController,
      templateUrl: 'view/dialog-add-graph.tpl.html',
      targetEvent: e
    }).then(function(answer) {
      return Sens.addGraph(answer.date, answer.params, $scope, $routeParams.sensId);
    });
  };
  Sens.list($scope, $routeParams.sensId);
  $scope.params = ['mu', 'eps'];
  $rootScope.params = $scope.params;
  SensEditDialogController = function($scope, $mdDialog) {
    $scope.cancel = function() {
      return $mdDialog.cancel();
    };
    $scope.answer = function(answer) {
      return $mdDialog.hide(answer);
    };
    return $scope.loadCat = function() {
      return Sens.loadCat($scope);
    };
  };
  return SensDialogController = function($rootScope, $scope, $mdDialog) {
    $scope.cancel = function() {
      return $mdDialog.cancel();
    };
    $scope.answer = function(answer) {
      return $mdDialog.hide({
        params: $scope.graph.val,
        date: answer
      });
    };
    $scope.params = $rootScope.params;
    return $scope.graph = {
      val: {}
    };
  };
});

moduleService.service('List', function(DB) {
  this.list = function($scope, objId) {
    var exp;
    exp = {
      obj: false
    };
    DB.Obj.findBy(persistence, null, 'id', objId, function(obj) {
      return exp.obj = obj ? obj : false;
    });
    DB.SensCat.all().list(function(cats) {
      if (cats.length) {
        return cats.forEach(function(cat, ind, ar) {
          return $scope.categories.push({
            name: cat.name,
            id: cat.id,
            sensors: []
          });
        });
      }
    });
    return persistence.flush(function() {
      if (exp.obj) {
        return exp.obj.sensors.list(function(senses) {
          if (senses.length) {
            $scope.lazyShow = true;
            senses.forEach(function(sens, ind, ar) {
              return sens.fetch('category', function(cat) {
                var i, _i, _len, _ref, _results;
                if (cat != null) {
                  _ref = $scope.categories;
                  _results = [];
                  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                    i = _ref[_i];
                    if (i.id === cat.id) {
                      _results.push(i.sensors.push({
                        name: sens.name,
                        id: sens.id
                      }));
                    } else {
                      _results.push(void 0);
                    }
                  }
                  return _results;
                }
              });
            });
            return persistence.flush(function() {
              $scope.lazyShow = false;
              return $scope.$apply();
            });
          }
        });
      }
    });
  };
});

moduleService.service('Main', function(DB) {
  this.list = function($scope) {
    return DB.Obj.all().list(function(items) {
      var arr;
      if (items.length) {
        $scope.lazyShow = true;
        arr = [];
        return items.forEach(function(item, ind, itemsArray) {
          var indLast;
          indLast = itemsArray.length - 1;
          return item.sensors.list(function(res) {
            var count;
            count = res.length;
            arr.push({
              name: item.name,
              id: item.id,
              count: count
            });
            $scope.lists = arr;
            if (ind === indLast) {
              $scope.lazyShow = false;
            }
            return $scope.$apply();
          });
        });
      }
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
  this.list = function($scope, objId, colors) {
    return DB.Obj.findBy(persistence, null, 'id', objId, function(obj) {
      if (obj) {
        return obj.maps.list(function(items) {
          var arr;
          arr = [];
          if (items.length === 0) {
            $scope.lazyShow = false;
            $scope.tabs = [];
            $scope.$apply();
            return;
          }
          return items.forEach(function(item) {
            var sensors;
            sensors = [];
            return item.sensors.list(null, function(sens) {
              sens.forEach(function(sen) {
                return sen.fetch('category', function(cat) {
                  cat = cat ? cat : 4;
                  return sensors.push({
                    id: sen.id,
                    top: sen.top,
                    name: sen.name,
                    left: sen.left,
                    color: colors[cat.color]
                  });
                });
              });
              return persistence.flush(function() {
                arr.push({
                  name: item.name,
                  id: item.id,
                  img: item.img,
                  sensors: sensors
                });
                $scope.mapId = arr[0].id;
                $scope.tabs = arr;
                $scope.lazyShow = false;
                return $scope.$apply();
              });
            });
          });
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
      return $scope.tabs.forEach(function(elem, ind) {
        var selInd;
        if (elem.id === id) {
          $scope.tabs.splice(ind, 1);
          $scope.$apply();
        }
        selInd = $scope.tabs[$scope.selectedIndex] || {
          id: 0
        };
        return $scope.mapId = selInd.id != null ? selInd.id : void 0;
      });
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
  this.addSens = function(sensName, sensTypeId, colors, top, left, objId, mapId, $scope) {
    var exp, s;
    exp = {
      obj: false,
      map: false,
      type: false
    };
    DB.Obj.findBy(persistence, null, 'id', objId, function(obj) {
      if (obj) {
        return exp.obj = obj;
      }
    });
    DB.Maps.findBy(persistence, null, 'id', mapId, function(map) {
      if (map) {
        return exp.map = map;
      }
    });
    DB.SensCat.findBy(persistence, null, 'id', sensTypeId, function(type) {
      if (type) {
        return exp.type = type;
      }
    });
    s = new DB.Sensor({
      name: sensName,
      top: top,
      left: left
    });
    return persistence.flush(function() {
      if (exp.obj && exp.map && exp.type) {
        s.category = exp.type;
        exp.obj.sensors.add(s);
        exp.map.sensors.add(s);
        return persistence.flush(function() {
          return $scope.tabs.forEach(function(tabs, ind) {
            var _base;
            if (tabs.id === exp.map.id) {
              if ((_base = $scope.tabs[ind]).sensors == null) {
                _base.sensors = [];
              }
              $scope.tabs[ind].sensors.push({
                id: s.id,
                type: sensTypeId,
                name: sensName,
                top: top,
                left: left,
                color: colors[exp.type.color]
              });
              return $scope.$apply();
            }
          });
        });
      }
    });
  };
  this.addCat = function(nameCat, color, ui) {
    var c;
    c = new DB.SensCat;
    c.name = nameCat;
    c.color = color;
    c.ui = ui;
    persistence.add(c);
    return persistence.flush(function() {
      return console.log("sensor " + c.name + " added with color " + color + " and ui number " + ui + "!");
    });
  };
  this.listCat = function($scope) {
    return DB.SensCat.all().list(function(cats) {
      var arrCats;
      if (cats) {
        arrCats = [];
        return cats.forEach(function(cat, ind, ar) {
          arrCats.push({
            id: cat.id,
            name: cat.name,
            color: cat.color
          });
          if (ind === ar.length - 1) {
            $scope.categories = arrCats;
            return $scope.$apply();
          }
        });
      }
    });
  };
});

moduleService.service('Sens', function(DB, $window) {
  this.list = function($scope, sensId) {
    return DB.Sensor.findBy(persistence, null, 'id', sensId, function(sens) {
      var arr;
      arr = [];
      sens.fetch('obj', function(obj) {
        var objId, objName;
        objName = obj.name;
        objId = obj.id;
        return sens.fetch('map', function(map) {
          var mapName;
          mapName = map.name;
          arr.push({
            id: sens.id,
            top: sens.top,
            name: sens.name,
            left: sens.left,
            obj: objName,
            objId: objId,
            map: mapName
          });
          $scope.sensor = arr;
          return $scope.$apply();
        });
      });
      return sens.graphs.list(function(graphs) {
        var graphArr, l;
        graphArr = [];
        l = graphs.length;
        return graphs.forEach(function(graph, ind) {
          var ar1, ar2, el1, el2, i, j, params, _i, _j, _k, _len, _len1, _len2;
          params = JSON.parse(graph.params);
          graphArr.push({
            date: new Date(graph.date),
            params: params
          });
          ar2 = Object.keys(params);
          ar1 = $scope.params;
          for (i = _i = 0, _len = ar1.length; _i < _len; i = ++_i) {
            el1 = ar1[i];
            for (j = _j = 0, _len1 = ar2.length; _j < _len1; j = ++_j) {
              el2 = ar2[j];
              if (el1 !== el2) {
                continue;
              }
              ar2.splice(j, 1);
            }
          }
          for (_k = 0, _len2 = ar2.length; _k < _len2; _k++) {
            i = ar2[_k];
            $scope.params.push(i);
          }
          if (ind === l - 1) {
            $scope.graph = graphArr;
            $scope.$apply();
            return $scope.updatePath(Object.getOwnPropertyNames(graphArr[0].params)[0]);
          }
        });
      });
    });
  };
  this.removeSens = function(id, $scope) {
    return DB.Sensor.findBy(persistence, null, 'id', id, function(sens) {
      return sens.fetch('obj', function(obj) {
        persistence.remove(sens);
        return persistence.flush(function() {
          return $window.location.href = "#/map/" + obj.id;
        });
      });
    });
  };
  this.removeGraph = function($scope) {
    return DB.Graph.all().destroyAll(function() {});
  };
  this.editSens = function(newName, category, id, $scope) {
    return DB.Sensor.findBy(persistence, null, 'id', id, function(sens) {
      if (sens) {
        if (newName) {
          sens.name = newName;
          persistence.flush(function() {
            $scope.sensor[0].name = newName;
            return $scope.$apply();
          });
        }
        if (category) {
          return DB.SensCat.findBy(persistence, null, 'id', category, function(cat) {
            if (cat) {
              sens.category = cat;
              return persistence.flush(function() {});
            }
          });
        }
      }
    });
  };
  this.addCat = function(nameCat, color) {
    var c;
    c = new DB.SensCat;
    c.name = nameCat;
    c.color = color;
    persistence.add(c);
    return persistence.flush(function() {
      return console.log("sensor " + c.name + " added with color " + color + "!");
    });
  };
  this.renameCat = function(id, newcolor) {
    return DB.SensCat.findBy(persistence, null, 'id', id, function(cat) {
      return cat.color = newcolor;
    });
  };
  this.loadCat = function($scope) {
    return DB.SensCat.all().list(function(cats) {
      var arrCats;
      if (cats) {
        arrCats = [];
        return cats.forEach(function(cat, ind, ar) {
          arrCats.push({
            id: cat.id,
            name: cat.name
          });
          if (ind === ar.length - 1) {
            $scope.categories = arrCats;
            return $scope.$apply();
          }
        });
      }
    });
  };
  this.addGraph = function(date, params, $scope, sensId) {
    return DB.Sensor.findBy(persistence, null, 'id', sensId, function(sens) {
      var t;
      t = new DB.Graph;
      t.date = date;
      t.params = JSON.stringify(params);
      sens.graphs.add(t);
      return persistence.flush(function() {
        $scope.graph.push({
          date: date,
          params: params
        });
        $scope.$apply();
        return $scope.updatePath('eps');
      });
    });
  };
});
