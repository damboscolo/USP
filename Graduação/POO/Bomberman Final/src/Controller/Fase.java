/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Controller;

import Library.Consts;
import Library.Mapa;
import Library.Posicao;
import Library.SpriteLoader;
import Model.Bloco;
import Model.Bomba;
import Model.Fogo;
import Model.Inimigo;
import Model.Jogo;
import Model.Sprite;
import View.Mapas;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Owner
 */
public class Fase extends Tela{
    
    private int fase;
    private ArrayList<Bloco> listBlocos;
    private ArrayList<Bomba> listBombas;
    private ArrayList<Fogo> listFogos;
    private ArrayList<Inimigo> listInimigos;
    private Sprite bomber;
    private Mapa mapa;
    
    public Fase(Jogo jogo, Graphics2D g, int fase) throws IOException{
        super(jogo, g);
        this.fase = fase;
        this.mapa = new Mapa(Mapas.MAPAS[fase]);
        this.listBlocos = new ArrayList();
        this.listBombas = new ArrayList();
        this.listFogos = new ArrayList();
        this.listInimigos = new ArrayList();
        this.bomber = SpriteLoader.get().getSprite("life.png");
        analisaMapa();
    }

    @Override
    public void logic() {
        int i, j;
        Bomba tempBomba;
        Fogo tempFogo;
        Inimigo inimigoTemp;
        if(!listBombas.isEmpty()){
            for(i = 0; i < listBombas.size(); i++){
                try{
                    tempBomba = listBombas.get(i);
                    if(!tempBomba.getExplodiu()){
                        tempBomba.Contagem(System.currentTimeMillis());
                    }else{
                        try {
                            criaFogo(tempBomba);
                            listBombas.remove(i);
                        } catch (IOException ex) {
                            Logger.getLogger(Fase.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        }
        if(!listFogos.isEmpty()){
            for(i = 0; i < listFogos.size(); i++){
                tempFogo = listFogos.get(i);
                if(tempFogo.getPosicao().igual(jogo.bomber.getPosicao())){
                    listFogos.remove(i);
                    jogo.bomber.Morre();
                }
                if(tempFogo.getApagou()){
                        for(j = 0; j < listBlocos.size(); j++){
                            if(listBlocos.get(j).getPosicao().igual(tempFogo.getPosicao()))
                                listBlocos.remove(j);
                        }
                        for(j = 0; j < listInimigos.size(); j++){
                            if(listInimigos.get(j).getPosicao().igual(tempFogo.getPosicao()))
                                listInimigos.remove(j);
                        }
                        listFogos.remove(i);
                }else{
                    tempFogo.Contagem(System.currentTimeMillis());
                }
            }
        }
        if(!listInimigos.isEmpty()){
            for(i = 0; i < listInimigos.size(); i++){
                try{
                    inimigoTemp = listInimigos.get(i);
                    if(inimigoTemp.getPosicao().igual(jogo.getBomberman().getPosicao()))
                        jogo.getBomberman().Morre();
                }catch(Exception e){
                    e.printStackTrace();
                }
            }
        }else{
            jogo.ProximaFase();
        }
        if(jogo.getBomberman() != null && jogo.getBomberman().getVidas() <= 0){
            jogo.GameOver();
        }
        
        delta = System.currentTimeMillis() - lastTime;
        if(delta > 300){
            lastTime = System.currentTimeMillis();
            for(i = 0; i < listInimigos.size(); i++){
                inimigoTemp = listInimigos.get(i);
                inimigoTemp.DecideAndar();
                if(inimigoTemp.getAndar())
                    inimigoTemp.Move(inimigoTemp.getDirection());
            }
        }
    }

    @Override
    public void update() {
        g.setColor(Color.GREEN);
        g.fillRect(0, 0, 860, 600);
        g.setColor(Color.white);
        g.fillRect(0, 550, 860, 50);
        int i, j;
        for(i = 0; i < listBlocos.size(); i++){
            listBlocos.get(i).desenha(g);
        }
        for(i = 0; i < listBombas.size(); i++){
            listBombas.get(i).desenha(g);
        }
        for(i = 0; i < listFogos.size(); i++){
            listFogos.get(i).desenha(g);
        }
        for(i = 0; i < listInimigos.size(); i++){
            listInimigos.get(i).desenha(g);
        }
        jogo.bomber.desenha(g);
        g.setColor(Color.BLACK);
        g.setFont(new Font("Verdana", Font.BOLD, 26));
        g.drawString("Vidas:", 20, 580);
        for(i = 0; i < jogo.bomber.getVidas(); i++){
            bomber.draw(g, 120+(i*25), 560);
        }
    }

    @Override
    public void keyeventhandle(Consts.KEYS key) {
        Bomba tempBomba;
        switch(key){
            case KUP:
                jogo.bomber.Move(Consts.DIRECTION.UP);
                break;
            case KDOWN:
                jogo.bomber.Move(Consts.DIRECTION.DOWN);
                break;
            case KRIGHT:
                jogo.bomber.Move(Consts.DIRECTION.RIGHT);
                break;
            case KLEFT:
                jogo.bomber.Move(Consts.DIRECTION.LEFT);
                break;
            case KBOMBA:
                    try {
                        tempBomba = new Bomba("bomba.png", new Posicao(0,0), 2, 2, true);
                        tempBomba.SetPosicao(jogo.bomber.getPosicao().getLinha(), jogo.bomber.getPosicao().getColuna());
                        listBombas.add(tempBomba);
                    } catch (IOException ex) {
                        Logger.getLogger(Fase.class.getName()).log(Level.SEVERE, null, ex);
                    }
                break;
        }
    }
    
    
    public void criaFogo(Bomba bomba) throws IOException{
        int i;
        Posicao p = bomba.getPosicao();
        int linha, coluna;
        linha = p.getLinha();
        coluna = p.getColuna();
        listFogos.add(new Fogo("fogo.png", new Posicao(linha, coluna), 300));
        boolean stoptop = false, stopbottom = false, stopleft = false, stopright = false;
        for(i = 1; i <= bomba.getRange(); i++){
            if(linha+(i*1) < 11 && mapa.getElementoId(linha+(i*1), coluna) != 1 && !stopbottom){
                if(mapa.getElementoId(linha+(i*1), coluna) == 2)
                    stopbottom = true;
                listFogos.add(new Fogo("fogo.png", new Posicao(linha+(i*1), coluna), 300));
            }else
                stopbottom = true;
            if(linha-(i*1) > 0 && mapa.getElementoId(linha-(i*1), coluna) != 1 && !stoptop){
                if(mapa.getElementoId(linha-(i*1), coluna) == 2)
                    stoptop = true;
                listFogos.add(new Fogo("fogo.png", new Posicao(linha-(i*1), coluna), 300));
            }else
                stoptop = true;
            if(coluna+(i*1) < 16 && mapa.getElementoId(linha, coluna+(i*1)) != 1 && !stopright){
                if(mapa.getElementoId(linha, coluna+(i*1)) == 2)
                    stopright = true;
                listFogos.add(new Fogo("fogo.png", new Posicao(linha, coluna+(i*1)), 300));
            }else
                stopright = true;
            if(coluna-(i*1) > 0 && mapa.getElementoId(linha, coluna-(i*1)) != 1 && !stopleft){
                if(mapa.getElementoId(linha, coluna-(i*1)) == 2)
                    stopleft = true;
                listFogos.add(new Fogo("fogo.png", new Posicao(linha, coluna-(i*1)), 300));
            }else
                stopleft = true;
        }
        
    }
    
    public void analisaMapa(){
        int i,j;
        for(i = 0; i < mapa.getMapaLinhas(); i++){
            for(j = 0; j < mapa.getMapaColunas(); j++){
                switch(mapa.getElementoId(i, j)){
                    case 1:
                        listBlocos.add(new Bloco("blocoindestrutivel.png", new Posicao(i,j), true));
                        break;
                    case 2:
                        listBlocos.add(new Bloco("bloco.png", new Posicao(i,j), false));
                        break;
                    case 3:
                        listInimigos.add(new Inimigo("inimigo.png", new Posicao(i,j), jogo));
                        break;
                }
            }
        }
    }
    
    public ArrayList<Bloco> getBlocos(){
        return listBlocos;
    }
    public ArrayList<Bomba> getBombas(){
        return listBombas;
    }
    public ArrayList<Fogo> getFogos(){
        return listFogos;
    }
    public ArrayList<Inimigo> getInimigos(){
        return listInimigos;
    }
    
    public void recomecar(){
        for(int i = listBlocos.size()-1; i >= 0; i--){
            listBlocos.remove(i);
        }
        for(int i = listInimigos.size()-1; i >= 0; i--){
            listInimigos.remove(i);
        }
        analisaMapa();
    }
    
    public void setMapa(Mapa mapa){
        this.mapa = mapa;
    }
    
    public Mapa getMapa(){
        return this.mapa;
    }
    
    public void atualizaMapa(){
        for(int i = 0; i < this.mapa.getMapaLinhas(); i++){
            for(int j = 0; j < this.mapa.getMapaColunas(); j++){
                int elm = this.mapa.getElementoId(i, j);
                if(elm == 2 || elm == 3)
                    this.mapa.setElementoId(i, j, 0);
            }
        }
        Bloco tb;
        Inimigo ti;
        for(int i = 0; i < listBlocos.size(); i++){
            tb = (Bloco) listBlocos.get(i);
            if(!tb.getInd())
                this.mapa.setElementoId(tb.getPosicao(), 2);
        }
        for(int i = 0; i < listInimigos.size(); i++){
            ti = (Inimigo) listInimigos.get(i);
            this.mapa.setElementoId(ti.getPosicao(), 3);
        }
    }
}
