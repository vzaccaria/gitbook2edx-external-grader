debug = require('debug')('profiles')


_module = ->
          
    iface = { 

        'node': 
                path: "/usr/local/bin/node"
                user: "node-sandbox"
                aa: -> """
                    \#include <tunables/global>

                    #it flags=(enforce) {
                        \#include <abstractions/base>
                    }
                    """

        'mnode': 
                path: "/usr/local/bin/node"
                aa: -> """
                    \#include <tunables/global>
                    #it flags=(enforce) {
                        \#include <abstractions/base>
                    }
                    """


        'octave': 
                path: "path/to/octave"
                aa: -> """
                        this is the octave profile 
                    """
    }
  
    return iface
 
module.exports = _module()

