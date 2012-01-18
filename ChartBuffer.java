import java.util.Vector;
import java.util.concurrent.*;
import java.nio.*;
public class ChartBuffer extends Thread
{

  Vector<Float> degrees = new Vector<Float>();
  Vector<Float> times = new Vector<Float>();
  PendulumChartDynamic PCD;
  long paused;
  public ChartBuffer(PendulumChartDynamic pcd, long pause)
  {
    PCD = pcd;
    paused = pause;
  }
  public void  addPoint(float degs, float time)
  {
    degrees.add(degs);
    times.add(time);
  }
  public void run() {
    try {
      while (true) {
        float[][] pairs = new float[degrees.capacity()][2];
        int i = 0;
        while (i < degrees.size())
        {
          pairs[i][0] = degrees.get(i);
          pairs[i][1] = times.get(i);
          i++;
        }
        PCD.addThetas(pairs);
        degrees.clear();
        times.clear();
        Thread.sleep(paused);
      }

      
      //        /System.out.println("her");
    } 
    catch (InterruptedException iex) {
      iex.printStackTrace();
    }
  }
}
class PendulumPoint
{
  float degrs;
  float tim;
  public PendulumPoint(float degs, float time)
  {
    degrs = degs;
    tim = time;
  }
  public float getDegrees()
  {
    return degrs;
  }
  public float getTime()
  {
    return tim;
  }
  public float[] getPair()
  {
    float[] f = {degrs, tim};
    return f;
  }
}

