class Contadores {
  int limiteTiempo;
  PFont font;
  float segundos;
  int time;
  float tiempoDamping;

  Contadores() {

    font = createFont("PressStart2P-Regular.ttf", 30);
    textAlign(CENTER, CENTER);
    noFill();
    stroke(200);
    strokeWeight(5);
    time = 1;
  }

  void tiempo(int limite_, int x_, int y_) {
    int limiteTiempo = limite_;
    segundos = frameCount/60;

    tiempoDamping = map(time, 30, 0, 0.4, 4);


    push();
    textFont(font);
    fill(55);
    rect(x_, y_, 100, 100);
    /*                   -----------CONDICIONES PARA EL CAMBIO DE COLOR DEL RELOJ
     */
    if (time > 30) {



      fill(255);
    } else if (time > 10 && time <= 30) {
     // println(tiempoDamping);
      tejo.setDamping(tiempoDamping);
      fill(255, 255, 0);
    } else {
      tejo.setDamping(tiempoDamping);
     // println(tiempoDamping);
      fill(255, 0, 0);
    }
    text(time, x_+50, y_+50);
    pop();
    /*                   -----------CONDICIÓN PARA FRENAR EL RELOJ
     */

    if (time > 0) {
      time = int(limiteTiempo - segundos);
    } else {
      time = 0;
    }
  }

  void marcador(int goles_, int x_, int y_) {
    push();
    fill (0, 255, 0);
    text("GOLES", x_, y_-50);
    text(goles_, x_, y_);
    pop();
  }
}
