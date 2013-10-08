########################### problem2.s ##########################
#
# SPIMbot commands
#
# command   no. of arguments            meaning
# ---------------------------------------------------
#   0             1            wait, arg = time to wait
#   1             1            absolute turn, arg = angle
#   2             1            arg = 1 ==> paint
#                                  = 0 ==> don't paint
#   3             0            done


# Example sequence of tokens
#
# This makes SPIMbot print 233 on the screen


.data       ##### Data segment #####

string:
.word  	2 1     0 100   1 90      0 100
.word	1 135   0 144   1 0       0 100
.word	2 0     0 50    2 1       0 100
.word   1 -90   0 100   1 -180    0 100
.word   2 0     1 -90   0 100     1 0
.word   2 1     0 100   1 90      0 100
.word   2 0     1 0     0 50      1 -90
.word   0 100   1 90	0 200
.word	1 0	2 1     0 100
.word   1 -90   0 100   1 -180    0 100
.word   2 0     1 -90   0 100     1 0
.word   2 1     0 100   1 90      0 100
.word   2 0     1 0     0 50      1 -90
.word   0 100   1 0	3

##### Code segment #####

.text

# Function 'wait', just a delay loop
# argument $a0: time to wait

wait:
  sll  $a0, $a0, 5   # scale argument by 32
wait_loop:     # delay loop
  sub  $a0, $a0, 1
  bne  $a0, $zero, wait_loop
  jr   $ra           # return


# Function 'paint', starts/stops paintbrush
# argument $a0: 0 (stop painting) or 1 (start painting)

paint:

# SPIMbot uses "Memory-mapped I/O" -- we will discuss this in class.
# It paints by writing to a specific location in memory.
  sw   $a0, 0xffff0090($zero)    # write $a0 to specific memory location
  jr   $ra                       # jr $ra


# Function 'abs_turn', changes SPIMbot's heading
# argument $a0: angle representing new heading

abs_turn:
# Once again, this is achieved with memory-mapped I/O
  sw   $a0, 0xffff0014($zero) # write $a0 to specific memory location
  li   $t0, 1
  sw   $t0, 0xffff0018($zero) # send the turn command
  jr   $ra                    # return


# Function 'print_unknown_token' to print unknown token (duh)
# argument $a0: the unknown token

print_unknown_token:
# Yet again, this is achieved with memory-mapped I/O
  sw   $a0, 0xffff0080($zero)	# print out unrecognized token
  jr   $ra                    # return


# The 'main' function

main:
  sub $sp, $sp, 4
  sw  $ra, 0($sp)    # save $ra

  li  $t0, 10
  sw  $t0, 0xffff0010($zero)  # set velocity (memory-mapped I/O)

  la  $a0, string    # pass command tokens as argument
  jal interpret      # call your function

  lw  $ra, 0($sp)    # restore $ra
  add $sp, $sp, 4
  jr  $ra            # return

# ALL your code goes below this line.
#
# We will delete EVERYTHING above the line; DO NOT delete the line.
#
# ---------------------------------------------------------------------

interpret:
	li $t0,0 #int number
	li $t1,0 #int parameter
	li $t2,0 #int index
	sub $sp,$sp,20
	infinite_loop:
		add $t3, $t2,$a0 #tokens[index]
		lw $t0,0($t3) #number=tokens[index]
		beq $t0,3,return #if(number==3)return
		add $t3,$t2,4 #index+1
		add $t3,$t3,$a0 #tokens[index+1]
		lw $t1,0($t3) #parameter=tokens[index+1]
		add $t2, $t2, 8 #parameter+=2
		sw $ra,0($sp) #stores return address
		sw $t0,4($sp) #stores number
		sw $t1,8($sp) #stores parameter
		sw $t2,12($sp) #stores index
		sw $a0,16($sp) #stores index[]
		bne $t0,0,e1
			move $a0,$t1
			jal wait #call to wait function
			j end
		e1:
			bne $t0,1,e2
			move $a0,$t1
			jal abs_turn
			j end
		e2:
			bne $t0,2,e3
			move $a0,$t1
			jal paint
			j end
		e3:
			move $a0,$t0
			jal print_unknown_token
			lw $t2, 12($sp)
			sub $t2,$t2,1
			j end1
end:		lw $t2, 12($sp)
end1:		lw $ra, 0($sp)
		lw $t1, 8($sp)
		lw $t0, 4($sp)
		lw $a0, 16($sp)
		j infinite_loop

return: 
		add $sp, $sp, 20
		jr   $ra
