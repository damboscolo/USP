/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Library;

import Model.Sprite;
import java.awt.GraphicsConfiguration;
import java.awt.GraphicsEnvironment;
import java.awt.Image;
import java.awt.Transparency;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import javax.imageio.ImageIO;

/**
 *
 * @author Owner
 */
public class SpriteLoader {
    
    private static SpriteLoader single = new SpriteLoader();
    
    public static SpriteLoader get(){
        return single;
    }
    
    private HashMap sprites = new HashMap();
    
    public Sprite getSprite(String ref){
        if(sprites.get(ref)!=null)
            return (Sprite) sprites.get(ref);
        
        BufferedImage source = null;
        
        try{
            URL url = this.getClass().getClassLoader().getResource(ref);
            if(url==null)
                mostraErro("Nao encontrou: "+ref);
            source = ImageIO.read(url);            
        }catch(IOException e){
            mostraErro("Falho ao carregar: "+ref);
        }
        
        GraphicsConfiguration gc = GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice().getDefaultConfiguration();
        Image imagem = gc.createCompatibleImage(source.getWidth(), source.getHeight(), Transparency.BITMASK);
        imagem.getGraphics().drawImage(source, 0, 0, null);
        
        Sprite sprite = new Sprite(imagem);
        sprites.put(ref, sprite);
        
        return sprite;
    }
    
    private void mostraErro(String mensagem){
        System.err.println(mensagem);
        System.exit(0);
    }
}