
#include <iostream>
#include "shell.hxx"

using namespace std;

int main(int argc, char const *argv[])
{
	if(argc < 2) {
		return 1;
	} else {
		string output;
		int result;
		if(shell::test("-e", "/usr/local/bin/octave")) {
			result = shell::exec(string("/usr/local/bin/octave --silent ")+argv[1], output);
		} else {
			if(shell::test("-e", "/usr/bin/octave")) {
				result = shell::exec(string("/usr/bin/octave --silent ")+argv[1], output);	
			} else {
				return 1;
			}
		}
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