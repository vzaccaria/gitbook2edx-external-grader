
all: index.js lib/server.js  lib/lang/javascript.js

index.js: index.ls
	echo '#!/usr/bin/env node --harmony' > $@
	lsc -p -c $<  >> $@
	chmod +x $@

lib:
	mkdir -p lib

lib/lang:
	mkdir -p lib/lang

lib/%.js: src/%.ls lib
	lsc -p -c $< >> $@

lib/lang/%.js: languages/%.ls lib/lang
	lsc -p -c $< >> $@

clean:
	rm index.js lib/*.js

watch: 
	DEBUG=* nodemon -w lib -w ./index.js --exec './index.js'