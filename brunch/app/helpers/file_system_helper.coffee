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
    entry = new DirectoryEntry()
    entry.fullPath = 'file:///android_asset/www'
    success(entry) if success?
    #window.resolveLocalFileSystemURI 'file:///android_asset/www/', success, fail
  else if (app.helpers.device.isIOS())
    helper.filesystem.root.getDirectory '/../spots-container.app/web/', {create:false}, success, fail
  else
    success(helper.emptyEntry) if success?

helper.getSubdirInDirectoryEntry = (entry, subdir, success, fail) ->
  return success(helper.emptyEntry) if !LocalFileSystem?
  if (app.helpers.device.isAndroid())
    newDir = new DirectoryEntry()
    newDir.fullPath = entry.fullPath + subdir
    success(newDir) if success?
  else
    entry.getDirectory subdir, {create:false}, success, fail

helper.getSeedPath = (success, fail) ->
  return success(helper.emptyEntry) if !LocalFileSystem?
  helper.getAssetsPath (entry) ->
    helper.getSubdirInDirectoryEntry entry, '/seed', success, fail
  , fail

helper.getSeedImagesPath = (success, fail) ->
  return success(helper.emptyEntry) if !LocalFileSystem?
  helper.getSeedPath (entry) ->
    helper.getSubdirInDirectoryEntry entry, '/images', success, fail
  , fail

helper.getSeedPackImagesPath = (success, fail) ->
  return success(helper.emptyEntry) if !LocalFileSystem?
  helper.getSeedImagesPath (entry) ->
    helper.getSubdirInDirectoryEntry '/pack', success, fail
  , fail

helper.getSeedItemImagesPath = (success, fail) ->
  return success(helper.emptyEntry) if !LocalFileSystem?
  helper.getSeedImagesPath (entry) ->
    helper.getSubdirInDirectoryEntry '/item', success, fail
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
