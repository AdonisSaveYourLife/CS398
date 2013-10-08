#include <stdio.h>
#include <stdlib.h>
#include "bmp.h"


void insertMessage(BMPfile bmpfile, char *message) 
{
  	int decodedChar;
  	int width = getWidth(bmpfile);
  	int i = 0, x = 0, y = 0;				/* initialize co-ordinates */
	
  	do 
	{
	 	decodedChar = message[i];	
		
	 	i ++;
	 	for (int bit = 0; bit < 8; bit++) 
		{
			char bit = (decodedChar >> 7) & 1;
			decodedChar = (decodedChar << 1);

			pixel p = getPixel(bmpfile, x, y);
			p.green = (p.green & 0xfe) | bit; 
			putPixel(bmpfile, p, x, y);	
	
			x++;					/* set new x, y co-ordinates */
			if (x >= width) 
			{
		  		x = 0;
		  		y++;
			}	
	 	}
  	} while(decodedChar != 0);
}

