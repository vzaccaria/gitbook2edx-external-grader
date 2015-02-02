.DEFAULT_GOAL := all

.build/0-grader.js: ./src/grader.ls
	lsc -p -c src/grader.ls > .build/0-grader.js

.build/1-javascript.js: ./src/lang/javascript.ls
	lsc -p -c src/lang/javascript.ls > .build/1-javascript.js

.build/2-server.js: ./src/server.ls
	lsc -p -c src/server.ls > .build/2-server.js

lib/grader.js: .build/0-grader.js
	@mkdir -p ./lib/
	cp .build/0-grader.js $@

lib/lang/javascript.js: .build/1-javascript.js
	@mkdir -p ./lib//lang
	cp .build/1-javascript.js $@

lib/server.js: .build/2-server.js
	@mkdir -p ./lib/
	cp .build/2-server.js $@

.build/3-index.js: ./index.ls
	(echo '#!/usr/bin/env node --harmony' && lsc -p -c index.ls) > .build/3-index.js

index.js: .build/3-index.js
	@mkdir -p ./.
	cp .build/3-index.js $@

.PHONY : cmd-4
cmd-4: 
	chmod +x ./index.js

.PHONY : cmd-seq-5
cmd-seq-5: 
	make lib/grader.js
	make lib/lang/javascript.js
	make lib/server.js
	make index.js
	make cmd-4

.PHONY : all
all: cmd-seq-5

.PHONY : clean-6
clean-6: 
	rm -rf .build/0-grader.js .build/1-javascript.js .build/2-server.js lib/grader.js lib/lang/javascript.js lib/server.js .build/3-index.js index.js

.PHONY : clean-7
clean-7: 
	rm -rf .build

.PHONY : clean-8
clean-8: 
	mkdir -p .build

.PHONY : clean
clean: clean-6 clean-7 clean-8

.PHONY : cmd-9
cmd-9: 
	./node_modules/.bin/xyz --increment major

.PHONY : release-major
release-major: cmd-9

.PHONY : cmd-10
cmd-10: 
	./node_modules/.bin/xyz --increment minor

.PHONY : release-minor
release-minor: cmd-10

.PHONY : cmd-11
cmd-11: 
	./node_modules/.bin/xyz --increment patch

.PHONY : release-patch
release-patch: cmd-11

.PHONY : cmd-12
cmd-12: 
	make all

.PHONY : cmd-13
cmd-13: 
	DEBUG=* nodemon -w lib -w ./index.js --exec './index.js'

.PHONY : cmd-seq-14
cmd-seq-14: 
	make cmd-12
	make cmd-13

.PHONY : watch
watch: cmd-seq-14
