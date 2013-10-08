########################### problem1.s ##########################

.data         # Data segment

bool:
.word 1, 0, 0, 1,   # 0x 9
.word 1, 1, 0, 0,   # 0x c
.word 1, 1, 1, 0,   # 0x e
.word 0, 1, 1, 1,   # 0x 7
.word 0, 0, 1, 1,   # 0x 3
.word 1, 0, 0, 1,   # 0x 9
.word 1, 1, 0, 0,   # 0x c
.word 1, 1, 1, 0,   # 0x e
.word 0, 1, 1       # 0x 6

length: .word 35   # length of array

output: .word 0, 0, 0, 0, 0, 0, 0, 0   # output array


.text         # Code segment

# print_array function
#
# argument $a0: base address of an array of words
# argument $a1: length of array
#
# This function prints out the elements of the array (in decimal)

print_array:

  move $t0, $a0   # copy base address into $t0
  li   $t1, 0     # initialize loop iterator

print_array_loop:

  bge  $t1, $a1, print_array_done  # if ($t1 >= $a1) exit
  lw   $a0, 0($t0)        # load current element into print register
  li   $v0, 1             # load the syscall option for printing ints
  syscall                 # print the element

  li   $a0, 32            # print a black space (ASCII 32)
  li   $v0, 11            # load the syscall option for printing chars
  syscall                 # print the char

  # loop maintenance
  addi $t0, $t0, 4        # increase the array "pointer"
  addi $t1, $t1, 1        # increment the loop iterator
  j    print_array_loop   # jump to start of loop

print_array_done:
  jr      $ra             # return to the calling procedure


# main function

main:

  sub  $sp, $sp -4
  sw   $ra, 0($sp)        # save $ra on stack

  la   $a0, bool          # set arguments
  lw   $a1, length
  la   $a2, output

  jal  compact            # call your function

  # Now print the compacted array. It has size ceiling(length / 32)

  la   $a0, output        # reload $a0 and $a1
  lw   $a1, length        # from memory

  # compute ceiling(length / 32) == (length + 31) / 32

  addi $a1, $a1, 31       # $a1 += 31
  sra  $a1, $a1, 5        # $a1 = $a1 >> 5  (i.e. $a1 / 32)
                          # Do you know the difference between srl and
                          # sra? Which of these does the C operator >> do?

  jal  print_array        # print the compact array

  lw   $ra, 0($sp)        # restore $ra
  addi $sp, $sp, 4

  jr   $ra

# ALL your code goes below this line.
#
# We will delete EVERYTHING above the line; DO NOT delete the line.
#
# ---------------------------------------------------------------------

compact:
	li $t0,0 #boolIndex=0
	li $t1,0 #wordIndex=0
	li $t2,1
	sll $t2,$t2,31 #mask=1<<31
loop:	bge $t0,$a1,end
	mul $t3,$t0,4
	add $t3,$t3,$a0 #$t3=bool[boolIndex] 
	lw $t3,0($t3)
	mul $t4,$t1,4
	add $t4,$t4,$a2 #$t4=word[wordIndex]
	lw $t5,0($t4)
	beq $t3,0,else
	or $t5,$t5,$t2 #word[wordIndex |=mask
	sw $t5,0($t4)
	j next
else:	nor $t6,$t2,0 #~mask
	and $t5,$t5,$t6 #word[index] &=mask
	sw $t5, 0($t4)
next:	srl $t2,$t2,1
	add $t0,$t0,1
	bne $t2,0,loop
	add $t1,$t1,1
	li $t2,1
	sll $t2,$t2,31
	j loop
end:	jr	$ra
