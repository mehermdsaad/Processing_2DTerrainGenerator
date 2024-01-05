int gridSize = 6;
float resolution = 240;

float xOff = 0+10000;
float yOff = 0+10000;

int scrollSpeed = 3;

//Using time for unique screenshot name
import java.time.LocalDate;

void setup(){
  size(1200,800);
  noStroke();
}

void draw(){
  background(0);
  drawTerrain();
  
  // text feedback mostly for debugging purposes
  textMode(RIGHT);
  fill(20,100);
  rect(width-140,10,125,150);
  fill(255);
  textSize(50);
  //resolution
  text(str(resolution),width-130,50);
  //x-Offset
  text(str(xOff),width-130,100);
  //y-Offset
  text(str(yOff),width-130,150);
  
  //mouse hover on the cell in grid
  noFill();
  stroke(255,0,0);
  rect(int(mouseX/gridSize)*gridSize,int(mouseY/gridSize)*gridSize,gridSize,gridSize);
  noStroke();
}


float waveProgress = 0;
float waveSpeed = 1;
float waveWidth = 0.05;
float waveOpacity = 0;

void drawTerrain(){
  for(int y=0;y<height;y+=gridSize){
    for(int x=0;x<width;x+=gridSize){
      
      //where the magic happens
      float noiseVal = noise((x+xOff*gridSize)/resolution,(y+yOff*gridSize)/resolution);
      
      if(noiseVal<0.5){
        fill(#08C8E5);
        
        if (waveProgress<100){
          waveOpacity=map(waveProgress,0,100,250,100);
        }
        //else if(waveProgress>50){
        //  waveOpacity=map(waveProgress,50,100,250,100);
        //}
        //else{
        //  waveOpacity = 255;
        //}
        
        
        if(noiseVal>map(waveProgress,0,100,0.43,0.46) && noiseVal<map(waveProgress,0,100,0.50,0.50)){
          fill(#08C8E5);
          rect(x,y,gridSize,gridSize);
          fill(209,242,240,waveOpacity);
        }
        if(noiseVal>0.46){
          fill(209,242,240);
        }
        
        if(noiseVal<0.3){
          fill(#2A5AAC);
        }
        
      } // Water
      else if(noiseVal<0.6){fill(#FDCF7E);} // Sand
      else if(noiseVal<0.7){fill(#A3CE49);} // Grass
      else if(noiseVal<1){fill(#16831C);}  // Forest
      
      rect(x,y,gridSize,gridSize);
    }
  }
  
  waveProgress += waveSpeed;
  if(waveProgress>=100){waveProgress=0;}
}





int timeOfFirstKey = 0;
LocalDate dateStamp = LocalDate.now();

void keyPressed(){
  
  // when 'R' is pressed, reset the defaults
  if(key=='r'){
    resolution=240;
    xOff = 10000 ;
    yOff = 10000;
    
  }
  
  // generate new landscape when SPACE is pressed 
  if(key==' '){
    noiseSeed(millis());
  }
  
  // moving through the maps
  if(keyCode == LEFT){xOff-=scrollSpeed;}
  if(keyCode == RIGHT){xOff+=scrollSpeed;}
  if(keyCode == UP){yOff-=scrollSpeed;}
  if(keyCode == DOWN){yOff+=scrollSpeed;}
  
  

    if (keyCode == 83){ // When S is pressed
        if(timeOfFirstKey == 0 || millis()-timeOfFirstKey > 1000){ //the time when the S key is pressed first 
            timeOfFirstKey=millis();
        }
        else if(millis()-timeOfFirstKey < 1000){ //When the next time S is pressed, 'i.e. double pressed' it compares if it is within a second or not
                saveFrame("img/ss"+dateStamp+"-######.jpg"); // if so then save the screenshot
                timeOfFirstKey = 0; // reset the timer
        }
    }

}

void mouseWheel(MouseEvent event){
  if(event.getCount()>0){
    resolution+=5;
    
    // where the scroll-zoom magic happens
    // makes sure that zoom is with respect to the tile highlighted by the mouse
    xOff+=(resolution/(resolution-5)-1)*int(mouseX/gridSize+xOff);
    yOff+=(resolution/(resolution-5)-1)*int(mouseY/gridSize+yOff);
  }

  if(event.getCount()<0){
    if(resolution-5>5){
      resolution-=5;
      xOff-=(1-resolution/(resolution+5))*int(mouseX/gridSize+xOff);
      yOff-=(1-resolution/(resolution+5))*int(mouseY/gridSize+yOff);
    }
  }
}


void mouseDragged(){
  // drag the map to any location using the mouse
  xOff-=((mouseX-pmouseX)/gridSize);
  yOff-=((mouseY-pmouseY)/gridSize);
}
