/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Model;

import Controller.Configuracoes;
import Controller.Fim;
import Controller.Fase;
import Controller.Tela;
import Controller.Inicio;
import Library.Configuracao;
import Library.Consts;
import Library.Consts.KEYS;
import Library.Posicao;
import Library.Save;
import java.awt.Canvas;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics2D;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.image.BufferStrategy;
import java.io.IOException;
import java.util.ArrayList;
import javax.swing.*;
import Library.GZIP;
import Library.Mapa;
import Library.PopupBomber;
import Library.SpriteLoader;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.io.File;

/**
 *
 * @author Owner
 */
public class Jogo extends Canvas{
    private BufferStrategy bufferS;
    private boolean gameRunning = true;
    public boolean hasSave = false;
    public boolean hasConfig = false;
    private Graphics2D g;
    private ArrayList<Tela> telas = new ArrayList();
    private Tela tela;
    public Bomberman bomber;
    public Save save;
    public Configuracao config;
    private boolean upKey = false;
    private boolean downKey = false;
    private boolean leftKey = false;
    private boolean rightKey = false;
    private boolean bombaKey = false;
    private boolean enterKey = false;
    private boolean pauseKey = false;
    private boolean pause = false;
    private boolean telaPause = false;
    private int fase = 1;
    public int autoSaveDelay = 20000;
    public int vidasIniciais = 3;
    private boolean ganhou = false;
    private boolean comecou = false;
    private boolean editandoAutoSave = false;
    private boolean editouAutoSave = false;
    private AutoSave autoSave;
    private File savefile, configfile;
    private Sprite botaoSairFundo, jogoPausadoTitulo, setaPause, info_campo, intervaloAutoSave, incrementaAutoSave, decrementaAutoSave, salvarJogoPause, voltarAoJogo;
    private int setaPauseY;
    Jogo self;
    
    public Jogo() throws IOException{
        
        JFrame tela = new JFrame("Bomberman");
        
        JPanel painel = (JPanel) tela.getContentPane();
        painel.setPreferredSize(new Dimension(840,590));
        painel.setLayout(null);
        
        setBounds(0,0,850,600);
        painel.add(this);
	
        setIgnoreRepaint(true);
        
        tela.pack();
        tela.setResizable(false);
        tela.setVisible(true);
        
        tela.addWindowListener(new WindowAdapter(){
            @Override
            public void windowClosing(WindowEvent e){
                System.exit(0);
            }
        });
        
        addKeyListener(new KeyInputHandler());
        addMouseListener(new MouseInputHandler());
        requestFocus();
        
        createBufferStrategy(2);
        bufferS = getBufferStrategy();
        
        g = (Graphics2D) bufferS.getDrawGraphics();
        telas.add((Tela) new Inicio(this, g));
        telas.add((Tela) new Fim(this, g));
        telas.add((Tela) new Configuracoes(this, g));
        for(int i = 0; i < 5; i++){
            telas.add((Tela) new Fase(this, g,i));
        }
        this.tela = telas.get(0);
        
        save = new Save(1, this.vidasIniciais, 1);
        save.setPosicao(new Posicao(1,1));
        
        autoSave = new AutoSave(this);
        
        config = new Configuracao(this.autoSaveDelay, this.vidasIniciais);
        
        savefile = new File("Save.dat");
        configfile = new File("Config.dat");
        if(savefile.exists())
            this.hasSave = true;
        if(configfile.exists()){
            this.hasConfig = true;
            CarregaConfiguracao();
        }
        
        self = this;
        
        botaoSairFundo = SpriteLoader.get().getSprite("sairPause.png");
        jogoPausadoTitulo = SpriteLoader.get().getSprite("jogoPausadoTitulo.png");
        setaPause = SpriteLoader.get().getSprite("setaPause.png");
        info_campo = SpriteLoader.get().getSprite("info_campo.png");
        intervaloAutoSave = SpriteLoader.get().getSprite("intervaloAutoSave.png");
        incrementaAutoSave = SpriteLoader.get().getSprite("incrementaAutoSave.png");
        decrementaAutoSave = SpriteLoader.get().getSprite("decrementaAutoSave.png");
        salvarJogoPause = SpriteLoader.get().getSprite("salvarJogoPause.png");
        voltarAoJogo = SpriteLoader.get().getSprite("voltarAoJogo.png");
        setaPauseY = 210;
    }
    
    public void ComecarJogo(){
        tela = telas.get(2+fase);
        bomber = new Bomberman("miniBomber.png", new Posicao(1,1), this, this.vidasIniciais);
        comecou = true;
        Salvar();
        if(!autoSave.isAlive())
            autoSave.start();
    }
    
    public void CarregaJogo(){
        save = (Save) GZIP.loadGZipObject("Save.dat");
        System.out.println(save.toString());
        this.fase = save.getFase();
        this.tela = telas.get(2+fase);
        Fase tempFase = (Fase) this.tela;
        tempFase.setMapa(save.getMapa());
        tempFase.recomecar();
        bomber = new Bomberman("miniBomber.png", new Posicao(save.getPosicao().getLinha(),save.getPosicao().getColuna()), this, this.vidasIniciais);
        bomber.setVidas(save.getVidas());
        autoSave.start();
    }
    
    public void Configuracoes(){
        tela = telas.get(2);
    }
    
    public void voltarInicio(){
        tela = telas.get(0);
    }
    
    public void loopPrincipal() {
        while(gameRunning){
            this.update();
            try { Thread.sleep(1); } catch (Exception e) {e.printStackTrace();}
        }
    }
    
    private void update(){
        int i,j;
        long ultimoLoop = System.currentTimeMillis();
        long delta = System.currentTimeMillis() - ultimoLoop;
        ultimoLoop = System.currentTimeMillis();

        Graphics2D g = (Graphics2D) bufferS.getDrawGraphics();
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, 850, 600);
        
        if(!this.pause)
            tela.logic();
        tela.update();

        if(this.pause && this.telaPause)
            desenhaTelaPause();
        
        g.dispose();
        bufferS.show();

        if(leftKey && (!rightKey)){
            leftKey = false;
            if(this.pause)
                pauseKeyEventHandle(KEYS.KLEFT);
            else
                tela.keyeventhandle(KEYS.KLEFT);
        }
        if(rightKey && (!leftKey)){
            rightKey = false;
            if(this.pause)
                pauseKeyEventHandle(KEYS.KRIGHT);
            else
                tela.keyeventhandle(KEYS.KRIGHT);
        }
        if(upKey && (!downKey)){
            upKey = false;
            if(this.pause)
                pauseKeyEventHandle(KEYS.KUP);
            else
                tela.keyeventhandle(KEYS.KUP);
        }
        if(downKey && (!upKey)){
            downKey = false;
            if(this.pause)
                pauseKeyEventHandle(KEYS.KDOWN);
            else
                tela.keyeventhandle(KEYS.KDOWN);
        }
        if(bombaKey){
            bombaKey = false;
            if(this.pause)
                pauseKeyEventHandle(KEYS.KBOMBA);
            else
                tela.keyeventhandle(KEYS.KBOMBA);
        }
        if(enterKey){
            enterKey = false;
            if(this.pause)
                pauseKeyEventHandle(KEYS.KENTER);
            else
                tela.keyeventhandle(KEYS.KENTER);
        }
        if(pauseKey){
            pauseKey = false;
            if(this.pause)
                Continuar();
            else
                Pausar(true);
        }
    }
    
    private class KeyInputHandler extends KeyAdapter {
        
        @Override
        public void keyPressed(KeyEvent e){
            if(e.getKeyCode() == KeyEvent.VK_LEFT){
                leftKey = true;
            }
            if(e.getKeyCode() == KeyEvent.VK_RIGHT){
                rightKey = true;
            }
            if(e.getKeyCode() == KeyEvent.VK_UP){
                upKey = true;
            }
            if(e.getKeyCode() == KeyEvent.VK_DOWN){
                downKey = true;
            }
            if(e.getKeyCode() == KeyEvent.VK_SPACE){
                bombaKey = true;
            }
            if(e.getKeyCode() == KeyEvent.VK_ENTER){
                enterKey = true;
            }
            if(e.getKeyCode() == KeyEvent.VK_P && self.comecou)
                pauseKey = true;
            
            update();
            
        }
        @Override
        public void keyReleased(KeyEvent e){
            
            if(e.getKeyCode() == KeyEvent.VK_LEFT){
                leftKey = false;
            }
            if(e.getKeyCode() == KeyEvent.VK_RIGHT){
                rightKey = false;
            }
            if(e.getKeyCode() == KeyEvent.VK_UP){
                upKey = false;
            }
            if(e.getKeyCode() == KeyEvent.VK_DOWN){
                downKey = false;
            }
            if(e.getKeyCode() == KeyEvent.VK_SPACE){
                bombaKey = false;
            }
            if(e.getKeyCode() == KeyEvent.VK_ENTER){
                enterKey = false;
            }
            update();
        }
    }
    
    private class MouseInputHandler implements MouseListener{

        @Override
        public void mouseClicked(MouseEvent e) {
        }

        @Override
        public void mousePressed(MouseEvent e) {
            if(SwingUtilities.isRightMouseButton(e)){
                if(self.comecou)
                    abrePopup(e);
            }
        }

        @Override
        public void mouseReleased(MouseEvent e) {
        }

        @Override
        public void mouseEntered(MouseEvent e) {
        }

        @Override
        public void mouseExited(MouseEvent e) {
        }
        
        private void abrePopup(MouseEvent e){
            self.Pausar(false);
            int x = e.getX(), y = e.getY(), linha, coluna, id;
            linha = (int) Math.floor(y / Consts.SIZE);
            coluna = (int) Math.floor(x / Consts.SIZE);
            Posicao pos = new Posicao(linha, coluna);
            if(self.bomber.getPosicao().igual(pos))
                id = 10;
            else if(self.checkBombaPos(pos))
                id = 11;
            else if(self.checkFogoPos(pos))
                id = 12;
            else{
                Fase tf = (Fase) self.tela;
                tf.atualizaMapa();
                Mapa tm = tf.getMapa();
                id = tm.getElementoId(pos);
            }
            PopupBomber menu = new PopupBomber(self, id);
            menu.show(self, x, y);
        }
        
    }
    
    public Tela getTela(){
        return this.tela;
    }
    
    public Bomberman getBomberman(){
        return this.bomber;
    }
    
    public void GameOver(){
        this.tela = telas.get(1);
    }
    public void ProximaFase(){
        this.fase++;
        this.tela = telas.get(2+fase);
        this.bomber.SetPosicao(1, 1);
        this.bomber.setVidas(this.vidasIniciais);
    }
    public boolean getGanhou(){
        return this.ganhou;
    }
    
    public void Salvar(){
        save.setFase(this.fase);
        Fase tf = (Fase) this.tela;
        tf.atualizaMapa();
        save.setMapa(tf.getMapa());
        save.setPosicao(bomber.getPosicao());
        save.setVidas(bomber.getVidas());
        System.out.println("Salvando...");
        GZIP.saveGZipObject(save, "Save.dat");
        System.out.println("Salvo");
    }
    
    public void MudarImagem(File imagem, int id){
        if(!imagem.exists() || !imagem.isFile()) //Para evitar operaçoes for inuteis
            return;
        Fase tf = (Fase) tela;
        ArrayList<Bloco> lb = tf.getBlocos();
        ArrayList<Inimigo> li = tf.getInimigos();
        ArrayList<Bomba> lbb = tf.getBombas();
        ArrayList<Fogo> lf = tf.getFogos();
        int j;
        Bloco b;
        Inimigo i;
        Bomba bb;
        Fogo f;
        switch(id){
            case 1:
                for(j = 0; j < lb.size(); j++){
                    b = lb.get(j);
                    if(b.getInd()){
                        b.setSprite(imagem);
                    }
                }
                break;
            case 2:
                for(j = 0; j < lb.size(); j++){
                    b = lb.get(j);
                    if(!b.getInd()){
                        b.setSprite(imagem);
                    }
                }
                break;
            case 3:
                for(j = 0; j < li.size(); j++){
                    i = li.get(j);
                    i.setSprite(imagem);
                }
                break;
            case 10:
                bomber.setSprite(imagem);
                break;
            case 11:
                for(j = 0; j < lbb.size(); j++){
                    bb = lbb.get(j);
                    bb.setSprite(imagem);
                }
                break;
            case 12:
                for(j = 0; j < lf.size(); j++){
                    f = lf.get(j);
                    f.setSprite(imagem);
                }
                break;
        }
        Continuar();
    }
    
    public boolean checkBombaPos(Posicao pos){
        Fase tf = (Fase) tela;
        ArrayList<Bomba> lbb = tf.getBombas();
        Bomba bb;
        int i;
        for(i = 0; i < lbb.size(); i++){
            bb = lbb.get(i);
            if(bb.getPosicao().igual(pos)){
                return true;
            }
        }
        return false;
    }
    
    public boolean checkFogoPos(Posicao pos){
        Fase tf = (Fase) tela;
        ArrayList<Fogo> lf = tf.getFogos();
        Fogo f;
        int i;
        for(i = 0; i < lf.size(); i++){
            f = lf.get(i);
            if(f.getPosicao().igual(pos)){
                return true;
            }
        }
        return false;
    }
    
    public void Continuar(){
        this.pause = false;
        this.telaPause = false;
        update();
    }
    
    public void Pausar(boolean mostraTela){
        this.pause = true;
        this.telaPause = mostraTela;
    }
    
    public void desenhaTelaPause(){
        Color c = new Color(0.0f, 0.0f, 0.0f, 0.6f);
        g.setColor(c);
        g.fillRect(0, 0, 850, 600);
        botaoSairFundo.draw(g, 325, 500);
        jogoPausadoTitulo.draw(g, 200, 30);
        setaPause.draw(g, 180, setaPauseY);
        g.setColor(Color.WHITE);
        if(editandoAutoSave){
            g.setColor(Color.BLACK);
            incrementaAutoSave.draw(g, 550, 305);
            decrementaAutoSave.draw(g, 460, 305);
        }
        g.drawString(""+(autoSaveDelay/1000), 500, 330);
        voltarAoJogo.draw(g, 220, 200);
        salvarJogoPause.draw(g, 220, 400);
        intervaloAutoSave.draw(g, 200, 300);
        info_campo.draw(g, 210, 340);
    }
    
    public void pauseKeyEventHandle(KEYS k){
        switch(k){
            case KUP:
                if(!editandoAutoSave){
                    setaPauseY = setaPauseY > 210 ? setaPauseY - 100 : 510;
                }
                break;
            case KDOWN:
                if(!editandoAutoSave){
                    setaPauseY = setaPauseY < 510 ? setaPauseY + 100 : 210;
                }
                break;
            case KLEFT:
                if(editandoAutoSave){
                    if(autoSaveDelay > 10000)
                        autoSaveDelay -= 1000;
                }
                break;
            case KRIGHT:
                if(editandoAutoSave){
                    if(autoSaveDelay < 120000)
                        autoSaveDelay += 1000;
                }
                break;
            case KENTER:
                if(setaPauseY == 210){
                    Continuar();
                }
                if(setaPauseY == 310){
                    if(editandoAutoSave){
                        editandoAutoSave = false;
                        SalvaConfiguracao();
                    }else{
                        editandoAutoSave = true;
                    }
                }
                if(setaPauseY == 410){
                    Salvar();
                    Continuar();
                }
                if(setaPauseY == 510){
                    System.exit(0);
                }
                break;
        }
    }
    
    public void CarregaConfiguracao(){
        config = (Configuracao) GZIP.loadGZipObject("Config.dat");
        this.autoSaveDelay = config.autoSaveDelay;
        this.vidasIniciais = config.vidasIniciais;
    }
    
    public void SalvaConfiguracao(){
        config.autoSaveDelay = this.autoSaveDelay;
        config.vidasIniciais = this.vidasIniciais;
        GZIP.saveGZipObject(config, "Config.dat");
    }
	
}