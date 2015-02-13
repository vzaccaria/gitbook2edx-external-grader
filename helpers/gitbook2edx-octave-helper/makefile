.DEFAULT_GOAL := all

.build/1-main.o: src/shell.hxx src/underscore.hxx src/main.cxx
	clang++ -c -I./src/cppformat -I./src -std=c++11 -DUSE_STD src/main.cxx -o .build/1-main.o

.build/2-format.o: src/cppformat/format.cc
	clang++ -c -I./src/cppformat -I./src -std=c++11 -DUSE_STD src/cppformat/format.cc -o .build/2-format.o

.build/linked0.x: .build/1-main.o .build/2-format.o
	clang++ $^  -o $@

./bin: 
	mkdir -p ./bin

./bin/octave-helper: .build/linked0.x ./bin
	cp .build/linked0.x $@

.PHONY : build
build: bin/octave-helper

.PHONY : cmd-3
cmd-3: 
	make build

.PHONY : cmd-4
cmd-4: 
	./bin/octave-helper /home/vagrant/gitbook2edx-external-grader/helpers/gitbook2edx-octave-helper/fix/t.m

.PHONY : cmd-seq-5
cmd-seq-5: 
	make cmd-3
	make cmd-4

.PHONY : all
all: cmd-seq-5

.PHONY : clean-6
clean-6: 
	rm -rf .build/1-main.o .build/2-format.o .build/linked0.x ./bin ./bin/octave-helper

.PHONY : clean-7
clean-7: 
	rm -rf .build

.PHONY : clean-8
clean-8: 
	mkdir -p .build

.PHONY : cmd-9
cmd-9: 
	rm -rf ./bin

.PHONY : clean
clean: clean-6 clean-7 clean-8 cmd-9
