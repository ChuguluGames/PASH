helper = {}

# for downloading remote JSONPs
helper.download = (url, params, success, fail) ->
  $.ajax
    url     : url
    data    : params
    dataType: 'jsonp'
    success : (data) ->
      success(data) if success?
    error : (error) ->
      fail(error) if fail?

# for downloading local files (JSON seeds)
helper.localDownload = (url, success, fail) ->
  $.ajax
    url     : url
    dataType: 'json'
    success : (data) ->
      success(data) if success?
    error : (error) ->
      fail(error) if fail?

# Tags
# local saving
helper.saveTags = (data, done, progress) ->
  tags = []
  count = 0
  total = data.length
  for tag in data
    do (tag) ->
      tagModel = TagModel.fromJSON(tag)
      tags.push tagModel
      app.helpers.db.save tagModel, ->
          count++
          progress(count / total) if progress?
          done(tags) if (count == total) and done?

# remote seeding
helper.getTags = (done, progress) ->
  helper.download app.helpers.config.getTagsUrl(), null, (data) ->
      helper.saveTags data, done, progress

# local seeding
helper.getLocalTags = (done, progress) ->
  helper.localDownload app.helpers.config.getTagsLocalSeedUrl(), (data) ->
      helper.saveTags data, done, progress
# end Tags

# Packs
# local saving
helper.savePacks = (data, done, progress, pretend) ->
  packs = []
  count = 0
  total = data.length
  for pack in data
    do (pack) ->
      packModel = PackModel.fromJSON(pack)
      packs.push packModel
      app.helpers.db.save packModel, ->
        app.helpers.image_downloader.download packModel.cover_image_url, packModel, 'cover_image', (coverImage) ->
          app.helpers.image_downloader.download packModel.preview_image_url, packModel, 'preview_image', (previewImage) ->
            ++count
            progress(count / total) if progress?
            done(packs) if (count == total) and done?
          , pretend
        , pretend

# remote seeding
helper.getPacks = (done, progress) ->
  helper.download app.helpers.config.getPacksUrl(), null, (data) ->
      helper.savePacks data, done, progress

# local seeding
helper.getLocalPacks = (done, progress) ->
  helper.localDownload app.helpers.config.getPacksLocalSeedUrl(), (data) ->
      helper.savePacks data, done, progress, true

# end Packs


# Items
# local saving
helper.saveItemsForPack = (pack, data, done, progress, pretend) ->
  items = []
  count = 0
  total = data.length
  for item in data
    do (item) ->
      itemModel      = ItemModel.fromJSON(item)
      itemModel.pack = pack
      items.push itemModel
      app.helpers.db.save itemModel, ->
        app.helpers.image_downloader.download itemModel.first_image_url, itemModel, 'first_image', (firstImage) ->
          app.helpers.image_downloader.download itemModel.second_image_url, itemModel, 'second_image', (secondImage) ->
            count++
            progress(count / total) if progress?
            if (count == total)
              pack.state = PackModel.STATE_SELECTED
              #pack.state = PackModel.STATE_READY_TO_PLAY # use this instead when pack selection is implemented
              app.helpers.db.save pack, ->
                done(items) if done?
          , pretend # second_image
        , pretend # first_image

# remote seeding
helper.getItemsForPack = (pack, done, progress) ->
  return (done(null) if done?) if !pack?
  pack.state = PackModel.STATE_INCOMPLETE
  app.helpers.db.save pack, ->
      helper.download app.helpers.config.getItemsUrlForPack(pack), {player_id: 454}, (data) ->
        helper.saveItemsForPack pack, data, done, progress

helper.getItemsForPackIdentity = (packIdentity, done, progress) ->
  PackModel.findBy 'identity', packIdentity, (pack) ->
      helper.getItemsForPack pack, done, progress


# local seeding
helper.getLocalItemsForPack = (pack, done, progress) ->
  return (done(null) if done?) if !pack?
  pack.state = PackModel.STATE_INCOMPLETE
  app.helpers.db.save pack, ->
      helper.localDownload app.helpers.config.getItemsLocalSeedUrlForPack(pack), (data) ->
        helper.saveItemsForPack pack, data, done, progress, true

helper.getLocalItemsForPackIdentity = (packIdentity, done, progress) ->
  PackModel.findBy 'identity', packIdentity, (pack) ->
      helper.getLocalItemsForPack pack, done, progress

# end Items



helper.getAll = (done) ->
  helper.getTags (tags) ->
      helper.getPacks (packs) ->
        count = 0
        total = packs.length
        for pack in packs
          do (pack) ->
            helper.getItemsForPack pack, (items) ->
                done() if (++count == total) and done?

helper.getLocalAll = (done) ->
  helper.getLocalTags (tags) ->
      helper.getLocalPacks (packs) ->
        count = 0
        total = packs.length
        for pack in packs
          do (pack) ->
            helper.getLocalItemsForPack pack, (items) ->
                done() if (++count == total) and done?

exports.ModelDownloadHelper = helper
