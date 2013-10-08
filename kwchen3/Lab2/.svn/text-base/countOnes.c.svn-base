// Don't put any code but your countOnes function in this file

// Your countOnes function should contain no loops or conditional statements

unsigned int countOnes(unsigned int input) 
{
	//32 blocks of 1 bit
	unsigned int even=input&0xAAAAAAAA;
	unsigned int odd=input&0x55555555;
	even = even >> 1;
	input=even + odd;

	//16 blocks of 2 bits
	odd=input&0x33333333;
	even=input&0xCCCCCCCCC;
	even =even >>2;
	input=even + odd;

	//8 blocks 4 bits
	odd=input&0x0F0F0F0F;
	even=input&0xF0F0F0F0;
	even=even >>4;
	input=even+odd;
	
	//4 blocks 8 bit
	odd=input&0x00FF00FF;
	even=input&0xFF00FF00;
	even = even >> 8;
	input=even +odd;

	//2 blocks 16 bit
	odd=input&0x0000FFFF;
	even=input&0xFFFF0000;
	even =even >>16;
	input=even+odd;

	return input;
	
}

