/*
Eduardo Sigrist Ciciliato nº USP 7986542
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define pontos 4

double f(double[], double, int);

int main(){
	
	int i, j, n;
	double resultado[5], F[4][4], X[4], p;

	scanf("%d", &n);
	double fx[n];

	for(i = 0; i < n; i++){
		for(j = 0; j < n; j++){
			F[i][j] = 0.0f;
		}
	}

	for(i = 0; i < n; i++){
		scanf("%lf", &fx[i])
	}
	scanf("%lf", &p);

	X[0] = p - 2;
	X[1] = p - 1;
	X[2] = p + 1;
	X[3] = p + 2;

	for(i = 0; i < pontos; i++){
		F[i][0] = f(fx, X[i], n);
	}

	for(i = 0; i < pontos; i++){
		for(j = 0; j < pontos; j++){
			F[i][j] = ( ( F[i][j-1] - F[i-1][j-1] ) / ( X[i] - X[i-j] ) );
		}
	}

	for(i = 0; i < pontos; i++){
		printf("%.4f", X[i]);
		for(j = 0; j < pontos; j++){
			printf("%.4f", F[i][j]);
		}
		printf("\n");
	}



	printf("P1(x) = %.4f + (%.4f)(x-(%.4f))",F[1][0],F[2][1],X[1]);
	printf("\nP2(x) = %.4f + (%.4f)(x-(%.4f)) + (%.4f)(x-(%.4f))(x-(%.4f))",F[0][0],F[1][1],X[0],F[2][2],X[0],X[1]);
	printf("\nP3(x) = %.4f + (%.4f)(x-(%.4f)) + (%.4f)(x-(%.4f))(x-(%.4f))",F[1][0],F[2][1],X[1],F[3][2],X[1],X[2]);
	printf("\nP4(x) = %.4f + (%.4f)(x-(%.4f)) + (%.4f)(x-(%.4f))(x-(%.4f)) + ((%.4f))(x-(%.4f))(x-(%.4f))(x-(%.4f))\n",F[0][0],F[1][1],X[0],F[2][2],X[0],X[1], F[3][3], X[0],X[1],X[2]);
	
	resultado[0] = f(fx, p, n);
	resultado[1] = F[1][0] + ((F[2][1])*(p-(X[1])));
	resultado[2] = F[0][0] + ((F[1][1])*(p-(X[0]))) + ((F[2][2])*(p-(X[0]))*(p-(X[1])));
	resultado[3] = F[1][0] + ((F[2][1])*(p-(X[1]))) + ((F[3][2])*(p-(X[1]))*(p-(X[2])));
	resultado[4] = F[0][0] + ((F[1][1])*(p-(X[0]))) + ((F[2][2])*(p-(X[0]))*(p-(X[1]))) + ((F[3][3])*(p-(X[0]))*(p-(X[1]))*(p-(X[2])));
	printf("%.4f %.4f %.4f %.4f %.4f\n", resultado[0], resultado[1], resultado[2], resultado[3], resultado[4]);
	
	return 0;

}

double f(double fx[], double p, int n){
	int i;
	double result = 0;
	for(i=0; i<=n; i++){
		result += pow(p, (double) i ) * fx[i];
	}
	return result;
}