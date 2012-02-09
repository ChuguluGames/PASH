class exports.SeedHelper
  # dependencies: FileSystemHelper, ModelDownloadHelper

  @tag = "SeedHelper"

  @shouldSeed = (callback) ->
    TagModel.all().count (tagCount) =>
      return callback(false) if tagCount > 0
      PackModel.all().count (packCount) ->
        return callback(false) if packCount > 0
        callback(true)

  @moveImages = (success, fail) ->
    FileSystemHelper.getContentDownloadPath (destinationEntry) ->
      return (success() if success?) if destinationEntry.fullPath == ''
      FileSystemHelper.getSeedItemImagesPath (itemEntry) ->
        itemEntry.copyTo destinationEntry, null, ->
          FileSystemHelper.getSeedPackImagesPath (packEntry) ->
            packEntry.copyTo destinationEntry, null, ->
              success() if success?
            , fail #packEntry.copyTo
          , fail #getSeedPackImagesPath
        , fail #itemEntry.copyTo
      , fail #getSeedItemImagesPath
    , fail #getContentDownloadPath

  @seed = (success, fail) ->
    @shouldSeed (should) =>
      return success(should) if not should
      LogHelper.info "should seed", @tag
      ModelDownloadHelper.getLocalAll =>
        success(should) if success?
        #@moveImages success, fail
