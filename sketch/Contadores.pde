class Contadores {
  int limiteTiempo = 60;
  PFont font;
  float segundos = limiteTiempo*60;
  int time = int(segundos/60);
  float tiempoDamping;
  float frameInicial;
  boolean empezoElTiempo = false;


  Contadores() {

    font = createFont("PressStart2P-Regular.ttf", 30);
    textAlign(CENTER, CENTER);
    noFill();
    stroke(200);
    strokeWeight(5);

  }

  void tiempo(int x_, int y_) {


   time = int(segundos/60);
    println(time);
    tiempoDamping = map(time, 60, 0, 0.01, 2);

    segundos--;
    push();
    textFont(font);
    fill(55);
    rect(x_, y_, 100, 100);
    /*                   -----------CONDICIONES PARA EL CAMBIO DE COLOR DEL RELOJ
     */
    if (time > 30) {
      fill(255);
    } else if (time > 10 && time <= 30) {

      tejo.setDamping(tiempoDamping);
      fill(255, 255, 0);
    } else {
      tejo.setDamping(tiempoDamping);
      // println(tiempoDamping);
      fill(255, 0, 0);
    }
    text(time, x_+50, y_+50);
    pop();
  }

  void marcador(int goles_, int x_, int y_) {
    push();
    fill (0, 255, 0);
    text("Puntaje", x_, y_-50);
    text(goles_, x_, y_);
    pop();
  }
}
