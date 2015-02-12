.DEFAULT_GOAL := all

.build/1-main.o: src/shell.hxx src/underscore.hxx src/main.cxx
	clang++ -c -I./src -std=c++11 -DUSE_STD src/main.cxx -o .build/1-main.o

.build/linked0.x: .build/1-main.o
	clang++ $^  -o $@

./bin: 
	mkdir -p ./bin

./bin/octave-helper: .build/linked0.x ./bin
	cp .build/linked0.x $@

.PHONY : build
build: bin/octave-helper

.PHONY : cmd-2
cmd-2: 
	make build

.PHONY : cmd-3
cmd-3: 
	./bin/octave-helper ./fix/t.m

.PHONY : cmd-seq-4
cmd-seq-4: 
	make cmd-2
	make cmd-3

.PHONY : all
all: cmd-seq-4

.PHONY : clean-5
clean-5: 
	rm -rf .build/1-main.o .build/linked0.x ./bin ./bin/octave-helper

.PHONY : clean-6
clean-6: 
	rm -rf .build

.PHONY : clean-7
clean-7: 
	mkdir -p .build

.PHONY : cmd-8
cmd-8: 
	rm -rf ./bin

.PHONY : clean
clean: clean-5 clean-6 clean-7 cmd-8
