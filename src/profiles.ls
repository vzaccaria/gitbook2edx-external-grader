debug = require('debug')('profiles')

os = require('os')

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

        'octave': 
                path: "#{__dirname}/../helpers/gitbook2edx-octave-helper/bin/octave-helper"
                aa: (it, c) -> """
                    \#include <tunables/global>

                    #it {
                        \#include <abstractions/base>
                        #{__dirname}/../helpers/gitbook2edx-octave-helper/bin/octave-helper ix,
                        /usr/local/bin/octave mr,
                        /usr/bin/octave mr,
                        /bin/dash,
                        #{c.folder-name},
                        #it mr,
                    }
                    """

        'fake': 
                path: "/bin/cat"
                aa: -> """
                       """

    }
  
    return iface
 
module.exports = _module()

