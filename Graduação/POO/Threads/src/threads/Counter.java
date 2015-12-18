package threads;

/**
 *
 * @author Junio
 */
class Counter {
    private int iContador = 0;
    public int getContador() {
        return iContador;
    }
    
    /*count como um método sincronizado é suficiente para que a concorrência seja resolvida*/
    public void fazerContagem() {
        /*Cada vez que uma thread retoma a contagem,
         usa um valor de i menor do que possuia quando foi interrompida,
         pois outra thread começou a contar depois, fazendo a contagem voltar atrás*/
        for (int j = 0; j < 10000; j++) /*Aqui o valor máximo da contagem varia de processador para processador, quanto mais rápido, maior deve ser o número*/
            iContador++;
    }
}