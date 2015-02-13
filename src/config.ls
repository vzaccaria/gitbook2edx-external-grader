


debug = require('debug')('config')


_module = ->

    config = {}
          
    iface = { 
        set: ->
            config := it
        get: ->
            config
    }
  
    return iface
 
module.exports = _module()

