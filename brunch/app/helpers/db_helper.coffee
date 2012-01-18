helper = {
  verbose   : true
  created   : false
  store_type: null
}

helper.log = (message) ->
  console.log "db: " + message if message? && @verbose

helper.modelIsDefined = (model_name) ->
  return persistence.isDefined model_name

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
  helper.log "creating database '" + dbname + "'"
  supports_webdatabase = !!window.openDatabase
  using_localstorage = !supports_webdatabase

  if supports_webdatabase
    helper.log "using websql"
    helper.store_type = "websql"
    persistence.store.websql.config persistence, dbname, dbdescription, dbsize
  else
    helper.log "using memory"
    helper.store_type = "memory"
    persistence.store.memory.config persistence, dbdescription, dbsize, dbversion

  persistence.debug = @verbose
  persistence.schemaSync ->
    helper.log "schema synced"
    helper.created = true
    callback() if callback?
#  persistence.flush null, ->
#    helper.log 'changes flushed'

helper.createTestDatabase = (callback) ->
  helper.createDatabase "test_pash", "database", 5 * 1024 * 1024, '1.0', callback

helper.createProductionDatabase = (callback) ->
  helper.createDatabase "pash", "database", 5 * 1024 * 1024, '1.0', callback

exports.DbHelper = helper
