/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Library;

import java.io.File;
import javax.swing.filechooser.FileFilter;

/**
 *
 * @author Owner
 */
public class FiltroImagem extends FileFilter{

    @Override
    public boolean accept(File f) {
        if(f.exists() && (f.isDirectory() || (f.isFile() && (f.getName().endsWith(".gif") || f.getName().endsWith(".png") || f.getName().endsWith(".jpg")))))
            return true;
        return false;
    }

    @Override
    public String getDescription() {
        return "Imagens (JPG, GIF, PNG)";
    }
    
}
