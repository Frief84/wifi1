import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.data.*;



class  DataPoint {
  Location location;  
  String sessionId;
  String Accuracy;
  String SingalLevel;
  
  // Indicates whether to show the name as label
  boolean showLabel;

// override toString() for better debugging
 @Override  
public String toString() {
  return getClass().getSimpleName() + "[location=" + location + "]" + "[sessionId=" + sessionId + "]"+ "[Accuracy=" + Accuracy + "]"+ "[SingalLevel=" + SingalLevel + "].........";
  }
}


// Url to CSV Datasource
//String src_Url = "http://www.frief.de/heatmap/testrun_data_potsdam.csv"
String src_Url = "testrun_data_test.csv"; // in case CSV_URL
String DataFile = src_Url;

UnfoldingMap map;

ArrayList <DataPoint> datapoints = new ArrayList();



void setup() {
  
  size(800, 600, P2D);
  smooth();
  
 // Create interactive map centered around Potsdam
  map = new UnfoldingMap(this);
  map.zoomAndPanTo(16, new Location(52.402129, 13.049753));
  MapUtils.createDefaultEventDispatcher(this, map);
  map.setTweening(true);
  
   // Load CSV data
  Table DataCSV = loadTable(DataFile, "header, csv");
  
  for (TableRow dataPointRow : DataCSV.rows()) {
    
    // Create new empty object to store data
    DataPoint DataValue = new DataPoint();
    
    // Read data from CSV
    DataValue.sessionId = dataPointRow.getString("sessionId");
    DataValue.Accuracy = dataPointRow.getString("Accuracy");
    DataValue.SingalLevel = dataPointRow.getString("SingalLevel");
    float lat = dataPointRow.getFloat("Latitude");
    float lng = dataPointRow.getFloat("Longitude");
    DataValue.location=new Location(lat, lng);
    
    datapoints.add(DataValue);
    
   
  }
   println( DataCSV.getRowCount()+" datarows read");
   printArray(datapoints.size());
   //System.out.println(datapoints);
       
}
 

void draw() {
  map.draw();
  fill(0, 100);
  rect(0, 0, width, height);
  noStroke();
//  System.out.println(datapoints);
  for (DataPoint DataValue : datapoints) {
    // Convert geo locations to screen positions
    ScreenPosition pos = map.getScreenPosition(DataValue.location);
 
   //float s = map(DataValue.SingalLevel, 0, 100, 0, 255);
    
    fill(255, 0, 0, 50);
    ellipse(pos.x, pos.y, 10, 10);
     
  }

  

}
