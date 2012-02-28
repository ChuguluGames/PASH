class exports.DbHelper
  # dependencies: ConfigHelper, LogHelper

  @tag            = "DbHelper"
  @created        = false

  @activateWebSQL = true
  @activateMemory = true
  @usingWebSQL    = false
  @usingMemory    = false

  @modelIsDefined = (model_name) ->
    return persistence.isDefined model_name

  @remove = (object, callback) ->
    if !object?
      return
    persistence.remove object
    @flush callback

  @save = (object, callback) ->
    if !object?
      return
    persistence.add object
    @flush callback

  @createDatabase = (dbname, dbdescription, dbsize, dbversion, callback) ->
    LogHelper.info "creating database '" + dbname + "'", @tag

    if DbHelper.activateWebSQL and window.openDatabase
      LogHelper.info "using websql", @tag
      DbHelper.usingWebSQL = true
      persistence.store.websql.config persistence, dbname, dbdescription, dbsize
    else if DbHelper.activateMemory and window.localStorage
      LogHelper.info "using memory", @tag
      DbHelper.usingMemory = true
      persistence.store.memory.config persistence, dbdescription, dbsize, dbversion

    persistence.debug = app.verbose.DbHelper

    DbHelper.schemaSync callback

  @schemaSync = (callback) ->
    persistence.schemaSync =>
      console.log "schema sync"
      if DbHelper.usingMemory
        console.log "loading from memory"

        # load db from localstorage
        persistence.loadFromLocalStorage =>
          console.log "loaded from memory"
          callback() # don't need to flush

      else @flush callback

  @flush = (callback) ->
    if DbHelper.usingWebSQL
      console.log "flush"
      persistence.flush null, callback
    else if DbHelper.usingMemory
      console.log "saveToLocalStorage"
      persistence.saveToLocalStorage callback

  #helper.createTestDatabase = (callback) ->
  #  helper.createDatabase "test_pash", "database", 5 * 1024 * 1024, '1.0', callback
  #
  #helper.createProductionDatabase = (callback) ->
  #  helper.createDatabase "pash", "database", 5 * 1024 * 1024, '1.0', callback
  #
  @createPASHDatabase = (callback) ->
    @createDatabase ConfigHelper.getDatabaseName(), "database", 5 * 1024 * 1024, '1.0', callback