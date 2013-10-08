#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include "filter.h"

void filter_fusion(pixel_t **image1, pixel_t **image2)
{
	for (int i = 0; i < SIZE - 2; i++)
	{
		filter1(image1, image2, i + 1);
		if (i + 2 < SIZE - 2)
			filter2(image1, image2, i + 2);
	}

	for (int i = 1; i < SIZE - 5; i++)
	{
		filter3(image2, i);
	}

}

void filter_prefetch(pixel_t **image1, pixel_t **image2)
{

	for (int i = 1; i < SIZE - 1; i++)
	{
		filter1(image1, image2, i);
		__builtin_prefetch(&(*image1[i + 50]), 0);
		__builtin_prefetch(&(*image2[i + 50]), 1);

	}

	for (int i = 2; i < SIZE - 2; i++)
	{
		filter2(image1, image2, i);
		__builtin_prefetch(&(*image1[i + 50]), 0);
		__builtin_prefetch(&(*image2[i + 50]), 1);
	}

	for (int i = 1; i < SIZE - 5; i++)
	{
		filter3(image2, i);
		__builtin_prefetch(&(*image2[i + 50]));

	}

}

void filter_all(pixel_t **image1, pixel_t **image2)
{

	for (int i = 0; i < SIZE - 2; i++)
	{
		filter1(image1, image2, i + 1);
		if (i + 2 < SIZE - 2)
			filter2(image1, image2, i + 2);
		
		__builtin_prefetch(&(*image1[i + 50]), 0);
		__builtin_prefetch(&(*image2[i + 50]), 1);

	}

	for (int i = 1; i < SIZE - 5; i++)
	{
		filter3(image2, i);
		__builtin_prefetch(&(*image2[i + 50]));

	}

}
