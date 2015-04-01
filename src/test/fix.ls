

module.exports = {
  darwin: {
      test0:  '''
              Executing: mkdir -p /fake/tmp/fakeuid
              Writing to /fake/tmp/fakeuid/f1: f1
              Writing to /fake/tmp/fakeuid/f2: f2
              Writing to /fake/tmp/fakeuid/profile.aa:
              Writing to /fake/tmp/fakeuid/jailed.code: #!/bin/cat
              x+1
              Executing: chmod +x /fake/tmp/fakeuid/jailed.code
              Executing: SANDBOXDIR=/fake/tmp/fakeuid /fake/tmp/fakeuid/jailed.code
              Executing: rm -rf /fake/tmp/fakeuid
              Executing: mkdir -p /fake/tmp/fakeuid
              Writing to /fake/tmp/fakeuid/profile.aa:
              Writing to /fake/tmp/fakeuid/jailed.code: #!/bin/cat
              x+y+z
              Executing: chmod +x /fake/tmp/fakeuid/jailed.code
              Executing: SANDBOXDIR=/fake/tmp/fakeuid /fake/tmp/fakeuid/jailed.code
              Executing: rm -rf /fake/tmp/fakeuid
              { success: true, result: 'ok' }
              '''

      test1:  '''
              Executing: mkdir -p faketmp/fakeuid
              Writing to faketmp/fakeuid/profile.aa: #include <tunables/global>

              faketmp/fakeuid/jailed.code {
                  #include <abstractions/base>
                  /usr/local/bin/node mr,
                  faketmp/fakeuid/jailed.code mr,
              }
              Writing to faketmp/fakeuid/jailed.code: #!/usr/local/bin/node
              var x=1
              Executing: chmod +x faketmp/fakeuid/jailed.code
              Executing: SANDBOXDIR=faketmp/fakeuid faketmp/fakeuid/jailed.code
              Executing: rm -rf faketmp/fakeuid

              '''
  },
  linux: {

  }
}
