#include "declarations.h"

typedef struct{int x, y, z;} point;
int ptx[LEN7];
int pty[LEN7];
int ptz[LEN7];
point bodies[LEN7];

#pragma auto_inline(off)
int t7() {
	int sum = 0;

	#pragma novector
	for (int nl = 0; nl < 2*ntimes; nl++) {
		for (int i = 0; i < LEN7; i++) {
			sum+= ptx[i];
		}
	}

	return sum;
}

void t7init(){
	
	for (int i = 0; i < LEN7; i++){
		ptx[i] = 1;
		pty[i] = 2;
		ptz[i] = 3;
	}	
	
	unsigned long long start_c, end_c, diff_c;
	start_c = _rdtsc();
	
	int sum = t7();
	
	end_c = _rdtsc(); 
	diff_c = end_c - start_c;
	float giga_cycle = diff_c / 1000000000.0;
	printf("Time \t %.2f and the average is %d \n", giga_cycle, sum);
	
}	


