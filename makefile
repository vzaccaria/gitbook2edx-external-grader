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

.build/5-codejail-test.js: ./src/test/codejail-test.ls
	lsc -p -c src/test/codejail-test.ls > .build/5-codejail-test.js

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

lib/test/codejail-test.js: .build/5-codejail-test.js
	@mkdir -p ./lib//test
	cp .build/5-codejail-test.js $@

.build/6-codejail-test.js: ./src/test/codejail-test.ls
	lsc -p -c src/test/codejail-test.ls > .build/6-codejail-test.js

lib/codejail-test.js: .build/6-codejail-test.js
	@mkdir -p ./lib/
	cp .build/6-codejail-test.js $@

.build/7-index.js: ./index.ls
	(echo '#!/usr/local/bin/node --harmony' && lsc -p -c index.ls) > .build/7-index.js

index.js: .build/7-index.js
	@mkdir -p ./.
	cp .build/7-index.js $@

.PHONY : cmd-8
cmd-8: 
	chmod +x ./index.js

.PHONY : cmd-9
cmd-9: 
	make test

.PHONY : cmd-seq-10
cmd-seq-10: 
	make lib/codejail.js
	make lib/grader.js
	make lib/lang/javascript.js
	make lib/profiles.js
	make lib/server.js
	make lib/test/codejail-test.js
	make lib/codejail-test.js
	make index.js
	make cmd-8
	make cmd-9

.PHONY : all
all: cmd-seq-10

.PHONY : clean-11
clean-11: 
	rm -rf .build/0-codejail.js .build/1-grader.js .build/2-javascript.js .build/3-profiles.js .build/4-server.js .build/5-codejail-test.js lib/codejail.js lib/grader.js lib/lang/javascript.js lib/profiles.js lib/server.js lib/test/codejail-test.js .build/6-codejail-test.js lib/codejail-test.js .build/7-index.js index.js

.PHONY : clean-12
clean-12: 
	rm -rf .build

.PHONY : clean-13
clean-13: 
	mkdir -p .build

.PHONY : clean
clean: clean-11 clean-12 clean-13

.PHONY : cmd-14
cmd-14: 
	./test/test.sh

.PHONY : test
test: cmd-14

.PHONY : cmd-15
cmd-15: 
	./node_modules/.bin/xyz --increment major

.PHONY : release-major
release-major: cmd-15

.PHONY : cmd-16
cmd-16: 
	./node_modules/.bin/xyz --increment minor

.PHONY : release-minor
release-minor: cmd-16

.PHONY : cmd-17
cmd-17: 
	./node_modules/.bin/xyz --increment patch

.PHONY : release-patch
release-patch: cmd-17

.PHONY : cmd-18
cmd-18: 
	make all

.PHONY : cmd-19
cmd-19: 
	DEBUG=* nodemon -w lib -w ./index.js --exec './index.js'

.PHONY : cmd-seq-20
cmd-seq-20: 
	make cmd-18
	make cmd-19

.PHONY : watch
watch: cmd-seq-20
