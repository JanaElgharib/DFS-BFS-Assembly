.data
		
	#repOne: .space 28	# 4 * 7
	repTwo: .space 28	# 4 * 7
	
	comma: .asciiz ", "
	newLine: .asciiz "\n"
	repOne: .word 4, 9, 10, 10, 15, 2, 3
	#repTwo: .word 4, 9, 10, 15, 10, 2, 3
	
	queue:	.space 16	# 4 * 4
	
.text
	# intialize length
	li $s7, 7
		
	# intialize queue
	li $s0, 0 	# start
	li $s1, 0 	# end
	li $s2, 0 	# size
	
	# intialize repTwo pointer
	li $s3, 0
	
	
	main:	
		li $a1, 0 	# node value
        	jal convertToRepTwo
		
		la $a1, repTwo
		jal print
		
		la $a1, 10	# tagret 
		jal searchRepTwo
		
		#print
		#li $v0, 1
		#move $a0, $v1
		#syscall
		
		# exit
		#li $v0, 10
		#syscall
	
	enqueue:
		sw $a1, queue($s1)
		# increment end pointer
		addi $s1, $s1, 4
		# increment size
		addi $s2, $s2, 1
		jr $ra
		
	dequeue:
		lw $v1, queue($s0)
		# increment start pointer
		addi $s0, $s0, 4
		# decrement size
		addi $s2, $s2, -1
		jr $ra
		
	convertToRepOne:
		
		# add ra to stack
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		# calculate the difference between the children of the current node
		addi $t1, $s7, 1	# n + 1
		srl $t1, $t1, 1		# (n + 1) / 2
		
		li $a1, 0
		jal enqueue
		
		# intialize repOne pointer
		li $t2, 0
		
		convertToRepOneOuterLoop:
			
			# loop over number of nodes in current level
			# intialize iterator
			move $t3, $s2
			convertToRepOneInnerLoop:
				
				jal dequeue					
				move $t0, $v1	
				sll $t4, $t0, 2
				lw $t5, repTwo($t4)			
				
				
				sw $t5, repOne($t2) 	# add to repOne 
				addi $t2, $t2, 4
				
				
				li $t9, 1
				beq $t1, $t9, convertToRepOneContinue	# check if leaf
				
				
				addi $a1, $t0, 1	# calculate first child
				jal enqueue		# add first child to queue
				
				add $a1, $t0, $t1	# calculate second child index
				jal enqueue		# add second child to index
				
				
				
				convertToRepOneContinue:
				addi $t3, $t3, -1	# increment operator
				
				bne $t3, $zero, convertToRepOneInnerLoop 	# convertToRepOneInnerLoop condition
			  
			  
			
			
			srl $t1, $t1, 1
			
			
			bne $s2, $zero, convertToRepOneOuterLoop
		
		
		
		# remove ra from stack
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		#return
		jr $ra
	
	
	convertToRepTwo:    
        	# add ra and $a1 to stack
        	addi $sp, $sp, -8
        	sw $ra, 0($sp)
        	sw $a1, 4($sp)
        
        	# return void if (node >= repOne.size())
       		bge $a1, $s7, return    
        	#else recursion    
        
        	sll $t1, $a1, 2    
        	lw $t0, repOne($t1)
        	sw $t0, repTwo($s3)
        	addi $s3, $s3, 4
        
       		# first child
        	sll $a1, $a1, 1
        	addi $a1, $a1, 1 
        	jal convertToRepTwo 
    
        	lw $a1, 4($sp) 
        
        	#sec child
        	sll $a1, $a1, 1
        	addi $a1, $a1, 2      
        	jal convertToRepTwo 
                            
                                        
        	return:
        	lw $ra, 0($sp)
        	lw $a1, 4($sp)
        	addi $sp, $sp, 8
        
        	jr $ra
		
	# $a1 target
	# level of target if found in repOne else 0. 
	searchRepOne:
		# intialize iterator i
		li $t1, 0 
		
		# intialize level
		li $t2, 1
		
		# intialize sum of nodes in previous levels
		li $t3, 0
		
		# intialize number of nodes in current leel
		li $t4, 1
		
		searchRepOneLoop:
			
			# calculate the index of the first node in the next level 
			add $t5, $t4, $t3
			# check if the current index is less than the index of the first node in the next level 
			bne $t1, $t5, continue
			
			# increment level
			addi $t2, $t2, 1
			# update sum of nodes in previous levels
			add $t3, $t3, $t5
			# update number of nodes in current level
			sll $t4, $t4, 1
			
			continue:
			# calculate offset
			sll $t6, $t1, 2
			
			# load item
			lw $t0, repOne($t6)
			
			# check if target equals item
			beq $t0, $a1, found
			
			# increment iterator
			addi, $t1, $t1, 1
			
			bne $t1, $s7, searchRepOneLoop
			
			
			move $v1, $zero
			jr $ra
			
			found:
			# return level
			move $v1, $t2
			jr $ra
				
					
	searchRepTwo:
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $a1, 4($sp)
		
		jal convertToRepOne
		
		lw $a1, 4($sp)
		jal searchRepOne
		
		lw $ra, 0($sp)
		lw $a1, 4($sp)
		addi $sp, $sp, 8
		
		jr $ra																				
													
																									
	print:
		li $v1, 0
		# intialize iterator i
		li $t1, 0 
		printLoop:
			# offset
			sll $t3, $t1, 2 
			
			# base + offset
			add $t3, $t3, $a1
			
			# load item
			lw $t0, 0($t3)
			
			# print
			li $v0, 1
			move $a0, $t0
			syscall
			
			# print new line
			li $v0, 4
			la $a0, comma
			syscall
			
			# increment 
			addi, $t1, $t1, 1
			
			
			
			# termination condition
			bne $t1, $s7, printLoop
			
			li $v0, 4
			la $a0, newLine
			syscall
			
			jr $ra  
