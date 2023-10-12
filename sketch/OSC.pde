import oscP5.*;
OscP5 osc;

OscProperties propiedadesOSC;

ArrayList <OscMessage> mensajes; // lista de mensajes entrantes

void setupOSC( int puerto) {


  propiedadesOSC = new OscProperties();

  propiedadesOSC.setDatagramSize(10000);
  propiedadesOSC.setListeningPort(puerto);
  osc = new OscP5(this, propiedadesOSC);

  mensajes = new ArrayList<OscMessage>();
}

void oscEvent (OscMessage m) {
  mensajes.add(m);
}
