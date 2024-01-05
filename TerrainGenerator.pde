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


float wave1Progress = 0;
float wave1Speed = 1;
float wave1SpeedHigh = 4;
float wave1SpeedLow = 0.1;
float wave1Opacity = 0;
float wave1PauseTimer = 0;

void drawTerrain(){
  for(int y=0;y<height;y+=gridSize){
    for(int x=0;x<width;x+=gridSize){
      
      //where the magic happens
      float noiseVal = noise((x+xOff*gridSize)/resolution,(y+yOff*gridSize)/resolution);
      
      if(noiseVal<0.5){
        fill(#08C8E5);
        
        if (wave1Progress<50){
          wave1Opacity=map(wave1Progress,0,50,0,200);
        }
        else{
          wave1Opacity=map(wave1Progress,50,100,200,100);
        }
        
        
        if(noiseVal>map(wave1Progress,0,100,0.43,0.46) && noiseVal<map(wave1Progress,0,100,0.50,0.50)){
          fill(#08C8E5);
          rect(x,y,gridSize,gridSize);
          fill(209,242,240,wave1Opacity);
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
  
  if(wave1PauseTimer==0){
    wave1Progress += wave1Speed;
  }
  else{
    wave1PauseTimer-=1;
  }
  
  if(wave1Progress>100){wave1Progress = 0; wave1PauseTimer = 20;}
  
  
  if(wave1Progress<85){wave1Speed = map(wave1Progress,0,85,1,2);}
  else{wave1Speed = map(wave1Progress,85,100,2,1);}
  
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
