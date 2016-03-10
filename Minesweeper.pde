import de.bezier.guido.*;
int NUM_ROWS = 10;
int NUM_COLS = 10;
int NUM_BOMBS = 5; 
private MSButton[][] buttons;
private ArrayList <MSButton> bombs = new ArrayList <MSButton>();
void setup()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    Interactive.make(this);
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
for(int y = 0; y < NUM_ROWS; y++)
{
    for(int x = 0; x < NUM_COLS; x++)
    {
        buttons[y][x] = new MSButton(y, x);
    }
}    
    setBombs();
}
public void setBombs()
{
    for(int i = 0; i < NUM_BOMBS; i++)
    {
        int bombX = (int)(Math.random() * NUM_COLS);
        int bombY = (int)(Math.random() * NUM_ROWS);
        if(!bombs.contains(buttons[bombY][bombX]))
            bombs.add(buttons[bombY][bombX]);
        else
            setBombs();
    }
}
public void draw()
{
    background(0);
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int markedAll = 0;
    int clickedAll = 0;
    for(int i = 0; i < NUM_BOMBS; i++)
    {
        if(bombs.get(i).isMarked())
            markedAll++;
    }
    for(int row = 0; row < NUM_ROWS; row++)
    {
        for(int col = 0; col < NUM_COLS; col++)
        {
            if(buttons[row][col].isClicked())
                clickedAll++;
        }
    }
    if(markedAll == NUM_BOMBS && clickedAll == (NUM_ROWS * NUM_COLS))
        return true;
    else
        return false;
}
public void displayLosingMessage()
{

    for(int row = 0; row < NUM_ROWS; row += 2)
    {
        for(int col = 0; col < NUM_COLS; col += 2)
            buttons[row][col].setLabel("you");
    }
    for(int row = 1; row < NUM_ROWS; row += 2)
    {
        for(int col = 1; col < NUM_COLS; col += 2)
            buttons[row][col].setLabel("lose");
    }
    for(int row = 0; row < NUM_ROWS; row++)
    {
        for(int col = 0; col < NUM_COLS; col++)
            if(bombs.contains(buttons[row][col]))
                buttons[row][col].clicked = true;
    }
    noLoop();
}
public void displayWinningMessage()
{
    for(int row = 0; row < NUM_ROWS; row += 2)
    {
        for(int col = 0; col < NUM_COLS; col += 2)
            buttons[row][col].setLabel("you");        
    }
    for(int row = 1; row < NUM_ROWS; row += 2)
    {
        for(int col = 1; col < NUM_COLS; col += 2)
            buttons[row][col].setLabel("win");
    }
    for(int row = 1; row < NUM_ROWS; row += 2)
    {
        for(int col = 0; col < NUM_COLS; col += 2)
            buttons[row][col].setLabel("");
    }
    for(int row = 0; row < NUM_ROWS; row += 2)
    {
        for(int col = 1; col < NUM_COLS; col += 2)
            buttons[row][col].setLabel("");
    }
    noLoop();
}
public class MSButton
{
    private int r, c;
    private float x, y, width, height;
    private boolean clicked, marked;
    private String label;
    public MSButton ( int rr, int cc )
    {
        width = 400 / NUM_COLS;
        height = 400 / NUM_ROWS;
        r = rr;
        c = cc; 
        x = c * width;
        y = r * height;
        label = "";
        marked = clicked = false;
        Interactive.add(this);
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    public void mousePressed () 
    {
        clicked = true;
        if(keyPressed == true)
            marked = !marked;
        else if(bombs.contains(this))
            displayLosingMessage();
        else if(countBombs(r, c) > 0)
            setLabel(str(countBombs(r, c)));
        else
            for(int checkRows = -1; checkRows < 2; checkRows++)
            {
                for(int checkCols = -1; checkCols < 2; checkCols++)
                {
                    if(isValid(r + checkRows, c + checkCols) && !buttons[r + checkRows][c + checkCols].isClicked() && !buttons[r + checkRows][c + checkCols].isMarked())
                        buttons[r + checkRows][c + checkCols].mousePressed();
                }
            }
    } 
    public void draw () 
    {    
        if(marked)
            fill(0);
        else if(clicked && bombs.contains(this)) 
            fill(255, 0, 0);
        else if(clicked)
            fill(200);
        else 
            fill(100);
        rect(x, y, width, height);
        fill(0);
        text(label, x + width / 2, y + height / 2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
            return true;
        else
            return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int bombRows = -1; bombRows < 2; bombRows++)
        {
            for(int bombCols = -1; bombCols < 2; bombCols++)
            {
                if(isValid(row + bombRows, col + bombCols) && bombs.contains(buttons[row + bombRows][col + bombCols]))
                    numBombs++;
            }
        }
        return numBombs;
    }
}