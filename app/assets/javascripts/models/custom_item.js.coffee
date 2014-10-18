App.CustomItem = DS.Model.extend
  name: DS.attr 'string', defaultValue: 'custom item'
  inShop: DS.attr 'boolean', defaultValue: false
  inCart: DS.attr 'boolean', defaultValue: false
  noProduct: Em.computed.empty 'product_id'
  noSelectedColors: Em.computed.empty 'selectedColors'
  colorOptions: Em.computed.alias 'product.colorTypes'

  selectedColors: DS.hasMany 'selected_color'
  customOptions: DS.hasMany 'custom_option'
  lineItem: DS.belongsTo 'line_item'

  price: DS.attr 'number'

  basePrice: (->
    @recalculatePrice()
  ).observes('product_id').on('init')

  product_id: DS.attr 'number'
  product: (->
    @store.getById('product', @get('product_id')) if @get 'product_id'
  ).property('product_id')

  properties: (->
    @get 'product.properties'
  ).property('product_id')

  description: (->
    @get 'product.description'
  ).property('product_id')

  specs: (->
    @get 'product.specs'
  ).property('product_id')

  #- Properties for mapping SVG data
  availableColors: (->
    @store.all 'color_value'
  ).property()
  patterns: Em.computed.map 'availableColors', (color)->
    {url: color.get('small_url'), name: "#{color.get('name')}-pattern"}

  #- Helper methods
  recalculatePrice: ->
    base = @get 'product.price'
    selected = @get('customOptions').filter (option)->
      option.get('selected') is true
    selected.forEach (option)->
      base += option.get 'price'
    @set 'price', base

  loadOptions: ()->
    product = @get 'product'
    @populateColorRelationship(product)
    @populateOptionRelationship(product)

  reloadRelationships: ->
    self = this
    [@get('selectedColors'), @get('customOptions')].forEach (relationship)->
      items = relationship.content.toArray()
      items.forEach (record)->
        relationship.removeRecord(record)
        record.unloadRecord()
        record.destroy()
      relationship.save()
    @loadOptions()
    @save()

  populateColorRelationship: (product)->
    self = this
    colorTypes = product.get('colorTypes')
    colorTypes.forEach (colorType)->
      record = self.store.createRecord 'selectedColor',
        colorType_id: colorType.get 'id'
      self.get('selectedColors').addRecord(record)

  populateOptionRelationship: (product)->
    self = this
    customOptions = this.get('customOptions')
    product.get('optionTypes').forEach (optionType)->
      optionType.get('optionValues').forEach (optionValue)->
        record = self.store.createRecord 'custom_option',
          optionValue_id: optionValue.get 'id'
          selected: no
          customItem: self
          price: optionValue.get 'price'
        customOptions.addRecord(record)
