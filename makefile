.DEFAULT_GOAL := all

.build/0-armor.js: ./src/armor.ls
	lsc -p -c src/armor.ls > .build/0-armor.js

.build/1-codejail.js: ./src/codejail.ls
	lsc -p -c src/codejail.ls > .build/1-codejail.js

.build/2-das.js: ./src/das.ls
	lsc -p -c src/das.ls > .build/2-das.js

.build/3-grader.js: ./src/grader.ls
	lsc -p -c src/grader.ls > .build/3-grader.js

.build/4-profiles.js: ./src/profiles.ls
	lsc -p -c src/profiles.ls > .build/4-profiles.js

.build/5-server.js: ./src/server.ls
	lsc -p -c src/server.ls > .build/5-server.js

.build/6-codejail-test.js: ./src/test/codejail-test.ls
	lsc -p -c src/test/codejail-test.ls > .build/6-codejail-test.js

.build/7-server-test.js: ./src/test/server-test.ls
	lsc -p -c src/test/server-test.ls > .build/7-server-test.js

lib/armor.js: .build/0-armor.js
	@mkdir -p ./lib/
	cp .build/0-armor.js $@

lib/codejail.js: .build/1-codejail.js
	@mkdir -p ./lib/
	cp .build/1-codejail.js $@

lib/das.js: .build/2-das.js
	@mkdir -p ./lib/
	cp .build/2-das.js $@

lib/grader.js: .build/3-grader.js
	@mkdir -p ./lib/
	cp .build/3-grader.js $@

lib/profiles.js: .build/4-profiles.js
	@mkdir -p ./lib/
	cp .build/4-profiles.js $@

lib/server.js: .build/5-server.js
	@mkdir -p ./lib/
	cp .build/5-server.js $@

lib/test/codejail-test.js: .build/6-codejail-test.js
	@mkdir -p ./lib//test
	cp .build/6-codejail-test.js $@

lib/test/server-test.js: .build/7-server-test.js
	@mkdir -p ./lib//test
	cp .build/7-server-test.js $@

.build/8-codejail-test.js: ./src/test/codejail-test.ls
	lsc -p -c src/test/codejail-test.ls > .build/8-codejail-test.js

.build/9-server-test.js: ./src/test/server-test.ls
	lsc -p -c src/test/server-test.ls > .build/9-server-test.js

lib/codejail-test.js: .build/8-codejail-test.js
	@mkdir -p ./lib/
	cp .build/8-codejail-test.js $@

lib/server-test.js: .build/9-server-test.js
	@mkdir -p ./lib/
	cp .build/9-server-test.js $@

.build/10-index.js: ./index.ls
	(echo '#!/usr/local/bin/node --harmony' && lsc -p -c index.ls) > .build/10-index.js

index.js: .build/10-index.js
	@mkdir -p ./.
	cp .build/10-index.js $@

.PHONY : compile
compile: lib/armor.js lib/codejail.js lib/das.js lib/grader.js lib/profiles.js lib/server.js lib/test/codejail-test.js lib/test/server-test.js lib/codejail-test.js lib/server-test.js index.js

.PHONY : cmd-11
cmd-11: 
	chmod +x ./index.js

.PHONY : cmd-seq-12
cmd-seq-12: 
	make compile
	make cmd-11

.PHONY : all
all: cmd-seq-12

.PHONY : clean-13
clean-13: 
	rm -rf .build/0-armor.js .build/1-codejail.js .build/2-das.js .build/3-grader.js .build/4-profiles.js .build/5-server.js .build/6-codejail-test.js .build/7-server-test.js lib/armor.js lib/codejail.js lib/das.js lib/grader.js lib/profiles.js lib/server.js lib/test/codejail-test.js lib/test/server-test.js .build/8-codejail-test.js .build/9-server-test.js lib/codejail-test.js lib/server-test.js .build/10-index.js index.js

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
	make all

.PHONY : cmd-18
cmd-18: 
	./test/test.sh

.PHONY : cmd-19
cmd-19: 
	./node_modules/.bin/mocha -C --harmony ./lib/server-test.js -R spec

.PHONY : cmd-seq-20
cmd-seq-20: 
	make cmd-17
	make cmd-18
	make cmd-19

.PHONY : test
test: cmd-seq-20

.PHONY : cmd-21
cmd-21: 
	./node_modules/.bin/xyz --increment major

.PHONY : release-major
release-major: cmd-21

.PHONY : cmd-22
cmd-22: 
	./node_modules/.bin/xyz --increment minor

.PHONY : release-minor
release-minor: cmd-22

.PHONY : cmd-23
cmd-23: 
	./node_modules/.bin/xyz --increment patch

.PHONY : release-patch
release-patch: cmd-23

.PHONY : cmd-24
cmd-24: 
	make all

.PHONY : cmd-25
cmd-25: 
	./node_modules/.bin/pm2 start ./grader.json

.PHONY : cmd-26
cmd-26: 
	./node_modules/.bin/pm2 start /usr/local/bin/ngrok --interpreter none -x -- start grader

.PHONY : cmd-27
cmd-27: 
	./node_modules/.bin/pm2 logs grader

.PHONY : cmd-28
cmd-28: 
	echo 'Connect to http://localhost:4040 to watch for incoming traffic

.PHONY : cmd-seq-29
cmd-seq-29: 
	make cmd-24
	make cmd-25
	make cmd-26
	make cmd-27
	make cmd-28

.PHONY : start
start: cmd-seq-29

.PHONY : cmd-30
cmd-30: 
	./node_modules/.bin/pm2 delete all

.PHONY : stop
stop: cmd-30

.PHONY : cmd-31
cmd-31: 
	./node_modules/.bin/pm2 monit

.PHONY : monit
monit: cmd-31

.PHONY : cmd-32
cmd-32: 
	./node_modules/.bin/pm2 status

.PHONY : s
s: cmd-32
