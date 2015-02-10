.DEFAULT_GOAL := all

.build/0-codejail.js: ./src/codejail.ls
	lsc -p -c src/codejail.ls > .build/0-codejail.js

.build/1-das.js: ./src/das.ls
	lsc -p -c src/das.ls > .build/1-das.js

.build/2-grader.js: ./src/grader.ls
	lsc -p -c src/grader.ls > .build/2-grader.js

.build/3-fakelang.js: ./src/lang/fakelang.ls
	lsc -p -c src/lang/fakelang.ls > .build/3-fakelang.js

.build/4-javascript.js: ./src/lang/javascript.ls
	lsc -p -c src/lang/javascript.ls > .build/4-javascript.js

.build/5-profiles.js: ./src/profiles.ls
	lsc -p -c src/profiles.ls > .build/5-profiles.js

.build/6-server.js: ./src/server.ls
	lsc -p -c src/server.ls > .build/6-server.js

.build/7-codejail-test.js: ./src/test/codejail-test.ls
	lsc -p -c src/test/codejail-test.ls > .build/7-codejail-test.js

.build/8-server-test.js: ./src/test/server-test.ls
	lsc -p -c src/test/server-test.ls > .build/8-server-test.js

lib/codejail.js: .build/0-codejail.js
	@mkdir -p ./lib/
	cp .build/0-codejail.js $@

lib/das.js: .build/1-das.js
	@mkdir -p ./lib/
	cp .build/1-das.js $@

lib/grader.js: .build/2-grader.js
	@mkdir -p ./lib/
	cp .build/2-grader.js $@

lib/lang/fakelang.js: .build/3-fakelang.js
	@mkdir -p ./lib//lang
	cp .build/3-fakelang.js $@

lib/lang/javascript.js: .build/4-javascript.js
	@mkdir -p ./lib//lang
	cp .build/4-javascript.js $@

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
compile: lib/codejail.js lib/das.js lib/grader.js lib/lang/fakelang.js lib/lang/javascript.js lib/profiles.js lib/server.js lib/test/codejail-test.js lib/test/server-test.js lib/codejail-test.js lib/server-test.js index.js

.PHONY : cmd-12
cmd-12: 
	chmod +x ./index.js

.PHONY : cmd-seq-13
cmd-seq-13: 
	make compile
	make cmd-12

.PHONY : all
all: cmd-seq-13

.PHONY : clean-14
clean-14: 
	rm -rf .build/0-codejail.js .build/1-das.js .build/2-grader.js .build/3-fakelang.js .build/4-javascript.js .build/5-profiles.js .build/6-server.js .build/7-codejail-test.js .build/8-server-test.js lib/codejail.js lib/das.js lib/grader.js lib/lang/fakelang.js lib/lang/javascript.js lib/profiles.js lib/server.js lib/test/codejail-test.js lib/test/server-test.js .build/9-codejail-test.js .build/10-server-test.js lib/codejail-test.js lib/server-test.js .build/11-index.js index.js

.PHONY : clean-15
clean-15: 
	rm -rf .build

.PHONY : clean-16
clean-16: 
	mkdir -p .build

.PHONY : cmd-17
cmd-17: 
	rm -rf ./lib

.PHONY : clean
clean: clean-14 clean-15 clean-16 cmd-17

.PHONY : cmd-18
cmd-18: 
	./test/test.sh

.PHONY : cmd-19
cmd-19: 
	./node_modules/.bin/mocha -C --harmony ./lib/server-test.js

.PHONY : test
test: cmd-18 cmd-19

.PHONY : cmd-20
cmd-20: 
	./node_modules/.bin/xyz --increment major

.PHONY : release-major
release-major: cmd-20

.PHONY : cmd-21
cmd-21: 
	./node_modules/.bin/xyz --increment minor

.PHONY : release-minor
release-minor: cmd-21

.PHONY : cmd-22
cmd-22: 
	./node_modules/.bin/xyz --increment patch

.PHONY : release-patch
release-patch: cmd-22

.PHONY : cmd-23
cmd-23: 
	make all

.PHONY : cmd-24
cmd-24: 
	./node_modules/.bin/pm2 start ./grader.json

.PHONY : cmd-25
cmd-25: 
	./node_modules/.bin/pm2 start /usr/local/bin/ngrok --interpreter none -x -- start grader

.PHONY : cmd-26
cmd-26: 
	./node_modules/.bin/pm2 logs grader

.PHONY : cmd-27
cmd-27: 
	echo 'Connect to http://localhost:4040 to watch for incoming traffic

.PHONY : cmd-seq-28
cmd-seq-28: 
	make cmd-23
	make cmd-24
	make cmd-25
	make cmd-26
	make cmd-27

.PHONY : start
start: cmd-seq-28

.PHONY : cmd-29
cmd-29: 
	./node_modules/.bin/pm2 delete all

.PHONY : stop
stop: cmd-29

.PHONY : cmd-30
cmd-30: 
	./node_modules/.bin/pm2 monit

.PHONY : monit
monit: cmd-30

.PHONY : cmd-31
cmd-31: 
	./node_modules/.bin/pm2 status

.PHONY : s
s: cmd-31
