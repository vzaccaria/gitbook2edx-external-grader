
#include <iostream>
#include "shell.hxx"
#include <stdlib.h>
#include "format.h"
#include "debug.hxx"

using namespace std;
using namespace fmt;

auto debug = Debug("edx:octave-helper");

int main(int argc, char const *argv[])
{

	if(argc < 2) {
		debug("Sorry, not enough arguments");
		return 1;
	} else {
		string output;
		string command;
		int result;
		if(shell::test("-e", "/usr/local/bin/octave")) {
			command = format("/usr/local/bin/octave --silent {}", argv[1]);
			debug(command);
		} else {
			if(shell::test("-e", "/usr/bin/octave")) {
				debug(command);
				command = format("cd `dirname {}` && OCTAVE_HISTFILE=`dirname {}`/.octave_hist /usr/bin/octave --silent {}", argv[1], argv[1], argv[1]);
			} else {
				debug("Unable to find octave.. oops..");
				return 1;
			}
		}
		result = shell::exec(command, output);
		if(result != 0) {
			debug("Invalid output");
			debug(output);
			cout << "Invalid program" << endl;
			return 1;
		} else {
			cout << output << endl;
			return 0;
		}
	}
	return 0;
}
