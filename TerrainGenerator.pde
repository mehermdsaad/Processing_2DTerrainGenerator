int gridSize = 10;
float resolution = 240;

float xOff = 0;
float yOff = 0;



void setup(){
  size(1200,800);
  noStroke();
}

void draw(){
  background(0);
  drawTerrain();
  
  textMode(RIGHT);
  fill(20,100);
  rect(width-140,10,125,150);
  fill(255);
  textSize(50);
  text(str(resolution),width-130,50);
  text(str(xOff),width-130,100);
  text(str(yOff),width-130,150);
  
  noFill();
  stroke(255,0,0);
  rect(int(mouseX/gridSize)*gridSize,int(mouseY/gridSize)*gridSize,gridSize,gridSize);
  noStroke();
}

void drawTerrain(){
  for(int y=0;y<height;y+=gridSize){
    for(int x=0;x<width;x+=gridSize){
      float noiseVal = noise((x+xOff*gridSize)/resolution,(y+yOff*gridSize)/resolution);
      
      if(noiseVal<0.5){fill(#0D545C);}
      else if(noiseVal<0.6){fill(#8F7E5F);}
      else if(noiseVal<0.7){fill(#6A7F3F);}
      else if(noiseVal<1){fill(#2C3D05);}
      rect(x,y,gridSize,gridSize);
    }
  }
}






void keyPressed(){
  if(key=='r'){
    resolution=240;
    xOff = 0 ;
    yOff = 0;
    
  }
  if(key==' '){
    noiseSeed(millis());
  }
  
  if(keyCode == LEFT){xOff-=1;}
  if(keyCode == RIGHT){xOff+=1;}
  if(keyCode == UP){yOff-=1;}
  if(keyCode == DOWN){yOff+=1;}
  
  if(key == 'p'){println(resolution);}
}

void mouseWheel(MouseEvent event){
  if(event.getCount()>0){
    resolution+=5;
    xOff+=(resolution/(resolution-5)-1)*int(mouseX/gridSize+xOff);
    yOff+=(resolution/(resolution-5)-1)*int(mouseY/gridSize+yOff);
  }

  if(event.getCount()<0){
    resolution-=5;
    xOff-=(resolution/(resolution-5)-1)*int(mouseX/gridSize+xOff);
    yOff-=(resolution/(resolution-5)-1)*int(mouseY/gridSize+yOff);
  }
}


void mouseDragged(){
  xOff-=((mouseX-pmouseX)/gridSize);
  yOff-=((mouseY-pmouseY)/gridSize);
}
