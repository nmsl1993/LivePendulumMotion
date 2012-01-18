import controlP5.*;
import javax.swing.SwingUtilities;
float g = 9.81;
float l = 1;
float mass = 1.0;

float dt = 0.01; 
float timeMin = 0.0;
float timeMax = 2.84;
float theta_not = radians(10);

float theta = theta_not;
float thetaPrime = 0;
float thetaDoublePrime = (-1 * G / l) * sin(theta);

float fakeTheta = theta_not;
float fakeThetaPrime = 0;
float fakeThetaDoublePrime = (-1 * G / l) * sin(theta);


//float thetaDoublePrime = 0;
float omega = sqrt(g/l);
int xOffset, yOffset;
float circleR = 30;
float x = 0;
float y = 0;
float damnped = .995f;
PendulumChartDynamic PCD;
ChartBuffer chartBuffer;
int count = 0;
boolean enableSHOPendulum = true;
ControlP5 controlP5;
Textfield degreesTextfield;

void setup() {
  size(250, 250);
  this.setLocation(500,500);
  frameRate(25);
    //frameRate(100);
  xOffset = width/2;
  yOffset = height/4;
  //noSmooth();
  smooth();
   PCD = new PendulumChartDynamic("Pendulum Angle vs Time");
  PCD.pack();
  PCD.setLocation(screenWidth/3, screenHeight/3);
  //RefineryUtilities.centerFrameOnScreen(PCD);
  PCD.setVisible(true);
// setupChartBuffer();

  controlP5 = new ControlP5(this);
  degreesTextfield = controlP5.addTextfield("Degrees", 10,30,40,20);
  degreesTextfield.setText(Float.toString(round(degrees(theta_not))));
}

void setupChartBuffer()
{
  chartBuffer = new ChartBuffer(PCD, 100L);
  chartBuffer.start();
  print("herro");
  //SwingUtilities.invokeLater(chartBuffer);
 }
 
void controlEvent(ControlEvent theEvent) {
  if(theEvent.controller().equals(degreesTextfield))
  {
   theta_not = radians(parseFloat(degreesTextfield.getText()));
   print(theta_not);
  }
}
void draw() {
  background(0);
  updatePendulum();
  x = 100*(l * sin(theta));
  y = 100*(l * cos(theta));
  //println(theta);
  //println("x: " + x + " y: " + y);
  stroke(255, 31, 31, 255);
  fill(255, 31, 31, 255);
  line(xOffset, yOffset, x+xOffset, y+yOffset);
  ellipse(x+xOffset, y+yOffset, circleR, circleR);
  PCD.addTheta(degrees(theta), count/(float)frameRate);
  //chartBuffer.addPoint(degrees(theta), count/(float)frameRate);
  count++;
  if(enableSHOPendulum)
  {
    updateSHOPendulum();
    PCD.addFakeTheta(degrees(fakeTheta), count/(float)frameRate);

    float fakeX = 100*(l * sin(fakeTheta));
    float fakeY = 100*(l * cos(fakeTheta));
    stroke(74, 17, 211, 255);
  fill(74, 17, 211, 120);
  line(xOffset, yOffset, fakeX+xOffset, fakeY+yOffset);
  ellipse(fakeX+xOffset, fakeY+yOffset, circleR, circleR);
  
  }
  
}
void updateSHOPendulum()
{
  fakeThetaDoublePrime = (-1 * G / l) *(fakeTheta);
  fakeThetaPrime += fakeThetaDoublePrime*dt;
  //thetaPrime *= damnped;
  fakeTheta += fakeThetaPrime*dt;
}
void updatePendulum()
{
  thetaDoublePrime = (-1 * G / l) * sin(theta);
  thetaPrime += thetaDoublePrime*dt;
  //thetaPrime *= damnped;
  theta += thetaPrime*dt;
}

