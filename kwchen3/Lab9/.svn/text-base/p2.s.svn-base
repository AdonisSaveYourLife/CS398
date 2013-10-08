.data
index:	.word 0
state: 	.word 0

x_coords:
.word   15	108	250	91	67	
.word   42	180	220	96	270	
.word   140	201	32	150	180

y_coords:
.word   42	180	96	220	270	
.word   108	250	91	67	15	
.word   32	150	201	140	180

	.text
main:
	sw	$0,  0xffff0010($0)	#stop the bot

	jal	initialize	# call your initialization function
				# this should set up interrupt handling;
				# all of the actual steering, etc. should
				# be done by the interrupt handler

infinite:
	j	infinite	# loop forever (note that interrupts
				# will still be handled)

# ALL your code goes below this line.
#
# We will delete EVERYTHING above the line; DO NOT delete the line.
#
# ---------------------------------------------------------------------

initialize: 
	li     $t4, 0x8000                # timer interrupt enable bit
	or     $t4, $t4, 1                # global interrupt enable
	mtc0   $t4, $12                   # set interrupt mask (Status register)

	lw     $v0, 0xffff001c($0)        # read current time
	add    $v0, $v0, 100000               # add 100000 to current time
	sw     $v0, 0xffff001c($0)        # request timer interrupt in 100000 cycles

	jr $ra


.kdata                # interrupt handler data (separated just for readability)
chunkIH:.space 28      # space for two registers
non_intrpt_str:   .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"


.ktext 0x80000180
interrupt_handler:
.set noat
      move      $k1, $at               # Save $at                               
.set at
      la      $k0, chunkIH                
      sw      $a0, 0($k0)              # Get some free registers                  
      sw      $a1, 4($k0)              # by storing them to a global variable     
      sw	  $t0, 8($k0)
      sw	  $t1, 12($k0)
      sw	  $t2, 16($k0)
      sw	  $t3, 20($k0)
      sw	$k1,24($k0)

      mfc0    $k0, $13                 # Get Cause register                       
      srl     $a0, $k0, 2                
      and     $a0, $a0, 0xf            # ExcCode field                            
      bne     $a0, 0, non_intrpt         

interrupt_dispatch:                    # Interrupt:                             
      mfc0    $k0, $13                 # Get Cause register, again                 
      beq     $k0, $zero, done         # handled all outstanding interrupts 
          
      and     $a0, $k0, 0x8000         # is there a timer interrupt?
      bne     $a0, 0, timer_interrupt
      
      li      $k1, 4                   # Unhandled interrupt types
      la      $a0, unhandled_str
      syscall 
      j       done
      
timer_interrupt:
      sw	$a1, 0xffff006c($zero)   # acknowledge interrupt
	  la $k0, state
	  lw $a0, 0($k0) #$a0 = state
	  la $k0, index
	  lw $a1,0($k0) #$a1 = index

while:
	bne $a0,$0,else # if(state ==0)
	la $k0, x_coords
	lw $t0, 0($k0) #x_coords[]
	lw $t1, 0xffff0020($0) #current x
	mul $k0, $a1, 4
	lw $t0, x_coords($k0) #target_x = x_coords[index]
	sub $t3,$t0,$t1 #t3=diff
	abs $t2,$t3	#t2=abs(diff)
	li $k0, 2
	bge $t2, $k0, else1
	li $a0, 1

	j while

else1:		
	ble $t3, $0, else2
	li $t3, 0
	j end_while

else2:		
	li $t3, 180
	j end_while

else:	
	la $k0, y_coords
	lw $t0, 0($k0) #y_coords[]
	lw $t1, 0xffff0024($0) #current y
	mul $k0, $a1, 4
	lw $t0, y_coords($k0) #target_y = y_coords[index]
	sub $t3,$t0,$t1 #t3=diff
	abs $t2,$t3	#t2=abs(diff)
	li $k0, 2
	bge $t2, $k0, else3
	li $a0, 0
	add $a1, $a1, 1

	j while

else3:		
	ble $t3, $0, else4
	li $t3, 90
	j end_while

else4:		
	li $t3, 270
	j end_while

end_while:

	la $k0, state
	sw $a0, 0($k0) #$a0 = state storing back state
	la $k0, index
	sw $a1,0($k0) #$a1 = index storing back index
	
	sw $t3,0xffff0014($zero)

	li $k0,1
	sw $k0,0xffff0018($zero)
	
	li $k0,10
	sw $k0,0xffff0010($zero)
	
	lw $k0, 0xffff001c($0)        # read current time
	mul $t2,$t2,400
	add $k0,$k0,$t2
	sw $k0, 0xffff001c($0)        # request timer interrupt in 400*abs_diff + get_timer() cycles
	j interrupt_dispatch
	
non_intrpt:                            # was some non-interrupt
      li      $k1, 4
      la      $a0, non_intrpt_str
      syscall                          # print out an error message

      # fall through to done

done:
      la    $k0, chunkIH
      lw    $a0, 0($k0)              # Restore saved registers
      lw    $a1, 4($k0)
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

