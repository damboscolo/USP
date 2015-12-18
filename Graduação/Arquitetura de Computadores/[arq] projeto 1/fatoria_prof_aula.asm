fatorial:
			addi $sp, $sp -8
			sw $ra, 0($sp)
			sw $a0, 4($sp)

			beq $a0, $zero, attr_1
			addi $a0, $a0, -1

			jal fatorial
			
			lw $a0, 4($sp)
			mul $v0, $v0, $a0
			j desempilha

attr_1: 	li $v0, 1
desempilha: lw $ra, 0($sp)
			lw $a0, 4($sp)
			addi $sp, $sp, 8
			jr $ra
		