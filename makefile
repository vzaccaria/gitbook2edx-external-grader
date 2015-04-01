.DEFAULT_GOAL := all

.build/0-armor.js: ./src/armor.ls
	./node_modules/.bin/lsc -p -c src/armor.ls > .build/0-armor.js

.build/1-codejail.js: ./src/codejail.ls
	./node_modules/.bin/lsc -p -c src/codejail.ls > .build/1-codejail.js

.build/2-config.js: ./src/config.ls
	./node_modules/.bin/lsc -p -c src/config.ls > .build/2-config.js

.build/3-das.js: ./src/das.ls
	./node_modules/.bin/lsc -p -c src/das.ls > .build/3-das.js

.build/4-grader.js: ./src/grader.ls
	./node_modules/.bin/lsc -p -c src/grader.ls > .build/4-grader.js

.build/5-profiles.js: ./src/profiles.ls
	./node_modules/.bin/lsc -p -c src/profiles.ls > .build/5-profiles.js

.build/6-server.js: ./src/server.ls
	./node_modules/.bin/lsc -p -c src/server.ls > .build/6-server.js

.build/7-codejail-test.js: ./src/test/codejail-test.ls
	./node_modules/.bin/lsc -p -c src/test/codejail-test.ls > .build/7-codejail-test.js

.build/8-fix.js: ./src/test/fix.ls
	./node_modules/.bin/lsc -p -c src/test/fix.ls > .build/8-fix.js

.build/9-server-test.js: ./src/test/server-test.ls
	./node_modules/.bin/lsc -p -c src/test/server-test.ls > .build/9-server-test.js

lib/armor.js: .build/0-armor.js
	@mkdir -p ./lib/
	cp .build/0-armor.js $@

lib/codejail.js: .build/1-codejail.js
	@mkdir -p ./lib/
	cp .build/1-codejail.js $@

lib/config.js: .build/2-config.js
	@mkdir -p ./lib/
	cp .build/2-config.js $@

lib/das.js: .build/3-das.js
	@mkdir -p ./lib/
	cp .build/3-das.js $@

lib/grader.js: .build/4-grader.js
	@mkdir -p ./lib/
	cp .build/4-grader.js $@

lib/profiles.js: .build/5-profiles.js
	@mkdir -p ./lib/
	cp .build/5-profiles.js $@

lib/server.js: .build/6-server.js
	@mkdir -p ./lib/
	cp .build/6-server.js $@

lib/test/codejail-test.js: .build/7-codejail-test.js
	@mkdir -p ./lib//test
	cp .build/7-codejail-test.js $@

lib/test/fix.js: .build/8-fix.js
	@mkdir -p ./lib//test
	cp .build/8-fix.js $@

lib/test/server-test.js: .build/9-server-test.js
	@mkdir -p ./lib//test
	cp .build/9-server-test.js $@

.build/10-armor-test.js: ./src/test/armor-test.js
	cp src/test/armor-test.js .build/10-armor-test.js

lib/test/armor-test.js: .build/10-armor-test.js
	@mkdir -p ./lib//test
	cp .build/10-armor-test.js $@

.build/11-index.js: ./index.ls
	(echo '#!/usr/local/bin/node --harmony' && ./node_modules/.bin/lsc -p -c index.ls) > .build/11-index.js

index.js: .build/11-index.js
	@mkdir -p ./.
	cp .build/11-index.js $@

.PHONY : compile
compile: lib/armor.js lib/codejail.js lib/config.js lib/das.js lib/grader.js lib/profiles.js lib/server.js lib/test/codejail-test.js lib/test/fix.js lib/test/server-test.js lib/test/armor-test.js index.js

.PHONY : cmd-12
cmd-12: 
	make helpers

.PHONY : cmd-13
cmd-13: 
	chmod +x ./index.js

.PHONY : cmd-seq-14
cmd-seq-14: 
	make compile
	make cmd-12
	make cmd-13

.PHONY : all
all: cmd-seq-14

.PHONY : cmd-15
cmd-15: 
	./node_modules/.bin/lsc makefile.ls

.PHONY : update
update: cmd-15

.PHONY : clean-16
clean-16: 
	rm -rf .build/0-armor.js .build/1-codejail.js .build/2-config.js .build/3-das.js .build/4-grader.js .build/5-profiles.js .build/6-server.js .build/7-codejail-test.js .build/8-fix.js .build/9-server-test.js lib/armor.js lib/codejail.js lib/config.js lib/das.js lib/grader.js lib/profiles.js lib/server.js lib/test/codejail-test.js lib/test/fix.js lib/test/server-test.js .build/10-armor-test.js lib/test/armor-test.js .build/11-index.js index.js

.PHONY : clean-17
clean-17: 
	rm -rf .build

.PHONY : clean-18
clean-18: 
	mkdir -p .build

.PHONY : cmd-19
cmd-19: 
	rm -rf ./lib

.PHONY : clean
clean: clean-16 clean-17 clean-18 cmd-19

.PHONY : cmd-20
cmd-20: 
	cd helpers/gitbook2edx-octave-helper && ../../node_modules/.bin/lsc ./makefile.ls && make clean && make

.PHONY : helpers
helpers: cmd-20

.PHONY : cmd-21
cmd-21: 
	make clean

.PHONY : cmd-22
cmd-22: 
	make all

.PHONY : cmd-23
cmd-23: 
	./node_modules/.bin/mocha -C --harmony ./lib/test/armor-test.js -R spec

.PHONY : cmd-24
cmd-24: 
	./node_modules/.bin/mocha -C --harmony ./lib/test/server-test.js -R spec

.PHONY : cmd-seq-25
cmd-seq-25: 
	make cmd-21
	make cmd-22
	make cmd-23
	make cmd-24

.PHONY : test
test: cmd-seq-25

.PHONY : cmd-26
cmd-26: 
	./node_modules/.bin/xyz --increment major

.PHONY : release-major
release-major: cmd-26

.PHONY : cmd-27
cmd-27: 
	./node_modules/.bin/xyz --increment minor

.PHONY : release-minor
release-minor: cmd-27

.PHONY : cmd-28
cmd-28: 
	./node_modules/.bin/xyz --increment patch

.PHONY : release-patch
release-patch: cmd-28

.PHONY : cmd-29
cmd-29: 
	make all

.PHONY : cmd-30
cmd-30: 
	./node_modules/.bin/pm2 start ./grader.json

.PHONY : cmd-31
cmd-31: 
	./node_modules/.bin/pm2 start /usr/local/bin/ngrok --interpreter none -x -- start grader

.PHONY : cmd-32
cmd-32: 
	./node_modules/.bin/pm2 logs grader

.PHONY : cmd-33
cmd-33: 
	echo 'Connect to http://localhost:4040 to watch for incoming traffic

.PHONY : cmd-seq-34
cmd-seq-34: 
	make cmd-29
	make cmd-30
	make cmd-31
	make cmd-32
	make cmd-33

.PHONY : start
start: cmd-seq-34

.PHONY : cmd-35
cmd-35: 
	./node_modules/.bin/pm2 delete all

.PHONY : stop
stop: cmd-35

.PHONY : cmd-36
cmd-36: 
	./node_modules/.bin/pm2 monit

.PHONY : monit
monit: cmd-36

.PHONY : cmd-37
cmd-37: 
	./node_modules/.bin/pm2 status

.PHONY : s
s: cmd-37
