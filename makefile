
all: index.js lib/server.js

index.js: index.ls
	echo '#!/usr/bin/env node --harmony' > $@
	lsc -p -c $<  >> $@
	chmod +x $@

lib:
	mkdir -p lib

lib/%.js: src/%.ls lib
	lsc -p -c $< >> $@

clean:
	rm index.js lib/*.js
