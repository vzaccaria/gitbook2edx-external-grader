.DEFAULT_GOAL := all

.build/0-armor.js: ./src/armor.ls
	lsc -p -c src/armor.ls > .build/0-armor.js

.build/1-codejail.js: ./src/codejail.ls
	lsc -p -c src/codejail.ls > .build/1-codejail.js

.build/2-config.js: ./src/config.ls
	lsc -p -c src/config.ls > .build/2-config.js

.build/3-das.js: ./src/das.ls
	lsc -p -c src/das.ls > .build/3-das.js

.build/4-grader.js: ./src/grader.ls
	lsc -p -c src/grader.ls > .build/4-grader.js

.build/5-profiles.js: ./src/profiles.ls
	lsc -p -c src/profiles.ls > .build/5-profiles.js

.build/6-server.js: ./src/server.ls
	lsc -p -c src/server.ls > .build/6-server.js

.build/7-codejail-test.js: ./src/test/codejail-test.ls
	lsc -p -c src/test/codejail-test.ls > .build/7-codejail-test.js

.build/8-server-test.js: ./src/test/server-test.ls
	lsc -p -c src/test/server-test.ls > .build/8-server-test.js

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

lib/test/server-test.js: .build/8-server-test.js
	@mkdir -p ./lib//test
	cp .build/8-server-test.js $@

.build/9-codejail-test.js: ./src/test/codejail-test.ls
	lsc -p -c src/test/codejail-test.ls > .build/9-codejail-test.js

.build/10-server-test.js: ./src/test/server-test.ls
	lsc -p -c src/test/server-test.ls > .build/10-server-test.js

lib/codejail-test.js: .build/9-codejail-test.js
	@mkdir -p ./lib/
	cp .build/9-codejail-test.js $@

lib/server-test.js: .build/10-server-test.js
	@mkdir -p ./lib/
	cp .build/10-server-test.js $@

.build/11-index.js: ./index.ls
	(echo '#!/usr/local/bin/node --harmony' && lsc -p -c index.ls) > .build/11-index.js

index.js: .build/11-index.js
	@mkdir -p ./.
	cp .build/11-index.js $@

.PHONY : compile
compile: lib/armor.js lib/codejail.js lib/config.js lib/das.js lib/grader.js lib/profiles.js lib/server.js lib/test/codejail-test.js lib/test/server-test.js lib/codejail-test.js lib/server-test.js index.js

.PHONY : cmd-12
cmd-12: 
	cd ./helpers/gitbook2edx-octave-helper && make

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

.PHONY : clean-15
clean-15: 
	rm -rf .build/0-armor.js .build/1-codejail.js .build/2-config.js .build/3-das.js .build/4-grader.js .build/5-profiles.js .build/6-server.js .build/7-codejail-test.js .build/8-server-test.js lib/armor.js lib/codejail.js lib/config.js lib/das.js lib/grader.js lib/profiles.js lib/server.js lib/test/codejail-test.js lib/test/server-test.js .build/9-codejail-test.js .build/10-server-test.js lib/codejail-test.js lib/server-test.js .build/11-index.js index.js

.PHONY : clean-16
clean-16: 
	rm -rf .build

.PHONY : clean-17
clean-17: 
	mkdir -p .build

.PHONY : cmd-18
cmd-18: 
	rm -rf ./lib

.PHONY : clean
clean: clean-15 clean-16 clean-17 cmd-18

.PHONY : cmd-19
cmd-19: 
	make clean

.PHONY : cmd-20
cmd-20: 
	make -j all

.PHONY : cmd-21
cmd-21: 
	./test/test.sh

.PHONY : cmd-22
cmd-22: 
	./node_modules/.bin/mocha -C --harmony ./lib/server-test.js -R spec

.PHONY : cmd-seq-23
cmd-seq-23: 
	make cmd-19
	make cmd-20
	make cmd-21
	make cmd-22

.PHONY : test
test: cmd-seq-23

.PHONY : cmd-24
cmd-24: 
	./node_modules/.bin/xyz --increment major

.PHONY : release-major
release-major: cmd-24

.PHONY : cmd-25
cmd-25: 
	./node_modules/.bin/xyz --increment minor

.PHONY : release-minor
release-minor: cmd-25

.PHONY : cmd-26
cmd-26: 
	./node_modules/.bin/xyz --increment patch

.PHONY : release-patch
release-patch: cmd-26

.PHONY : cmd-27
cmd-27: 
	make all

.PHONY : cmd-28
cmd-28: 
	./node_modules/.bin/pm2 start ./grader.json

.PHONY : cmd-29
cmd-29: 
	./node_modules/.bin/pm2 start /usr/local/bin/ngrok --interpreter none -x -- start grader

.PHONY : cmd-30
cmd-30: 
	./node_modules/.bin/pm2 logs grader

.PHONY : cmd-31
cmd-31: 
	echo 'Connect to http://localhost:4040 to watch for incoming traffic

.PHONY : cmd-seq-32
cmd-seq-32: 
	make cmd-27
	make cmd-28
	make cmd-29
	make cmd-30
	make cmd-31

.PHONY : start
start: cmd-seq-32

.PHONY : cmd-33
cmd-33: 
	./node_modules/.bin/pm2 delete all

.PHONY : stop
stop: cmd-33

.PHONY : cmd-34
cmd-34: 
	./node_modules/.bin/pm2 monit

.PHONY : monit
monit: cmd-34

.PHONY : cmd-35
cmd-35: 
	./node_modules/.bin/pm2 status

.PHONY : s
s: cmd-35
