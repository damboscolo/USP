/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Library;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;

/**
 *
 * @author Owner
 */
public class GZIP {  
    
    public static void saveGZipObject(Object vlo, String fileName) {
	FileOutputStream fos = null;
	GZIPOutputStream gos = null;
	ObjectOutputStream oos = null;
	try {
            fos = new FileOutputStream(fileName);
            gos = new GZIPOutputStream(fos);
            oos = new ObjectOutputStream(gos);
            oos.writeObject(vlo);
            oos.flush();
            oos.close();
            gos.close();
            fos.close();
	} catch(IOException ioe) {
            ioe.printStackTrace();
	}
    }
        
    public static Object loadGZipObject(String fileName) {
	Object obj = null;
	FileInputStream fis = null;
	GZIPInputStream gis = null;
	ObjectInputStream ois = null;
	try {
            fis = new FileInputStream(fileName);
            gis = new GZIPInputStream(fis);
            ois = new ObjectInputStream(gis);
            obj = ois.readObject();
            ois.close();
            gis.close();
            fis.close();
	} catch(IOException ioe) {
            ioe.printStackTrace();
	} catch(ClassNotFoundException cnfe) {
            cnfe.printStackTrace();
	}
	return obj;
    }
}
