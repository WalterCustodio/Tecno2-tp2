class Fondo {
  PImage lado_izq_img;
  PImage lado_der_img;
  PImage lado_sup_izq_img;
  PImage lado_sup_der_img;
  PImage lado_inf_izq_img;
  PImage lado_inf_der_img;

  int distanciaX, distanciaY;
  int cantidadX, cantidadY;

  FWorld mundo;
  FBox lado_izq;
  FBox lado_der;
  FBox caja_inf_izq;
  FBox caja_inf_der;
  FBox caja_sup_izq;
  FBox caja_sup_der;

  int largo_cancha = 720;
  int ancho_cancha = 340;
  int ancho_fondo_cancha = 155;


  Fondo(FWorld mundo_) {
    lado_izq_img = loadImage("lado_izq.png");
    lado_der_img = loadImage("lado_der.png");
    lado_sup_izq_img = loadImage("lado_sup_izq.png");
    lado_sup_der_img = loadImage("lado_sup_der.png");
    lado_inf_izq_img = loadImage("lado_inf_izq.png");
    lado_inf_der_img = loadImage("lado_inf_der.png");

    mundo = mundo_;

    caja_sup_izq = new FBox(ancho_fondo_cancha, 5);
    caja_sup_izq.setPosition(125, 90);
    caja_sup_izq.setStatic(true);
    caja_sup_izq.attachImage(lado_sup_izq_img);

    caja_sup_der = new FBox(ancho_fondo_cancha, 5);
    caja_sup_der.setPosition(370, 90);
    caja_sup_der.setStatic(true);
    caja_sup_der.attachImage(lado_sup_der_img);

    caja_inf_izq = new FBox(ancho_fondo_cancha, 5);
    caja_inf_izq.setPosition(125, 808);
    caja_inf_izq.setStatic(true);
    caja_inf_izq.attachImage(lado_inf_izq_img);

    caja_inf_der = new FBox(ancho_fondo_cancha, 5);
    caja_inf_der.setPosition(370, 808);
    caja_inf_der.setStatic(true);
    caja_inf_der.attachImage(lado_inf_der_img);

    lado_izq = new FBox(5, largo_cancha);
    lado_izq.setPosition(50, 450);
    lado_izq.setStatic(true);
    lado_izq.attachImage(lado_izq_img);

    lado_der = new FBox(5, largo_cancha);
    lado_der.setPosition(445, 450);
    lado_der.setStatic(true);
    lado_der.attachImage(lado_der_img);

    mundo.add(lado_der);
    mundo.add(lado_izq);
    mundo.add(caja_sup_izq);
    mundo.add(caja_sup_der);
    mundo.add(caja_inf_izq);
    mundo.add(caja_inf_der);

  }

  void inicio() {
  }
  void pantallaGanar() {
  }
  void pantallaPerder() {
  }
}
