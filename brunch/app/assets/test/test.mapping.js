describe('Mapping', function() {
  describe('Tags', function() {
    it('should have all properties', function(){
      var properties = [
        'name',
        'identity'
      ];
      for (var i = window.seed.tags.length - 1; i >= 0; i--) {
        var tag = TagModel.fromJSON(window.seed.tags[i]);
        for (var k = properties.length - 1; k >= 0; k--) {
          var property = properties[k];
          bdd_assert(tag[property] !== null, 'tag[' + i + '].' + property + ' == null');
        };
      };
    });
  });

  describe('Packs', function(){
    it('should have all properties', function(){
      var properties = [
        'name',
        'identity',
        "position",
        "description_text",
        "preview_image_url",
        "cover_image_url",
        "coins",
        "state",
      ];
      for (var i = window.seed.packs.length - 1; i >= 0; i--) {
        var pack = PackModel.fromJSON(window.seed.packs[i]);
        for (var k = properties.length - 1; k >= 0; k--) {
          var property = properties[k];
          bdd_assert(pack[property] !== null, 'pack[' + i + '].' + property + ' == null')
        };
      };
    });
  });

  describe('Items', function(){
    it('should should have all properties', function(){
      var itemProperties = [
        'identity',
        'first_image_url',
        'second_image_url',
      ];
      var differencePointProperties = ['x', 'y'];
      for (var i = window.seed.items.length - 1; i >= 0; i--) {
        var item = ItemModel.fromJSON(window.seed.items[i]);
        bdd_assert(item !== null, 'item[' + i + '] == null');
        for (var p = itemProperties.length - 1; p >= 0; p--) {
          var itemProperty = itemProperties[p];
          bdd_assert(item[itemProperty] !== null, 'item[' + i + '].' + itemProperty + ' == null');
        };
        
      };
    });
  });

});