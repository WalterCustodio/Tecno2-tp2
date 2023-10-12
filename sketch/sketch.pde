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
SoundFile sonidoFondo;
SoundFile golazo;
SoundFile errar;

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
PImage inicio;
PImage creditos;
PImage jugar;
PImage ganaste;
PImage perdiste;
PImage enemigo_img;
PImage controlador_img;


String estado;



float xMap;
float yMap;

float d1;
float x = 120;
float velocidadX;
boolean movEnemigo = false;
boolean detenerTejo = false;
int tiempoDetencion = 0;
float xpuntero = 0;
float ypuntero = 0;
boolean choco = false;

float vel_tiempo;

void setup() {

  size(600, 900);

  //iniciamos el mundo
  Fisica.init(this);
  mundo = new FWorld();
  mundo.setGravity(-0, 0);
  mundo.setEdges();

  estado = "inicio";

  //imagenes.
  inicio = loadImage("inicio.png");
  creditos = loadImage("creditos.png");
  jugar = loadImage ("juega.png");
  enemigo_img = loadImage("enemigo.png");
  controlador_img = loadImage("controlador.png");
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
  fx_choque = new SoundFile(this, "choque.wav");

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
  sonidoFondo = new SoundFile (this, "sonidodefondo.mp3");
  golazo = new SoundFile (this, "golazo.mp3");
  errar = new SoundFile (this, "erra.mp3");
  sonidoFondo.loop();
  sonidoFondo.amp(.4);
  velocidadX = 15 /((contadores.time)+1);
}

void draw() {
  background(0);
  mundo.step();
  mundo.draw();

  xMap = map(tejo.getX(), 65, 450, -1, 1);
  yMap = map(tejo.getY(), 50, 810, 0.0015, 0.015);
  choco = false;


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
    xpuntero = admin.xpuntero;
    ypuntero = admin.ypuntero;
    choco = admin.choco;
  }
  if (choco && !fx_choque.isPlaying()) {
    fx_choque.play();
  }

  if (estado == "inicio") {

    receptor.actualizar(mensajes); //

    background(inicio);
    // contadores.time = 60;

    image(controlador_img, xpuntero, ypuntero);

    if (xpuntero > 200 && xpuntero < 400 && ypuntero > 400 && ypuntero < 480) {
      estado = "jugar";
    }

    if (xpuntero > 200 && xpuntero < 400 && ypuntero > 551 && ypuntero < 635) {
      estado = "creditos";
    }
  }

  if (estado == "jugar") {

    contadores.tiempo(475, 50);
    contadores.marcador(goles, 300, 450);
    sonidoFondo.amp(.3);

    //enemigo comportamiento
    if (contadores.time <= 40) {
      if (caja_enemigo.getX() <= 95 || caja_enemigo.getX() >= 390)
      {
        velocidadX *= -1;
      }
      caja_enemigo.setPosition(caja_enemigo.getX() + velocidadX, 200);
      //  tejo.setDamping (0.1);
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
      tejo.setPosition(200, 700);
      tejo.setVelocity(0, 0);
      golazo.play();
      golazo.amp(.4);

      golHecho = millis();
    }

    if (tejo.getY() > 820) {
      goles = goles -1;
      tejo.setPosition(200, 700);
      tejo.setVelocity(0, 0);
      errar.play();
      errar.amp(.3);
      uuf = true;
      golHecho = millis();
    }

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
    if ( (contadores.time <= 0) && (goles < objetivo_goles) || (goles <= -3)) {

      estado = "perder";
    }
    if (goles >= objetivo_goles) {
      estado ="ganar";
    }
  }

  if (estado=="perder") {
    image(perdiste, 0, 0, width, height);
    contadores.time = 0;
  }
  //lógica para ganar

  if (estado == "ganar") {
    image(ganaste, 0, 0, width, height);
    contadores.time = 60;
    sonidoFondo.amp(.4);
  }
  if (estado == "creditos") {

    image (creditos, 0, 0, width, height);
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      estado = "inicio";
      contadores = new Contadores();
      fondo = new Fondo(mundo);
      goles = 0;
      tejo.setDamping (0.01);
      //enemigo
      caja_enemigo.setPosition(200, 200);
      sonidoFondo.amp(.4);
      velocidadX = 15 /((contadores.time)+1);
    }
  }
}
