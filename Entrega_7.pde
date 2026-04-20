Table datos;
int nDatos;

int[] voteCount;
float[] voteAverage;
String[] originalTitle;

float[] x, y, size;

PShape gear;

int hoveredIndex = -1;

int maxVotes = 0;
float maxRating = 0;

void setup() {
  size(900, 900);
  
  datos = loadTable("movies.csv", "header");
  nDatos = datos.getRowCount();
  
  voteCount = new int[nDatos];
  voteAverage = new float[nDatos];
  originalTitle = new String[nDatos];
  
  x = new float[nDatos];
  y = new float[nDatos];
  size = new float[nDatos];
  
  gear = loadShape("gear.svg");
  gear.disableStyle(); // permitir cambiar color del svg
  
  // Leer datos
  for (int i = 0; i < nDatos; i++) {
    voteCount[i] = datos.getInt(i, "vote_count");
    voteAverage[i] = datos.getFloat(i, "vote_average");
    originalTitle[i] = datos.getString(i, "original_title");
    
    if (voteCount[i] > maxVotes) maxVotes = voteCount[i];
    if (voteAverage[i] > maxRating) maxRating = voteAverage[i];
  }
  
  // Mapear posiciones y tamaños
  for (int i = 0; i < nDatos; i++) {
    x[i] = map(i, 0, nDatos, 50, width - 50);
    y[i] = map(voteAverage[i], 0, maxRating, height - 50, 80);
    size[i] = map(voteCount[i], 0, maxVotes, 50, 100);
  }
}

void draw() {
  background(20); // fondo oscuro
  shapeMode(CENTER);
  
  hoveredIndex = -1;
  
  // Dibujar figuras
  for (int i = 0; i < nDatos; i++) {
    float d = dist(mouseX, mouseY, x[i], y[i]);
    float s = size[i];
    
    boolean hover = d < s * 0.6;
    
    if (hover) {
      s += 5;
      hoveredIndex = i;
    }
    
    pushMatrix();
    translate(x[i], y[i]);
    
    // color segun votos
    fill(getColorByVotes(voteCount[i]));
    noStroke();
    
    shape(gear, 0, 0, s, s);
    
    popMatrix();
  }
  
  // Texto superior
  if (hoveredIndex != -1) {
    fill(255);
    textAlign(CENTER);
    
    textSize(28);
    text(originalTitle[hoveredIndex], width/2, 35);
    
    textSize(16);
    text(voteCount[hoveredIndex] + " votes", width/2, 65);
  }
  
  // Dibujar leyenda
  drawLegend();
}

// Funcion de color
color getColorByVotes(int v) {
  float norm = (float)v / maxVotes;

  if (norm < 0.05) return color(100, 150, 255);
  if (norm < 0.15) return color(0, 200, 255);
  if (norm < 0.30) return color(0, 255, 150);
  if (norm < 0.50) return color(255, 220, 0);
  if (norm < 0.75) return color(255, 140, 0);
  return color(255, 50, 50);
}

// Leyenda visual
void drawLegend() {
  int x0 = 20;
  int y0 = height - 180;
  int w = 20;
  int h = 20;
  int spacing = 25;
  
  fill(255);
  textSize(12);
  textAlign(LEFT);
  text("Vote Count", x0, y0 - 10);
  
  // colores
  fill(100, 150, 255);
  rect(x0, y0, w, h);
  fill(255);
  text("Muy bajo", x0 + 30, y0 + 15);
  
  fill(0, 200, 255);
  rect(x0, y0 + spacing, w, h);
  fill(255);
  text("Bajo", x0 + 30, y0 + spacing + 15);
  
  fill(0, 255, 150);
  rect(x0, y0 + spacing*2, w, h);
  fill(255);
  text("Medio", x0 + 30, y0 + spacing*2 + 15);
  
  fill(255, 220, 0);
  rect(x0, y0 + spacing*3, w, h);
  fill(255);
  text("Alto", x0 + 30, y0 + spacing*3 + 15);
  
  fill(255, 140, 0);
  rect(x0, y0 + spacing*4, w, h);
  fill(255);
  text("Muy alto", x0 + 30, y0 + spacing*4 + 15);
  
  fill(255, 50, 50);
  rect(x0, y0 + spacing*5, w, h);
  fill(255);
  text("Extremo", x0 + 30, y0 + spacing*5 + 15);
}
