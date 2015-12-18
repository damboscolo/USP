import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumn;
import static oracle.net.aso.C11.i;

public class DBFuncionalidades {
    private static final DBFuncionalidades INSTANCE = new DBFuncionalidades(); 
    
    private DBFuncionalidades() {
    } 
    
    public static DBFuncionalidades getInstance() { 
        return INSTANCE;
    }

    Connection connection;
    Statement stmt;
    ResultSet rs;
    JTextArea jtAreaDeStatus;
    PreparedStatement prepStmt;
    String msg;
    
    String nome;
    String senha;
    String nomeHost;
    String porta;
    String sid;
    
    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    public String getNomeHost() {
        return nomeHost;
    }

    public void setNomeHost(String nomeHost) {
        this.nomeHost = nomeHost;
    }

    public String getPorta() {
        return porta;
    }

    public void setPorta(String porta) {
        this.porta = porta;
    }

    public String getSid() {
        return sid;
    }

    public void setSid(String sid) {
        this.sid = sid;
    }
    
    public String conectar(){  
            
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            connection = DriverManager.getConnection(
                    "jdbc:oracle:thin:@"+this.nomeHost+":"+this.porta+":"+this.sid,//192.168.183.2:1521:orcl1",
                    this.getNome(),
                    this.getSenha());
            System.out.println("Conectado");
            msg = "true";
            return msg;
        } catch (ClassNotFoundException ex) {
            msg = "Erro: verifique o driver do banco de dados.";
        } catch(SQLException ex){
            msg = "Erro: verifique os dados inseridos.";
        }
        return msg;
    }

     public void buscaNomesTabelas(JComboBox jc) {
        String s = "";
        try {
            s = "SELECT table_name FROM user_tables";
            stmt = connection.createStatement();
            rs = stmt.executeQuery(s);
            while (rs.next()) {
                jc.addItem(rs.getString("table_name"));
            }
            stmt.close();
        } catch (SQLException ex) {
            jtAreaDeStatus.setText("Erro na consulta: \"" + s + "\"");
        }
    }
    
    public String[] buscaNomesColunas(String nomeTabela) {
        String dado = "";
        int i = 0;
        
        try {
             String comandoSQL = "SELECT C.COLUMN_NAME FROM USER_TABLES T,USER_TAB_COLUMNS C WHERE  T.TABLE_NAME = C.TABLE_NAME "
                                + " AND T.TABLE_NAME = '" + nomeTabela + "'";
            
            prepStmt = connection.prepareStatement(comandoSQL);
            rs = prepStmt.executeQuery();
            java.sql.ResultSetMetaData rsmd = rs.getMetaData();
            int numCol = 0;
            while(rs.next()){
                numCol++;
            }
            rs = prepStmt.executeQuery();
            String[] colunas = new String[numCol];
            while (rs.next()) {
                dado = rs.getString(1);
                colunas[i] = dado;
                i++;
            }
            return colunas;
        } catch (SQLException ex) {
            Logger.getLogger(jTabelas.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
     public String[] buscaTiposColunas(String nomeTabela, int numCol) {
        try {
            String comandoSQL = "SELECT C.DATA_TYPE FROM USER_TABLES T,USER_TAB_COLUMNS C WHERE  T.TABLE_NAME = C.TABLE_NAME  AND T.TABLE_NAME = '" + nomeTabela + "'";

            prepStmt = connection.prepareStatement(comandoSQL);
            rs = prepStmt.executeQuery();
            
            String tipos[] = new String[numCol];
            int i = 0;
            while (rs.next()) {                
                tipos[i] = rs.getString(1);
                i++;
            }                
            prepStmt.close();
            return tipos;
        } catch (SQLException ex) {
            Logger.getLogger(jTabelas.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    public void buscaDadosDasTabelas(JTable table, String nomeTabela, String comandoSQL,String[] arrayNomeColunas) {
        DefaultTableModel defaultModel = (DefaultTableModel) table.getModel();
        defaultModel.setColumnIdentifiers(arrayNomeColunas);
        table.setPreferredScrollableViewportSize(new Dimension(730, 70));
        table.setFillsViewportHeight(true);
       
        //Limpa tabela para novos valores
        for (int i = table.getRowCount() - 1; i >= 0; i--) {
            defaultModel.removeRow(i);
        }
        
        try {
            prepStmt = connection.prepareStatement(comandoSQL);
            rs = prepStmt.executeQuery();
            java.sql.ResultSetMetaData rsMD = rs.getMetaData();
            
            int numCol = rsMD.getColumnCount();
            defaultModel.setColumnCount(numCol);
            
            Object[] objItems;
            while (rs.next()) {
                objItems = new Object[numCol];
                for (int i = 0; i < numCol; i++) {
                    objItems[i] = rs.getObject(i + 1);
                }
                defaultModel.addRow(objItems);
            }
            table.setModel(defaultModel);
            

            int i = 0;
            String nomeColuna = null;
            ArrayList<String> arrayColunasPK = new ArrayList<String>();
            arrayColunasPK = buscaPks(nomeTabela);
            TableColumn tc;
            while(i < numCol){
                nomeColuna = arrayNomeColunas[i];
                tc = table.getColumn(nomeColuna);
                if(arrayColunasPK.contains(nomeColuna)){
                    tc.setCellRenderer(new PKRenderer());
                }else{
                    tc.setCellRenderer(new CellRenderer());                  
                }
                i++;
            }
            defaultModel.fireTableDataChanged();
            prepStmt.close();
            return;
        } catch (SQLException ex) {
            Logger.getLogger(jTabelas.class.getName()).log(Level.SEVERE, null, ex);
        }
        return;
    }
    
    public void buscaDadosParaStatusArea(JTextArea jtxtArea, String nomeTabela, String[] arrayNomeColunas) {
        try {
            jtxtArea.setText("");
            String comandoSQL = "SELECT C.COLUMN_ID, C.COLUMN_NAME, C.DATA_TYPE, C.DATA_LENGTH, C.DATA_DEFAULT, C.NULLABLE FROM USER_TABLES T,USER_TAB_COLUMNS C WHERE  T.TABLE_NAME = C.TABLE_NAME  AND T.TABLE_NAME = '" + nomeTabela + "'";

            prepStmt = connection.prepareStatement(comandoSQL);
            rs = prepStmt.executeQuery();
            
            while (rs.next()) {
                jtxtArea.append("ID = " + rs.getString(1));
                jtxtArea.append("\tNome = " + rs.getString(2));
                jtxtArea.append("\t\tTipo = " + rs.getString(3));
                jtxtArea.append("\t\tTamanho = " + rs.getString(4));
                jtxtArea.append("\tValor Default = " + rs.getString(5));
                jtxtArea.append("\tNull = " + rs.getString(6));
                jtxtArea.append("\n");
            }                
            prepStmt.close();
            return;
        } catch (SQLException ex) {
            Logger.getLogger(jTabelas.class.getName()).log(Level.SEVERE, null, ex);
            jtxtArea.setText("Erro ao buscar dados.");
        }
        return;
    }
    

    public ArrayList<String> buscaPks(String nometabela){
        ArrayList<String> colunasPK = new ArrayList<String>();
        String comandoSQL = "SELECT cols.table_name, cols.COLUMN_NAME\n" +
                            "FROM user_constraints cons, user_cons_columns cols\n" +
                            "WHERE cols.table_name = '" + nometabela.toUpperCase() + "'\n" +
                            "AND cons.constraint_type = 'P'\n" +
                            "AND cons.constraint_name = cols.constraint_name\n" +
                            "AND cons.owner = cols.owner\n" +
                            "ORDER BY cols.table_name, cols.position";
        try {            
            stmt = connection.createStatement();
            rs = stmt.executeQuery(comandoSQL);
            while (rs.next()) {
                colunasPK.add(rs.getString("COLUMN_NAME"));
            }
            return colunasPK;
        } catch (SQLException ex) {
            jtAreaDeStatus.setText("Erro no comando: " + comandoSQL);
            Logger.getLogger(jTabelas.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
     public ArrayList<String> buscaFks(String nomeTabela){
        ArrayList<String> colunasFK = new ArrayList<>();
        String comandoSQL =    "SELECT DISTINCT ucc.TABLE_NAME AS NOME_TABLE, ucc.COLUMN_NAME AS FK, ucc2.table_name AS FK_TABLE" +
                        " FROM USER_CONS_COLUMNS ucc JOIN USER_CONSTRAINTS uc ON ucc.OWNER = uc.OWNER AND ucc.CONSTRAINT_NAME = uc.CONSTRAINT_NAME" +
                        " JOIN USER_CONSTRAINTS uc_pk ON uc.R_OWNER = uc_pk.OWNER AND uc.CONSTRAINT_NAME = uc_pk.CONSTRAINT_NAME" +
                        " JOIN USER_CONS_COLUMNS ucc2 ON ucc2.CONSTRAINT_NAME = uc.R_CONSTRAINT_NAME "+
                        " WHERE ucc.TABLE_NAME = '" + nomeTabela.toUpperCase() + "'";
        try {            
            stmt = connection.createStatement();
            rs = stmt.executeQuery(comandoSQL);
            while (rs.next()) {
                colunasFK.add(rs.getString("FK"));
            }
            return colunasFK;
        } catch (SQLException ex) {
            jtAreaDeStatus.setText("Erro no comando: " + comandoSQL);
            Logger.getLogger(jTabelas.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }    
     public ArrayList<ArrayList<String>> buscaFKsTabelaOriginal(String nomeTabela){
        ArrayList<ArrayList<String>> array = new  ArrayList();
         ArrayList<String> colunasFKs = new ArrayList<>();
        ArrayList<String> tabelasFKs = new ArrayList<>();
        
        String sql =    "SELECT DISTINCT ucc.TABLE_NAME AS NOME_TABLE, ucc2.COLUMN_NAME AS FK, ucc2.table_name AS FK_TABLE" +
                        " FROM USER_CONS_COLUMNS ucc JOIN USER_CONSTRAINTS uc ON ucc.OWNER = uc.OWNER AND ucc.CONSTRAINT_NAME = uc.CONSTRAINT_NAME" +
                        " JOIN USER_CONSTRAINTS uc_pk ON uc.R_OWNER = uc_pk.OWNER AND uc.CONSTRAINT_NAME = uc_pk.CONSTRAINT_NAME" +
                        " JOIN USER_CONS_COLUMNS ucc2 ON ucc2.CONSTRAINT_NAME = uc.R_CONSTRAINT_NAME "+
                        " WHERE ucc.TABLE_NAME = '" + nomeTabela + "'";
        try {
            stmt = connection.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                tabelasFKs.add(rs.getString("FK_TABLE"));
                colunasFKs.add(rs.getString("FK"));
            }
            array.add(tabelasFKs);
            array.add(colunasFKs);
            return array;
        } catch (SQLException ex) {
            jtAreaDeStatus.setText("Erro no comando: "+sql);
            Logger.getLogger(jTabelas.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
      
    public ArrayList<String> selectFKs(String nomeTabela, String nomeColuna){
        ArrayList<String> colunas = new ArrayList<>();
        String comandoSQL = "SELECT DISTINCT " + nomeColuna + " FROM " + nomeTabela +" ORDER BY " + nomeColuna;
        try {
            stmt = connection.createStatement();
            rs = stmt.executeQuery(comandoSQL);
            while (rs.next()) {
                colunas.add(rs.getString(nomeColuna));
            }            
            return colunas;
        } catch (SQLException ex) {
            jtAreaDeStatus.setText("Erro no comando: " + comandoSQL);
            Logger.getLogger(jTabelas.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    public void criaTxtLabels(final JTextArea jtxtMsg, final JPanel jPanel, final String nomeTabela, final String[] nomesColunas){
        jPanel.removeAll();
        GridLayout gLayout = new GridLayout();
        gLayout.setColumns(2);
        gLayout.setRows(nomesColunas.length+1);
        jPanel.setLayout(gLayout); 
        
        ArrayList<String> arrayNomes = getColunasComContraints(nomeTabela);
        ArrayList<String> arrayColunasFKs = buscaFks(nomeTabela);
        ArrayList<ArrayList<String>> arrayFK = buscaFKsTabelaOriginal(nomeTabela); 
        String[] valoresCheck = getValoresDosChecks(nomeTabela);
        
        ArrayList<String> valoresFks;
        
        int countFK = 0;
        for(int i = 0; i < nomesColunas.length; i++){
            if(arrayNomes.contains(nomesColunas[i])){
                jPanel.add(new JLabel(nomesColunas[i]));
                JComboBox combobox = new JComboBox();
                for(int j = 0; j < valoresCheck.length; j++){
                    combobox.addItem(valoresCheck[j]);
                }
                jPanel.add(combobox);
            }
            else if(arrayColunasFKs.contains(nomesColunas[i])){
                valoresFks = selectFKs(arrayFK.get(0).get(countFK), arrayFK.get(1).get(countFK));
                jPanel.add(new JLabel(nomesColunas[i]));
                JComboBox combobox = new JComboBox();
                for(int j = 0; j < valoresFks.size(); j++){                     
                    combobox.addItem(valoresFks.get(j));
                    jPanel.add(combobox);                    
                }
                countFK++;
            }
            else{
                jPanel.add(new JLabel(nomesColunas[i]));
                jPanel.add(new JTextField(""));
            }            
        }        
        
        JButton jbtnLimpar = new JButton("Limpar");
        jbtnLimpar.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
               JTextField jtf;
               for(int i = 0; i < jPanel.getComponentCount()-2; i++){
                   if(i%2 == 1){
                       if(jPanel.getComponent(i) instanceof JTextField){//se é uma label, limpa
                           jtf = (JTextField) jPanel.getComponent(i); 
                           jtf.setText("");
                       }
                   }                    
                }
            }
        });
        JButton jbtnSalvar = new JButton("Salvar");
        jbtnSalvar.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    inserirDados(jtxtMsg, jPanel, nomeTabela, nomesColunas.length);
                } catch (SQLException ex) {
                    Logger.getLogger(DBFuncionalidades.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        });
        jPanel.add(jbtnLimpar);
        jPanel.add(jbtnSalvar);
    }

    public ArrayList<String> getColunasComContraints(String nomeTabela){//Retorna nomes das colunas que pussuem checks
        String comandoSQL = "SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = '" + nomeTabela + "' AND CONSTRAINT_TYPE = 'C'";
        ArrayList<String> arrayNomeColuna = new ArrayList<String>();
        String busca;
        int index;
        try{
            stmt = connection.createStatement();
            rs = stmt.executeQuery(comandoSQL);
            while (rs.next()) {
                busca = rs.getString("SEARCH_CONDITION");
                if(busca.contains(" IN ")){                    
                    index = busca.lastIndexOf(" IN ");
                    nome = busca.substring(0, index);
                    arrayNomeColuna.add(nome.toUpperCase());
                }
            }
            return arrayNomeColuna;
        } catch (SQLException ex) {
            jtAreaDeStatus.setText("Erro na consulta " + comandoSQL);
            System.err.println(ex.getErrorCode());
        }  
        return null;
    }
    
    public String[] getValoresDosChecks(String nomeTabela){//Retorna os valores dos checks
        String comandoSQL = "SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = '" + nomeTabela + "' AND CONSTRAINT_TYPE = 'C'";
        String busca, valor;
        String[] vetorValor = null;
        ArrayList<String> arrayValores = new ArrayList<String>();
        int index;
        try{
            stmt = connection.createStatement();
            rs = stmt.executeQuery(comandoSQL);
            while (rs.next()) {
                busca = rs.getString("SEARCH_CONDITION");
                if(busca.contains(" IN ")){
                    String[] svValues;
                    index = busca.lastIndexOf(" IN ");
                    valor = busca.substring(index+5, busca.length()-1);
                    valor = valor.replaceAll("'", ""); //Remove todas as aspas simples
                    vetorValor = valor.split(",");
                    ArrayList<String> vcValues = new ArrayList<String>();
                    for (int i = 0; i < vetorValor.length; i++) {
                        vetorValor[i] = vetorValor[i].trim();
                    }
                }
            }
            return vetorValor;
        } catch (SQLException ex) {
            jtAreaDeStatus.setText("Erro na consulta "+ comandoSQL);
            System.err.println(ex.getErrorCode());
        }  
        return null;
    }
    
    public void inserirDados(JTextArea jtxtMsg, JPanel jPanel, String nomeTabela, int numCol) throws SQLException{
        StringBuilder comandoSQL = new StringBuilder();
        String[] colunaNome = new String[numCol];
        String[] colunaValor = new String[numCol];
        String[] colunaTipo = buscaTiposColunas(nomeTabela, numCol);
        JTextField jtf;
        JLabel jlbl; 
        JComboBox combobox;
        int i, j = 0;        
        try{
            for(i = 0; i < jPanel.getComponentCount()-2; i++){//-2 por causa dos dois botoes
                if(i%2 == 0){//se for numero par é label
                    jlbl = (JLabel) jPanel.getComponent(i);
                    colunaNome[j] = jlbl.getText();
                    if(jPanel.getComponent(i+1) instanceof JComboBox){//Se for uma combobox
                       combobox = (JComboBox) jPanel.getComponent(i+1);//textField
                       colunaValor[j] = (String) combobox.getSelectedItem();
                    }else{
                       jtf = (JTextField) jPanel.getComponent(i+1);//textField
                       colunaValor[j] = jtf.getText();
                    }
                    j++;
                       
                }                    
            }
            //Formato SQL
            comandoSQL.append("INSERT INTO " + nomeTabela + "(");
            for(i = 0; i < colunaNome.length - 1; i++){
                comandoSQL.append(colunaNome[i] + ", ");
            }
            comandoSQL.append(colunaNome[i] + ") VALUES (");

            for(i = 0; i < colunaValor.length; i++){
                if(i!= 0)
                    comandoSQL.append(", ");
                switch(colunaTipo[i]){
                    case ("BLOB"):
                        comandoSQL.append("EMPTY_BLOB()");
                        break;
                    case ("DATE"):
                        comandoSQL.append("to_date(" + colunaValor[i] + ")");
                        break;
                    default:
                        comandoSQL.append("'" + colunaValor[i] + "'");
                        break;
                }               
            }
            comandoSQL.append(")");

            System.out.println(comandoSQL.toString());
            
            prepStmt = connection.prepareStatement(comandoSQL.toString());
            prepStmt.setEscapeProcessing(true);
            prepStmt.executeUpdate();
            prepStmt.close();
            jtxtMsg.setText("Dados inseridos com sucesso! \n\nComando: " + comandoSQL.toString());
        }catch (SQLException ex) {
            jtxtMsg.setText("Erro na inserção. Verifique os dados: \n" + comandoSQL);
            Logger.getLogger(jTabelas.class.getName()).log(Level.SEVERE, null, ex);
        }    
    }
    
     
     
    public void getDDL(JTextArea jText, JTextArea jtxtDDL) {
        try {
            StringBuilder writer = new StringBuilder();
            CallableStatement Stmt;
            String date = new SimpleDateFormat("yyyy-MM-dd_HH.mm.ss").format(new Date());
            Writer bufWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("Arquivo_de_Definicoes_" + getNome() + "_" + date + ".sql"), "utf-8"));
            
            String aux;
            int i = 0;
            int j = 0;
            int k = 0;
            String comandoSQL = "{ CALL dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'STORAGE', false) }";
            String comandoSQL1 = "{ CALL dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'SEGMENT_ATTRIBUTES', false) }";
            String comandoSQL2 = "{ CALL dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'SQLTERMINATOR', true) }";
            String comandoSQL3 = "{ CALL dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'CONSTRAINTS_AS_ALTER', true) }";
            String comandoSQL4 = "{ CALL dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'REF_CONSTRAINTS', false) }";
            String comandoSQL5 = "{ CALL dbms_metadata.set_transform_param(dbms_metadata.session_transform, 'REF_CONSTRAINTS', true) }";
            String comandoSQL6 = "SELECT dbms_metadata.get_ddl('TABLE', table_name) FROM user_tables WHERE table_name NOT LIKE '%MLOG%' ORDER BY table_name";
            String comandoSQL7 = "SELECT dbms_metadata.get_ddl('SYNONYM', synonym_name) FROM user_synonyms";
            String comandoSQL8 = "SELECT dbms_metadata.get_ddl('SEQUENCE', sequence_name) FROM user_sequences";
            
            writer.append("--Arquivo de Definições\n"
                    + "--Este arquivo cria todas as tables, synonyms e sequences de acordo com o schema \"" + getNome() + "\" na data " + date + "\n");
            
            Stmt = connection.prepareCall(comandoSQL);
            Stmt.execute();
            
            Stmt = connection.prepareCall(comandoSQL1);
            Stmt.execute();
            
            Stmt = connection.prepareCall(comandoSQL2);
            Stmt.execute();
            
            Stmt = connection.prepareCall(comandoSQL3);
            Stmt.execute();
            
            Stmt = connection.prepareCall(comandoSQL4);
            Stmt.execute();
            
            prepStmt = connection.prepareStatement(comandoSQL6);
            rs = prepStmt.executeQuery();
            
            int size = 0;
                    
            while(rs.next()){
                size++;
            }

            String[] Create, Constraint, Sequence;
            Create = new String[size];
            Constraint = new String[size];
            Sequence = new String[size];
            
            prepStmt = connection.prepareStatement(comandoSQL6);
            rs = prepStmt.executeQuery();
            
            while(rs.next()){
                aux = rs.getString(1);
                Create[i] = aux;
                i++;
            }
            
            Stmt = connection.prepareCall(comandoSQL5);
            Stmt.execute();
            
            prepStmt = connection.prepareStatement(comandoSQL6);
            rs = prepStmt.executeQuery();
            
            while(rs.next()){
                aux = rs.getString(1);
                Constraint[j] = aux.replace(Create[j], "");
                j++;
            }
            
            for(i = 0; i < size; i++){
                Create[i] = Create[i].replace("\"" + getNome() + "\".", "");
                writer.append(Create[i] + "\n");
            }
            
            for(j = 0; j < size; j++){
                Constraint[j] = Constraint[j].replace("\"" + getNome() + "\".", "");
                writer.append(Constraint[j] + "\n");
            }
            
            prepStmt = connection.prepareStatement(comandoSQL7);
            rs = prepStmt.executeQuery();
            
            while(rs.next()){
                writer.append(rs.getString(1).replace("\"" + getNome() + "\".", ""));
            }
            
            prepStmt = connection.prepareStatement(comandoSQL8);
            rs = prepStmt.executeQuery();
            
            while(rs.next()){
                aux = rs.getString(1);
                Sequence[k] = aux;
                Sequence[k] = Sequence[k].replace("\"" + getNome() + "\".", "");
                int index = Sequence[k].indexOf("MINVALUE");
                Sequence[k] = Sequence[k].substring(0, index);
                Sequence[k] = Sequence[k].concat(" NOCACHE NOCYCLE;");
                writer.append(Sequence[k]);
                k++;
            }    
            
            bufWriter.write(writer.toString());
            bufWriter.close();
            jText.setText("Arquivo de definições de tabelas criado com sucesso.");
            jtxtDDL.setText(writer.toString());  
            jtxtDDL.setCaretPosition(0);
        } catch (SQLException ex) {
            Logger.getLogger(DBFuncionalidades.class.getName()).log(Level.SEVERE, null, ex);
            jText.setText("Não foi possível criar o arquivo de definições de tabelas.");
        } catch (FileNotFoundException ex) {
            Logger.getLogger(DBFuncionalidades.class.getName()).log(Level.SEVERE, null, ex);
            jText.setText("Não foi possível criar o arquivo de definições de tabelas.");
        } catch (UnsupportedEncodingException ex) {
            Logger.getLogger(DBFuncionalidades.class.getName()).log(Level.SEVERE, null, ex);
            jText.setText("Não foi possível criar o arquivo de definições de tabelas.");
        } catch (IOException ex) {
            Logger.getLogger(DBFuncionalidades.class.getName()).log(Level.SEVERE, null, ex);
            jText.setText("Não foi possível criar o arquivo de definições de tabelas.");
        }
    }
}

