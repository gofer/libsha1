#include <iostream>
#include <fstream>
#include <sha1.hpp>

const int BUFFER_SIZE = 0xFFFF;

int main(int argc, char** argv) {
	std::string src;
	
	if(argc < 2) {
		std::cin >> src;
	} else {
		std::ifstream ifs;
		ifs.open(argv[1]);
		while(!ifs.eof()) {
			char* buf = new char[BUFFER_SIZE];
			ifs.read(buf, BUFFER_SIZE);
			src.append(buf);
			delete buf;
		}
		ifs.close();
	}
	
	std::cout << SHA1::to_string( SHA1::hash(src) ) << "  " << argv[1] << std::endl;
	
	return 0;
}
