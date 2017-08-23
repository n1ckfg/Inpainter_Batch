import gab.opencv.*;
import org.opencv.photo.Photo;
import org.opencv.imgproc.Imgproc;
import processing.opengl.PGraphics2D;

int threshold = 50;
boolean flipVertical = false;
PFont font;
int fontSize = 18;
//PImage img;
PGraphics2D canvas;
OpenCV opencv, mask;
boolean showOrig = false;
//boolean isDirty = true;
Settings settings;

void setup(){
  size(50, 50, P2D);
  settings = new Settings("settings.txt");
  //img = loadImage("test.png");
  //initMask();
  font = createFont("Arial", fontSize);
  textFont(font, fontSize);
  fileSetup();
  surface.setSize(img.width*2, img.height);
}

void draw(){
  fileFirstRun();
  
  initMask();
  processMask();
  
  targetImg.beginDraw();
  targetImg.image(opencv.getOutput(),0,0);
  targetImg.endDraw();

  image(targetImg, 0, 0); 
  image(canvas, img.width , 0);
  
  fill(255);
  text("threshold: " + threshold, fontSize, fontSize*1.5);
  
  fileLoop();
}

void initMask() {
  opencv = new OpenCV(this, img, true);
  canvas = (PGraphics2D) createGraphics(img.width, img.height, P2D);
  mask = new OpenCV(this, canvas.width, canvas.height);
  canvas.beginDraw();
  canvas.background(0);
  canvas.endDraw();
}

void processMask() {
 canvas.beginDraw();
 img.loadPixels();
 canvas.loadPixels();
 for (int i=0; i<canvas.pixels.length; i++) {
   if (red(img.pixels[i]) <= threshold) {
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