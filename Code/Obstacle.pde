/*
  Implementação da classe Obstacle
 Usada para criar repulsão e oposição ao deslocamento de peixes
 */

class Obstacle {
  // Atributos
  PVector pos;    // posição do obstáculo
  int size;       // tamanho do obstáculo 

  // Construtor da classe! Tem sempre o mesmo nome da classe! Podem exister vários construtores se o número de parâmetros variar (neste caso opta-se por apenas um contrutor)
  Obstacle(float xx, float yy, int s) {    // recebe como argumentos as coordenadas xx e yy que queremos dar ao obstáculo e o seu tamanho s.
    pos = new PVector(xx, yy);             // definir a posição
    size = s;                              // definir o tamanho
  }

  // Nesta classe só precisamos de perguntar pela posição (o setter não é preciso porque assumimos que o objeto vai estar sempre parado)
  public PVector getPos() {
    return pos;
  }

  // função que diz como desenhar o objeto
  void draw_obs () {
    fill(0);                              // pintado de preto
    ellipse(pos.x, pos.y, size, size);    // uma elipse com posição (pos.x, pos.y) e tamanho size (eixo vertical: size, eixo horizontal: size)
  }
}