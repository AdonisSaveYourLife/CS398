// currently the extractMessage function manipulates pixels values so
// that it swaps the blue and red tinting of pixels.  Obviously this
// has nothing to do with the assignment; but it shows you how to read
// pixel values.  Re-write it as the assignment specifies.

#include "bmp.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void extractMessage(BMPfile bmpfile) 
{
  	unsigned char tempChar=0x00;
  	int width = getWidth(bmpfile);
  	int height = getHeight(bmpfile);
  	int flag=0;
	int counter=0;

  	for (int y = 0 ; y < height &&flag!=1; y++) 
  	{
	 	for (int x = 0 ; x < width &&flag!=1; x++) 
		{
			pixel p = getPixel(bmpfile, x, y);	/* read pixel */
			unsigned char g=p.green;

			unsigned char lsb=g&0x01;
			int tempNum=7-counter;
			tempChar=tempChar|(lsb<<tempNum);
			if(counter==7)
			{
				char c=tempChar;
				printf("%c",c);
				
				if(tempChar==0x00){
					flag=1;

				}
				counter=0;
				tempChar=tempChar&0x00;
			}
			else
			{
				counter++;
			}
		}
  	}
}

