helper =
  baseUrl: "https://playboy-preprod.chugulu.com"

helper.download = (url, params, success, fail) ->
  $.ajax
    url     : helper.baseUrl + '/' + url
    data    : params
    dataType: 'jsonp'
    success : (data) ->
      success(data) if success?
    error : (error) ->
      fail(error) if error?

helper.getTags = (done, progress) ->
  helper.download "en/tags.js", null, (data) ->
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

helper.getPacks = (done, progress) ->
  helper.download "en/packs.js", null, (data) ->
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

helper.getItemsForPackIdentity = (packIdentity, done, progress) ->
  PackModel.findBy 'identity', packIdentity, (pack) ->
      helper.getItemsForPack pack, done, progress

helper.getItemsForPack = (pack, done, progress) ->
  return (done(null) if done?) if !pack?
  pack.state = PackModel.STATE_INCOMPLETE
  app.helpers.db.save pack, ->
      helper.download "en/packs/" + pack.identity + "/items.js", {player_id: 454}, (data) ->
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

helper.getAll = (done) ->
  helper.getTags (tags) ->
      helper.getPacks (packs) ->
        count = 0
        total = packs.length
        for pack in packs
          do (pack) ->
            helper.getItemsForPack pack, (items) ->
                done() if (++count == total) and done?

exports.ModelDownloadHelper = helper
