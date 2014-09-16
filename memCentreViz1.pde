import processing.pdf.*;

//Declare Globals
final float PHI = 0.618033989;

// Declare Font Variables
PFont mainTitleF;

boolean PDFOUT = false;

// Declare Layout Variables
float margin;
float PLOT_X1, PLOT_X2, PLOT_Y1, PLOT_Y2, PLOT_W, PLOT_H;

void setup() {
  background(255);
  if (PDFOUT) {
    size(750, 750, PDF, generateSaveImgFileName(".pdf"));
  }
  else {
    size(750, 750); // quarter page size
  }

  margin = width * pow(PHI, 6);
  println("margin: " + margin);
  PLOT_X1 = margin;
  PLOT_X2 = width-margin;
  PLOT_W = PLOT_X2 - PLOT_X1;
  PLOT_Y1 = margin;
  PLOT_Y2 = height-margin;
  PLOT_H = PLOT_Y2 - PLOT_Y1;

  mainTitleF = createFont("Helvetica", 18);  //requires a font file in the data folder?
  // smooth();
  println("setup done: " + nf(millis() / 1000.0, 1, 2));
}

void draw() {
  background(250);
  textFont(mainTitleF);
  text("sspboyd", PLOT_X2-textWidth("sspboyd"), PLOT_Y2-textAscent());

  int sqrM = 47;
  int q = 132000;
  int dim = floor(sqrt(q / sqrM)) + 1;
  float sqrSz = PLOT_H / dim / pow(PHI,PHI);
  float sqrFill=128;

  float cx, cy;
  for (int i = 0; i < q/sqrM; i++) {
    cx = map(i%dim, 0, dim, PLOT_X1, PLOT_X2);
    cy = map(i/dim, 0, dim, PLOT_Y1, PLOT_Y2);
    pushMatrix();
      translate(cx, cy);
      float rotOff = map(noise(i+millis()/1100.0), 0, 1, -PHI * TWO_PI / 4.0, PHI * TWO_PI / 4.0); 
      float rot = map(i + millis() / 4.0, 0, dim * dim, 0, TWO_PI);
      rotate(rot + rotOff);
      // rotate(rotOff);
      // sqrFill += map((rot + rotOff) % TWO_PI, 0, TWO_PI, -123, 123);
      // rectMode(CENTER);
      strokeWeight(.5);
      stroke(200,250);
      // fill(sqrFill);
      fill(4, 180);
      // noFill();
      rect(0,0,sqrSz*pow(PHI,3),sqrSz/PHI);
    popMatrix();
  }
  if (PDFOUT) exit();
}


// Boilerplate Utility stuff...
void keyPressed() {
  if (key == 'S') screenCap(".tif");
}

String generateSaveImgFileName(String fileType) {
  String fileName;
  // save functionality in here
  String outputDir = "out/";
  String sketchName = getSketchName() + "-";
  String dateTimeStamp = "" + year() + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + "-";
  fileName = outputDir + sketchName + dateTimeStamp + fileType;
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