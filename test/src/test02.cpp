#include <iostream>
#include <sha1.hpp>

SHA1::Hash *val = new SHA1::Hash;

void test1() {
	std::string *str = new std::string("");
	std::string *dst = new std::string();
	SHA1::hash(str, val);
	SHA1::to_string(val, dst);
	std::cout << *dst << std::endl;
}

void test2(){
	std::string *str = new std::string("The quick brown fox jumps over the lazy dog");
	std::string *dst = new std::string();
	SHA1::hash(str, val);
	SHA1::to_string(val, dst);
	std::cout << *dst << std::endl;
}

void test3(){
	std::string *str = new std::string("ウィキペディア");
	std::string *dst = new std::string();
	SHA1::hash(str, val);
	SHA1::to_string(val, dst);
	std::cout << *dst << std::endl;
}

void test4(){
	std::string *str = new std::string("01234567890123456789012345678901234567890123456789012345678901234567890123456789");
	std::string *dst = new std::string();
	SHA1::hash(str, val);
	SHA1::to_string(val, dst);
	std::cout << *dst << std::endl;
}

int main(void) {
	test1();
	
	test2();
	
	test3();
	
	test4();
	
	return 0;
}
