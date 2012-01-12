var supports_webdatabase = !!window.openDatabase
var using_localstorage = !supports_webdatabase

if (supports_webdatabase) {
    // Empty methods which would be implemented by persistence.store.memory
    persistence.loadFromLocalStorage = function(callback) { callback(); };
    persistence.saveToLocalStorage = function(callback) { callback(); };
    // Use WebSQL
    persistence.store.websql.config(persistence, "pash", 'database', 5 * 1024 * 1024);
}
else { // Use localStorage
    persistence.store.memory.config(persistence, 'database', 5 * 1024 * 1024, '1.0');
}

persistence.debug = true;

var tablesDefinition = {};

function initializeTable(model) {
  var name = model.name, relation, collection, collectionModel, collectionEntity;

  console.log(model.name)

  if(typeof tablesDefinition[name] == 'undefined') {
    tablesDefinition[name] = persistence.define(model.name, model.table);

    if (typeof model.has_many != "undefined") {

      for (var i = 0; i < model.has_many.length; i++ ) {
        relation = model.has_many[i];
        collection = model.get(relation);
        collectionModel = new collection.model();

        collectionEntity = initializeTable(collectionModel);
        tablesDefinition[name].hasMany(relation, collectionEntity, model.name);
      }
    }

  }

  return tablesDefinition[name];
}

function crudCreate(model) {
  var item = new (initializeTable(model))();

  for (var prop in model.table) {
    item[prop] = model.get(prop);
  }

  persistence.schemaSync(function() {
    console.log("shema sync");
  });

  persistence.add(item);

  model.set({id: item.id}, {silent: true});
  model.id = item.id;

  persistence.flush(function() {
    console.log('Done flushing');
  })
};

function updateCreate(model) {
  var item = new (initializeTable(model))();

  for (var prop in model.table) {
    item[prop] = model.get(prop);
  }

  persistence.schemaSync(function() {
    console.log("shema sync");
  });

  persistence.flush(function() {
    console.log('Done flushing');
  })
};

Backbone.sync = function(method, model, success, error) {
  console.log(method);
  switch (method) {
    case "read":  break;
    case "create": crudCreate(model); break;
    case "update": updateCreate(model); break;
    case "delete": break;
  }
};
