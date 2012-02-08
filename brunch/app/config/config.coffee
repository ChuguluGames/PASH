exports.config =
  locales:
    accepted: [
      'en'
      'fr'
      'es'
    ]
    default: 'en'

  test:
    database: 'pash_test'
    base_url: "https://spots-preprod.chugulu.com"
    base_pack_ids: [1]

  development:
    database: 'pash'
    base_url: "https://spots-preprod.chugulu.com"
    base_pack_ids: [1]

  production:
    database: 'pash'
    base_url: "https://spots-preprod.chugulu.com"
    base_pack_ids: [1]

  spots_modes:
    ZEN       : 'zen'
    CHALLENGE : 'challenge'
    SURVIVAL  : 'survival'

  dynamic_screen:
    baseWindowSize:
      width : 480
      height: 320
    baseItemSize:
      width : 238
      height: 273
    scaleFontSize: .35