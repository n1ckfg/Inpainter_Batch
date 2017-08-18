import gab.opencv.*;
import org.opencv.photo.Photo;
import org.opencv.imgproc.Imgproc;
import processing.opengl.PGraphics2D;

int threshold = 50;
PFont font;
int fontSize = 18;
PImage src;
PGraphics2D canvas;
OpenCV opencv, mask;
boolean showOrig = false;
boolean isDirty = true;

void setup(){
  size(50, 50, P2D);
  src = loadImage("test.png");
  //initMask();
  surface.setSize(src.width*2, src.height);
  font = createFont("Arial", fontSize);
  textFont(font, fontSize);
}

void draw(){
  if (isDirty) {
    initMask();
    processMask();
    isDirty = false;
  }
  
  if (showOrig) {
    image(src, 0, 0);
  } else {
    image(opencv.getOutput(), 0, 0); 
  }
  noTint();
  image(canvas, src.width , 0);
  
  fill(255);
  text("threshold: " + threshold, fontSize, fontSize*1.5);
}

void initMask() {
  opencv = new OpenCV(this, src, true);
  canvas = (PGraphics2D) createGraphics(src.width, src.height, P2D);
  mask = new OpenCV(this, canvas.width, canvas.height);
  canvas.beginDraw();
  canvas.background(0);
  canvas.endDraw();
}

void processMask() {
 canvas.beginDraw();
 src.loadPixels();
 canvas.loadPixels();
 for (int i=0; i<canvas.pixels.length; i++) {
   if (red(src.pixels[i]) <= threshold) {
     canvas.pixels[i] = color(255);
   } else {
     canvas.pixels[i] = color(0);
   }
 }  
 canvas.updatePixels();
 canvas.endDraw();
 
 mask.loadImage(canvas);
 Imgproc.cvtColor(opencv.getColor(), opencv.getColor(), Imgproc.COLOR_BGRA2BGR);
 Photo.inpaint(opencv.getColor(), mask.getGray(), opencv.getColor(), 5.0, Photo.INPAINT_NS);
 Imgproc.cvtColor(opencv.getColor(), opencv.getColor(), Imgproc.COLOR_BGR2BGRA);
}

void keyPressed() {
  if (keyCode == UP) {
    threshold++;
    if (threshold > 255) threshold = 255;
    isDirty = true;
  } 
  
  if (keyCode == DOWN) {
    threshold--;
    if (threshold < 0) threshold = 0;
    isDirty = true;
  } 
  
  if (key == ' ') {
    showOrig = !showOrig;
  }
}