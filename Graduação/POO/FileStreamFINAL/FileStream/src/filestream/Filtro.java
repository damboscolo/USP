/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package filestream;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Daniele
 */
public class Filtro implements FilenameFilter {

    @Override
    public boolean accept(File file, String name) {
        try {
            if (name.endsWith(".exe") || new File(file.getCanonicalFile() + "\\" + name).isDirectory()) {
                return true;
            } else {
                return false;
            }
        } catch (IOException ex) {
            return false;
        }
    }
}
