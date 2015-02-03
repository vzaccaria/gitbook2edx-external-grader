.DEFAULT_GOAL := all

.build/0-codejail.js: ./src/codejail.ls
	lsc -p -c src/codejail.ls > .build/0-codejail.js

.build/1-grader.js: ./src/grader.ls
	lsc -p -c src/grader.ls > .build/1-grader.js

.build/2-javascript.js: ./src/lang/javascript.ls
	lsc -p -c src/lang/javascript.ls > .build/2-javascript.js

.build/3-profiles.js: ./src/profiles.ls
	lsc -p -c src/profiles.ls > .build/3-profiles.js

.build/4-server.js: ./src/server.ls
	lsc -p -c src/server.ls > .build/4-server.js

lib/codejail.js: .build/0-codejail.js
	@mkdir -p ./lib/
	cp .build/0-codejail.js $@

lib/grader.js: .build/1-grader.js
	@mkdir -p ./lib/
	cp .build/1-grader.js $@

lib/lang/javascript.js: .build/2-javascript.js
	@mkdir -p ./lib//lang
	cp .build/2-javascript.js $@

lib/profiles.js: .build/3-profiles.js
	@mkdir -p ./lib/
	cp .build/3-profiles.js $@

lib/server.js: .build/4-server.js
	@mkdir -p ./lib/
	cp .build/4-server.js $@

.build/5-codejail-test.js: ./test/codejail-test.ls
	lsc -p -c test/codejail-test.ls > .build/5-codejail-test.js

lib/codejail-test.js: .build/5-codejail-test.js
	@mkdir -p ./lib/
	cp .build/5-codejail-test.js $@

.build/6-index.js: ./index.ls
	(echo '#!/usr/bin/env node --harmony' && lsc -p -c index.ls) > .build/6-index.js

index.js: .build/6-index.js
	@mkdir -p ./.
	cp .build/6-index.js $@

.PHONY : cmd-7
cmd-7: 
	chmod +x ./index.js

.PHONY : cmd-8
cmd-8: 
	make test

.PHONY : cmd-seq-9
cmd-seq-9: 
	make lib/codejail.js
	make lib/grader.js
	make lib/lang/javascript.js
	make lib/profiles.js
	make lib/server.js
	make lib/codejail-test.js
	make index.js
	make cmd-7
	make cmd-8

.PHONY : all
all: cmd-seq-9

.PHONY : clean-10
clean-10: 
	rm -rf .build/0-codejail.js .build/1-grader.js .build/2-javascript.js .build/3-profiles.js .build/4-server.js lib/codejail.js lib/grader.js lib/lang/javascript.js lib/profiles.js lib/server.js .build/5-codejail-test.js lib/codejail-test.js .build/6-index.js index.js

.PHONY : clean-11
clean-11: 
	rm -rf .build

.PHONY : clean-12
clean-12: 
	mkdir -p .build

.PHONY : clean
clean: clean-10 clean-11 clean-12

.PHONY : cmd-13
cmd-13: 
	DEBUG=* node --harmony ./lib/codejail-test.js

.PHONY : test
test: cmd-13

.PHONY : cmd-14
cmd-14: 
	./node_modules/.bin/xyz --increment major

.PHONY : release-major
release-major: cmd-14

.PHONY : cmd-15
cmd-15: 
	./node_modules/.bin/xyz --increment minor

.PHONY : release-minor
release-minor: cmd-15

.PHONY : cmd-16
cmd-16: 
	./node_modules/.bin/xyz --increment patch

.PHONY : release-patch
release-patch: cmd-16

.PHONY : cmd-17
cmd-17: 
	make all

.PHONY : cmd-18
cmd-18: 
	DEBUG=* nodemon -w lib -w ./index.js --exec './index.js'

.PHONY : cmd-seq-19
cmd-seq-19: 
	make cmd-17
	make cmd-18

.PHONY : watch
watch: cmd-seq-19
