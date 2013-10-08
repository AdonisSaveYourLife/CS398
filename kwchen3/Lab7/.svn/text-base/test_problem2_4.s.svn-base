# Testing for: uninitialized registers
# Points: 10
#
# Expected output:
#
# SPIM Version 6.5 of January 4, 2003
# Copyright 1990-2003 by James R. Larus (larus@cs.wisc.edu).
# All Rights Reserved.
# See the file README for a full copyright notice.
# Loaded: /homesta/cs232/trap_handler/trap.handler
# 1

.data       ##### Data segment #####

string: .word   1 0x7  7 0 0x8  2 0x1  3

sequence: .word 0x9

##### Code segment #####

.text

wait:
  la   $t0, sequence
  lw   $t1, 0($t0)
  sll  $t1, $t1, 8
  srl  $t2, $a0, 4
  bne  $t2, $zero, wait_err
  or   $t1, $t1, $a0
wait_err:
  sw   $t1, 0($t0)
  jr   $ra           # return


paint:
  la   $t0, sequence
  lw   $t1, 0($t0)
  sll  $t1, $t1, 8
  ori  $t1, $t1, 0x20
  srl  $t2, $a0, 4
  bne  $t2, $zero, paint_err
  or   $t1, $t1, $a0
paint_err:
  sw   $t1, 0($t0)
  jr   $ra           # return


abs_turn:
  la   $t0, sequence
  lw   $t1, 0($t0)
  sll  $t1, $t1, 8
  ori  $t1, $t1, 0x10
  srl  $t2, $a0, 4
  bne  $t2, $zero, abs_err
  or   $t1, $t1, $a0
abs_err:
  sw   $t1, 0($t0)
  jr   $ra           # return


print_unknown_token:
  la   $t0, sequence
  lw   $t1, 0($t0)
  sll  $t1, $t1, 4
  srl  $t2, $a0, 4
  bne  $t2, $zero, unknown_err
  or   $t1, $t1, $a0
unknown_err:
  sw   $t1, 0($t0)
  jr   $ra           # return


# The 'main' function

main:
  sub  $sp, $sp, 4
  sw   $ra, 0($sp)        # save $ra on stack

  li   $v0, 9
  li   $v1, 9
  li   $a3, 9
  li   $t0, 9
  li   $t1, 9
  li   $t2, 9
  li   $t3, 9
  li   $t4, 9
  li   $t5, 9
  li   $t6, 9
  li   $t7, 9
  li   $t8, 9
  li   $t9, 9

  la  $a0, string    # pass command tokens as argument
  jal interpret      # call your function

  lw  $t0, sequence
  bne $t0, 0x91770821, failed
  li   $v0, 1
  li   $a0, 1
  syscall
  li   $v0, 11
  li   $a0, 10
  syscall

failed:
  lw   $ra, 0($sp)        # restore $ra
  addi $sp, $sp, 4
  jr   $ra


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
