class Blob {

  boolean actualizado;
  boolean entro;
  boolean salio;

  int vida;

  int ultimaActualizacion;

  int limite_tiempo_salir;

  // datos del blob
  int id;
  float age;
  float centroidX;
  float centroidY;
  float averageX;
  float averageY;
  float centerX;
  float centerY;
  float velocityX;
  float velocityY;
  float area;
  float perimeter;
  float boundingRectX;
  float boundingRectY;
  float boundingRectW;
  float boundingRectH;
  float vertexNumber;

  ArrayList <Float> contorno;

  Blob() {

    entro =  true;
    actualizado = false;
    salio = false;

    vida = 0;
    ultimaActualizacion = 0;

    limite_tiempo_salir = -5;

    id = -1;
    age = 0 ;
    centroidX = 0;
    centroidY = 0;
    averageX = 0;
    averageY = 0;
    centerX = 0;
    centerY = 0;
    velocityX = 0;
    velocityY = 0;
    area = 0;
    perimeter = 0;
    boundingRectX = 0;
    boundingRectY = 0;
    boundingRectW = 0;
    boundingRectH = 0;
    vertexNumber = 0;

    contorno = new ArrayList<Float>();
  }

  void actualizar() {
    if (vida > 0) {
      entro = false;
    }
    vida++;
    vida = vida % 100;

    salio = ultimaActualizacion == limite_tiempo_salir ? true : false;
  }
  void actualizarDatos(OscMessage m) {

    contorno.clear();

    age = m.get(1).floatValue();
    centroidX = m.get(2).floatValue();
    centroidY = m.get(3).floatValue();
    averageX = m.get(4).floatValue();
    averageY = m.get(5).floatValue();
    centerX = m.get(6).floatValue();
    centerY = m.get(7).floatValue();
    velocityX = m.get(8).floatValue();
    velocityY = m.get(9).floatValue();
    area = m.get(10).floatValue();
    perimeter = m.get(11).floatValue();
    boundingRectX = m.get(12).floatValue();
    boundingRectY = m.get(13).floatValue();
    boundingRectW = m.get(14).floatValue();
    boundingRectH = m.get(15).floatValue();
    vertexNumber = m.get(16).floatValue();

    for (int i = 17; i < m.arguments ().length; i++) {
      contorno.add(m.get(i).floatValue());
    }
  }

  void setID( int id) {
    this.id = id;
  }

  void dibujar(float w, float h) {

    // Centro - ID - Age
    float x = centerX * w;
    float y = centerY * h;

    stroke(255, 255, 0);
    pushMatrix();
    translate(x, y);
    ellipse(0, 0, 5, 5);
    stroke(255, 0, 0);
    line(0, 0, velocityX * w, velocityY * h);
    fill(0);
    text("id: " + id, 5, 5);
    text("age: " + age, 5, 15);
    popMatrix();

    // Bounding Rect
    float rx = boundingRectX * w;
    float ry = boundingRectY * h;

    noFill();
    stroke(0, 0, 255);
    pushMatrix();
    translate(rx, ry);
    rect( 0, 0, boundingRectW * w, boundingRectH * h);
    popMatrix();

    // Contorno
    stroke(0, 255, 0);
    beginShape();

    for (int i=0; i<contorno.size()-1; i+=2) {

      vertex(contorno.get(i) * w, contorno.get(i+1) * h);
    }
    endShape(CLOSE);
  }
}
