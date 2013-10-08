
sample : sample.c 
	gcc -std=c99 -Wall -o sample bmp.c sample.c

p1 : p1.c extractMessage.c
	gcc -std=c99 -Wall -o p1 extractMessage.c bmp.c p1.c


p2 : countOnes.c p2.c
	gcc -std=c99 -Wall -o p2 countOnes.c p2.c
