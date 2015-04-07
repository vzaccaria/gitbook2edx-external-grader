debug = require('debug')('edx:profiles')

{ which } = require('shelljs')
os = require('os')

cpulimit = (seconds, dataM, stackM) ->
  # http://wiki.apparmor.net/index.php/AppArmor_Core_Policy_Reference#Rlimit_rules
  """
  set rlimit cpu <= #{seconds},
  set rlimit data <= #{dataM}M,
  set rlimit stack <= #{stackM}M,
  """

_module = ->

    iface = {

        'javascript':
                path: which('node')
                code: (response, payload) ->
                    """

                    /* require assert for assertions */
                    var assert = require('assert');
                    #{payload.context}
                    #{response}
                    #{payload.validation}
                    """
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
                        #{cpulimit(3, 50, 50)}
                    }
                    """

        'fake':
                path: "/bin/cat"
                aa: -> """
                       """

    }

    return iface

module.exports = _module()
