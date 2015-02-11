debug = require('debug')('profiles')


_module = ->
          
    iface = { 

        'javascript': 
                path: "/usr/local/bin/node"
                aa: -> """
                    \#include <tunables/global>

                    #it {
                        \#include <abstractions/base>
                        /usr/local/bin/node mr,
                        #it mr,
                    }
                    """
        'fake': 
                path: "/bin/cat"
                aa: -> """
                       """

        'octave': 
                path: "path/to/octave"
                aa: -> """
                        this is the octave profile 
                    """
    }
  
    return iface
 
module.exports = _module()

