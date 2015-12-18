#include "Fatorial.h"

int fatorial(int n) {
    if(n == 0 || n  == 1)
        return 1;
    else if(n > 0)
        return n * fatorial(n-1);
    else
        return -1;
	return 0;
}
