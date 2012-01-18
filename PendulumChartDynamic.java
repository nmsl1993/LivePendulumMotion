
import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JPanel;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.plot.XYPlot;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;
import org.jfree.data.xy.XYDataset;

import org.jfree.ui.ApplicationFrame;
import org.jfree.ui.RefineryUtilities;
import org.jfree.chart.plot.PlotOrientation;

/**
 * A demonstration application showing a time series chart where you can dynamically add
 * (random) data by clicking on a button.
 *
 */
public class PendulumChartDynamic extends ApplicationFrame{

  
    private XYSeries thetaVsTime;
    private XYSeries fakeThetaVsTime;
    private XYSeriesCollection data;
    public PendulumChartDynamic(final String title) {
        super(title);
        thetaVsTime = new XYSeries("Theta vs Time");
        fakeThetaVsTime = new XYSeries("SHOTheta vs Time");
        //thetaVsTime.setMaximumItemCount(50);
        //thetaVsTime.add(1.0, 500.2);
        data = new XYSeriesCollection(thetaVsTime);
        data.addSeries(fakeThetaVsTime);
        JFreeChart chart = ChartFactory.createXYLineChart(
            title,
            "Time (Seconds)",
            "Amplitude (Degrees)",
            data,
            PlotOrientation.VERTICAL,
            false,
            false,
            false
        );
        final ChartPanel chartPanel = new ChartPanel(chart);
        chartPanel.setPreferredSize(new java.awt.Dimension(500, 270));
        setContentPane(chartPanel);
    }
    
     public synchronized void addFakeTheta(float degs, float time)
    {
      this.fakeThetaVsTime.add(time, degs);
      //data.setXPosition(time);
    }
    public synchronized void addTheta(float degs, float time)
    {
      this.thetaVsTime.add(time, degs);
      //data.setXPosition(time);
    }
    
    public synchronized void addThetas(float[][] data)
    {
     for(int i = 0; i < data.length; i ++)
     { 
       if( i + 1 == data.length)
       {
                  System.out.println("yes");

         this.thetaVsTime.add(data[i][1], data[i][0], true);
       }
       else
       {
         System.out.println("no");
       this.thetaVsTime.add(data[i][1], data[i][0], false);
       }
     }
    }
    /*
    public void actionPerformed(final ActionEvent e) {
        if (e.getActionCommand().equals("ADD_DATA")) {
            final double factor = 0.90 + 0.2 * Math.random();
            this.lastValue = this.lastValue * factor;
            final Millisecond now = new Millisecond();
            System.out.println("Now = " + now.toString());
            this.series.add(new Millisecond(), this.lastValue);
        
    }
    */
}








           
