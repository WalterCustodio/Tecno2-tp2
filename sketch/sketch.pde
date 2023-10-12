import processing.sound.*;
import fisica.*;

FWorld mundo;

int PUERTO_OSC = 12345;

Receptor receptor;
Administrador admin;

// variables de física
// enemigo
FBox caja_enemigo;
FRevoluteJoint articulacion;

//variables de sonid

BrownNoise fx_noise;
WhiteNoise fx_noise2;
SoundFile fx_choque;

FCircle tejo;


Contadores contadores;

Fondo fondo;

int goles;
int objetivo_goles = 3;

//lógica para goles
boolean fueGol = false;
int golHecho;
PImage gol_img;
//lógica para cuando erra
boolean uuf = false;
PImage bu;
//Menú
PImage jugar;
PImage ganaste;
PImage perdiste;
PImage enemigo_img;


String estado;

//SoundFile sonidoFondo;
//SoundFile golazo;
//SoundFile errar;

float xMap;
float yMap;

float d1;
float x = 120;
float velocidadX;
boolean movEnemigo = false;
boolean detenerTejo = false;
int tiempoDetencion = 0;

float vel_tiempo;

void setup() {

  size(550, 900);

  //iniciamos el mundo
  Fisica.init(this);
  mundo = new FWorld();
  mundo.setGravity(-0, 0);
  //mundo.setEdges();

  estado = "jugar";
  enemigo_img = loadImage("enemigo.png");
  jugar = loadImage ("juega.png");
  gol_img = loadImage ("gool.png");
  bu = loadImage ("buu.png");
  ganaste = loadImage ("ganaste.png");
  perdiste = loadImage ("perdiste.png");
  golHecho = millis();

  //osc
  setupOSC(PUERTO_OSC);
  receptor = new Receptor();
  admin = new Administrador(mundo);

  //sonido

  fx_noise = new BrownNoise(this);
  fx_noise2 = new WhiteNoise(this);
  fx_noise.amp(0.05);


  //fondo
  contadores = new Contadores();
  fondo = new Fondo(mundo);

  tejo = crearTejo(40, 20);
  tejo.setDamping (0.01);

  //enemigo
  caja_enemigo = new FBox(  65, 65  );
  caja_enemigo.setPosition(200, 200);
  caja_enemigo.attachImage(enemigo_img);


  mundo.add(caja_enemigo);
  mundo.add(tejo);


  //agrega las imágenes y el contador del tiempo de los pop ups

  //carga los sonidos y sus amplitudes
  //sonidoFondo = new SoundFile (this, "sonidodefondo.mp3");
  //golazo = new SoundFile (this, "golazo.mp3");
  //errar = new SoundFile (this, "erra.mp3");
  //sonidoFondo.loop();
  //sonidoFondo.amp(.9);

  velocidadX = 15 /((contadores.time)+1);
  caja_enemigo.setNoStroke();
}

void draw() {
  background(50);
  mundo.step();
  mundo.draw();

  xMap = map(tejo.getX(), 65, 450, -1, 1);
  yMap = map(tejo.getY(), 50, 810, 0.0015, 0.015);

  d1 = dist(tejo.getX(), caja_enemigo.getX(), 120, tejo.getY());

  vel_tiempo = map(contadores.time, 60, 0, 5, 10);
  x += velocidadX;

  // OSC RECEPTOR

  receptor.actualizar(mensajes); //

  // Eventos de entrada y salida
  for (Blob b : receptor.blobs) {
    if (b.entro) {

      admin.crearPuntero(b);

    }
    if (b.salio) {

      admin.removerPuntero(b);
    }
    admin.actualizarPuntero(b);
  }

  if (estado == "inicio") //lógica del menú, este está hasta que pongas el disco en mitad de la cancha
  {
    image(jugar, 0, 0, width, height);
    // contadores.time = 60;
    //cambiar la posición del mouse por los blobs
    circle(mouseX, mouseY, 50);
    if (mouseX > 150 && mouseX < 200 && mouseY > 275 && mouseY < 325)
    {
      estado = "jugar";
    }
  }

  if (estado == "jugar") {

    //contadores.tiempo(60, 450, 50);
    //contadores.marcador(goles, 500, 400);
    //sonidoFondo.amp(.6);
    //enemigo comportamiento

    if (contadores.time <= 40) {
      if (caja_enemigo.getX() <= 95 || caja_enemigo.getX() >= 390)
      {
        velocidadX *= -1;
      }
      caja_enemigo.setPosition(caja_enemigo.getX() + velocidadX, 200);
      tejo.setDamping (0.1);
    }
    if (contadores.time <= 10)
    {
      tejo.setDamping (0.3);
    }


    if (abs(tejo.getVelocityX())>5 || abs(tejo.getVelocityY())>5) {
      fx_noise.pan(xMap);
      fx_noise.amp(yMap*2);
      fx_noise.play();
      fx_noise2.amp(yMap);
      fx_noise2.pan(xMap);
      fx_noise2.play();
    } else {
      fx_noise2.stop();
      fx_noise.stop();
    }

    if (tejo.getY() < 70) {
      fueGol = true;
      goles = goles +1;
      tejo.setPosition(250, 400);
      tejo.setVelocity(0, 0);
      //golazo.play();
      //golazo.amp(.4);

      golHecho = millis();
    }

    if (tejo.getY() > 820) {
      goles = goles -1;
      tejo.setPosition(250, 500);
      tejo.setVelocity(0, 0);
      //errar.play();
      //errar.amp(.4);
      uuf = true;
      golHecho = millis();
    }
    //println("cantidad de blobs: " + receptor.blobs.size());
    //pop up del gol
    if (fueGol) {
      image(gol_img, width/2-240, height/2-290, 230, 230);
      if (millis() - golHecho >= 1500) {
        fueGol = false;
      }
    }
    //pop up de cuando errás
    if (uuf) {
      image(bu, width/2-240, height/2+50, 230, 230);
      if (millis() - golHecho >= 1500) {
        uuf = false;
      }
    }
    //lógica para perder
    if ( contadores.time <= 0 && goles != objetivo_goles)
    {
      estado = "perder";
    }
  }
  if (estado=="perder") {
    image(perdiste, 0, 0, width, height);
    contadores.time = 60;
  }
  //lógica para ganar
  if (contadores.time >= 0 && goles >= objetivo_goles) {
    estado ="ganar";
  }
  if (estado == "ganar") {
    image(ganaste, 0, 0, width, height);
    contadores.time = 60;
    //sonidoFondo.amp(.9);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      goles = goles+1;
      //golazo.play();
      //golazo.amp(.4);
      fueGol = true;
      golHecho = millis();
    } else if (keyCode == DOWN) {
      //errar.play();
      //errar.amp(.4);
      uuf = true;
      golHecho = millis();
      goles = goles-1;
    }
  }
  if (key == CODED) {
    if (keyCode == RIGHT) {
      tejo.setPosition(174, 300);
      tejo.setVelocity(0, 0);
    }
  }
}
void mousePressed() {
}
