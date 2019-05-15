public void setup()
{
  size(500, 500);
  colorStyles.add(new RippleColorStyle(new float[] {0, 0, 0}));
  colorStyles.add(new RippleColorStyle(new float[] {0, 0, 100}, new boolean[] {false, true, false}, new boolean[] {true, false, false}));
}

ArrayList<RippleColorStyle> colorStyles = new ArrayList<RippleColorStyle>();
int selectedColorStyle = 1;

String styleSelection = "";
String styleSelectionError = "";
String styleSelectionSuccess = "";
String styleSelectionCompletion = "";
boolean devShowing = false;
boolean devEnabled = false;

public class RippleColorStyle
{
  public float red;
  public float green;
  public float blue;
  public boolean redStatic;
  public boolean greenStatic;
  public boolean blueStatic;
  public boolean redReverse;
  public boolean greenReverse;
  public boolean blueReverse;

  public RippleColorStyle(float[] colorValues)
  {
    this.red = colorValues[0];
    this.green = colorValues[1];
    this.blue = colorValues[2];
  }

  public RippleColorStyle(float[] colorValues, boolean[] staticValues)
  {
    this.red = colorValues[0];
    this.green = colorValues[1];
    this.blue = colorValues[2];

    this.redStatic = staticValues[0];
    this.greenStatic = staticValues[1];
    this.blueStatic = staticValues[2];
  }

  public RippleColorStyle(float[] colorValues, boolean[] staticValues, boolean[] reverseValues)
  {
    this.red = colorValues[0];
    this.green = colorValues[1];
    this.blue = colorValues[2];

    this.redStatic = staticValues[0];
    this.greenStatic = staticValues[1];
    this.blueStatic = staticValues[2];

    this.redReverse = reverseValues[0];
    this.greenReverse = reverseValues[1];
    this.blueReverse = reverseValues[2];
  }

  public RippleColorStyle(RippleColorStyle original)
  {
    this.red = original.red;
    this.green = original.green;
    this.blue = original.blue;

    this.redStatic = original.redStatic;
    this.greenStatic = original.greenStatic;
    this.blueStatic = original.blueStatic;

    this.redReverse = original.redReverse;
    this.greenReverse = original.greenReverse;
    this.blueReverse = original.blueReverse;
  }

  public String toString()
  {
    return "RGB: " + red + "," + green + "," + blue + " Static: " + redStatic + "," + greenStatic + "," + blueStatic + " Reverse: " + redReverse + "," + greenReverse + "," + blueReverse;
  }
}

int rippleShapeType = 0;

public class RippleObject
{
  int rippleSize;
  int rippleX;
  int rippleY;
  float decay = 0.0;

  public RippleObject(int rippleSize, int rippleX, int rippleY)
  {
    this.rippleSize = rippleSize;
    this.rippleX = rippleX;
    this.rippleY = rippleY;
  }

  public void addToRipple()
  {
    rippleSize += 1;
  }

  public void drawRipple()
  {
    noStroke();
    fill(getRedColor(), getGreenColor(), getBlueColor(), 100.0-decay);

    switch (rippleShapeType)
    {
        case 0:
        drawHex(rippleX, rippleY, rippleSize/3.0);
        break;
        case 1:
        rectMode(CENTER);
        rect(rippleX, rippleY, rippleSize, rippleSize);
        break;
        case 2:
        ellipse(rippleX, rippleY, rippleSize, rippleSize);
        break;
    }
  }

  public void drawHex(float x, float y, float gs)
  {
    beginShape();
    vertex(x - gs, y - sqrt(3) * gs);
    vertex(x + gs, y - sqrt(3) * gs);
    vertex(x + 2 * gs, y);
    vertex(x + gs, y + sqrt(3) * gs);
    vertex(x - gs, y + sqrt(3) * gs);
    vertex(x - 2 * gs, y);
    endShape(CLOSE);
  }

  public void decayObject()
  {
    decay += 1.0;
  }

  public float getValueForMinusValue(float colorValue, boolean colorStatic, boolean colorReverse)
  {
    if (colorStatic)
    {
      return 255*colorValue/100;
    }
    else if (colorReverse)
    {
      return 255*(decay-colorValue)/100;
    }
    else
    {
      return 255*(colorValue-decay)/100;
    }
  }

  public float getRedColor()
  {
    float redMinus = colorStyles.get(selectedColorStyle).red;
    boolean redStatic = colorStyles.get(selectedColorStyle).redStatic;
    boolean redReverse = colorStyles.get(selectedColorStyle).redReverse;
    return getValueForMinusValue(redMinus, redStatic, redReverse);
  }

  public float getGreenColor()
  {
    float greenMinus = colorStyles.get(selectedColorStyle).green;
    boolean greenStatic = colorStyles.get(selectedColorStyle).greenStatic;
    boolean greenReverse = colorStyles.get(selectedColorStyle).greenReverse;
    return getValueForMinusValue(greenMinus, greenStatic, greenReverse);
  }

  public float getBlueColor()
  {
    float blueMinus = colorStyles.get(selectedColorStyle).blue;
    boolean blueStatic = colorStyles.get(selectedColorStyle).blueStatic;
    boolean blueReverse = colorStyles.get(selectedColorStyle).blueReverse;
    return getValueForMinusValue(blueMinus, blueStatic, blueReverse);
  }
}

public ArrayList<RippleObject> rippleArray = new ArrayList<RippleObject>();
public int lastMouseX = 0;
public int lastMouseY = 0;

public void draw()
{
  background(204);

  fill(0);
  textAlign(RIGHT);
  text(round(frameRate), width-10, 20);

  if (devShowing)
  {
    textAlign(LEFT);
    fill(0);
    text(selectedColorStyle + " " + colorStyles.get(selectedColorStyle).toString(), 10, 20);
    fill(0);
    text("> " + styleSelection + ((frameCount%50 < 50/2 && devEnabled) ? "_" : ""), 10, 40);
    fill(200, 75, 50);
    text(styleSelectionError != "" ? "Error: " + styleSelectionError : "", 10, 60);
    fill(40, 180, 60);
    stroke(0);
    text(styleSelectionSuccess != "" ? "Success: " + styleSelectionSuccess : "", 10, 60);
    fill(40, 60, 180);
    stroke(0);
    text(styleSelectionSuccess == "" ? "" + styleSelectionCompletion : "", 10, 60);
  }

  for (int i=0; i<rippleArray.size(); i++)
  {
    RippleObject rippleObject = rippleArray.get(i);
    rippleObject.addToRipple();
    rippleObject.decayObject();
    rippleObject.drawRipple();

    if (rippleObject.decay >= 100.0)
    {
      rippleArray.remove(i);
    }
  }

  int[] rippleCoords = getRippleCoords();
  if (rippleCoords[0] == 1)
  {
    rippleArray.add(new RippleObject(1, rippleCoords[1], rippleCoords[2]));
  }
}

boolean mouseControlling = false;

float lastDegree = 0.0;
float radius = 30.0;

public int[] getRippleCoords()
{
  if (mouseControlling)
  {
    boolean mouseChanged = (lastMouseX != mouseX || lastMouseY != mouseY);
    if (mouseChanged)
    {
      lastMouseX = mouseX;
      lastMouseY = mouseY;
    }
    return new int[]{mouseChanged ? 1 : 0, mouseX, mouseY};
  }
  else
  {
    lastDegree += 7;

    return new int[]{1, (int)(radius*cos(lastDegree*PI/180))+width/2, (int)(radius*sin(lastDegree*PI/180))+height/2};
  }
}

public final String[] commands = {"red", "green", "blue", "redstatic", "greenstatic", "bluestatic", "redreverse", "greenreverse", "bluereverse", "preset", "dev"};

public void keyPressed()
{
  String charKey = str(char(keyCode)).toLowerCase();
  String keyString = "" + charKey;

  if ((key == ENTER || key == RETURN) && styleSelection != "" && styleSelection.split(" ").length >= 2)
  {
    String stylePartSelection = styleSelection.split(" ")[0];
    String styleSelectionValue = styleSelection.split(" ")[1];

    styleSelectionSuccess = "";
    styleSelectionError = "";
    styleSelectionCompletion = "";

    switch (stylePartSelection)
    {
      case "0":
      case "red":
        colorStyles.get(selectedColorStyle).red = parseInt(styleSelectionValue);
        break;
      case "1":
      case "green":
        colorStyles.get(selectedColorStyle).green = parseInt(styleSelectionValue);
        break;
      case "2":
      case "blue":
        colorStyles.get(selectedColorStyle).blue = parseInt(styleSelectionValue);
        break;
      case "3":
      case "redstatic":
        colorStyles.get(selectedColorStyle).redStatic = boolean(styleSelectionValue);
        break;
      case "4":
      case "greenstatic":
        colorStyles.get(selectedColorStyle).greenStatic = boolean(styleSelectionValue);
        break;
      case "5":
      case "bluestatic":
        colorStyles.get(selectedColorStyle).blueStatic = boolean(styleSelectionValue);
        break;
      case "6":
      case "redreverse":
        colorStyles.get(selectedColorStyle).redReverse = boolean(styleSelectionValue);
        break;
      case "7":
      case "greenreverse":
        colorStyles.get(selectedColorStyle).greenReverse = boolean(styleSelectionValue);
        break;
      case "8":
      case "bluereverse":
        colorStyles.get(selectedColorStyle).blueReverse = boolean(styleSelectionValue);
        break;
      case "dev":
        devShowing = boolean(styleSelectionValue);
        break;
      case "preset":
        if (colorStyles.size() > parseInt(styleSelectionValue) && parseInt(styleSelectionValue) >= 0)
        {
          selectedColorStyle = parseInt(styleSelectionValue);
        }
        else if (colorStyles.size()+1 > parseInt(styleSelectionValue) && parseInt(styleSelectionValue) >= 0)
        {
          colorStyles.add(new RippleColorStyle(colorStyles.get(0)));
          selectedColorStyle = parseInt(styleSelectionValue);
        }
        else
        {
          styleSelectionError = parseInt(styleSelectionValue) + " is not a valid index for preset array";
        }
        break;
      default:
        styleSelectionError = "Command not found";
        break;
    }

    if (styleSelectionError == "")
    {
      styleSelectionSuccess = "Set " + stylePartSelection + " to " + styleSelectionValue;
    }

    styleSelection = "";
  }
  else if ((key == ENTER || key == RETURN) && styleSelection.length() <= 0)
  {
    devEnabled = !devEnabled;
    devShowing = devEnabled ? true : devShowing;
  }
  else if (key == ENTER || key == RETURN)
  {
    styleSelectionSuccess = "";
    styleSelectionError = "Type a command, then a value";
  }
  else if (devEnabled && key != BACKSPACE && key != DELETE && key != ENTER && key != RETURN && key != TAB && keyCode != 192)
  {
    styleSelection += keyString;
  }
  else if ((key == DELETE || key == BACKSPACE) && styleSelection.length() > 0)
  {
    styleSelection = styleSelection.substring(0, styleSelection.length() - 1);
  }
  else if ((key == TAB || keyCode == 192) && styleSelection.length() > 0 && styleSelection.split(" ").length == 1)
  {
    ArrayList<String> commandsThatContainSubCommand = new ArrayList<String>();
    for (int i=0; commands.length > i; i++)
    {
      if (commands[i].startsWith(styleSelection))
      {
        commandsThatContainSubCommand.add(commands[i]);
      }
    }

    if (commandsThatContainSubCommand.size() > 0)
    {
      int equalPrefixSize = 0;
      for (int i=0; commandsThatContainSubCommand.get(0).length() > i; i++)
      {
        boolean hasEqualPrefixChar = true;
        for (int j=0; commandsThatContainSubCommand.size() > j; j++)
        {
          if (commandsThatContainSubCommand.get(j).length() < i || (commandsThatContainSubCommand.get(j).charAt(i) != commandsThatContainSubCommand.get(0).charAt(i)))
          {
            hasEqualPrefixChar = false;
          }
        }

        if (hasEqualPrefixChar)
        {
          equalPrefixSize = i;
        }
        else
        {
          break;
        }
      }

      //println(commandsThatContainSubCommand);

      styleSelection = commandsThatContainSubCommand.get(0).substring(0, equalPrefixSize+1) + ((commandsThatContainSubCommand.get(0).length() == equalPrefixSize+1 && commandsThatContainSubCommand.size() == 1) ? " " : "");
      //Add completion results to success selection text

      styleSelectionSuccess = "";
      styleSelectionError = "";
      styleSelectionCompletion = arrayToString(commandsThatContainSubCommand);
    }
  }
}

public String arrayToString(ArrayList arr)
{
  String str = "[";
  for (Object obj : arr)
    str += obj.toString() + ", ";
  str = str.substring(0, str.length()-2);
  str += "]";
  return str;
}

public void mousePressed()
{
  switch (mouseButton)
  {
    case LEFT:
      switch (rippleShapeType)
      {
          case 0:
            rippleShapeType = 1;
            break;
          case 1:
            rippleShapeType = 2;
            break;
          case 2:
            rippleShapeType = 0;
            break;
      }
      break;
    case RIGHT:
      mouseControlling = !mouseControlling;
      break;
  }
}
