FCircle crearTejo( float t, float g) {
  PImage tejo_img;
  tejo_img = loadImage("tejo.png");
  FCircle main = new FCircle(t);
  main.setPosition(200, 700);
  // main.setVelocity(0, 0);
  main.setNoStroke();
  main.setGrabbable(true);
  main.setRestitution(1);//indice de rebotabilidad
// FALTA ATARLO AL TIEMPO RESTANTE, MIENTRAS MENOS TIEMPO QUEDE MÁS PISADA ES EL TEJO
  main.attachImage(tejo_img);
    return main;
}
