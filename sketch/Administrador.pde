class Administrador {

  ArrayList <Puntero> punteros;

  FWorld mundo;
  float xpuntero;
  float ypuntero;
  boolean choco;

  Administrador(FWorld mundo_) {
    punteros = new ArrayList<Puntero>();

    mundo = mundo_;
  }


  void crearPuntero (Blob b) {
    if (punteros.size()< 2) {
      Puntero p = new Puntero(mundo, b.id, b.centroidX * width, b.centroidY * height);
      punteros.add(p);
    }
    if (punteros.size()> 1) {
      for (int i = 0; i < punteros.size()-1; i++) {
        Puntero p = punteros.get(i);
        p.borrar();
        punteros.remove(i);
      }
    }
  }
  void removerPuntero (Blob b) {
    if (punteros.size() > 1) {
      for (int i = punteros.size()-1; i >=0; i--) {
        Puntero p = punteros.get(i);
        if (p.id == b.id) {
          p.borrar();
          punteros.remove(i);
          break;
        }
      }
    } else {
    }
  }
  void actualizarPuntero (Blob b) {

    if (punteros.size() == 0) {
    }
    for (Puntero p : punteros) {
      if (p.id == b.id) {
        xpuntero = p.x();
        ypuntero = p.y();
        choco = p.choco();
        p.setTarget(b.centroidX* width, b.centroidY * height);
        break;
      }
    }
  }

}
