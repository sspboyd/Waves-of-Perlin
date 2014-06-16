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

float perXOff = 0.0;
float perYOff = 0.0;
float perZOff = 0.0;

final int xDim = 20;
final int yDim = 20;

// size of board 10x10
int boardLength = xDim * yDim;

int[] bkgClrArr = new int[boardLength];
int[] frgClrArr = new int[boardLength];
int[] angArr = new int[boardLength];
float tileW, tileH;



/*////////////////////////////////////////
 SETUP
 ////////////////////////////////////////*/

void setup() {
  background(255);
  if (PDFOUT) {
    size(800, 450, PDF, generateSaveImgFileName(".pdf"));
  }
  else {
    size(600, 600); // quarter page size
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

  updateBkg();
  updateFrg();
  println("setup done: " + nf(millis() / 1000.0, 1, 2));
}

// Perlin example
// background color - Black or White
// forground colour  - black with white outline, white with black outline
// rotation of figure - 1 of 4

void updateBkg() {
  for (int i = 0; i < bkgClrArr.length; i++) {
    perXOff += 0.1;
    bkgClrArr[i] = round(noise(perXOff));
  }
}


void renderBkg() {
  for (int y = 0; y < yDim; y++) {
    for (int x = 0; x < xDim; ++x) {
      // draw bkground (solid b or w clr)
      color bkgClr = color(255 * bkgClrArr[(y*xDim) + x]);
      fill(bkgClr);
      rect(x * tileW, y * tileH, tileW, tileH);
    }
  }
}

void updateFrg() {
  for (int i = 0; i < frgClrArr.length; i++) {
    perYOff += 0.1;
    frgClrArr[i] = round(noise(perXOff, perYOff));
  }
}

void renderFrg() {
  for (int y = 0; y < yDim; y++) {
    for (int x = 0; x < xDim; ++x) {
      // draw bkground (solid b or w clr)
      color frgClr = color(255 * frgClrArr[(y*xDim) + x]);
      fill(frgClr);
      pushMatrix();
      translate(x * tileW + tileW/2, y * tileH + (tileH / 2));
      rotate(PI + QUARTER_PI);
      rect(tileW / -2, tileH / (1 / pow(PHI, 2)) / -2, tileW, tileH / (1 / pow(PHI, 2)));
      popMatrix();
    }
  }
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
    // updateBkg();
    // updateFrg();
  }
  if (PDFOUT) exit();
}

void keyPressed() {
  if (key == 'S') screenCap(".tif");
}

void mousePressed() {
  updateBkg();
  updateFrg();
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
