#Quick Sort
#Nome: Eduardo Sigrist Ciciliato nUSP: 7986542
#Nome: Hiero Martinelli nUSP: 7986646
#Nome: Daniele Hidalgo Boscolo  nUSP: 7986625

#
# Release Notes
#
# Version 0.1
#
# Changes:
# Primeiro código funcionando
# Le e imprime um vetor alocado dinamicamente sem problemas
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

#$t0 = temporario para operacoes aritmeticas e condicionais
#$t1 = N
#$t2 = N bytes para alocar / Posicao na memoria que sera pulada para carregamento dos valores no vetor
#$t3 = i
#$t4 = Posicao inicial do vetor original
#$t5 = Posicao inicial do vetor ordenado

			.text
			.align 2
			.globl main
		
main:

			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_quant 
			syscall
			
			li $v0, 5 #atribui 5 para $v0. Codigo para ler inteiro
			syscall

			move $t1, $v0 
			li $t0, 15
			ble $t1, $zero, exit #Se digitar 0 ou menos numeros sai do programa
			bgt $t1, $t0, error #Se digitar mais do que 15 numeros sai do programa
			
			li $t0, 4 #atribui 4 a $t2. Pois como um inteiro possui 4 bytes nós precisamos alocar 4 bytes para cada numero inteiro
			mul $t2, $t1, $t0
			
			li $v0, 9 #atribui 9 para $v0. Codigo para alocação dinamica
			move $a0, $t2 #aloca N * 4 bytes para o vetor original
			syscall
			
			move $t4, $v0 #move posicao inicial do novo vetor para $t4 (vetor original)
			
			li $v0, 9 #atribui 9 para $v0. Codigo para alocação dinamica
			move $a0, $t2 #aloca N * 4 bytes para o vetor ordenado
			syscall
			
			move $t5, $v0 #move posicao inicial do novo vetor para $t5 (vetor ordenado)
			
			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_num 
			syscall
			
			#Comeca o for para pegar todos os numeros
			li $t3, 0 #inicializa i com 0
			move $t0, $t4 #carrega o endereco do inicial do vetor original para $t0
			
loop_scan:	li $v0, 5 #atribui 5 para $v0. Codigo para ler inteiro
			syscall
			sw $v0, 0($t0)
			addi $t3, $t3, 1
			addi $t0, $t0, 4 #soma 4 em $t0 para poder acessar 4 bytes para frente na memoria na proxima iteracao
			bne $t1, $t3, loop_scan
			
			
			#Comeca o for para mostrar os valores do vetor original
			li $t3, 0 #inicializa i com 0
			move $t0, $t4 #carrega o endereco do inicial do vetor original para $t0
			
loop_print: lw $a0, 0($t0)
			li $v0, 1
			syscall
			addi $t3, $t3, 1
			addi $t0, $t0, 4 #soma 4 em $t0 para poder acessar 4 bytes para frente na memoria na proxima iteracao

			#imprime virgula entre os valores (", ")
			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_comma
			syscall

			bne $t3, $t1, loop_print

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
#	- $a1 = posicao a esquerda
#	- $a2 = posicao a direita
#
# Retorno:
#	vetor $a0 ordenado
#
quicksort:

# Funçao para particionar vetor
#
# Parametros:
#	- $a0 = Vetor a ser particionado
#	- $a1 = posicao esquerda
#	- $a2 = posicao direita
#
# Retorno:
#	- $v0 = posicao particionada
#
vect_part:

# Funçao para troca de valores na memoria
#
# Parametros:
#	- $a0 = posicao na memoria A
#	- $a1 = posicao na memoria B
#
# Retorno:
#	Os valores na memoria serão trocados entre A e B
swap: