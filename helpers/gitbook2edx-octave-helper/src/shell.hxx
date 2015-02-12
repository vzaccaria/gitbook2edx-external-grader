/*
Copyright (C) 2014 Vittorio Zaccaria

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#ifndef SHELL_HXX
#define SHELL_HXX

#include <fstream>
#include <sstream>
#include <stdio.h>
#include <sys/stat.h>

namespace shell {

	using namespace std;

	static string catin() {
		string line;
		string complete = "";
		while (getline(cin, line))
		{
			complete = complete + line + "\n";
		}
		return complete;
	}

	static string cat(string filename) {
		ifstream t(filename);
		stringstream buffer;
		buffer << t.rdbuf();
		return buffer.str();
	}

	static void to(string filename, string content) {
		ofstream t(filename);
		t << content;
	}

	static string tmpdir() {
		auto folder = getenv("TMPDIR");
		if (folder == 0)
    		folder = ("/tmp");
    	return folder;
	}

	static bool test(string how, string what) {
		if(how=="-e") {
			struct stat buffer;   
  			return (stat (what.c_str(), &buffer) == 0); 
		} else {
			return false;
		}
	}

	static int exec(string command, string &complete) {
		char buff[128];
		auto fpipe = popen(command.c_str(), "r");
		while(fgets(buff, sizeof(buff), fpipe)) {
			complete = complete + buff;	
		}
		return pclose(fpipe);
	}
}

#endif // SHELL_HXX
