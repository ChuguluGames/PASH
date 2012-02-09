class exports.FileSystemHelper
  # dependencies: DeviceHelper

  @tag        = "FileSystemHelper"
  @filesystem = null
  @emptyEntry =
    fullPath: ''

  @init = (success, fail) ->
    if !LocalFileSystem?
      @filesystem = {}
      return (success() if success?)
    window.requestFileSystem LocalFileSystem.PERSISTENT, 0
    , (fs) =>
      @filesystem = fs
      success() if success?
    , (evt) =>
      fail(evt) if fail?

  @getAssetsPath = (success, fail) ->
    return success(@emptyEntry) if !LocalFileSystem?
    if (DeviceHelper.isAndroid())
      entry = new DirectoryEntry()
      entry.fullPath = 'file:///android_asset/www'
      success(entry) if success?
      #window.resolveLocalFileSystemURI 'file:///android_asset/www/', success, fail
    else if (DeviceHelper.isIOS())
      @filesystem.root.getDirectory '/../spots-container.app/web/', {create:false}, success, fail
    else
      success(@emptyEntry) if success?

  @getSubdirInDirectoryEntry = (entry, subdir, success, fail) ->
    return success(@emptyEntry) if !LocalFileSystem?
    if (DeviceHelper.isAndroid())
      newDir = new DirectoryEntry()
      newDir.fullPath = entry.fullPath + subdir
      success(newDir) if success?
    else
      entry.getDirectory subdir, {create:false}, success, fail

  @getSeedPath = (success, fail) ->
    return success(@emptyEntry) if !LocalFileSystem?
    @getAssetsPath (entry) =>
      @getSubdirInDirectoryEntry entry, '/seed', success, fail
    , fail

  @getSeedImagesPath = (success, fail) ->
    return success(@emptyEntry) if !LocalFileSystem?
    @getSeedPath (entry) =>
      @getSubdirInDirectoryEntry entry, '/images', success, fail
    , fail

  @getSeedPackImagesPath = (success, fail) ->
    return success(@emptyEntry) if !LocalFileSystem?
    @getSeedImagesPath (entry) =>
      @getSubdirInDirectoryEntry '/pack', success, fail
    , fail

  @getSeedItemImagesPath = (success, fail) ->
    return success(@emptyEntry) if !LocalFileSystem?
    @getSeedImagesPath (entry) =>
      @getSubdirInDirectoryEntry '/item', success, fail
    , fail

  @getContentDownloadPath = (success, fail) ->
    return success(@emptyEntry) if !LocalFileSystem?
    if (DeviceHelper.isAndroid())
      @filesystem.root.getDirectory '/../../data/data/com.phonegap.pash/', {create:false}, success, fail
    else if (DeviceHelper.isIOS())
      success(@filesystem.root) if success?
    else
      success(@emptyEntry) if success?