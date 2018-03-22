PFont font;
int fontSize = 18;
boolean showOrig = false;
Settings settings;

void setup(){
  size(50, 50, P2D);
  settings = new Settings("settings.txt");
  font = createFont("Arial", fontSize);
  textFont(font, fontSize);
  fileSetup();
  surface.setSize(img.width*2, img.height);
}

void draw(){
  fileFirstRun();
  
  initMask();
  processMask();

  image(targetImg, 0, 0); 
  image(canvas, img.width , 0);
  
  fill(255);
  text("threshold: " + threshold, fontSize, fontSize*1.5);
  
  fileLoop();
}
