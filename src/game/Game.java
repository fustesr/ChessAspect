package game;

import agent.StupidAI;
import agent.HumanPlayer;
import agent.Player;

public class Game {

    protected Board board;

    public Game() {
	board = new Board();
	board.setupChessBoard();
    }

    public Board getBoard() {
	return board;
    }

    public void setBoard(Board board) {
	this.board = board;
    }

    private void play() {
	Player human = new HumanPlayer(Player.BLACK, board);
	Player dumber = new StupidAI(Player.WHITE, board);

	while (true) {
	    board.print();
	    human.makeMove();
	    board.print();
	    dumber.makeMove();
	}
    }

    public static void main(String[] args) {
	System.out.println("Chess : White are smallcaps ");
	new Game().play();
    }
}
