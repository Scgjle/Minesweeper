import de.bezier.guido.*;
public int NUM_ROWS = 20;
public int NUM_COLS = 20;
public int NUM_MINES = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        buttons[r][c] = new MSButton(r, c); 
      }
    }
    
    mines = new ArrayList<MSButton>(); 
    setMines();
}
public void setMines()
{
    mines.clear();
    while(mines.size() < NUM_MINES) {
      MSButton wow = buttons[(int)(Math.random()*NUM_ROWS)][(int)(Math.random()*NUM_COLS)];
      
      if (!mines.contains(wow)) {
        mines.add(wow);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        MSButton b = buttons[r][c];
        
        if (!mines.contains(b) && !b.clicked) {
          return false; // still hidden mine
        }
      }
    }
    return true;
}
public void displayLosingMessage()
{
    for (int i = 0; i < mines.size(); i++) { 
      MSButton b = mines.get(i); b.clicked = true;
    }
}
public void displayWinningMessage() 
{
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            MSButton b = buttons[r][c];
            b.clicked = true;
            b.setLabel("WIN");
        }
    }
}
public boolean isValid(int r, int c)
{
    return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = -1; r <=1; r++) {
      for(int c = -1; c <= 1; c++) {
        if (r==0 && c==0) continue;
        if(isValid(row+r,col+c)) {
          if (mines.contains(buttons[row+r][col+c])) {
            numMines++;
          }
        }
      }
    }   
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400.0/NUM_COLS;
        height = 400.0/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed() 
{
    if (mouseButton == RIGHT) {
        if (!clicked) {
            flagged = !flagged;
        }
        return;
    }

    if (mouseButton == LEFT) {
        if (clicked || flagged) return;

        clicked = true;
        if (mines.contains(this)) {
            displayLosingMessage();
            return;
        }
        int n = countMines(myRow, myCol);

        if (n > 0) {
            setLabel(n);
        } 
        else {
            for (int dr = -1; dr <= 1; dr++) {
                for (int dc = -1; dc <= 1; dc++) {
                    if (dr == 0 && dc == 0) continue;
                    int nr = myRow + dr;
                    int nc = myCol + dc;
                    if (isValid(nr, nc)) {
                        MSButton neighbor = buttons[nr][nc];

                        if (!neighbor.clicked && !neighbor.flagged) {
                            neighbor.mousePressed();   // recursion
                        }
                    }
                }
            }
        }

        // W WIN CONDITION
        if (isWon()) {
            displayWinningMessage();
        }
    }
}
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
