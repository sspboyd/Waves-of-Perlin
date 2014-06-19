import processing.pdf.*;

//Declare Globals
int rSn; // randomSeed number. put into var so can be saved in file name. defaults to 47
final float PHI = 0.618033989;

// Declare Font Variables
PFont sigF;

boolean PDFOUT = false;

// Declare Positioning Variables
float margin;
float PLOT_X1, PLOT_X2, PLOT_Y1, PLOT_Y2;

// float perXOff = 0.0; // not needed here. it is now a local var in the getNewVals function
// float perYOff = 0.0; 
float perZOff = 0.0;

final int xDim = 10;
final int yDim = 20;

// size of board 10x10
int boardLength = xDim * yDim;

int[] bkgClrArr = new int[boardLength];
int[] frgClrArr = new int[boardLength];
float[] angArr = new float[boardLength];
float tileW, tileH;



/*////////////////////////////////////////
 SETUP
 ////////////////////////////////////////*/

void setup() {
  background(255);
  if (PDFOUT) {
    size(720, 720, PDF, generateSaveImgFileName(".pdf"));
  }
  else {
    size(720, 720); // quarter page size
  }

  smooth(8);

  margin = width * pow(PHI, 6);
  println("margin: " + margin);
  PLOT_X1 = margin;
  PLOT_X2 = width-margin;
  PLOT_Y1 = margin;
  PLOT_Y2 = height-margin;


  rSn = 47; // 29, 18;
  randomSeed(rSn);

  sigF = createFont("Helvetica", 12, true);  //requires a font file in the data folder?

  tileW = width/xDim;
  tileH = height/yDim;

  noStroke();

  updateAng();
  updateBkg();
  updateFrg();
  println("setup done: " + nf(millis() / 1000.0, 1, 2));
}

void draw() {
  renderBkg();
  renderFrg();

  textFont(sigF);
  fill(0, 255);
  text("sspboyd", PLOT_X2 - textWidth("sspboyd") + margin / 2, PLOT_Y2 + margin / 2);
  fill(200);
  text("sspboyd", PLOT_X2 - textWidth("sspboyd")  + margin / 2 - 1, PLOT_Y2  + margin / 2 - 0);

  if (mousePressed) {
  }else{
    updateAng();
    updateBkg();
    updateFrg();
  }
  if (PDFOUT) exit();
}




// Perlin example
// background color - Black or White
// forground colour  - black with white outline, white with black outline
// rotation of figure - 1 of 4

// returns an array of 0-1 floats from a perlin noise field.
// the x and y values indicate the size of the grid to be filled
// zOff is the z index offset for the perlin field
float[] getNewVals(int xD, int yD){
  float[] newValArr = new float[xD*yD];
  float perXOff = 0.0;
  float perYOff = 0.0;
  perZOff += 0.01;
  for (int y = 0; y < yD; y++) {
    perYOff+=0.1;
    for (int x = 0; x < xD; x++) {
      perXOff+=0.1;
      int indx = y*xD+x;
      newValArr[indx] = noise(perXOff, perYOff, perZOff);
    }
  }
  return newValArr;
}

void updateAng() {
  float[] newVals = getNewVals(xDim, yDim);
  for (int i = 0; i < angArr.length; i++) {
    angArr[i] = newVals[i];
  }
}

void updateBkg() {
  float[] newVals = getNewVals(xDim, yDim);
  for (int i = 0; i < bkgClrArr.length; i++) {
    bkgClrArr[i] = round(newVals[i]);
  }
}


void renderBkg() {
  for (int y = 0; y < yDim; y++) {
    for (int x = 0; x < xDim; ++x) {
      // draw bkground (solid b or w clr)
      color bkgClr = color(255 * bkgClrArr[(y*xDim) + x]);
      fill(bkgClr);
      noStroke();
      rect(x * tileW, y * tileH, tileW, tileH);
    }
  }
}

void updateFrg() {
  float[] newVals = getNewVals(xDim, yDim);
  for (int i = 0; i < frgClrArr.length; i++) {
    frgClrArr[i] = round(newVals[i]);
  }
}

void renderFrg() {
  for (int y = 0; y < yDim; y++) {
    for (int x = 0; x < xDim; ++x) {
      // draw bkground (solid b or w clr)
      color frgClr = color(255 * frgClrArr[(y*xDim) + x]);
      color frgInvClr = (frgClrArr[(y*xDim) + x] > 0) ? color(0) : color(255);
      // stroke(frgInvClr);
      fill(frgClr);
      pushMatrix();
      translate(x * tileW + tileW/2, y * tileH + (tileH / 2));
      rotate(HALF_PI * (round(4.0 * angArr[(y*xDim) + x])) + QUARTER_PI);
      rect(tileW / -1, tileH / (1 / pow(PHI, 2)) / -2, tileW, tileH / (1 / pow(PHI, 1)));
      popMatrix();
    }
  }
}
void keyPressed() {
  if (key == 'S') screenCap(".tif");
}

void mousePressed() {
  // updateBkg();
  // updateFrg();
}

String generateSaveImgFileName(String fileType) {
  String fileName;
  // save functionality in here
  String outputDir = "out/";
  String sketchName = getSketchName() + "-";
  String gridSize = "grid" + xDim + yDim + "-";
  String randomSeedNum = "rS" + rSn + "-";
  String dateTimeStamp = "" + year() + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  fileName = outputDir + sketchName + dateTimeStamp + gridSize + randomSeedNum + fileType;
  return fileName;
}

void screenCap(String fileType) {
  String saveName = generateSaveImgFileName(fileType);
  save(saveName);
  println("Screen shot saved to: " + saveName);
}

String getSketchName() {
  String[] path = split(sketchPath, "/");
  return path[path.length-1];
}
