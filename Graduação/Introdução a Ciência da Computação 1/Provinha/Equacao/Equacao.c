#include "Equacao.h"
#include <math.h>

int equacao(int a, int b, int c) {
    if(a == 0)
        return -1;
    int delta = pow(b, 2) - (4 * a * c);
    if(delta > 0)
        return 2;
    if(delta == 0)
        return 1;
    if(delta < 0)
        return 0;
}
