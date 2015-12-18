#Quick Sort
#Nome: Eduardo Sigrist Ciciliato nUSP: 7986542
#Nome: Hiero Martinelli nUSP: 7986646
#Nome: Daniele Hidalgo Boscolo  nUSP: 7986625

#
# Release Notes
#
# Version 0.6.0
#
# Changes:
#   - COMENTADO
#	- Função Quicksort quase funcionando. (Programa finaliza, mas o vetor não foi ordenado corretamente.)
#
# Atençao:
#	- Futuramente remover os comentários que dizem "equivalente a" por uma explicaçao melhor do que acontece
#


			.data
			.align 0
str_quant:	.asciiz "Digite a quantidade de numeros: "
str_num:	.asciiz "Digite os numeros: "
str_comma:	.asciiz ", "
str_ord:	.asciiz "Vetor ordenado: "
str_ori:	.asciiz "Vetor original: "
str_exit:	.asciiz "Programa finalizado com sucesso!"
str_error:	.asciiz "Erro: Quantidade de numeros excedeu o limite maximo de 15!"
str_nline:	.asciiz "\n"

#$t0 = temporario para operacoes aritmeticas e condicionais
#$t2 = N bytes para alocar / Posicao na memoria que sera pulada para carregamento dos valores no vetor
#$t3 = i
#$s0 = N | Mudou de $t1
#$s1 = Posicao inicial do vetor original | Mudou de $t4
#$s2 = Posicao inicial do vetor ordenado | Mudou de $t5

			.text
			.align 2
			.globl main
		
main:

			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_quant 
			syscall
			
			li $v0, 5 #atribui 5 para $v0. Codigo para ler inteiro
			syscall

			move $s0, $v0 
			li $t0, 15
			ble $s0, $zero, exit #Se digitar 0 ou menos numeros sai do programa
			bgt $s0, $t0, error #Se digitar mais do que 15 numeros sai do programa
			
			li $t0, 4 #atribui 4 a $t2. Pois como um inteiro possui 4 bytes nós precisamos alocar 4 bytes para cada numero inteiro
			mul $t2, $s0, $t0
			
			li $v0, 9 #atribui 9 para $v0. Codigo para alocação dinamica
			move $a0, $t2 #aloca N * 4 bytes para o vetor original
			syscall
			
			move $s1, $v0 #move posicao inicial do novo vetor para $s1 (vetor original)
			
			li $v0, 9 #atribui 9 para $v0. Codigo para alocação dinamica
			move $a0, $t2 #aloca N * 4 bytes para o vetor ordenado
			syscall
			
			move $s2, $v0 #move posicao inicial do novo vetor para $s2 (vetor ordenado)
			
			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_num 
			syscall
			
			#Comeca o for para pegar todos os numeros
			li $t3, 0 #inicializa i com 0
			move $t0, $s1 #carrega o endereco inicial do vetor original para $t0
			
loop_scan:	li $v0, 5 #atribui 5 para $v0. Codigo para ler inteiro
			syscall
			sw $v0, 0($t0) #armazena em $v0 o valor de $t0 + 0
			addi $t3, $t3, 1 #incrementa +1 em i
			addi $t0, $t0, 4 #soma 4 em $t0 para poder acessar 4 bytes para frente na memoria na proxima iteracao
			bne $s0, $t3, loop_scan #Se i < N, continua o loop do for
			
			
			#Comeca o for para mostrar os valores do vetor original
			li $t3, 0 #inicializa i com 0
			move $t0, $s1 #carrega o endereco inicial do vetor original para $t0
			
loop_print: lw $a0, 0($t0) #armazena em $a0 o valor de %t0 + 0
			li $v0, 1 #atribui 1 para $v0. Codigo para imprimir inteiro
			syscall
			addi $t3, $t3, 1 #incrementa +1 em i
			addi $t0, $t0, 4 #soma 4 em $t0 para poder acessar 4 bytes para frente na memoria na proxima iteracao

			#imprime virgula entre os valores (", ")
			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_comma
			syscall

			bne $t3, $s0, loop_print
			
			#Chamada da funcao quicksort
			move $a0, $s1 #move o endereco do inicio do vetor para $a0
			li $a1, 0 #$a1 recebe a posicao inicial do vetor (em bytes)
			move $t0, $s0 #move N para $t0 para nao perder o valor
			addi $t0, $t0, -1 #diminui o valor de $t0 em 1 para indicar o final do vetor
			li $t2, 4 #carrega 4 em $t2 para utilizar na multiplicacao que trara o valor da posicao final do vetor (inteiro = 4 bytes)
			mul $t2, $t0, $t2 #calculando o valor da posicao (em bytes) do final do vetor
			move $a2, $t2 #carrega a o valor (em bytes) da posicao final do vetor
			jal quicksort #inicia o quicksort
			move $s2, $a0 #move o endereco do inicio do vetor ordenado para $s2
			
			#Comeca o for para mostrar os valores do vetor original
			li $t3, 0 #inicializa i com 0
			move $t0, $s2 #carrega o endereco do inicial do vetor ordenado para $t0
			
loop_prord: lw $a0, 0($t0)
			li $v0, 1
			syscall
			addi $t3, $t3, 1
			addi $t0, $t0, 4 #soma 4 em $t0 para poder acessar 4 bytes para frente na memoria na proxima iteracao

			#imprime virgula entre os valores (", ")
			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_comma
			syscall

			bne $t3, $s0, loop_prord
			
exit:

			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_exit
			syscall

			li $v0, 10
			syscall


error:
			
			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_error
			syscall
			j exit		
		

# Funçao de Ordenaçao recursiva decrescente utilizando o algoritmo quicksort
#
# Parametros:
#	- $a0 = Vetor a ser ordenado
#	- $a1 = posicao a esquerda (geralmente 0) (multiplicado pelo numero de bytes que eh 4)
#	- $a2 = posicao a direita (geralmente o tamanho do vetor - 1) (multiplicado pelo numero de bytes que eh 4)
#
# Retorno:
#	vetor $a0 ordenado
#
quicksort:
					move $t0, $a0
					add $t0, $a1, $t0
					lw $t4, 0($t0) #carrega o valor de v[0] no registrador $t4
					move $t0, $a0
					add $t0, $a2, $t0
					lw $t5, 0($t0) #carrega o valor de v[N] no registrador $t5
					sgt $t0, $t4, $t5 #caso o valor da direita seja maior que o da esquerda, coloca 1 em $t0.
					beqz $t0, end_quicksort #finaliza caso $t0 seja igual a 0
					
					addi $sp, $sp, -20 #movendo o ponteiro da pilha
					sw $ra, 0($sp) #salvando os valores necessarios para uso posterior
					sw $a0, 4($sp)
					sw $a1, 8($sp)
					sw $a2, 12($sp)
					sw $t0, 16($sp)
					
					jal vect_part #chamada da funcao particionar vetor
					
					lw $ra, 0($sp) #recolocando os valores para continuar a execucao
					lw $a0, 4($sp)
					lw $a1, 8($sp)
					lw $a2, 12($sp)
					lw $t0, 16($sp)
					addi $sp, $sp, 20 #movendo o ponteiro da pilha
					
					move $t0, $v0 #move o valor de $v0 para $t0, evitando que ele se perca
					addi $t0, $t0, -4 #$t0 - 4 (numero de bytes para o numero anterior do vetor) para comecar um novo loop do quicksort
					move $a2, $t0 #move o valor de $t0 para $a2, fazendo com que o valor da posicao a direita mude
					addi $sp, $sp, -20 #movendo o ponteiro da pilha
					sw $ra, 0($sp) #salvando os valores necessarios para uso posterior
					sw $a0, 4($sp)
					sw $a1, 8($sp)
					sw $a2, 12($sp)
					sw $t0, 16($sp)
					jal quicksort #recursao do quicksort
					lw $ra, 0($sp) #recolocando os valores para continuar a execucao
					lw $a0, 4($sp)
					lw $a1, 8($sp)
					lw $a2, 12($sp)
					lw $t0, 16($sp)
					addi $sp, $sp, 20 #movendo o ponteiro da pilha
					
					addi $t0, $t0, 8 #$t0 + 4 (numero de bytes para o proximo numero do vetor) para comecar um novo loop do quicksort
					move $a1, $t0 #atualizando o valor da posicao a esquerda
					addi $sp, $sp, -20 #movendo o ponteiro da pilha
					sw $ra, 0($sp) #salvando os valores necessarios para uso posterior
					sw $a0, 4($sp)
					sw $a1, 8($sp)
					sw $a2, 12($sp)
					sw $t0, 16($sp)
					jal quicksort #recursao do quicksort
					lw $ra, 0($sp) #recolocando os valores para continuar a execucao
					lw $a0, 4($sp)
					lw $a1, 8($sp)
					lw $a2, 12($sp)
					lw $t0, 16($sp)
					addi $sp, $sp, 20 #movendo o ponteiro da pilha
			
end_quicksort:		jr $ra #finaliza o quicksort voltando para o endereco que o chamou
			
# Funçao para particionar vetor
#
# Parametros:
#	- $a0 = Vetor a ser particionado (v[])
#	- $a1 = posicao esquerda (esq/baixo) (multiplicado pelo numero de bytes que eh 4)
#	- $a2 = posicao direita (dir/cima) (multiplicado pelo numero de bytes que eh 4)
#
# Retorno:
#	- $v0 = posicao particionada
#
# Registradores Utilizados:
#	- $t4 = utilizado no loop para andar no vetor em que os valores estão sendo verificados
#	- $t5 = utilizado no loop para verificar os valores dentro do vetor
#	- $t6 = a
#	- $t7 = baixo
#	- $t8 = cima
#	- $t9 = usado para manipular a posicao no vetor sem perder o inicio
#
vect_part:
			move $t9, $a0 #coloca a posicao inicial do vetor v[] em $t9
			add $t9, $t9, $a1 #adiciona a posicao esquerda ao inicio do vetor para acessar a posicao esquerda
			lw 	$t6, 0($t9) # carrega v[esq] em a
			move $t7, $a1 #equivalente a baixo = esq
			move $t8, $a2 #equivalente a cima = dir

loop_part:	blt $t7, $t8, exit_loop_part #while(baixo < cima)

loop_part_low: move $t4, $a0 #while( v[baixo] >= a && baixo < dir )
			add $t4, $t4, $t7
			lw $t5, 0($t4)
			bge $t5, $t6, loop_part_high #equivalente a v[baixo] >= a
			blt $t7, $a1, loop_part_high #equivalente a baixo < dir
			addi $t7, $t7, 4
			j loop_part_low

loop_part_high:move $t4, $a0 #while( v[cima] < a )
			add $t4, $t4, $t8
			lw $t5, 0($t4)
			blt $t5, $t6, swap_condition #equivalente a v[cima] < a
			addi $t8, $t8, -4
			j loop_part_high

swap_condition: blt $t8, $t7, no_swap #if( baixo < cima )
			addi $sp, $sp, -16 #Empilha as variaveis e o $ra
			sw $ra, 0($sp)
			sw $a0, 4($sp)
			sw $a1, 8($sp)
			sw $a2, 12($sp)

			move $a0, $t7
			move $a1, $t8
			jal swap #chama a funcao swap com a posicao na memoria da variavel cima e baixo
			
			lw $ra, 0($sp) #Desempilha as variaveis e o $ra
			lw $a0, 4($sp)
			lw $a1, 8($sp)
			lw $a2, 12($sp)
			addi $sp, $sp, 16

no_swap:	j loop_part

exit_loop_part:	move $t4, $a0
			add $t4, $t4, $t8
			lw $t5, 0($t4)
			move $t0, $a0
			add $t0, $a2, $t0
			sw $t5, 0($t0) #equivalente a v[esq] = v[cima]
			move $t0, $a0
			add $t0, $t8, $t0
			sw $t6, 0($t0) #equivalente a v[cima] = a
			move $v0, $t8 #return cima
			jr $ra

			


# Funçao para troca de valores na memoria
#
# Parametros:
#	- $a0 = posicao na memoria A
#	- $a1 = posicao na memoria B
#
# Retorno:
#	Os valores na memoria serão trocados entre A e B
swap:
			move $t0, $a0 #$t0 = $a0
			move $a0, $a1 #$a0 = $a1
			move $a1, $t0 #$a1 = $t0