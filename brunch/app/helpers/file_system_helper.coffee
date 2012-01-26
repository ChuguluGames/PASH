helper =
  filesystem : null
  emptyEntry : {fullPath: ''}

helper.init = (success, fail) ->
  if !LocalFileSystem?
    helper.filesystem = {}
    return (success() if success?)
  window.requestFileSystem LocalFileSystem.PERSISTENT, 0
  , (fs) ->
    helper.filesystem = fs
    success() if success?
  , (evt) ->
    fail(evt) if fail?

helper.getAssetsPath = (success, fail) ->
  return success(helper.emptyEntry) if !LocalFileSystem?
  if (app.helpers.device.isAndroid())
    window.resolveLocalFileSystemURI 'file:///android_asset/web/', success, fail
  else if (app.helpers.device.isIOS())
    helper.filesystem.root.getDirectory '/../spots-container.app/web/', {create:false}, success, fail
  else
    success(helper.emptyEntry) if success?

helper.getSeedPath = (success, fail) ->
  return success(helper.emptyEntry) if !LocalFileSystem?
  helper.getAssetsPath (entry) ->
      entry.getDirectory '/seed/', {create:false}, success, fail
    , fail

helper.getSeedImagesPath = (success, fail) ->
  return success(helper.emptyEntry) if !LocalFileSystem?
  helper.getSeedPath (entry) ->
      entry.getDirectory '/images/', {create:false}, success, fail
    , fail

helper.getSeedPackImagesPath = (success, fail) ->
  return success(helper.emptyEntry) if !LocalFileSystem?
  helper.getSeedImagesPath (entry) ->
      entry.getDirectory '/pack/', {create:false}, success, fail
    , fail

helper.getSeedItemImagesPath = (success, fail) ->
  return success(helper.emptyEntry) if !LocalFileSystem?
  helper.getSeedImagesPath (entry) ->
      entry.getDirectory '/item/', {create:false}, success, fail
    , fail

helper.getContentDownloadPath = (success, fail) ->
  return success(helper.emptyEntry) if !LocalFileSystem?
  if (app.helpers.device.isAndroid())
    helper.filesystem.root.getDirectory '/../../data/data/com.phonegap.pash/', {create:false}, success, fail
  else if (app.helpers.device.isIOS())
    success(helper.filesystem.root) if success?
  else
    success(helper.emptyEntry) if success?

exports.FileSystemHelper = helper
