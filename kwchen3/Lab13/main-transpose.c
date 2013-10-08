#include"transpose.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>


void 
transpose1(int ** src, int** dest) {

	for (int i = 0 ; i < SIZE ; i ++) { 
		for (int j = i +1 ; j < SIZE ; j ++) {
			dest[i][j]= src[j][i];
		} 
	}
}


int 
main(int argc, char* argv[]) {
  // allocate memory for the images.
  int** image1, ** image2, ** image3;
  image1 = (int**) malloc(SIZE * sizeof (int*));
  image2 = (int**) malloc(SIZE * sizeof (int*));
  image3 = (int**) malloc(SIZE * sizeof (int*));
  
  for (int x=0 ; x < SIZE ; x++){
	 image1[x]= (int*) malloc (SIZE * sizeof(int));
	 image2[x]= (int*) malloc (SIZE * sizeof(int));
	 image3[x]= (int*) malloc (SIZE * sizeof(int));
  }
  
  for (int i=0; i < SIZE ; i++){
	 for (int j=0; j < SIZE ; j++){
		image1[i][j] = 0;
		image2[i][j] = random() % 10;
		image3[i][j] = 0;
	 }
  }
  
  clock_t c2, c3;
  c2 = clock(); 
  
  transpose1(image2,image1);
  
  c3 = clock();	
  printf("Elapsed CPU time without optimization is %lf seconds\n",
		   (((double)c3)-c2)/CLOCKS_PER_SEC);
  
  
  c2 = clock(); 

  transpose2(image2,image3);

  c3 = clock();	
  printf("Elapsed CPU time with optimization is %lf seconds\n",
		   (((double)c3)-c2)/CLOCKS_PER_SEC);


  // check to make sure we did things right
  bool matches = true;
  for (int i=0; i < SIZE ; i++){
	 for (int j=0; j < SIZE ; j++){
		matches &= (image1[i][j] == image3[i][j]);
	 }
  }
  printf("the transformed images %s\n", matches ? "match" : "don't match");
}
