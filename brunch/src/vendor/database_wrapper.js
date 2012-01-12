/*
 * Basic wrapper for HTML5 local database
 * by Florian Unternaehrer, september 2011
 * depends on underscore.js
 * contact: florian.unternaehrer@sysinf.ch
 */

var localDatabase = {
  getInstance: function(name, version) {
    "use strict";

    if (openDatabase) {
      name = name || 'local_db';
      version = version || '';

      // get instance of wrapper, if already exists
      this.instances = this.instances || {};
      this.instances[name] = this.instances[name] || (function() {

        // object for database access
        var database = openDatabase(name, version, name, 5 * 1024 * 1024),
            tables = {};

        // execute any query on the local database
        function executeSql(query, params, dataHandler, errorHandler) {
          params = _.map(params, function(v) { return typeof v === 'boolean' ? (v ? 1 : 0) : v; });
          dataHandler = dataHandler || defaultDataHandler;
          errorHandler = errorHandler || defaultErrorHandler;

          database.transaction(function(t) {
            if (window.debug === true) {
              console.log(query, params);
            }
            t.executeSql(query, params, dataHandler, errorHandler);
          });
        }

        // simple helper for inserting data, attribues is a hash
        function insert(table, item, dataHandler, errorHandler) {
          var columns = _.map(_.keys(item), function(e) { return '"' + e + '"'; }),
              values = _.map(item, function() { return '?'; }).join(", "),
              sql = 'INSERT INTO ' + table + '(' + columns + ') VALUES (' + values + ')';

          console.log(sql)

          executeSql(sql, _.values(item), dataHandler, function(error) {
            console.log(error)
          });
        }

        // simple helper for updating data, attribues is a hash
        function update(table, changes, where, dataHandler, errorHandler) {
          var body = _.map(changes, function(v, key) { return '"' + key + '" = ?'; }),
              condition = _.map(where, function(v, key) { return '"' + key + '" = ?'; }).join(' AND '),
              params = _.values(changes).concat(_.values(where)),
              sql = 'UPDATE ' + table + ' SET ' + body + ' WHERE ' + condition;

          executeSql(sql, params, dataHandler, errorHandler);
        }

        // simple helper for selecting data, columns is an array, can be null
        function select(table, columns, where, dataHandler, errorHandler) {
          var body = (columns != null ? columns : '*'),
              condition = _.map(where, function(v, key) { return '"' + key + '" = ?'; }).join(' AND '),
              sql = 'SELECT ' + body + ' FROM ' + table + (where != null ? ' WHERE ' + condition : '');

          executeSql(sql, _.values(where), dataHandler, errorHandler);
        }

        // simple helper for deleting data, attribues is a hash
        function remove(table, where, dataHandler, errorHandler) {
          var condition = _.map(where, function(v, key) { return '"' + key + '" = ?'; }).join(' AND '),
              sql = 'DELETE FROM ' + table + ' WHERE ' + condition;

          executeSql(sql, _.values(where), dataHandler, errorHandler);
        }

        // get object to manipulate table
        function getTable(name, columns) {
          if (columns != null) {
            var sql = 'CREATE TABLE IF NOT EXISTS ' + name + '(' + columns.join(', ') + ');';
            executeSql(sql);
          }

          tables[name] = tables[name] || {
            insert: function(item, dataHandler, errorHandler) {
              insert(name, item, dataHandler, errorHandler);
            },
            update: function(changes, where, dataHandler, errorHandler) {
              update(name, changes, where, dataHandler, errorHandler);
            },
            select: function(columns, where, dataHandler, errorHandler) {
              select(name, columns, where, dataHandler, errorHandler);
            },
            delete: function(where, dataHandler, errorHandler) {
              remove(name, where, dataHandler, errorHandler);
            }
          };

          return tables[name];
        }

        /// hidden methods

        function preloadTables() {
          var exclude_tables = ['sqlite_sequence', '__WebKitDatabaseInfoTable__'],
              sql = 'SELECT name FROM sqlite_master WHERE type="table" ' +
                    _.map(exclude_tables, function(v) { return 'AND NOT name="' + v + '" '; }).join(" ") +
                    'ORDER BY name;',
              i = 0;

          executeSql(sql, null, function(transaction, data) {
            for (i = 0; i < data.rows.length; i++) {
              getTable(data.rows.item(i).name);
            }
          });
        }

        // standard dataHandler, logs data
        function defaultDataHandler(transaction, data) {
          if (window.debug === true) {
            var i = 0;
            for (i = 0; i < data.rows.length; i++) {
              console.log(i + 1, data.rows.item(i));
            }
          }
        }

        // standard errorHandler, logs data
        function defaultErrorHandler() {
          if (window.debug === true) {
            console.log('error', arguments);
          }
        }

        /// initialize and return object
        preloadTables();
        return {
          'getTable': getTable,
          'tables': tables,
          'executeSql': executeSql,
          'insert': insert,
          'select': select,
          'update': update,
          'delete': remove
        };
      })();

      // return instance of our localdatabasewrapper
      return this.instances[name];
    }

    // return empty object if browser is not capable of localdatabase
    return {};
  }
};