

module.exports = {
  darwin: {
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
