#-------------------------------------------------------------
# spim doubly-linked list insertion, removal
#-------------------------------------------------------------
	
	.data
empty:	   .asciiz	"emptied list!\n"	
newline:   .asciiz  	"\n"    	# places the newline character in memory
space:	   .asciiz      " "
list:	   .word	listitem1, listitem7
listitem1: .word	8, 0, listitem2
listitem2: .word	5, listitem1, listitem3
listitem3: .word	1, listitem2, listitem4
listitem4: .word	12, listitem3, listitem5
listitem5: .word	3, listitem4, listitem6
listitem6: .word	9, listitem5, listitem7
listitem7: .word	7, listitem6, 0

	.text

main:    	#program initial entry point
	sub	$sp, $sp, 8		# allocate some stack space
	sw	$s0, 0($sp)		# free up a callee saved register for list
	sw	$ra, 4($sp)		# save return address

	la	$s0, list		#

	lw	$a0, 0($s0)
	jal	print_list		# should print "8 5 1 12 3 9 7"
	jal	print_newline

 	move	$a0, $s0
 	jal	sort_list

	lw	$a0, 0($s0)
	jal	print_list		# should print "1 3 5 7 8 9 12"
	jal	print_newline
	
	lw	$s0, 0($sp)		# restore $s0
	lw	$ra, 4($sp)		# restore return address
	add	$sp, $sp, 8		# deallocate stack space
	jr	$ra

print_list:	# a recursive version of the the print list function.
	# prints the list starting from $a0
	bne	$a0, $zero, pl_do
	jr	$ra

pl_do:
	sub	$sp, $sp, 8		# adjust sp for two words
	sw	$ra, 0($sp)		# save the return address	
	sw	$s0, 4($sp)		# save s0
	move	$s0, $a0		# make a backup copy of the current element

	lw	$a0, 0($s0)		# load the value into $a0
	li 	$v0, 1			# syscall code 1 prints an integer 
  	syscall                   	# print integer

    	la 	$a0, space        	# store address of space for printing
    	li 	$v0, 4			# syscall code 4 prints a string 
  	syscall                   	# print string @ 0($a0)

	lw	$a0, 8($s0)
	jal	print_list

	lw	$ra, 0($sp)		# restore the return address
	lw	$s0, 4($sp)
	add	$sp, $sp, 8		# adjust sp
	jr	$ra
	# END print_list

print_newline:   	
	# prints out \n
    	la 	$a0, newline        	# store address of newline for printing
    	li 	$v0, 4    		# syscall code 4 prints a string 
  	syscall                   	# print string @ 0($a0)
  	jr 	$ra    			# return from print_newline
	# END print_newline

# ALL your code goes below this line.
#
# We will delete EVERYTHING above the line; DO NOT delete the line.
#
# ---------------------------------------------------------------------
	
# copy your "insert_element_after" and "remove_element" functions here
insert_element_after:
	#a0=node,#a1=prev,#a2=list	
	bne $a1,0,if2 #if(prev!=NULL) goto if2
		lw $t0,0($a2) # list->head
		sw $t0,8($a0)
		sw $0,4($a0)
		beq $t0,0,next
			lw $t0,0($a2)
			sw $a0,4($t0)
next:		sw $a0,0($a2)
		lw $t1,4($a2) #tail pointer of list
		bne $t1,0,return
			sw $a0,4($a2) #mylist->tail=node
return:		jr	$ra
if2:	lw $t0,8($a1) #mem address of next pointer of prev
	bne $t0,0,else	
		sw $0,8($a0)
		sw $a0,4($a2)
		j next1
else:	
	lw $t0,8($a1)
	sw $t0,8($a0)
	lw $t0,8($a0)
	sw $a0,4($t0)
next1:	sw $a0,8($a1)
	sw $a1,4($a0)
	
	j return
	
	# END insert_element_after

remove_element:
	lw $t0,0($a1)
	lw $t1,4($a1)
	bne $t0,$t1 e1
		sw $0,0($a1)
		sw $0,4($a1)
		j end
e1:	lw $t0,4($a0)
	bne $t0,0,e2
		lw $t0,8($a0)
		sw $t0,0($a1)
		lw $t0,8($a0)
		sw $0,4($t0)
		j end
e2:	lw $t0, 8($a0)
	bne $t0,0,e3
		lw $t0,4($a0)
		sw $t0,4($a1)
		lw $t0,4($a0)
		sw $0,8($t0)
		j end
e3:	lw $t0,8($a0)#node->next
	lw $t1,4($a0)#node->prev
	sw $t0,8($t1)#node->prev->next=node->next
	sw $t1,4($t0)#node->next-prev=node-prev
end:	sw $0,4($a0)
	sw $0,8($a0)
	jr	$ra
	# END remove_element
	
sort_list:  
	
	lw $t0,0($a0)
	lw $t1,4($a0)
	bne $t0,$t1,n
	jr $ra
n:	sub $sp,$sp,12
	lw $t0,0($a0) # t0=smallest
	lw $t1,8($t0) # t1=trav=smallest->next
for:	beq $t1,0,remove
		lw $t2,0($t0) #smallest->data
		lw $t3,0($t1) #trav->data
		bge $t3,$t2,for_inc 
			move $t0,$t1
for_inc: lw $t1,8($t1)
	j for
remove:	
	sw $t0,0($sp)
	sw $a0,4($sp)
	move $a1,$a0
	sw $ra,8($sp)
	move $a0,$t0
	
	jal remove_element
	lw $a0,4($sp)
	jal sort_list
	lw $a0,0($sp)
	move $a1,$0
	lw $a2,4($sp)
	jal insert_element_after
	lw $ra,8($sp)
	lw $t0,0($sp)
	lw $a0,4($sp)
end_sort:	add $sp,$sp,12
	jr	$ra

