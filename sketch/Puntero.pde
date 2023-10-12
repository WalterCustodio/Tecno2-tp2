class Puntero {

  float id;
  float x;
  float y;
  float xMap;
  float yMap;
  PImage controlador_img;
  float xAmortiguado;
  float yAmortiguado;
  float diametro;

  float limiteX = 450;
  float limiteY = 800;


  FWorld mundo;
  FCircle controlador;
  FMouseJoint manija;

  Puntero(FWorld mundo_, int id_, float x_, float y_) {
    mundo = mundo_;
    diametro= 45;
    controlador_img = loadImage("controlador.png");


    xMap = map(x_, 0, width, 0, limiteX);
    yMap = map(y_, 0, height, 50, limiteY);
    controlador = new FCircle (diametro);
    controlador.setPosition(xMap, yMap);
    controlador.attachImage(controlador_img);
    controlador.setNoStroke();
    controlador.setFill(255, 0, 0);
    controlador.setRestitution(0.2);
    id = id_;
    manija = new FMouseJoint(controlador, xMap, yMap);

    mundo.add(controlador);
    mundo.add(manija);
  }
  void setTarget(float nx, float ny) {

    xMap = map(nx, 0, width, 50, limiteX);
    yMap = map(ny, 0, height, 0, limiteY);

    xAmortiguado = lerp(controlador.getX(), xMap, 0.7);
    yAmortiguado = lerp(controlador.getY(), yMap, 0.7);

    manija.setTarget(xAmortiguado, yAmortiguado);
  }
  void setID(float id) {
    this.id= id;
  }
  void borrar() {
    mundo.remove(manija);
    mundo.remove(controlador);
  }
  void dibujar() {
  }
}
