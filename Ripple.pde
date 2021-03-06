public void setup()
{
  PImage icon = loadImage("icon.png");
  surface.setIcon(icon);

  size(625, 625);
  colorStyles.add(new RippleColorStyle(new float[] {0, 0, 0}));
  colorStyles.add(new RippleColorStyle(new float[] {0, 0, 100}, new boolean[] {false, true, false}, new boolean[] {true, false, false}, new float[] {30.0, 7.0, 1.0}));
}

ArrayList<RippleColorStyle> colorStyles = new ArrayList<RippleColorStyle>();
int selectedColorStyle = 1;

String styleSelection = "";
String styleSelectionError = "";
String styleSelectionSuccess = "";
String styleSelectionCompletion = "";
boolean devShowing = false;
boolean devEnabled = false;

ClipHelper cp = new ClipHelper();

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
  public float radius;
  public float degreeAmountToAdd;
  public float decayAmount;

  public RippleColorStyle()
  {
    this.red = 0.0;
    this.green = 0.0;
    this.blue = 0.0;

    this.redStatic = false;
    this.greenStatic = false;
    this.blueStatic = false;

    this.redReverse = false;
    this.greenReverse = false;
    this.blueReverse = false;

    this.radius = 30.0;
    this.degreeAmountToAdd = 7.0;
    this.decayAmount = 1.0;
  }

  public RippleColorStyle(float[] colorValues)
  {
    this.red = colorValues[0];
    this.green = colorValues[1];
    this.blue = colorValues[2];

    this.redStatic = false;
    this.greenStatic = false;
    this.blueStatic = false;

    this.redReverse = false;
    this.greenReverse = false;
    this.blueReverse = false;

    this.radius = 30.0;
    this.degreeAmountToAdd = 7.0;
    this.decayAmount = 1.0;
  }

  public RippleColorStyle(float[] colorValues, boolean[] staticValues, boolean[] reverseValues, float[] shapeValues)
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

    this.radius = shapeValues[0];
    this.degreeAmountToAdd = shapeValues[1];
    this.decayAmount = shapeValues[2];
  }

  public RippleColorStyle(String[] data)
  {
    this.red = data.length > 0 ? float(data[0]) : 0.0;
    this.green = data.length > 1 ? float(data[1]) : 0.0;
    this.blue = data.length > 2 ? float(data[2]) : 0.0;

    this.redStatic = data.length > 3 ? boolean(int(data[3])) : false;
    this.greenStatic = data.length > 4 ? boolean(int(data[4])) : false;
    this.blueStatic = data.length > 5 ? boolean(int(data[5])) : false;

    this.redReverse = data.length > 6 ? boolean(int(data[6])) : false;
    this.greenReverse = data.length > 7 ? boolean(int(data[7])) : false;
    this.blueReverse = data.length > 8 ? boolean(int(data[8])) : false;

    this.radius = data.length > 9 ? float(data[9]) : 30.0;
    this.degreeAmountToAdd = data.length > 10 ? float(data[10]) : 7.0;
    this.decayAmount = data.length > 11 ? float(data[11]) : 1.0;
  }

  public String toString()
  {
    return "RGB: " + red + "," + green + "," + blue + "  Static: " + redStatic + "," + greenStatic + "," + blueStatic + "  Reverse: " + redReverse + "," + greenReverse + "," + blueReverse + "  Shape: " + radius + "," + degreeAmountToAdd + "," + decayAmount;
  }

  public String getExportString(String sep)
  {
    return int(red) + sep + int(green) + sep + int(blue) + sep + int(redStatic) + sep + int(greenStatic) + sep + int(blueStatic) + sep + int(redReverse) + sep + int(greenReverse) + sep + int(blueReverse) + sep + radius + sep + degreeAmountToAdd + sep + decayAmount;
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
    decay += colorStyles.get(selectedColorStyle).decayAmount;
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
    text(selectedColorStyle + "/" + (colorStyles.size()-1) + "  " + colorStyles.get(selectedColorStyle).toString(), 10, 20);
    fill(0);
    text("> " + styleSelection.substring(0, promptPosition) + (((frameCount%50 < 50/2 && devEnabled) ? (promptPosition == styleSelection.length() ? "_" : "|") : (promptPosition == styleSelection.length() ? "" : ":")) + styleSelection.substring(promptPosition, styleSelection.length())), 10, 40);
    fill(200, 75, 50);
    text(!styleSelectionError.equals("") ? "Error: " + styleSelectionError : "", 10, 60);
    fill(40, 180, 60);
    stroke(0);
    text(!styleSelectionSuccess.equals("") ? "Success: " + styleSelectionSuccess : "", 10, 60);
    fill(40, 60, 180);
    stroke(0);
    text(styleSelectionSuccess.equals("") ? "" + styleSelectionCompletion : "", 10, 60);
  }

  for (int i=0; i < rippleArray.size(); i++)
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
    lastDegree += colorStyles.get(selectedColorStyle).degreeAmountToAdd;

    return new int[]{1, (int)(colorStyles.get(selectedColorStyle).radius*cos(lastDegree*PI/180))+width/2, (int)(colorStyles.get(selectedColorStyle).radius*sin(lastDegree*PI/180))+height/2};
  }
}

public final String[] commands = {"red", "green", "blue", "redstatic", "greenstatic", "bluestatic", "redreverse", "greenreverse", "bluereverse", "preset", "radius", "degreeadd", "decayamount", "framerate", "dev", "export", "import"};

Boolean holdingControl = false;
Boolean holdingShift = false;
int promptPosition = 0;

public void keyPressed()
{
  if (keyCode == CONTROL)
  {
    holdingControl = true;
    return;
  }

  if (keyCode == SHIFT)
  {
    holdingShift = true;
    return;
  }

  if (keyCode == LEFT && promptPosition > 0) promptPosition--;
  if (keyCode == RIGHT && promptPosition < styleSelection.length()) promptPosition++;

  if (keyCode == ALT || keyCode == 20 || keyCode == SHIFT || keyCode == 0 || keyCode == 157 || keyCode == LEFT || keyCode == RIGHT) return;

  String keyString = str(char(keyCode)).toLowerCase();

  if (keyCode == 186) keyString = ";";
  if (keyCode == 191) keyString = "/";
  if (keyCode == 219) keyString = "[";
  if (keyCode == 221) keyString = "]";
  if (keyCode == 188) keyString = ",";
  if (keyCode == 190) keyString = ".";

  if (holdingControl)
  {
    if (keyString.equals("p"))
    {
      String pasteString = cp.pasteString();
      styleSelection = styleSelection.substring(0, promptPosition) + pasteString + styleSelection.substring(promptPosition, styleSelection.length());
      promptPosition += pasteString.length();
    }
    return;
  }

  if (holdingShift)
  {
    if (keyString.equals(";"))
      keyString = ":";
    else
      keyString = keyString.toUpperCase();
  }

  if ((key == ENTER || key == RETURN) && !styleSelection.equals("") && styleSelection.split(" ").length >= 2)
  {
    String stylePartSelection = styleSelection.split(" ")[0];
    String styleSelectionValue = styleSelection.split(" ")[1];

    styleSelectionSuccess = "";
    styleSelectionError = "";
    styleSelectionCompletion = "";

    switch (stylePartSelection.toLowerCase())
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
      case "9":
      case "radius":
        colorStyles.get(selectedColorStyle).radius = float(styleSelectionValue);
        break;
      case "10":
      case "degreeadd":
        colorStyles.get(selectedColorStyle).degreeAmountToAdd = float(styleSelectionValue);
        break;
      case "11":
      case "decayamount":
        colorStyles.get(selectedColorStyle).decayAmount = float(styleSelectionValue);
        break;
      case "export":
        String exportData = getExportData();
        if (styleSelectionValue.equals("copy"))
          cp.copyString(exportData);
        else
          saveStrings(((styleSelectionValue.startsWith("/") || styleSelectionValue.startsWith("http")) ? "" : "data/presets/") + styleSelectionValue, new String[] {exportData});
        styleSelectionSuccess = getExportData();
        break;
      case "import":
        if (styleSelectionValue.substring(0, 1).equals("[") && styleSelectionValue.substring(styleSelectionValue.length()-1, styleSelectionValue.length()).equals("]"))
        {
          setImportData(styleSelectionValue.substring(1, styleSelectionValue.length()-1));
          styleSelectionSuccess = "Imported Data";
        }
        else if (styleSelectionValue.equals("paste"))
        {
          String pasteString = cp.pasteString();
          if (pasteString != null)
          {
            setImportData(pasteString);
            styleSelectionSuccess = "Imported Data";
          }
          else
          {
            styleSelectionError = "Invalid Data";
          }
        }
        else
        {
          if (styleSelectionValue.startsWith("http") && !(styleSelectionValue.matches("http[s]?://.+")))
          {
            styleSelectionError = "Invalid URL";
          }
          else
          {
            String[] presetsFile = loadStrings(((styleSelectionValue.startsWith("/") || styleSelectionValue.startsWith("http")) ? "" : "data/presets/") + styleSelectionValue);
            if (presetsFile != null && presetsFile.length > 0 && !presetsFile[0].contains(" charset=UTF-8\" http-equiv=\"Content-Type\">"))
            {
              setImportData(presetsFile[0]);
              styleSelectionSuccess = "Imported Data";
            }
            else
            {
              styleSelectionError = "Invalid Data";
            }
          }
        }
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
          colorStyles.add(new RippleColorStyle());
          selectedColorStyle = parseInt(styleSelectionValue);
        }
        else
        {
          styleSelectionError = parseInt(styleSelectionValue) + " is not a valid index for preset array";
        }
        break;
      case "framerate":
        frameRate(float(styleSelectionValue));
        break;
      default:
        styleSelectionError = "Command not found";
        break;
    }

    if (styleSelectionError.equals("") && styleSelectionSuccess.equals(""))
    {
      styleSelectionSuccess = "Set " + stylePartSelection + " to " + styleSelectionValue;
    }

    styleSelection = "";
    promptPosition = 0;
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
    styleSelectionCompletion = "";
  }
  else if (devEnabled && key != BACKSPACE && key != DELETE && keyCode != 220 && keyCode != 92 && key != ENTER && key != RETURN && key != TAB && keyCode != 192)
  {
    styleSelection = styleSelection.substring(0, promptPosition) + keyString + styleSelection.substring(promptPosition, styleSelection.length());
    promptPosition++;
  }
  else if ((key == DELETE || key == BACKSPACE || keyCode == 220 || keyCode == 92) && promptPosition > 0)
  {
    styleSelection = styleSelection.substring(0, promptPosition - 1) + styleSelection.substring(promptPosition, styleSelection.length());
    promptPosition--;
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

      styleSelection = commandsThatContainSubCommand.get(0).substring(0, equalPrefixSize+1) + ((commandsThatContainSubCommand.get(0).length() == equalPrefixSize+1 && commandsThatContainSubCommand.size() == 1) ? " " : "");
      //Add completion results to success selection text
      promptPosition = styleSelection.length();

      styleSelectionSuccess = "";
      styleSelectionError = "";
      styleSelectionCompletion = arrayToString(commandsThatContainSubCommand);
    }
  }
}

public void keyReleased()
{
  if (keyCode == CONTROL) holdingControl = false;
  if (keyCode == SHIFT) holdingShift = false;
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

public String getExportData()
{
  String exportString = "";
  for (int i=1; i < colorStyles.size(); i++)
    exportString += colorStyles.get(i).getExportString(",") + ";";
  exportString = exportString.substring(0, exportString.length()-1);
  return exportString;
}

public void setImportData(String rawData)
{
  for (int i=colorStyles.size()-1; i > 0; i--)
    colorStyles.remove(i);
  String[] colorStyleArrayData = rawData.split(";");
  for (int i=0; i < colorStyleArrayData.length; i++)
  {
    RippleColorStyle colorStyle = new RippleColorStyle(colorStyleArrayData[i].split(","));
    colorStyles.add(colorStyle);
  }

  if (colorStyles.size() > 1)
    selectedColorStyle = 1;
  else
    selectedColorStyle = 0;
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
