package aspectP;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import agent.Move;
import agent.Player;
aspect Logger{

    private static File log;
    private static FileWriter fw;
    private Player p;
    String player;
    
    pointcut loggingMethod() : execution(public Move Player.makeMove());
    
    
    
    after() returning(Object mv) :loggingMethod(){
    	
    	p = (Player)thisJoinPoint.getThis();
    	
    	if (p.getColor() == 0) {
    		player = "(human)";
    	} else {
    		player = "(bot)";
    	}
        Move mov = (Move)mv;
    	log = new File("./log.txt");
        try {
            fw = new FileWriter(log,true);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        try {
			fw.write((char) ('a' + mov.xI) + "" + (mov.yI+1) + (char) ('a' + mov.xF) + "" + (mov.yF+1) + " " + player);
        	fw.append(System.getProperty("line.separator"));
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
        try {
            fw.close();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}