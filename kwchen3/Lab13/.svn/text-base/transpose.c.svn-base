#include <stdio.h> 
#include <stdlib.h> 
#include <time.h> 
#include "transpose.h" 

void transpose2(int** src, int** dest)
{

	/*for (int i = 0 ; i < SIZE ; i ++) { 
	 for (int j = i +1 ; j < SIZE ; j ++) {
	 dest[i][j]= src[j][i];
	 } 
	 }*/

	int n = SIZE;
	int b = 128;
	for (int i = 0; i < n; i += b)
	{
		for (int j = 0; j < n; j += b)
		{
			int xmin, ymin;
			(i + 2 < n) ? xmin = i + b : xmin = n;
			(j + 2 < n) ? ymin = j + b : ymin = n;
			for (int x = i; x < xmin; x++)
			{
				for (int y = j; y < ymin; y++)
				{
					if (y > x)
						dest[x][y] = src[y][x];
				}
			}
		}
	}
}