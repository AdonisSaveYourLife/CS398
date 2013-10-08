.text 
main:
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
chunkIH:.space 12      # space for two registers
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
      sw	$k1,8($k0) 
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
      sw      $a1, 0xffff006c($zero)   # acknowledge interrupt
      lw $k1,0xffff0014($zero)
      bne $k1,$0,elseif
      	li $k1, 135
      	sw $k1,0xffff0014($zero)
      	li $k1,1
      	sw $k1,0xffff0018($zero)
      	lw     $k1, 0xffff001c($0)        # read current time
     	add    $k1, $k1, 141420               # add 141420 to current time
     	sw     $k1, 0xffff001c($0)        # request timer interrupt in 141420 cycles
     	j interrupt_dispatch
elseif: 
	bne $k1,135,else
      		li $k1, 270
      		sw $k1,0xffff0014($zero)
      		li $k1,1
      		sw $k1,0xffff0018($zero)
      		lw     $k1, 0xffff001c($0)        # read current time
     		add    $k1, $k1, 100000               # add 100000 to current time
     		sw     $k1, 0xffff001c($0)        # request timer interrupt in 100000 cycles
     		j interrupt_dispatch
     		
else:	
	sw $zero,0xffff0014($zero)
      	li $k1,1
      	sw $k1,0xffff0018($zero)
      	lw     $k1, 0xffff001c($0)        # read current time
     	add    $k1, $k1, 100000               # add 100000 to current time
     	sw     $k1, 0xffff001c($0)        # request timer interrupt in 100000 cycles
     	j interrupt_dispatch

      j       interrupt_dispatch       # see if other interrupts are waiting

non_intrpt:                            # was some non-interrupt
      li      $k1, 4
      la      $a0, non_intrpt_str
      syscall                          # print out an error message

      # fall through to done

done:
      la      $k0, chunkIH
      lw      $a0, 0($k0)              # Restore saved registers
      lw      $a1, 4($k0)
      lw	$k1,8($k0)
      mfc0    $k0, $14                 # Exception Program Counter (PC)
.set noat
      move    $at, $k1                 # Restore $at
.set at 
      rfe   
      jr      $k0
      nop

