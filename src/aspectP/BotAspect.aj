import agent.Move;
import agent.StupidAI;
import game.Board;
import agent.Player;

public aspect BotAspect
{
	Move m1;
	Board b;
	Boolean verif;
	Player p;
	
    pointcut moveMethod2() : execution(public boolean StupidAI.move(Move));
    
    pointcut getBoardByConstructor2() : execution(agent.StupidAI.new(..));
	
    
 // Recuperation du Board par l'aspect
    before() : getBoardByConstructor2()
    {
    	Object[] args = new Object[2];
    	int i =0;
    	for (Object arg : thisJoinPoint.getArgs()) {
    		args[i] = arg;
    		i++;
    	}
    	
    	b = (Board)args[1];
    }
    
    // Recuperation du player par l'aspect
    after() : getBoardByConstructor2() 
    {
    	p = (Player)thisJoinPoint.getThis();
    }
    
    Boolean around() : moveMethod2()
    {
    	for (Object arg : thisJoinPoint.getArgs()) {
    		m1 = (Move)arg;
    	}
    	
    	return moveIsLegit(m1,b);
    }
    
	public boolean moveIsLegit(Move mov, Board brd){
			
	
			//depart ou arrivée hors tableau
			if (	mov.xI <0 || mov.xI > 7 || mov.xF < 0 || mov.xF> 7||
					mov.yI <0 || mov.yI > 7 || mov.yF < 0 || mov.yF> 7){
				printError(2);
				return false;
			}
			
			//case vide
			if (!brd.getGrid()[mov.xI][mov.yI].isOccupied()){
				printError(4);
				return false;
			}
			
			//piece human
			if (brd.getGrid()[mov.xI][mov.yI].getPiece().getPlayer() == 1){
				printError(5);
				return false;
			}
			
			//deplacement sur place
			if (mov.xI==mov.xF && mov.yI==mov.yF){
				printError(3);
				return false;
			}
			
			//manger un bot (impossible)
			if(brd.getGrid()[mov.xF][mov.yF].isOccupied() && brd.getGrid()[mov.xF][mov.yF].getPiece().getPlayer() == 0 ) {
				printError(1);
				return false;
			}
			
	
			
			switch (brd.getGrid()[mov.xI][mov.yI].getPiece().toString()){
				case "p" :
					//mange une piece adverse
					if ((mov.xF==mov.xI+1 || mov.xF==mov.xI-1) && mov.yF == mov.yI-1 && brd.getGrid()[mov.xF][mov.yF].isOccupied()){
						if (brd.getGrid()[mov.xF][mov.yF].getPiece().getPlayer() == 1){
							b.movePiece(m1);
							return true;
						}
					}
					//deplace pos départ
					if (mov.yI==6){
						if (mov.yF == mov.yI-2 && mov.xF == mov.xI && !brd.getGrid()[mov.xI][mov.yI-1].isOccupied() && !brd.getGrid()[mov.xI][mov.yI-2].isOccupied()){
							b.movePiece(m1);
							return true;
						}
					}
					//déplace
					if (mov.yF == mov.yI-1 && mov.xI == mov.xF && !(brd.getGrid()[mov.xF][mov.yF].isOccupied())){
						b.movePiece(m1);
						return true;
					}
					
					printError(6);
					break;
					
				case "t" :
					//deplacement vertical
					if (mov.xI == mov.xF){
						//Deplacement vers le bas
						if(mov.yF - mov.yI > 0){
							for (int i =mov.yI+1 ; i < mov.yF ; i++){
								if (brd.getGrid()[mov.xF][i].isOccupied()){ return false;}
							}
							//deplacement vers le haut
						}else{
							for (int i =mov.yI-1;i>mov.yF;i--){
								if (brd.getGrid()[mov.xF][i].isOccupied()){ return false;}
							}
						}
						b.movePiece(m1);
						return true;
						
						//deplacement horizontal
					}else if( mov.yI == mov.yF){
						//deplacement a droite
						if(mov.xF - mov.xI > 0){
							for (int i =mov.xI+1;i<mov.xF;i++){
								if (brd.getGrid()[i][mov.yI].isOccupied()){ return false;}
							}
							//deplacement a gauche
						}else{
							for (int i =mov.xI-1;i>mov.xF;i--){
								if (brd.getGrid()[i][mov.yI].isOccupied()){ return false;}
							}
						}
						b.movePiece(m1);
						return true;
	
					} else {
						printError(7);
						return false;
					}
					
				case "c":
					if(((mov.yF == mov.yI-2) && (mov.xF == mov.xI+1) ||
					    (mov.yF == mov.yI-1) && (mov.xF == mov.xI+2) ||
					    (mov.yF == mov.yI-2) && (mov.xF == mov.xI-1) ||
					    (mov.yF == mov.yI-1) && (mov.xF == mov.xI-2) ||
					    (mov.yF == mov.yI+2) && (mov.xF == mov.xI+1) ||
					    (mov.yF == mov.yI+1) && (mov.xF == mov.xI+2) ||
					    (mov.yF == mov.yI+2) && (mov.xF == mov.xI-1) ||
					    (mov.yF == mov.yI+1) && (mov.xF == mov.xI-2))
					   ) {
						b.movePiece(m1);
						return true;
					}
					
					printError(8);
					break;
					
				case "r":
					if( (mov.yF <= mov.yI+1 && mov.yF >= mov.yI-1) && (mov.xF <= mov.xI+1 && mov.xF >= mov.xI-1)) {
						b.movePiece(m1);
						return true;
					}
					
					printError(9);
					break;
					
				case "d":
					//deplacement vertical
					if (mov.xI == mov.xF){
						//Deplacement vers le bas
						if(mov.yF - mov.yI > 0){
							for (int i =mov.yI+1 ; i < mov.yF ; i++){
								if (brd.getGrid()[mov.xF][i].isOccupied()){ 
									printError(10);
									return false;
								}
							}
							//deplacement vers le haut
						}else{
							for (int i =mov.yI-1;i>mov.yF;i--){
								if (brd.getGrid()[mov.xF][i].isOccupied()){ 
									printError(10);
									return false;
								}
							}
						}
						b.movePiece(m1);
						return true;
						
						//deplacement horizontal
					}else if( mov.yI == mov.yF){
						//deplacement a droite
						if(mov.xF - mov.xI > 0){
							for (int i =mov.xI+1;i<mov.xF;i++){
								if (brd.getGrid()[i][mov.yI].isOccupied()){ 
									printError(10);
									return false;
								}
							}
							//deplacement a gauche
						}else{
							for (int i =mov.xI-1;i>mov.xF;i--){
								if (brd.getGrid()[i][mov.yI].isOccupied()){ 
									printError(10);
									return false;
								}
							}
						}
						b.movePiece(m1);
						return true;
	
					}else if (Math.abs(mov.xF-mov.xI)==Math.abs(mov.yF-mov.yI)){
						//deplacements en diagonale
						if ((mov.xF-mov.xI)>0 && (mov.yF-mov.yI)>0){
							for (int i =mov.xI+1,j=mov.yI+1; i<mov.xF && j<mov.yF ;j++,i++){
								if (brd.getGrid()[i][j].isOccupied()){ 
									printError(10);
									return false;
								}
							}
						}
						if ((mov.xF-mov.xI)>0 && (mov.yF-mov.yI)<0){
							for (int i =mov.xI+1,j=mov.yI-1; i<mov.xF && j>mov.yF ;j--,i++){
								if (brd.getGrid()[i][j].isOccupied()){ 
									printError(10);
									return false;
								}
							}
						}
						if ((mov.xF-mov.xI)<0 && (mov.yF-mov.yI)<0){
							for (int i =mov.xI-1,j=mov.yI-1; i>mov.xF && j>mov.yF ;j--,i--){
								if (brd.getGrid()[i][j].isOccupied()){ 
									printError(10);
									return false;
								}
							}
						}
						if ((mov.xF-mov.xI)<0 && (mov.yF-mov.yI)>0){
							for (int i =mov.xI-1,j=mov.yI+1; i>mov.xF && j<mov.yF ;j++,i--){
								if (brd.getGrid()[i][j].isOccupied()){ 
									printError(10);
									return false;
								}
							}
						}
						b.movePiece(m1);
						return true;
					}else {
						printError(10);
						return false;
					}
			}
			return false;
	}


	public void printError(int piece) {
		
		switch(piece) {
		case 1 : System.out.println("\n[BOT]Pourquoi vouloir manger son ami ?!\n"); break;
		case 2 : System.out.println("\n[BOT]Destination hors du Board !\n"); break;
		case 3 : System.out.println("\n[BOT]Deplacement sur soi-meme impossible !\n"); break;
		case 4 : System.out.println("\n[BOT]La case de départ est vide !\n"); break;
		case 5 : System.out.println("\n[BOT]Vous ne pouvez pas bouger une piece du bot !\n"); break;
		case 6 : System.out.println("\n[BOT]Move non autorisé pour le pion !\n"); break;
		case 7 : System.out.println("\n[BOT]Move non autorisé pour la tour !\n"); break;
		case 8 : System.out.println("\n[BOT]Move non autorisé pour le cavalier !\n"); break;
		case 9 : System.out.println("\n[BOT]Move non autorisé pour le roi !\n"); break;
		case 10 : System.out.println("\n[BOT]Move non autorisé pour la reine !\n"); break;
		case 11 : System.out.println("\n[BOT]Move non autorisé pour le roi !\n"); break;
			
		}
	}
	
}