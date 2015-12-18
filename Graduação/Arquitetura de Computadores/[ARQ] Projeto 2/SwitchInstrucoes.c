 #include <stdio.h>

 int main(){
	unsigned int inst;

	printf("Insert the instruction:\n");
	scanf("%x", &inst);

	printf("Instrução Assembly: ");
	switch(inst){
		case 0x0:	//Check function field
			switch(function){
				case 20:    //ADD (add)
                    printf("add");
				break;

				case 22:    //SUB (sub)
                    printf("sub");
				break;

				case 24:    //AND (and)

				break;

				case 25:    //OR (or)

				break;

				case 2A:    //Set Less Than (slt)

				break;

				default:
					printf("Instrução inválida.\n");
				break;
			}
		break;

		case 0x1:   //Branch if Less Than And Link (bltzal)

		break;

		case 0x2:	//Jump (j)

		break;

		case 0x3:   //Jump And Link (jal)

		break;

		case 0x4:   //Branch if Equal (beq)

		break;

		case 0x5:   //Branch if Not Equal (bnq)

		break;

		case 0x20:  //Load Byte (lb)

		break;

		case 0x23:  //Load Word (lw)

		break;

		case 0x28:  //Store Byte (sb)

		break;

		case 0x2B:  //Store Word (sw)

		break;

		default:
			printf("Instrução inválida.\n");
		break;
	}

	return 0;
 }
