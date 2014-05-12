#include <iostream>
#include <sha1.hpp>

void test1() {
	std::string str = "";
	std::cout << SHA1::to_string( SHA1::hash(str) ) << std::endl;
}

void test2() {
	std::string str = "The quick brown fox jumps over the lazy dog";
	std::cout << SHA1::to_string( SHA1::hash(str) ) << std::endl;
}

void test3() {
	std::string str = "ウィキペディア";
	std::cout << SHA1::to_string( SHA1::hash(str) ) << std::endl;
}

void test4() {
	std::string str = "01234567890123456789012345678901234567890123456789012345678901234567890123456789";
	std::cout << SHA1::to_string( SHA1::hash(str) ) << std::endl;
}

int main(void) {
	test1();
	
	test2();
	
	test3();
	
	test4();
	
	return 0;
}
