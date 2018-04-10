/*
  Implementação da classe abstrata Fish
  Usada para extender certas características e métodos a Classes cujos objetos são parecidos (neste caso LittleFish e Shark)
*/

abstract class Fish {
  // Atributos
  private PVector position;      // a posição do peixe. PVector é uma classe implementada em Processing que define objetos que são um vetor (permitem guardar dois valores [x e y] e tem métodos para modificar esse vetor [.add(...); .mult(...); .div(...); .normalize(); ...]
  private PVector velocity;      // a velocidade do peixe
  private int avoidRadius = 80;  // raio para cálculo da contribuição dos obstáculos na mudança de direção
  public int ID;                 // ID do peixe. Partilhado pelos LittleFish e Shark
  public int time;               // "idade" do peixe. Este valor é incrementado para cada peixe após cada ciclo de simulação.
  
  // Construtor da classe! Tem sempre o mesmo nome da classe! Podem exister vários construtores se o número de parâmetros variar (neste caso opta-se por apenas um contrutor)
  Fish (float xx, float yy) {        // recebe como argumentos as coordenadas x e y que queremos dar ao peixe.
    velocity = new PVector(0, 0);    // define a velocidade do peixe como 0 (o peixe está parado).
    position = new PVector(xx, yy);  // define a posição do peixe usando os parâmetros da do construtor.
  }
  
  // Definimos agora get's e set's para obter/definir (respetivamente) a posição do peixe e a sua velocidade
  public PVector getPos(){
    return position;
  }
  public void setPos(PVector p){
    position = p;
  }
  public PVector getVel(){
    return velocity;
  }
  public void setVel(PVector vel){
    velocity = vel;
  }

  // Todos os peixes nadam! Por isso implementa-se esse método nesta classe abstrata!
  void swim(){
    velocity = move();        // Calcular a velocidade do peixe. Esta velocidade depende do comportamento do peixe (se é peixe miúdo ou tubarão) e por isso a função "move()" vai ser definida não aqui (Fish) mas nas sub-classes (LittleFish e Shark).
    position.add(velocity);   // Tendo a velocidade, a nova posição é obtida adicionando à antiga posição a velocidade. v = dr/dt <=> v = (r_f - r_i) / (t_f - t_i) <=> v * (t_f - t_i) + r_i = r_f    Como o intervalo de tempo no simulador é discreto não interessa e podemos considerar dt = t_f - t_i = 1 de onde vem r_f = r_i + v
    wrap();                   // Esta função lida com a situação dos peixes nadarem para fora do sketch. Assim que um peixe passar o limite do sketch é teleportado para a extremidade oposta do sketch
  }

  // Cada peixe (LittleFish e Shark) move-se de maneira diferente por isso deixamos a sua implementação para as sub-classes. Para isso define-se o método "move()" como "abstract".
  abstract PVector move();
  // Como variam estes comportamentos?
  
  // Class LittleFish: o peixe miúdo faz uso de vários fatores para se mover:
  //   - Repulsão de obstáculos
  //   - Repulsão de outros peixes-miúdos
  //   - Repulsão de tubarões
  //   - Coesão entre peixes miúdos (para formar um grupo)
  //   - Alinhamento da velocidade com a dos outros peixes miúdos
  //   - Um componente aleatório
  
  // Class Shark: o tubarão faz uso de outros fatores para se mover:
  //   - Repulsão de obstáculos
  //   - Repulsão de outros tubarões
  //   - Um componente aleatório
  
  
  
  // Função a ser usada pelas sub-classes: define o vetor repulsão do peixe devido aos obstáculos próximos (dentro de um raio "avoidRadious)
  PVector getAvoidObstacles(){
    PVector steer = new PVector(0, 0);                                  // O resultado final começa a zero (vetor nulo)

    for (Obstacle obs : obstacles) {                                    // Para cada obstáculo existente "obs":
      float d = PVector.dist(this.getPos(), obs.getPos());              // Calcular a distância "d" a que esse obstáculo (obs) está do peixe (this)
      if(d < avoidRadius){                                              // Se o obstáculo "obs" estiver dentro do raio "avoidRadius" então:
        PVector diff = PVector.sub(this.getPos(), obs.getPos());        // Calcula o vetor repulsão (é a diferença entre os vetores posição)
        diff.normalize();                                               // Normaliza o vetor diff
        diff.div(d);                                                    // Pondera localmente o vetor. Se o obstáculo está muito próximo cria maior repulsão logo o vetor será maior e vice-versa.
        steer.add(diff);                                                // Adiciona este vetor "diff" ao resultado final "steer"
      }
    }
    return steer;                                                       // retorna o resultado final "steer" que é o resultado das repulsões feitas pelos obstáculos próximos do peixe
  }

  // Esta função lida com a situação dos peixes nadarem para fora do sketch. Assim que um peixe passar o limite do sketch é teleportado para a extremidade oposta do sketch
  void wrap () {
    position.x = (position.x + width) % width;
    position.y = (position.y + height) % height;
  }

  // Esta função diz como desenhar um peixe
  void draw_fish (color c, float s) {
    noStroke();
    fill(c);              // Cada sub-classe do peixe tem uma cor diferente (tubarão: vermelho; peixe miúdo: verde)
    pushMatrix();
    translate(this.getPos().x, this.getPos().y);
    rotate(this.getVel().heading());
    scale(s);             // Cada sub-classe do peixe tem um tamanho diferente (tubarão: 1.; peixe miúdo: 0.7)
    beginShape();
    vertex(15, 0);        // Cada um dos vértices do peixe.
    vertex(-7, 7);
    vertex(-7, -7);
    endShape(CLOSE);
    popMatrix();
  }
}