class exports.ModelDownloadHelper
  # dependencies: ConfigHelper, DbHelper, ImageDownloadHelper

  # for downloading remote JSONPs
  @download = (url, params, success, fail) ->
    $.ajax
      url     : url
      data    : params
      dataType: 'jsonp'
      success : (data) ->
        success(data) if success?
      error : (error) ->
        fail(error) if fail?

  # for downloading local files (JSON seeds)
  @localDownload = (url, success, fail) ->
    $.ajax
      url     : url
      dataType: 'json'
      success : (data) ->
        success(data) if success?
      error : (error) ->
        fail(error) if fail?

  # Tags
  # local saving
  @saveTags = (data, done, progress) ->
    tags = []
    count = 0
    total = data.length
    for tag in data
      do (tag) ->
        tagModel = TagModel.fromJSON(tag)
        tags.push tagModel
        DbHelper.save tagModel, ->
          count++
          progress(count / total) if progress?
          done(tags) if (count == total) and done?

  # remote seeding
  @getTags = (done, progress) ->
    @download ConfigHelper.getTagsUrl(), null, (data) =>
      @saveTags data, done, progress

  # local seeding
  @getLocalTags = (done, progress) ->
    @localDownload ConfigHelper.getTagsLocalSeedUrl(), (data) =>
      @saveTags data, done, progress
  # end Tags

  # Packs
  # local saving
  @savePacks = (data, done, progress, pretend) ->
    packs = []
    count = 0
    total = data.length
    for pack in data
      do (pack) ->
        packModel = PackModel.fromJSON(pack)
        packs.push packModel
        DbHelper.save packModel, ->
          ImageDownloadHelper.download packModel.cover_image_url, packModel, 'cover_image', (coverImage) ->
            ImageDownloadHelper.download packModel.preview_image_url, packModel, 'preview_image', (previewImage) ->
              ++count
              progress(count / total) if progress?
              done(packs) if (count == total) and done?
            , pretend
          , pretend

  # remote seeding
  @getPacks = (done, progress) ->
    @download ConfigHelper.getPacksUrl(), null, (data) ->
      @savePacks data, done, progress

  # local seeding
  @getLocalPacks = (done, progress) ->
    @localDownload ConfigHelper.getPacksLocalSeedUrl(), (data) =>
      @savePacks data, done, progress, true

  # end Packs

  # Items
  # local saving
  @saveItemsForPack = (pack, data, done, progress, pretend) ->
    items = []
    count = 0
    total = data.length
    for item in data
      do (item) ->
        itemModel      = ItemModel.fromJSON(item)
        itemModel.pack = pack
        items.push itemModel
        DbHelper.save itemModel, ->
          ImageDownloadHelper.download itemModel.first_image_url, itemModel, 'first_image', (firstImage) ->
            ImageDownloadHelper.download itemModel.second_image_url, itemModel, 'second_image', (secondImage) ->
              count++
              progress(count / total) if progress?
              if (count == total)
                console.log "pack id : " + pack.identity + " selected"
                pack.state = PackModel.STATE_SELECTED
                DbHelper.save pack, ->
                  done(items) if done?
            , pretend # second_image
          , pretend # first_image

  # remote seeding
  @getItemsForPack = (pack, done, progress) ->
    return (done(null) if done?) if !pack?
    pack.state = PackModel.STATE_INCOMPLETE
    DbHelper.save pack, =>
        @download ConfigHelper.getItemsUrlForPack(pack), {player_id: PlayerModel.getPlayer().identity}, (data) =>
          @saveItemsForPack pack, data, done, progress

  @getItemsForPackIdentity = (packIdentity, done, progress) ->
    PackModel.findBy 'identity', packIdentity, (pack) =>
        @getItemsForPack pack, done, progress

  # local seeding
  @getLocalItemsForPack = (pack, done, progress) ->
    return (done(null) if done?) if !pack?
    pack.state = PackModel.STATE_INCOMPLETE
    DbHelper.save pack, =>
      @localDownload ConfigHelper.getItemsLocalSeedUrlForPack(pack), (data) =>
        @saveItemsForPack pack, data, done, progress, true

  @getLocalItemsForPackIdentity = (packIdentity, done, progress) =>
    PackModel.findBy 'identity', packIdentity, (pack) =>
      @getLocalItemsForPack pack, done, progress

  # end Items

  @getAll = (done) ->
    @getTags (tags) =>
      @getPacks (packs) =>
        count = 0
        total = packs.length
        for pack in packs
          do (pack) =>
            @getItemsForPack pack, (items) ->
              done() if (++count == total) and done?

  @getLocalAll = (done) ->
    @getLocalTags (tags) =>
      @getLocalPacks (packs) =>
        basePackIds = ConfigHelper.getBasePackIds()
        count = 0
        total = packs.length
        baseTotal = basePackIds.length
        for pack in packs
          do (pack) =>
            console.log "pack"
            if $.inArray(pack.identity, basePackIds) != -1
              #console.log "pack " + pack.identity + " is base pack"
              @getLocalItemsForPack pack, (items) ->
                done() if (++count == total || count == baseTotal) and done?
