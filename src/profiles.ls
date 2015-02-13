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
                user: 'vagrant'
                aa: (it, c) -> """
                    \#include <tunables/global>

                    #it {
                        \#include <abstractions/base>


                        /bin/dash ix,
                        /bin/bash ix,
                        #{__dirname}/../helpers/gitbook2edx-octave-helper/bin/octave-helper mr,
                        /usr/local/bin/octave mr,
                        /usr/share/octave/** mr,
                        /usr/lib/x86_64-linux-gnu/octave/** mr,
                        /usr/bin/octave ix,
                        /usr/bin/dirname ix,
                        /usr/bin/octave-cli ix,
                        /usr/bin/env ix,
                        #{c.folder-name}/ rw,
                        #{c.folder-name}/** rw,
                        #{c.folder-name}/**/.* rw,
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

