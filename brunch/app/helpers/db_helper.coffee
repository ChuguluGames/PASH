class exports.DbHelper
  self=@

  self.created = false
  self.store_type = null
  self.tag = "DbHelper"

  self.modelIsDefined = (model_name) ->
    return persistence.isDefined model_name

  self.remove = (object, callback) ->
    if !object?
      return
    persistence.remove object
    persistence.flush null, callback

  self.save = (object, callback) ->
    if !object?
      return
    persistence.add object
    persistence.flush null, callback

  self.createDatabase = (dbname, dbdescription, dbsize, dbversion, callback) ->
    app.helpers.log.info "creating database '" + dbname + "'", self.tag
    supports_webdatabase = !!window.openDatabase
    using_localstorage = !supports_webdatabase

    if supports_webdatabase
      app.helpers.log.info "using websql", self.tag
      self.store_type = "websql"
      persistence.store.websql.config persistence, dbname, dbdescription, dbsize
    else
      app.helpers.log.info "using memory", self.tag
      self.store_type = "memory"
      persistence.store.memory.config persistence, dbdescription, dbsize, dbversion

    persistence.debug = app.verbose.DbHelper
    persistence.schemaSync ->
      app.helpers.log.info "schema synced", self.tag
      self.created = true
      callback() if callback?
  #  persistence.flush null, ->
  #    helper.log 'changes flushed'

  #helper.createTestDatabase = (callback) ->
  #  helper.createDatabase "test_pash", "database", 5 * 1024 * 1024, '1.0', callback
  #
  #helper.createProductionDatabase = (callback) ->
  #  helper.createDatabase "pash", "database", 5 * 1024 * 1024, '1.0', callback
  #
  self.createPASHDatabase = (callback) ->
    self.createDatabase app.helpers.config.getDatabaseName(), "database", 5 * 1024 * 1024, '1.0', callback