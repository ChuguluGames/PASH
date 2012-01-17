helper = {verbose: true}

helper.log = (message) ->
  console.log "db: " + message if message? && helper.verbose

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

helper.createDatabase = (dbname, dbdescription, dbsize, dbversion) ->
  helper.log "creating database '" + dbname + "'"
  supports_webdatabase = !!window.openDatabase
  using_localstorage = !supports_webdatabase

  if supports_webdatabase
    helper.log "using websql"
    persistence.store.websql.config persistence, dbname, dbdescription, dbsize
  else
    helper.log "using memory"
    persistence.store.memory.config persistence, dbdescription, dbsize, dbversion

  persistence.debug = true
  persistence.schemaSync ->
    helper.log "schema synced"
  persistence.flush null, ->
    helper.log 'changes flushed'

helper.createTestDatabase = ->
  helper.createDatabase "test_pash", "database", 5 * 1024 * 1024, '1.0'

helper.createProductionDatabase = ->
  helper.createDatabase "pash", "database", 5 * 1024 * 1024, '1.0'

exports.DbHelper = helper
