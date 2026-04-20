Table datos;
int nDatos;

int[] voteCount;
float[] voteAverage;
String[] originalTitle;

float[] x, y, size;

int hoveredIndex = -1;

void setup() {
  size(2000, 2000);
  
  datos = loadTable("movies.csv", "header");
  nDatos = datos.getRowCount();
  
  voteCount = new int[nDatos];
  voteAverage = new float[nDatos];
  originalTitle = new String[nDatos];
  
  x = new float[nDatos];
  y = new float[nDatos];
  size = new float[nDatos];
  
  int maxVotes = 0;
  float maxRating = 0;
  
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
  background(15, 20, 30);
  
  hoveredIndex = -1;
  
  // Dibujar palomitas
  for (int i = 0; i < nDatos; i++) {
    float d = dist(mouseX, mouseY, x[i], y[i]);
    float s = size[i];
    
    boolean hover = d < s * 0.6;
    
    if (hover) {
      s += 5;
      hoveredIndex = i;
    }
    
    drawPopcorn(x[i], y[i], s);
  }
  
  // Texto superior
  if (hoveredIndex != -1) {
    fill(255); // blanco para fondo oscuro
    textAlign(CENTER);
    
    textSize(28);
    text(originalTitle[hoveredIndex], width/2, 35);
    
    textSize(16);
    text(voteCount[hoveredIndex] + " votes", width/2, 65);
  }
}

// Palomitas con borde exterior
void drawPopcorn(float px, float py, float s) {
  pushMatrix();
  translate(px, py);
  
  // Contorno exterior
  fill(0);
  noStroke();
  drawPopcornShape(s * 1.08); // ligeramente más grande
  
  // Palomitas sin bordes internos)
  
  // Base amarilla
  fill(255, 204, 0);
  ellipse(0, s*0.2, s*0.6, s*0.5);
  
  // Parte blanca
  fill(255);
  ellipse(-s*0.2, -s*0.1, s*0.5, s*0.5);
  ellipse(0, -s*0.2, s*0.6, s*0.6);
  ellipse(s*0.2, -s*0.1, s*0.5, s*0.5);
  ellipse(0, 0, s*0.7, s*0.6);
  
  popMatrix();
}

// Forma base para generar el contorno
void drawPopcornShape(float s) {
  ellipse(0, s*0.2, s*0.6, s*0.5);
  ellipse(-s*0.2, -s*0.1, s*0.5, s*0.5);
  ellipse(0, -s*0.2, s*0.6, s*0.6);
  ellipse(s*0.2, -s*0.1, s*0.5, s*0.5);
  ellipse(0, 0, s*0.7, s*0.6);
}
