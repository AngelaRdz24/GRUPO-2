
Table datos;
int nDatos;

int[] voteCount;
float[] voteAverage;
String[] originalTitle;

float[] x, y, size;

PShape gear;
PImage cartel;
PFont fuente;

int hoveredIndex = -1;

void setup() {
  size(1000, 1000);

  datos = loadTable("movies.csv", "header");
  nDatos = datos.getRowCount();

  voteCount = new int[nDatos];
  voteAverage = new float[nDatos];
  originalTitle = new String[nDatos];

  x = new float[nDatos];
  y = new float[nDatos];
  size = new float[nDatos];

  gear = loadShape("gear.svg");
  cartel = loadImage("Titulopelicula.png");
  fuente = createFont("BebasNeue-Regular.ttf", 28);

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

    // Más rating = más arriba
    y[i] = map(voteAverage[i], 0, maxRating, height - 50, 80);

    // Más votos = más grande (50 a 100 px)
    size[i] = map(voteCount[i], 0, maxVotes, 50, 100);
  }
}

void draw() {
  background(0);
  shapeMode(CENTER);

  hoveredIndex = -1;

  // Dibujar engranajes
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
    shape(gear, 0, 0, s, s);
    popMatrix();
  }

  // Texto superior centrado
  if (hoveredIndex != -1) {
    fill(0);
    textAlign(CENTER);
    textFont(fuente);

    imageMode(CENTER);
    image(cartel, width/2, 150, 500, 300);

    textSize(24);
    text(originalTitle[hoveredIndex], width/2, 75);

    textSize(16);
    text(voteCount[hoveredIndex] + " votes", width/2, 105);
  }
}
