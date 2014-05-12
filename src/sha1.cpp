#include <array>
#include <sha1.hpp>

namespace SHA1 {
inline uint32_t rotate32(uint32_t w, uint32_t s) {return (w<<s)|(w>>(32-s));}

inline uint32_t f(uint32_t t, uint32_t B, uint32_t C, uint32_t D) {
	if( 0 <= t && t <= 19) return (B & C) | ((~B) & D);        else
	if(20 <= t && t <= 39) return B ^ C ^ D;                   else 
	if(40 <= t && t <= 59) return (B & C) | (B & D) | (C & D); else
	if(60 <= t && t <= 79) return B ^ C ^ D;                   else
	return 0xFFFFFFFF;
}

inline uint32_t K(uint32_t t) {
	if( 0 <= t && t <= 19) return 0x5A827999; else
	if(20 <= t && t <= 39) return 0x6ED9EBA1; else 
	if(40 <= t && t <= 59) return 0x8F1BBCDC; else
	if(60 <= t && t <= 79) return 0xCA62C1D6; else
	return 0xFFFFFFFF;
}

std::string padding(const std::string& src) {
	uint32_t m = src.length() % 64;
	uint32_t n = 56 - ((m > 56) ? (m - 64) : m);
	std::string dst(src);
	dst.append(  1, 0x80);
	dst.append(n-1, 0x00);
	return dst;
}

Hash hash(const std::string& _src) {
	// Step 1. add padding bit
	std::string src = padding(_src);
	
	// Step 2. add length
	_UINT64_T src_size;
	src_size.i = _src.length() * BITS_PER_BYTE;
	for(int i=0; i<8; ++i) src.append(1, src_size.s[7-i]);
	
	// Step 3. initialize word buffers (H)
	std::array<uint32_t, 5> H = {
		0x67452301, 
		0xEFCDAB89, 
		0x98BADCFE, 
		0x10325476, 
		0xC3D2E1F0
	};
	
	// Step 4. calculate
	uint32_t calc_end =  src.length() / 64;
	for(uint32_t i=0; i<calc_end; ++i) {
		// move from src to W
		std::array<_UINT32_T, 80> W;
		
		for(uint32_t t=0; t<16; ++t) {
			// !!endian-depended code
			// this code for little endian
			W[t].s[3] = src[i*64+t*4+0];
			W[t].s[2] = src[i*64+t*4+1];
			W[t].s[1] = src[i*64+t*4+2];
			W[t].s[0] = src[i*64+t*4+3];
		}
		for(uint32_t t=16; t<80; ++t)
			W[t].i = rotate32(W[t-3].i ^ W[t-8].i ^ W[t-14].i ^ W[t-16].i, 1);
		
		// set A, B, C, D, E from H
		uint32_t A = H[0];
		uint32_t B = H[1];
		uint32_t C = H[2];
		uint32_t D = H[3];
		uint32_t E = H[4];
		
		// calc
		for(uint32_t t=0; t<80; ++t) {
			uint32_t tmp = rotate32(A, 5) + f(t, B, C, D) + E + W[t].i + K(t);
			E = D;
			D = C;
			C = rotate32(B, 30);
			B = A;
			A = tmp;
		}
		
		// added H from A, B, C, D, E
		H[0] += A;
		H[1] += B;
		H[2] += C;
		H[3] += D;
		H[4] += E;
	}
	
	return Hash({H[0], H[1], H[2], H[3], H[4]});
}

std::string to_string(const Hash& hash)
{
	std::ostringstream oss;
	for(int i=0; i<5; ++i)
		oss << std::hex << std::setfill('0') << std::setw(8) << hash[i].i;
	return oss.str();
}

int padding(const std::string* src, std::string* dst) {
	uint32_t m = src->length() % 64;
	uint32_t n = 56 - ((m > 56) ? (m - 64) : m);
	dst->assign(*src);
	dst->append(  1, 0x80);
	dst->append(n-1, 0x00);
	return 0;
}

int hash(const std::string* _src, Hash* hash) {
	// Step 1. add padding bit
	std::string* src = new std::string();
	padding(_src, src);
	
	// Step 2. add length
	_UINT64_T src_size;
	src_size.i = _src->length() * BITS_PER_BYTE;
	for(int i=0; i<8; ++i) src->append(1, src_size.s[7-i]);
	
	// Step 3. initialize word buffers (H)
	std::array<uint32_t, 5> H = {
		0x67452301, 
		0xEFCDAB89, 
		0x98BADCFE, 
		0x10325476, 
		0xC3D2E1F0
	};
	
	// Step 4. calculate
	uint32_t calc_end =  src->length() / 64;
	for(uint32_t i=0; i<calc_end; ++i) {
		// move from src to W
		std::array<_UINT32_T, 80> W;
		
		for(uint32_t t=0; t<16; ++t) {
			// !!endian-depended code
			// this code for little endian
			W[t].s[3] = src->at(i*64+t*4+0);
			W[t].s[2] = src->at(i*64+t*4+1);
			W[t].s[1] = src->at(i*64+t*4+2);
			W[t].s[0] = src->at(i*64+t*4+3);
		}
		for(uint32_t t=16; t<80; ++t)
			W[t].i = rotate32(W[t-3].i ^ W[t-8].i ^ W[t-14].i ^ W[t-16].i, 1);
		
		// set A, B, C, D, E from H
		uint32_t A = H[0];
		uint32_t B = H[1];
		uint32_t C = H[2];
		uint32_t D = H[3];
		uint32_t E = H[4];
		
		// calc
		for(uint32_t t=0; t<80; ++t) {
			uint32_t tmp = rotate32(A, 5) + f(t, B, C, D) + E + W[t].i + K(t);
			E = D;
			D = C;
			C = rotate32(B, 30);
			B = A;
			A = tmp;
		}
		
		// added H from A, B, C, D, E
		H[0] += A;
		H[1] += B;
		H[2] += C;
		H[3] += D;
		H[4] += E;
	}
	
	for(int n=0; n<5; ++n) hash->at(n).i = H[n];
	
	delete src;
	
	return 0;
}

int to_string(const Hash* hash, std::string* dst) {
	std::ostringstream oss;
	for(int i=0; i<5; ++i)
		oss << std::hex << std::setfill('0') << std::setw(8) << (*hash)[i].i;
	dst->assign(oss.str());
	return 0;
}

};
