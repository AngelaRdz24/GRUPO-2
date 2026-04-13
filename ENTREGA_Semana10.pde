PShape[] iconos = new PShape[4];
String[] nombres = {"pintar.svg", "borrador.svg", "geom.svg", "limpiar.svg"};

int herramienta = -1, forma = 0;
ArrayList<Forma> formas = new ArrayList<Forma>();
Forma actual = null;

float h = 0, s = 255, b = 255;
boolean dragH = false, dragS = false;

void setup() {
  size(1000, 1000);
  colorMode(HSB, 255);
  for (int i = 0; i < 4; i++) iconos[i] = loadShape(nombres[i]);
}

void draw() {
  background(255);

  for (Forma f : formas) f.mostrar();

  for (int y = 150; y < height-30; y++) {
    stroke(map(y,150,height-30,0,255),255,255);
    line(20,y,50,y);

    stroke(h,map(y,150,height-30,0,255),255);
    line(60,y,90,y);
  }

  noFill(); stroke(0);
  rect(20,map(h,0,255,150,height-30)-3,30,6);
  rect(60,map(s,0,255,150,height-30)-3,30,6);

  fill(h,s,b);
  ellipse(120,height/2,40,40);

  fill(#896D8C); noStroke();
  rect(20,20,width-40,100,20);

  for (int i = 0; i < 4; i++) {
    float x = 65 + i*90;
    float t = (dist(mouseX,mouseY,x,70)<30 || herramienta==i)?80:60;

    fill(#A698AE);
    ellipse(x,70,t,t);
    shape(iconos[i],x-t/2,70-t/2,t,t);
  }

  // MENÚ FORMAS
  if (herramienta==2) {
    for (int i = 0; i < 8; i++) {
      float x = 65 + 4*90 + i*70;
      float t = (dist(mouseX,mouseY,x,70)<25 || forma==i)?70:50;

      fill(255); ellipse(x,70,t,t);
      stroke(0); noFill();
      float e = t*0.3;

      if (i==0) ellipse(x,70,e*2,e*2);
      else if (i==1) line(x-e,70+e,x+e,70-e);
      else if (i==2) poligono(x,70,3,e);
      else if (i==3) {rectMode(CENTER); rect(x,70,e*2,e*2); rectMode(CORNER);}
      else if (i==4) {rectMode(CENTER); rect(x,70,e*2.5,e*1.5); rectMode(CORNER);}
      else poligono(x,70,i,e);

      noStroke();
    }
  }
}

void mousePressed() {
  boolean ui = false;

  // sliders
  if (mouseX>20&&mouseX<50&&mouseY>150&&mouseY<height-30) {dragH=true; h=map(mouseY,150,height-30,0,255); ui=true;}
  if (mouseX>60&&mouseX<90&&mouseY>150&&mouseY<height-30) {dragS=true; s=map(mouseY,150,height-30,0,255); ui=true;}

  for (int i=0;i<4;i++) {
    if (dist(mouseX,mouseY,65+i*90,70)<40) {
      herramienta=i; 
      ui=true;
      //Si el boton es limpiar
      if( i == 3){
        formas.clear();
      }
    }
  }

  if (herramienta==2) {
    for (int i=0;i<8;i++) {
      if (dist(mouseX,mouseY,65+4*90+i*70,70)<35) {forma=i; ui=true;}
    }
  }

  if (!ui && herramienta==2 && mouseY>140) {
    actual = new Forma(mouseX,mouseY,forma,color(h,s,b));
    formas.add(actual);
  }
}

void mouseDragged() {
  if (dragH) h = constrain(map(mouseY,150,height-30,0,255),0,255);
  else if (dragS) s = constrain(map(mouseY,150,height-30,0,255),0,255);
  else if (actual!=null) actual.actualizar(mouseX,mouseY);
}

void mouseReleased() {
  dragH = dragS = false;
  actual = null;
}

void poligono(float x,float y,int lados,float r) {
  beginShape();
  for (int i=0;i<lados;i++) {
    float a = TWO_PI*i/lados;
    vertex(x+cos(a)*r,y+sin(a)*r);
  }
  endShape(CLOSE);
}

// CLASE
class Forma {
  float x,y,t=0;
  int tipo;
  color c;

  Forma(float x,float y,int tipo,color c){
    this.x=x; this.y=y; this.tipo=tipo; this.c=c;
  }

  void actualizar(float mx,float my){
    t = dist(x,y,mx,my);
  }

  void mostrar(){
    fill(c); noStroke();

    if (tipo==0) ellipse(x,y,t*2,t*2);
    else if (tipo==1) {stroke(c); line(x-t,y+t,x+t,y-t); noStroke();}
    else if (tipo==2) poligono(x,y,3,t);
    else if (tipo==3) {rectMode(CENTER); rect(x,y,t*2,t*2); rectMode(CORNER);}
    else if (tipo==4) {rectMode(CENTER); rect(x,y,t*2.5,t*1.5); rectMode(CORNER);}
    else poligono(x,y,tipo,t);
  }
}
