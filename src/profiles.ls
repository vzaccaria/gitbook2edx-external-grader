debug = require('debug')('profiles')


_module = ->
          
    iface = { 

        'node': 
                path: "path/to/node"
                aa: """
                       this is the node profile 
                    """

        'octave': 
                path: "path/to/octave"
                aa: """
                        this is the octave profile 
                    """
    }
  
    return iface
 
module.exports = _module()

