import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons;
private ArrayList <MSButton> mines = new ArrayList <MSButton>();

void setup ()
{
  size(400, 500);
  background( 0 );
  textAlign(CENTER, CENTER);

  Interactive.make( this );

  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++)
  {
    for (int c = 0; c < NUM_COLS; c++)
    {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  setMines();
}
public void setMines()
{
  for (int i = 0; i < 15; i++)
  {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[r][c]))
    {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  int num = 0;
  for (int r = 0; r < NUM_ROWS; r++)
  {
    for (int c = 0; c < NUM_COLS; c++)
    {
      if (mines.contains(buttons[r][c]) && buttons[r][c].flagged == true)
      {
        num++;
      }
    }
  }
  if (num == mines.size())
  {
    return true;
  }
  return false;
}
public void displayLosingMessage()
{
  fill(0);
  rect(0, 400, 400, 100);
  fill(255);
  text("Skill Issue", 200, 450);
  for (int r = 0; r < NUM_ROWS; r++)
      {
        for (int c = 0; c < NUM_COLS; c++)
        {
          if (!buttons[r][c].clicked)
          {
            buttons[r][c].mousePressed();
          }
        }
      }
}
public void displayWinningMessage()
{
  fill(0);
  rect(0, 400, 400, 100);
  fill(255);
  text("YOU WON!", 200, 450);
}
public boolean isValid(int r, int c)
{
  return(r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0);
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row-1; r < row+2; r++)
  {
    for (int c = col-1; c < col+2; c++)
    {
      if (isValid(r, c) == true && mines.contains(buttons[r][c]))
      {
        numMines++;
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed ()
  {
    clicked = true;

    if (mouseButton == RIGHT)
    {
      flagged = !flagged;
    } else if (mines.contains(buttons[myRow][myCol]))
    {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0)
    {
      setLabel(countMines(myRow, myCol));
    } else
    {
      for (int r = myRow-1; r < myRow+2; r++)
      {
        for (int c = myCol-1; c < myCol+2; c++)
        {
          if (isValid(r, c) == true && !buttons[r][c].clicked)
          {
            buttons[r][c].mousePressed();
          }
        }
      }
    }
  }
  public void draw ()
  {    
    if (flagged)
      fill(44, 174, 232);
    else if (clicked && mines.contains(this))
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else
      fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
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
