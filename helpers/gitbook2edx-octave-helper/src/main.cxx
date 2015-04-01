
#include <iostream>
#include "shell.hxx"
#include <stdlib.h>
#include "format.h"

using namespace std;
using namespace fmt;

int main(int argc, char const *argv[])
{
	if(argc < 2) {
		return 1;
	} else {
		string output;
		string command;
		int result;
		if(shell::test("-e", "/usr/local/bin/octave")) {
			command = format("/usr/local/bin/octave --silent {}", argv[1]);
		} else {
			if(shell::test("-e", "/usr/bin/octave")) {
				command = format("cd `dirname {}` && OCTAVE_HISTFILE=`dirname {}`/.octave_hist /usr/bin/octave --silent {}", argv[1], argv[1], argv[1]);
			} else {
				return 1;
			}
		}
		result = shell::exec(command, output);
		if(result != 0) {
			cout << "Invalid program" << endl;
			return 1;
		} else {
			cout << output << endl;
			return 0;
		}
	}
	return 0;
}
