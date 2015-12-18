/*
* Conversor de Instruçoes em Hexadecimal para Assembly MIPS - Arquitetura de Computadores
*
* Integrantes do Grupo:
*
* Nome: Daniele Hidalgo Boscolo  nUSP: 7986625
* Nome: Eduardo Sigrist Ciciliato nUSP: 7986542
* Nome: Gabriel de Souza Ribeiro nUSP: 7986667
* Nome: Hiero Martinelli nUSP: 7986646
* 
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define GENERAL 0x00
#define BLTZAL 0x01
#define JUMP 0x02
#define JAL 0x03
#define BEQ 0x04
#define BNE 0x05
#define ADDI 0x08
#define LB 0x20
#define LW 0x23
#define SB 0x28
#define SW 0x2B
#define ADD 0x20
#define SUB 0x22
#define AND 0x24
#define OR 0x25
#define SLT 0x2A

void printInstruction(int, char[], int, int, int); // Imprimi na tela o nome da instruçao e na ordem correta os nomes dos registradores.
char* getRegisterName(int); // Retorna uma String com o nome do registrador, utilizando seu numero como base.

int main(){

	unsigned int hex, hexaux, opcode, rd, rs, rt, imm, address, label, funcfield, ok; //todos os inteiros sem sinal para evitar pegar valores negativos em hexadecimal
	ok = 1; //verifica se deve continuar rodando

	while(ok == 1){
		fflush(stdin); // Evita loop infinita ao digitar hexadecimais com formato inválido.
		printf("Digite o codigo em hexa:");
		scanf("%x", &hex);
		if(hex == 0){ // Se o valor for 0x00000000 ou 0 em decimal, sai do programa.
			ok = 0;
			break;
		}

		opcode = hex >> 26; // Desloca 26 bits para direita, restando assim apenas os 6 primeiros bits referentes ao opcode.

		if(opcode != JUMP && opcode != JAL){ // Como as unicas funçoes que diferem bastante das outras são o Jump e o Jump and Link nós separamos eles do resto.
			hexaux = (hex >> 18) & 0xff; // Desloca 18 bits para direita e pega apenas os 8 bits menos significativos.
			rs = hexaux >> 3; // Desloca mais 3 bits para direita, ficando assim com os 5 bits do registrador source.
			hexaux = (hex >> 13) & 0xff; // Desloca 13 bits para direita e pega apenas os 8 bits menos significativos.
			rt = hexaux >> 3; // Desloca mais 3 bits para direita, ficando assim com os 5 bits do registrador target que estão 5 bits a direita do source.
		}else{
			hexaux = (hex << 2) & 0xfffffff; // Desloca 2 bits a esquerda eliminando assim os 2 primeiros bits e depois pega apenas os 28 bits menos significativos eliminando mais 4 bits, retirando assim o opcode.
			label = hexaux >> 2; //Desloca de volta os 2 bits e você tem 26 bits de label para o j e jal.
		}

		switch(opcode){
			case GENERAL:
				hexaux = (hex >> 8) & 0xff;
				rd = hexaux >> 3; // Assim como anteriormente temos que pegar os 5 bits do registrador de destino.
				hexaux = (hex << 2) & 0xff; // Desloca 2 bits a esquerda tornando os 6 ultimos bits os 8 ultimos bits e pegando apenas eles.
				funcfield = hexaux >> 2; // Transforma os 8 ultimos bits em 6 de volta e nós temos o function field.
				switch(funcfield){
					case ADD:
						printInstruction(opcode, "add", rs, rt, rd);
						break;
					case SUB:
						printInstruction(opcode, "sub", rs, rt, rd);
						break;
					case AND:
						printInstruction(opcode, "and", rs, rt, rd);
						break;
					case OR:
						printInstruction(opcode, "or", rs, rt, rd);
						break;
					case SLT:
						printInstruction(opcode, "slt", rs, rt, rd);
						break;
					default:
						printf("Instrucao invalida\n");
						break;
				}
				break;
			case BLTZAL:
				label = hex & 0xffff; // Armazena em label os ultimos 16 bits da instruçao
				printInstruction(opcode, "bltzal", rs, rt, label);
				break;
			case BEQ:
				label = hex & 0xffff; // Armazena em label os ultimos 16 bits da instruçao
				printInstruction(opcode, "beq", rs, rt, label);
				break;
			case BNE:
				label = hex & 0xffff; // Armazena em label os ultimos 16 bits da instruçao
				printInstruction(opcode, "bne", rs, rt, label);
				break;
			case ADDI: 
				imm = hex & 0xffff; // Armazena em imm os ultimos 16 bits da instruçao
				printInstruction(opcode, "addi", rs, rt, imm);
				break;
			case LB:
				address = hex & 0xffff; // Armazena em address os ultimos 16 bits da instruçao
				printInstruction(opcode, "lb", rs, rt, address);
				break;
			case LW:
				address = hex & 0xffff; // Armazena em address os ultimos 16 bits da instruçao
				printInstruction(opcode, "lw", rs, rt, address);
				break;
			case SB:
				address = hex & 0xffff; // Armazena em address os ultimos 16 bits da instruçao
				printInstruction(opcode, "sb", rs, rt, address);
				break;
			case SW:
				address = hex & 0xffff; // Armazena em address os ultimos 16 bits da instruçao
				printInstruction(opcode, "sw", rs, rt, address);
				break;
			case JUMP:
				printf("Instrucao Assembly: j %d\n", label);
				break;
			case JAL:
				printf("Instrucao Assembly: jal %d\n", label);
				break;
			default:
				printf("Instrucao invalida\n");
				break;
		}
	}

	system("exit");

	return 0;
}

void printInstruction(int op, char funcName[], int rs, int rt, int aux){ // Imprimi na tela o nome da instruçao e na ordem correta os nomes dos registradores.
	printf("Instrucao Assembly: ");
	switch(op){
		case GENERAL:
			printf("%s %s %s %s", funcName, getRegisterName(aux), getRegisterName(rs), getRegisterName(rt));
			break;
		case BLTZAL:
			printf("%s %s %d", funcName, getRegisterName(rs), aux);
			break;
		case BEQ:
		case BNE:
			printf("%s %s %s %d", funcName, getRegisterName(rs), getRegisterName(rt), aux);
			break;
		case ADDI:
			printf("%s %s %s %d", funcName, getRegisterName(rt), getRegisterName(rs), aux);
			break;
		case LB:
		case LW:
		case SB:
		case SW:
			printf("%s %s %d(%s)", funcName, getRegisterName(rt), aux, getRegisterName(rs));
			break;
	}
	printf("\n");
}

char* getRegisterName(int reg){ // Retorna uma String com o nome do registrador, utilizando seu numero como base.
	char *registradores[32];
	int i;
	registradores[0] = (char*) calloc(5, sizeof(char));
	for(i = 1; i < 32; i++){
		registradores[i] = (char*) calloc(3, sizeof(char));
	}
	registradores[0] = "$zero";
	registradores[1] = "$at";
	registradores[2] = "$v0";
	registradores[3] = "$v1";
	registradores[4] = "$a0";
	registradores[5] = "$a1";
	registradores[6] = "$a2";
	registradores[7] = "$a3";
	registradores[8] = "$t0";
	registradores[9] = "$t1"; 
	registradores[10] = "$t2";
	registradores[11] = "$t3";
	registradores[12] = "$t4";
	registradores[13] = "$t5";
	registradores[14] = "$t6";
	registradores[15] = "$t7";
	registradores[16] = "$s0";
	registradores[17] = "$s1";
	registradores[18] = "$s2";
	registradores[19] = "$s3";
	registradores[20] = "$s4";
	registradores[21] = "$s5";
	registradores[22] = "$s6";
	registradores[23] = "$s7";
	registradores[24] = "$t0";
	registradores[25] = "$t0";
	registradores[26] = "$k0";
	registradores[27] = "$k1";
	registradores[28] = "$gp";
	registradores[29] = "$sp";
	registradores[30] = "$fp";
	registradores[31] = "$ra";
	return registradores[reg];
}