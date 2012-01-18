helper = {}

helper.tag = "DbHelper"

helper.remove = (object, callback) ->
  if !object?
    return
  persistence.remove object
  persistence.flush null, callback

helper.save = (object, callback) ->
  if !object?
    return
  persistence.add object
  persistence.flush null, callback

helper.createDatabase = (dbname, dbdescription, dbsize, dbversion, callback) ->
  app.log.info "creating database '" + dbname + "'", @tag
  supports_webdatabase = !!window.openDatabase
  using_localstorage = !supports_webdatabase

  if supports_webdatabase
    app.log.info "using websql", @tag
    persistence.store.websql.config persistence, dbname, dbdescription, dbsize
  else
    app.log.info "using memory", @tag
    persistence.store.memory.config persistence, dbdescription, dbsize, dbversion

  persistence.debug = @verbose
  persistence.schemaSync ->
    app.log.info "schema synced", @tag
    callback() if callback?
#  persistence.flush null, ->
#    helper.log 'changes flushed'

helper.createTestDatabase = (callback) ->
  helper.createDatabase "test_pash", "database", 5 * 1024 * 1024, '1.0', callback

helper.createProductionDatabase = (callback) ->
  helper.createDatabase "pash", "database", 5 * 1024 * 1024, '1.0', callback

helper.collectionToArray = (collection) ->
  array=[]
  collection.each null, (item) ->
    array.push item

  array

exports.DbHelper = helper
