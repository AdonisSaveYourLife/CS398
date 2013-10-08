SCAN_ADDRESS:.space 16384	#think this allocates 16 KB
POINTSX:.space 60	#allocates space for the points
POINTSY:.space 60
index:	.word 0
state: 	.word 0

.text
main:
	sw	$0,  0xffff0010($0)	#stop the bot
	jal	initialize	

infinite:
	j	infinite	



initialize: 

	li     $t4, 0x8000                # timer interrupt enable bit
	or	$t4,$t4,0x2000	# scanner interrupt enable bit
	or	$t4,$t4,0x1000
	or	$t4, $t4, 1                # global interrupt enable
	mtc0	$t4, $12                   # set interrupt mask (Status register)
	
	#scanx=scany150	
	li	$t0,150
	sw	$t0,0xffff0050($0)	#scanX
	sw	$t0,0xffff0054($0)	#scanY
	li	$t0,213	#hardcoded radius
	sw	$t0,0xffff0058($0) 	#scanRadius
	la	$t1,SCAN_ADDRESS
	sw	$t1,0xffff005c($0)	#think this executes the scan  	

 
	j $ra
.kdata                # interrupt handler data (separated just for readability)
chunkIH:.space 28      # space for two registers
non_intrpt_str:   .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"


.ktext 0x80000180
interrupt_handler:
.set noat
      move      $k1, $at               # Save $at                               
.set at
      la	$k0, chunkIH                
      sw	$a0, 0($k0)              # Get some free registers                  
      sw	$a1, 4($k0)              # by storing them to a global variable     
      sw	$t0, 8($k0)
      sw	$t1, 12($k0)
      sw	$t2, 16($k0)
      sw	$t3, 20($k0)
      sw	$k1,24($k0)

      mfc0    $k0, $13                 # Get Cause register                       
      srl     $a0, $k0, 2                
      and     $a0, $a0, 0xf            # ExcCode field                            
      bne     $a0, 0, non_intrpt         

interrupt_dispatch:                    # Interrupt:                             
      mfc0    $k0, $13                 # Get Cause register, again                 
      beq     $k0, $zero, done         # handled all outstanding interrupts 
                
      and	$a0, $k0,0x2000
      bne	$a0,0,scanner_interrupt	
      
	andi    $a0, $k0, 0x8000	# timer interrupt
	bne     $a0, $0, timer_interrupt
      
      and     $a0, $k0, 0x1000         # is there a bonk interrupt?                
      bne     $a0, 0, bonk_interrupt   
      li      $k1, 4                   # Unhandled interrupt types
      la      $a0, unhandled_str
      syscall 
      j       done
      
non_intrpt:                            # was some non-interrupt
      li	$k1, 4
      la	$a0, non_intrpt_str
      syscall                          # print out an error message

      # fall through to done

done:
      la	$k0, chunkIH
      lw	$a0, 0($k0)              # Restore saved registers
      lw	$a1, 4($k0)
      lw	$t0, 8($k0)
      lw	$t1, 12($k0)
      lw	$t2, 16($k0)
      lw	$t3, 20($k0)
      lw	$k1,24($k0)
      mfc0  $k0, $14                 # Exception Program Counter (PC)
.set noat
      move    $at, $k1                 # Restore $at
.set at 
      rfe   
      jr      $k0
      nop      



bonk_interrupt:

      sw      $a1, 0xffff0060($zero)   # acknowledge interrupt

      j       interrupt_dispatch       # see if other interrupts are waiting
      
scanner_interrupt:

	sw      $a1, 0xffff0064($0)   # acknowledge interrupt
	
	
	jal startsort
	j interrupt_dispatch

	
startsort:
	sub $sp,$sp,8
	sw $ra, 4($sp)
	la $t8, SCAN_ADDRESS
	la $t9, POINTSX
	
	la $t7, POINTSY
	li $t5, 0

	sortfor:
		bge $t5, 15, endsortfor
		mul $t6, $t5, 8
		add $t6,$t6,$t8
		move $a0,$t6
		
		sw $t5,0($sp)
		jal sort_list
		move $a0,$t6
		jal compact
		
		lw $t5,0($sp)
		
		mul $t6, $t5, 4
		
		srl $t0,$v0,16
		bgt $t0,300,next

		and $t1,$v0,0xffff
		bgt $t1,300,next
		
		add $t2, $t6, $t9
		sw $t0,0($t2)

		add $t2, $t6, $t7
		sw $t1,0($t2)
	next:
		add $t5, $t5, 1
		j sortfor
		
	endsortfor:
		lw $ra, 4($sp)
		add $sp,$sp,8
		lw	$v0, 0xffff001c($0)	# current time
  		add	$v0, $v0, 1
  		sw	$v0, 0xffff001c($0)	# request timer in 50
		jr $ra

compact:

li $t0, 0                                # unsigned ret_val = 0
li $t1,1
       sll $t1, $t1, 31                        # mask = 1 << 31;
       lw        $t2,0($a0)                        # node_t *trav = list->head ;
loop:
       beq        $t2, $0, loop_end                # while(trav!=NULL)
       lw        $t3, 12($t2)                        # t3=trav->value
       beq        $t3, $0, else                        # if(trav->value != 0)
       or        $t0, $t0, $t1                        # ret_val |= mask;
       j        end_cond
else:
       not        $t4, $t1                        # t4=~mask
       and        $t0, $t0, $t4                        # ret_val &= ~mask;
end_cond:
       srl        $t1, $t1, 1                        # mask = mask >> 1;
       lw	$t2,8($t2)
       j loop
loop_end:
       move $v0, $t0

jr $ra
	
sort:
	insert_element_after:	
	# inserts the new element $a0 after $a1
	# if $a1 is 0, then we insert at the front of the list

	bne	$a1, $zero, iea_not_head # if a1 is null, we have to assign the head and tail

	lw	$t0, 0($a2) 		# $t0 = mylist->head
	sw	$t0, 8($a0)		# node->next = mylist->head;
	beqz	$t0, iea_after_head	# if ( mylist->head != NULL ) {
	sw	$a0, 4($t0)		#   mylist->head->prev = node;
		     			# }
iea_after_head:	
	sw	$a0, 0($a2)		# mylist->head = node;
	lw	$t0, 4($a2)		# $t0 = mylist->tail
	bnez	$t0, iea_done		# if ( mylist->tail == NULL ) {
	sw	$a0, 4($a2)		#   mylist->tail = node;
iea_done:	     			# }
	jr	$ra

iea_not_head:
	lw	$t1, 8($a1)		# $t1 = prev->next
	bne	$t1, $zero, iea_not_tail# if ( prev->next == NULL ) {
	sw	$a0, 4($a2)		#   mylist->tail = node;
	b	iea_end			# }
iea_not_tail:				# else {
	sw	$t1, 8($a0)		#   node->next = prev->next;
	sw	$a0, 4($t1)		#   node->next->prev = node;
		     			# }

iea_end:	
	sw	$a0, 8($a1)		# store the new pointer as the next of $a1
	sw	$a1, 4($a0)		# store the old pointer as prev of $a0
	jr	$ra			# return
	# END insert_element_after

remove_element:
	# removes the element at $a0 (list is in $a1)
	# if this element is the whole list, we have to empty the list
	lw	$t0, 0($a1)  	        # t0 = mylist->head
	lw	$t1, 4($a1)  	        # t1 = mylist->tail
	bne	$t0, $t1, re_not_empty_list

re_empty_list:
	sw	$zero, 0($a1)		# zero out the head ptr
	sw	$zero, 4($a1)		# zero out the tail ptr
	j	re_done

re_not_empty_list:
	lw	$t2, 4($a0)		# t2 = node->prev
	lw	$t3, 8($a0)		# t3 = node->next
	bne	$t2, $zero, re_not_first# if (node->prev == NULL) {

	sw	$t3, 0($a1)		# mylist->head = node->next;
	sw	$zero, 4($t3)		# node->next->prev = NULL;
	j	re_done

re_not_first: 
	bne	$t3, $zero, re_not_last# if (node->next == NULL) {
	sw	$t2, 4($a1)		# mylist->tail = node->prev;
	sw	$zero, 8($t2)		# node->prev->next = NULL;
	j	re_done
re_not_last:
	sw	$t3, 8($t2)		# node->prev->next = node->next;
	sw	$t2, 4($t3)		# node->next->prev = node->prev;

re_done:
	sw	$zero, 4($a0)		# zero out $a0's prev
	sw	$zero, 8($a0)		# zero out $a0's next
	jr	$ra			# return
	# END remove_element
	
sort_list:  # $a0 = mylist
	lw	$t0, 0($a0)  	        # t0 = mylist->head, smallest
	lw	$t1, 4($a0)  	        # t1 = mylist->tail
	bne	$t0, $t1, sl_2_or_more	# if (mylist->head == mylist->tail) {
	jr	$ra  	  		#    return;

sl_2_or_more:
	sub	$sp, $sp, 12
	sw	$ra, 0($sp)		# save $ra
	sw	$a0, 4($sp)		# save my_list
	lw	$t1, 8($t0)  	        # t1 = trav = smallest->next
sl_loop:
	beq	$t1, $zero, sl_loop_done # trav != NULL
	lw	$t3, 0($t1) 		# trav->data
	lw	$t2, 0($t0) 		# smallest->data
	bge	$t3, $t2, sl_skip	# inverse of: if (trav->data < smallest->data) { 
	move	$t0, $t1		# smallest = trav;
sl_skip:
	lw	$t1, 8($t1)		# trav = trav->next
	j	sl_loop
	
sl_loop_done:
	sw	$t0, 8($sp)		# save smallest

	move	$a1, $a0		# my_list is arg2
	move 	$a0, $t0		# smallest is arg1
	jal 	remove_element		# remove_node(smallest, mylist);

	lw	$a0, 4($sp)		# restore my_list as arg1
	jal	sort_list		# sort_list(mylist);

	lw	$a0, 8($sp)		# restore smallest as arg1
	li	$a1, 0			# pass NULL as arg2
	lw	$a2, 4($sp)		# restore my_list as arg3
	jal	insert_element_after	# insert_node_after(smallest, NULL, mylist);

	lw	$ra, 0($sp)		# restore $ra
	add	$sp, $sp, 12
	jr	$ra
	# END sort_list
	
	
	
timer_interrupt:
	sw	$0, 0xffff006c($0)		#acknowledge interrupt
	
	lw	$a0, state($0)
	bne	$a0, 0, timer_y

timer_x:
	lw	$a0, 0xffff0020($0)		#load our current x

	lw	$a1, index($0)
	mul	$a1, $a1, 4
	lw	$a1, POINTSX($a1)			#load target x

	sub	$a1, $a1, $a0
	abs	$a0, $a1
	blt	$a0, 2, timer_do_y		# within threshold

	lw	$k0, 0xffff001c($0)		# get current time
	mul	$a0, $a0, 400
	add	$k0, $k0, $a0			# set next timer appropriately
	sw	$k0, 0xffff001c($0)		# request timer 

	li	$a0, 0				# point in right direction
	bgt	$a1, $zero, t_drive
	li	$a0, 180

t_drive:
	sw	$a0, 0xffff0014($0)		# set angle
	li	$k0, 1
	sw	$k0, 0xffff0018($0)		# absolute
	li	$k0, 10
	sw	$k0, 0xffff0010($0)		# set velocity
	j	interrupt_dispatch

timer_do_y:
	li	$a0, 1
	lw	$a0, state($0)			# set state to 1

timer_y:
	lw	$a0, 0xffff0024($0)		# load our current y

	lw	$a1, index($0)
	mul	$a1, $a1, 4
	lw	$a1, POINTSY($a1)			# load target y

	sub	$a1, $a1, $a0
	abs	$a0, $a1
	blt	$a0, 2, timer_do_x		# within threshold

	lw	$k0, 0xffff001c($0)		# get current time
	mul	$a0, $a0, 400
	add	$k0, $k0, $a0			# set next timer appropriately
	sw	$k0, 0xffff001c($0)		# request timer 

	li	$a0, 90				# point in right direction
	bgt	$a1, $zero, t_drive
	li	$a0, 270
	j	t_drive

timer_do_x:
	li	$a0, 0
	lw	$a0, state($0)			# set state to 0
	
	lw	$a1, index($0)			# increment index
	add	$a1, $a1, 1
	sw	$a1, index($0)
	j	timer_x
