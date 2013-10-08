/**************************** sample.c *****************************
 *
 * This file is to facilitate your understanding of bmp.h and bmp.c.
 * 
 * We will not look at this file during grading, so don't put code
 * you want graded here.
 *
 */

/* Compiling and running this code:
 *
 * To compile the code, give the following command:
 *
 *   make sample
 *
 * Running the code:
 *
 * The compiler (gcc) will create a file called sample, which can be run
 * by giving the following command:
 *
 *   ./sample picture.png
 *
 * The argument to the program (picture.png in the above example) is 
 * the name of a file in the "portable network graphics" format.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include "bmp.h"
 
int main(int argc, char *argv[]) 
{
	int width;
	int height;
	BMPfile bmpfile;	/* bmpfile is a variable of type BMPfile */
	pixel p;			/* p is a variable of type pixel */

	/* Check for the correct number of arguments. The first argument
	 * (i.e. argv[0]) is always the program name (i.e. sample), so we
	 * require argc to be at least 2.
	 */
  	if (argc < 2) 
	{
		/* Print error message and quit program */
	 	fprintf(stderr, "Usage: %s filename\n", argv[0]);
	 	exit(-1);
  	}
  
	/* Open the image file */
  	bmpfile = openBMPfile(argv[1]);

	/* Find image's dimensions */
	width = getWidth(bmpfile);
	height = getHeight(bmpfile);
	printf("This image is of size %d x %d pixels.\n", width, height);

	/* Tint the entire image blue */
	for (int y = 0 ; y < height ; y++) 
	{
		for (int x = 0 ; x < width ; x++) 
		{
			p = getPixel(bmpfile, x, y);		/* read pixel */
			p.blue = 255;						/* access and set the blue component */
			putPixel(bmpfile, p, x, y);			/* write modified pixel */
	 	}
	}

  	printf("\n");

	/* Close open image file */
  	closeBMPfile(bmpfile);
}
