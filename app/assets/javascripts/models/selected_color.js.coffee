App.SelectedColor = DS.Model.extend
  name: DS.attr 'string'
  title: Em.computed.alias 'colorType.presentation'
  swatch: DS.attr 'string'
  selector: DS.attr 'string'
  colors: Em.computed.alias 'colorType.colorValues'
  customItem: DS.belongsTo 'custom_item'
  selected: (->
    @get('colorValue_id') != null
  ).property('colorValue_id')

  isUnselected: Em.computed.empty 'colorValue_id'

  #- Design pattern for DS.hasOne pointing to resources not saved in localStorage
  colorType_id: DS.attr 'number', defaultValue: null
  colorType: (->
    if @get 'colorType_id'
      @store.getById 'color_type', @get 'colorType_id'
  ).property('colorType_id')

  colorValue_id: DS.attr 'number', defaultValue: null
  colorValue: (->
    if @get 'colorValue_id'
      @store.getById 'color_value', @get 'colorValue_id'
  ).property('colorValue_id')

  #- Helper methods
  setColor: (colorValue)->
    @set 'colorValue_id', colorValue.get('id')
    @set 'name', colorValue.get('name')
    @set 'swatch', colorValue.get('small_url')
    @set 'selector', @get('colorType.selector')
    @save()

