# Testing for: callee-saved registers
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
  sub  $sp, $sp, 36
  sw   $ra, 0($sp)        # save $ra on stack
  sw   $s0, 4($sp)
  sw   $s1, 8($sp)
  sw   $s2, 12($sp)
  sw   $s3, 16($sp)
  sw   $s4, 20($sp)
  sw   $s5, 24($sp)
  sw   $s6, 28($sp)
  sw   $s7, 32($sp)
  li   $s0, 0x77007700
  li   $s1, 0x77007700
  li   $s2, 0x77007700
  move $s3, $sp
  li   $s4, 0x77007700
  li   $s5, 0x77007700
  li   $s6, 0x77007700
  li   $s7, 0x77007700

  la  $a0, string    # pass command tokens as argument
  jal interpret      # call your function

  bne  $s0, 0x77007700, failed
  bne  $s1, 0x77007700, failed
  bne  $s2, 0x77007700, failed
  bne  $s3, $sp, failed
  bne  $s4, 0x77007700, failed
  bne  $s5, 0x77007700, failed
  bne  $s6, 0x77007700, failed
  bne  $s7, 0x77007700, failed
  li   $v0, 1
  li   $a0, 1
  syscall
  li   $v0, 11
  li   $a0, 10
  syscall

failed:
  lw   $ra, 0($sp)        # restore $ra
  lw   $s0, 4($sp)
  lw   $s1, 8($sp)
  lw   $s2, 12($sp)
  lw   $s3, 16($sp)
  lw   $s4, 20($sp)
  lw   $s5, 24($sp)
  lw   $s6, 28($sp)
  lw   $s7, 32($sp)
  addi $sp, $sp, 36
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
