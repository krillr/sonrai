// Generated by CoffeeScript 1.8.0
(function() {
  var MyDatabase, MyModel, Sonrai, test,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Sonrai = require('../sonrai');

  test = require('tape');

  MyDatabase = new Sonrai.Databases.LocalStorageDatabase();

  MyModel = (function(_super) {
    __extends(MyModel, _super);

    function MyModel() {
      return MyModel.__super__.constructor.apply(this, arguments);
    }

    MyModel.db = MyDatabase;

    MyModel.prototype._fields = {
      myField: Sonrai.Fields.NumberField({
        "default": 1
      }),
      dateField: Sonrai.Fields.DateTimeField({
        "default": function() {
          return new Date();
        }
      })
    };

    return MyModel;

  })(Sonrai.Model);

  test('General tests', function(t) {
    var obj, q, results, s, x, _i;
    t.plan(1);
    s = new Date().getTime();
    for (x = _i = 0; _i <= 100000; x = ++_i) {
      obj = new MyModel({
        myField: Sonrai.Utils.rand(100)
      });
      obj.save();
    }
    console.log((new Date().getTime()) - s);
    q = new Sonrai.Query(MyModel);
    q = q.filter({
      myField: obj.get('myField')
    });
    results = q.run();
    return t.equal(results[0].get('myField'), obj.get('myField'));
  });

}).call(this);
