
import org.gwoptics.*;
import org.gwoptics.graphics.graph2D.traces.ILine2DEquation;
import org.gwoptics.graphics.graph2D.traces.UpdatingLine2DTrace;
import org.gwoptics.graphics.graph2D.traces.RollingLine2DTrace;

import org.gwoptics.graphics.graph2D.*;

import controlP5.*;
import javax.swing.SwingUtilities;

PFrame f;
secondApplet s;

float g = 9.81;
float l = 1;
float mass = 1.0;

float dt = 0.01; 
float timeMin = 0.0;
float timeMax = 2.84;
float theta_not = radians(10);

float theta = theta_not;
float thetaPrime = 0;
float thetaDoublePrime = (-1 * g / l) * sin(theta);

float fakeTheta = theta_not;
float fakeThetaPrime = 0;
float fakeThetaDoublePrime = (-1 * g / l) * sin(theta);


//float thetaDoublePrime = 0;
float omega = sqrt(g/l);
int xOffset, yOffset;
float circleR = 30;
float x = 0;
float y = 0;
long globalFrameRate;
float damnped = .995f;
int count = 0;
boolean enableSHOPendulum = true;
ControlP5 controlP5;
Textfield degreesTextfield;
Textfield gravityStepTextfield;


void setup() 
{
  size(400, 400);
  PFrame f = new PFrame();
  frameRate(100);
  globalFrameRate = (long)frameRate;
  //frameRate(100);
  xOffset = width/2;
  yOffset = height/4;
  //noSmooth();
  smooth();

  controlP5 = new ControlP5(this);
  degreesTextfield = controlP5.addTextfield("Degrees", 10, 30, 40, 20);
  degreesTextfield.setText(nfc(round(degrees(theta_not)), 3));
  gravityStepTextfield = controlP5.addTextfield("g = ", 10, 70, 90, 20);
  println(dt);
  gravityStepTextfield.setText(nfc(g, 2));
}
void initVariables()
{
  theta = theta_not;
  thetaPrime = 0;
  thetaDoublePrime = (-1 * g / l) * sin(theta);

  fakeTheta = theta_not;
  fakeThetaPrime = 0;
  fakeThetaDoublePrime = (-1 * g / l) * sin(theta);
  omega = sqrt(g/l);
  count = 0;

  globalFrameRate = (long)frameRate;
  s.changeGraph(false);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.controller().equals(degreesTextfield))
  {
    theta_not = radians(parseFloat(degreesTextfield.getText()));
    initVariables();
  }
  if (theEvent.controller().equals(gravityStepTextfield))
  {
    g = parseFloat(gravityStepTextfield.getText());
    initVariables();
  }
}
void draw() {
  frame.setLocation(30, 200);
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
  //PCD.addTheta(degrees(theta), count/(float)frameRate);
  count++;
  if (enableSHOPendulum)
  {
    updateSHOPendulum();
    //PCD.addFakeTheta(degrees(fakeTheta), count/(float)frameRate);

    float fakeX = 100*(l * sin(fakeTheta));
    float fakeY = 100*(l * cos(fakeTheta));
    stroke(74, 17, 211, 255);
    fill(74, 17, 211, 120);
    line(xOffset, yOffset, fakeX+xOffset, fakeY+yOffset);
    ellipse(fakeX+xOffset, fakeY+yOffset, circleR, circleR);
  }
  if (gravityStepTextfield.getText().equals("") && !gravityStepTextfield.isFocus())
  {
    gravityStepTextfield.setText(nfc(g, 2));
  }
  if (degreesTextfield.getText().equals("") && !degreesTextfield.isFocus())
  {
    degreesTextfield.setText(nfc(degrees(theta_not), 2));
  }
}
void updateSHOPendulum()
{
  fakeThetaDoublePrime = (-1 * g / l) *(fakeTheta);
  fakeThetaPrime += fakeThetaDoublePrime*dt;
  //thetaPrime *= damnped;
  fakeTheta += fakeThetaPrime*dt;
}
void updatePendulum()
{
  thetaDoublePrime = (-1 * g / l) * sin(theta);
  thetaPrime += thetaDoublePrime*dt;
  theta += thetaPrime*dt;
}
class PFrame extends Frame {
  public PFrame() {
    setBounds(screenWidth/3, 100, 750, 330);
    s = new secondApplet();
    add(s);
    s.init();
    show();
  }
}

class secondApplet extends PApplet {
  class RealPendulum implements ILine2DEquation {
    public double computePoint(double x, int pos) {
      return degrees(theta);
    }
  }
  class FakePendulum implements ILine2DEquation {
    public double computePoint(double x, int pos) {
      return degrees(fakeTheta);
    }
  }

  UpdatingLine2DTrace realPend;
  UpdatingLine2DTrace fakePend;


  //RollingLine2DTrace realPend;
  //RollingLine2DTrace fakePend;


  Graph2D g;
  public void setup() {
    size(700, 225);
    g = new Graph2D(this, this.width, this.height, false);

    g.setXAxisLabel("Time (Seconds)");
    g.setYAxisLabel("Theta (Degrees)");
    g.setXAxisTickSpacing(.5);
    g.setXAxisMax(3);
    changeGraph(true);
  }
  public void changeGraph(boolean isNew)
  {

    realPend = new UpdatingLine2DTrace(new RealPendulum(), globalFrameRate, dt);
    realPend.setTraceColour(255, 0, 0);
    fakePend = new UpdatingLine2DTrace(new FakePendulum(), globalFrameRate, dt);
    fakePend.setTraceColour(0, 0, 255);
    float thetaMax = degrees(theta_not);
    g.setYAxisMax(thetaMax);
    g.setYAxisMin(-1*thetaMax);
    g.setYAxisTickSpacing(thetaMax/5);
    g.addTrace(realPend);
    g.addTrace(fakePend);
  }
  public void draw() {
    background(255);
    translate(55, 20);
    g.draw();
  }
} 

