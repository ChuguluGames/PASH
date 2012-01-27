exports.config =
  test:
    database: 'pash_test'
    base_url: "https://playboy-preprod.chugulu.com"
    base_pack_ids: [450]

  development:
    database: 'pash'
    base_url: "https://playboy-preprod.chugulu.com"
    base_pack_ids: [450]

  production:
    database: 'pash'
    base_url: "https://playboy-preprod.chugulu.com"
    base_pack_ids: [450]
