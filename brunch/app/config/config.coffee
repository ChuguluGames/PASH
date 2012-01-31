exports.config =
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
