/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Library;

import java.io.File;

/**
 *
 * @author Owner
 */
public class Consts {
    public static int SIZE = 50;
    public static int COUNT = 17;
    public static int DELAY = 2000;
    public static String PATH = File.separator+"imgs"+File.separator;
    public static enum DIRECTION {UP, DOWN, LEFT, RIGHT};
    public static enum KEYS {KUP, KDOWN, KLEFT, KRIGHT, KBOMBA, KENTER};
}
