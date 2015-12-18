/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Library;

import Model.Jogo;
import java.awt.event.ActionEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.io.File;
import javax.swing.JFileChooser;
import javax.swing.JMenuItem;
import javax.swing.JPopupMenu;

/**
 *
 * @author Owner
 */
public class PopupBomber extends JPopupMenu{
    
    JMenuItem mudaImagem;
    JFileChooser escolherImagem;
    Jogo jogo;
    int id;
    
    public PopupBomber(Jogo jogo, int id){
        this.jogo = jogo;
        this.id = id;
        mudaImagem = new JMenuItem("Mudar Imagem");
        mudaImagem.addMouseListener(new MouseHandler());
        escolherImagem = new JFileChooser();
        escolherImagem.setCurrentDirectory(new File(System.getProperty("user.dir")+"/imgs/"));
        escolherImagem.setFileFilter(new FiltroImagem());
        add(mudaImagem);
    }
    
    public class MouseHandler implements MouseListener{

        @Override
        public void mouseClicked(MouseEvent e) {
        }

        @Override
        public void mousePressed(MouseEvent e) {
            EscolherImagem(e);
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
        
        private void EscolherImagem(MouseEvent e){
            int returnVal = escolherImagem.showOpenDialog(jogo);
            if(returnVal == JFileChooser.APPROVE_OPTION){
                File imagem = escolherImagem.getSelectedFile();
                jogo.MudarImagem(imagem, id);
            }else
                jogo.Continuar();
        }
        
    }
}
