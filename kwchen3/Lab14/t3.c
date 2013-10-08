#include "declarations.h"

#pragma auto_inline(off)
void t3(float A[512][512]) {
	for (int nl = 0; nl < 1000; nl++) {

 		for (int i = 0; i < 511; i++) {

			for (int j = 0; j < 511; j++) {
				A[i+1][j+1] = A[i][j] + A[i][j];
	    		}
	    	}
		A[0][0]++;
	}
}
