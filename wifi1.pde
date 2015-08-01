import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.data.*;



class  DataPoint {
  Location location;  
  String sessionId;
  float Accuracy;
  float SingalLevel;
  
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
    DataValue.Accuracy = dataPointRow.getFloat("Accuracy");
    DataValue.SingalLevel = Math.abs(dataPointRow.getFloat("SingalLevel"));
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
   
    if (DataValue.SingalLevel>80){
      fill(255, 0, 0, 30);
     }
     if (DataValue.SingalLevel<80){
      fill(255, 255, 0, 50);
     }
     if (DataValue.SingalLevel<75){
      fill(170, 255, 0, 80);
      }
     if (DataValue.SingalLevel<=65){
      fill(0, 255, 0, 100);
      }
     
     
      
    // do not display Points with an Accuracy > 5m
    if (DataValue.Accuracy>5){
      fill(255, 0,255,0);
     }
   
     
    ellipse(pos.x, pos.y, 5, 5);
    
      if (DataValue.showLabel) {
      fill(200);
      text(DataValue.SingalLevel, pos.x - textWidth(str(DataValue.SingalLevel))/2, pos.y);
    }  
  }
}

void mouseClicked() {
  // Simple way of displaying bike station names. Use markers for single station selection.
  for (DataPoint DataValue : datapoints) {
    DataValue.showLabel = false;
    ScreenPosition pos = map.getScreenPosition(DataValue.location);
    if (dist(pos.x, pos.y, mouseX, mouseY) < 10) {
      DataValue.showLabel = true;
    }
  }
}
