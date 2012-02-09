class exports.DbHelper
  # dependencies: ConfigHelper, LogHelper

  @tag        = "DbHelper"
  @created    = false
  @store_type = null

  @modelIsDefined = (model_name) ->
    return persistence.isDefined model_name

  @remove = (object, callback) ->
    if !object?
      return
    persistence.remove object
    persistence.flush null, callback

  @save = (object, callback) ->
    if !object?
      return
    persistence.add object
    persistence.flush null, callback

  @createDatabase = (dbname, dbdescription, dbsize, dbversion, callback) ->
    LogHelper.info "creating database '" + dbname + "'", @tag
    supports_webdatabase = !!window.openDatabase
    using_localstorage = !supports_webdatabase

    if supports_webdatabase
      LogHelper.info "using websql", @tag
      @store_type = "websql"
      persistence.store.websql.config persistence, dbname, dbdescription, dbsize
    else
      LogHelper.info "using memory", @tag
      @store_type = "memory"
      persistence.store.memory.config persistence, dbdescription, dbsize, dbversion

    persistence.debug = app.verbose.DbHelper
    persistence.schemaSync =>
      LogHelper.info "schema synced", @tag
      @created = true
      callback() if callback?
  #  persistence.flush null, ->
  #    helper.log 'changes flushed'

  #helper.createTestDatabase = (callback) ->
  #  helper.createDatabase "test_pash", "database", 5 * 1024 * 1024, '1.0', callback
  #
  #helper.createProductionDatabase = (callback) ->
  #  helper.createDatabase "pash", "database", 5 * 1024 * 1024, '1.0', callback
  #
  @createPASHDatabase = (callback) ->
    @createDatabase ConfigHelper.getDatabaseName(), "database", 5 * 1024 * 1024, '1.0', callback