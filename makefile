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

.build/6-server-test.js: ./src/test/server-test.ls
	lsc -p -c src/test/server-test.ls > .build/6-server-test.js

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

lib/test/server-test.js: .build/6-server-test.js
	@mkdir -p ./lib//test
	cp .build/6-server-test.js $@

.build/7-codejail-test.js: ./src/test/codejail-test.ls
	lsc -p -c src/test/codejail-test.ls > .build/7-codejail-test.js

.build/8-server-test.js: ./src/test/server-test.ls
	lsc -p -c src/test/server-test.ls > .build/8-server-test.js

lib/codejail-test.js: .build/7-codejail-test.js
	@mkdir -p ./lib/
	cp .build/7-codejail-test.js $@

lib/server-test.js: .build/8-server-test.js
	@mkdir -p ./lib/
	cp .build/8-server-test.js $@

.build/9-index.js: ./index.ls
	(echo '#!/usr/local/bin/node --harmony' && lsc -p -c index.ls | 6to5 ) > .build/9-index.js

index.js: .build/9-index.js
	@mkdir -p ./.
	cp .build/9-index.js $@

.PHONY : compile
compile: lib/codejail.js lib/grader.js lib/lang/javascript.js lib/profiles.js lib/server.js lib/test/codejail-test.js lib/test/server-test.js lib/codejail-test.js lib/server-test.js index.js

.PHONY : cmd-10
cmd-10: 
	chmod +x ./index.js

.PHONY : cmd-11
cmd-11: 
	make test

.PHONY : cmd-seq-12
cmd-seq-12: 
	make compile
	make cmd-10
	make cmd-11

.PHONY : all
all: cmd-seq-12

.PHONY : clean-13
clean-13: 
	rm -rf .build/0-codejail.js .build/1-grader.js .build/2-javascript.js .build/3-profiles.js .build/4-server.js .build/5-codejail-test.js .build/6-server-test.js lib/codejail.js lib/grader.js lib/lang/javascript.js lib/profiles.js lib/server.js lib/test/codejail-test.js lib/test/server-test.js .build/7-codejail-test.js .build/8-server-test.js lib/codejail-test.js lib/server-test.js .build/9-index.js index.js

.PHONY : clean-14
clean-14: 
	rm -rf .build

.PHONY : clean-15
clean-15: 
	mkdir -p .build

.PHONY : cmd-16
cmd-16: 
	rm -rf ./lib

.PHONY : clean
clean: clean-13 clean-14 clean-15 cmd-16

.PHONY : cmd-17
cmd-17: 
	./test/test.sh

.PHONY : cmd-18
cmd-18: 
	./node_modules/.bin/mocha --harmony ./lib/server-test.js

.PHONY : test
test: cmd-17 cmd-18

.PHONY : cmd-19
cmd-19: 
	./node_modules/.bin/xyz --increment major

.PHONY : release-major
release-major: cmd-19

.PHONY : cmd-20
cmd-20: 
	./node_modules/.bin/xyz --increment minor

.PHONY : release-minor
release-minor: cmd-20

.PHONY : cmd-21
cmd-21: 
	./node_modules/.bin/xyz --increment patch

.PHONY : release-patch
release-patch: cmd-21

.PHONY : cmd-22
cmd-22: 
	make all

.PHONY : cmd-23
cmd-23: 
	DEBUG=* nodemon -w lib -w ./index.js --exec './index.js'

.PHONY : cmd-seq-24
cmd-seq-24: 
	make cmd-22
	make cmd-23

.PHONY : watch
watch: cmd-seq-24
