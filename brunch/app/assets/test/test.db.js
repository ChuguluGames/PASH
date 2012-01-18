describe('Database', function() {
  var img_data = {
    url: 'http://spots.com',
    path: '/some/path'
  };

  var remove_callback = function() {
    describe("#filter(ImageModel.url = '" + img_data.url + "')", function() {
      it ('should NOT find ImageModels', function(filter_done) {
        ImageModel.all().filter('url', '=', img_data.url).one(null, function(result) {
          bdd_assert(result == null, 'result != null', filter_done);
        });
      });
    });
  }

  var db_remove = function(object) {
    describe("#remove(ImageModel{url: '" + object.url + "', path: '" + object.path + "'})", function() {
      it('should callback', function(remove_done) {
        app.helpers.db.remove(object, function() {
          remove_done();
          remove_callback();
        });
      });
    });
  }

  var save_callback = function() {
    describe("#filter(ImageModel.url = '" + img_data.url + "')", function() {
      it ('should find one ImageModel', function(filter_done) {
        ImageModel.all().filter('url', '=', img_data.url).one(null, function(result) {
          if (bdd_assert(result != null, 'result == null', filter_done))
            db_remove(result);
        });
      });
    });
  }

  var db_save = function() {
    describe("#save(ImageModel{url: '" + img_data.url + "', path: '" + img_data.path + "'})", function() {
      it('should callback', function(save_done) {
        app.helpers.db.save(new ImageModel(img_data), function() {
          save_done();
          save_callback();
        });
      });
    });
  }

  it('should be created', function() {
    bdd_assert(app.helpers.db.created, 'created : ' + app.helpers.db.created);
  });

  it('store should be websql', function() {
    bdd_assert(app.helpers.db.store_type == "websql", 'store type is ' + app.helpers.db.store_type);
  });

  it('models should be defined', function() {
    var models = [
      'player',
      'tag',
      'pack',
      'item',
      'difference',
      'difference_point',
      'image'
    ];
    var _i, _len, matches;
    for (_i = 0, _len = models.length; _i < _len; _i++)
      bdd_assert(app.helpers.db.modelIsDefined(models[_i]), models[_i] + ' is undefined');
  });
  db_save();
});
