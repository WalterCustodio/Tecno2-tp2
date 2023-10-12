class Receptor { //<>//

  ArrayList <Blob> blobs;
  int tiempo_para_borrar = -15;

  Receptor() {

    blobs = new ArrayList<Blob>();
  }

  void actualizar(ArrayList <OscMessage> mensajes) {

    resetBlobs(); // Si hay blobs, pone la variable "estaActualizado" en false, en todos los blobs

    while (mensajes.size() > 0) { // Mientras hay mensajes en el buffer


      OscMessage m = mensajes.get(0); // carga el primer mensaje que llegó en la variable m

      if (m.addrPattern().equals("/bblobtracker/blobs")) { // si el mensaje tiene la etiqueta (address) "/bblobtracke/blobs"

        boolean encontrado = false;  // 

        int id = (int) m.get(0).floatValue(); // le pido el ID a cada blob del mensaje

        for (int i=0; i<blobs.size(); i++) { // recorro la lista de blobs del repector

          Blob b = blobs.get(i);

          if (b.id == id) { // si el blob del mensaje ya estaba en mi lista de blobs
    
            b.actualizarDatos(m); // le envio el mensaje al blob para que tome los datos del indice correspondiente para actualizarse
            b.actualizado = true; // aviso que este blob ya fue actualizado
            b.ultimaActualizacion = 0;
            encontrado = true; // aviso que el blob del mensaje ya fue encontrado para que deje de buscar entre los de mi lista de blobs
            break; // salgo del siclo for para que deje de buscar
          }
        }

        if (!encontrado) { 
          Blob nb = new Blob();   // creo un NUEVO blob
          nb.setID(id);           // le pongo el ID
          nb.actualizarDatos(m);   // le actualizo los datos
          nb.actualizado = true; // lo marco como ya actualizado
          blobs.add(nb);
        }
      }
      mensajes.remove(0);
    }

    for (int k=blobs.size()-1; k>=0; k--) { //recorro mi lista de blobs de atras para adelante
      Blob vb = blobs.get(k);
      if (!vb.actualizado) {  // si encuentro alguno que no fue actualizado (porque en los mensajes de entrada no estaba
        vb.ultimaActualizacion--;
      }
      if (vb.ultimaActualizacion < tiempo_para_borrar) {

        blobs.remove(k);  // lo borro de la lista
      }
    }
    
    for (Blob b : blobs) {
      b.actualizar();
    }
  }

  void resetBlobs() {
    for (Blob b : blobs) {
      b.actualizado = false;
    }
  }

  void dibujarBlobs(float w, float h) {

    for (Blob b : blobs) {
      b.dibujar(w, h);
    }
  }
  
}
