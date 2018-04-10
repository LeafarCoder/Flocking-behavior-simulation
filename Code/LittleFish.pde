/*
  Implementação da classe LittleFish
 Esta classe extende a classe abstrata Fish e por isso herda dela todos os seus atributos e métodos
 */

public class LittleFish extends Fish {

  ArrayList<LittleFish> closeLittleFishes;      // vetor que vai manter guardado os peixes miúdo próximos

  // Atributos (variáveis de comportamento)
  private int friendRadius = 70;   // raio necessário para se adquirar a velocidade de vizinhos (alinhamento)
  private int crowdRadius = 50;    // raio necessário para haver repulsão de outros peixes miúdos
  private int coheseRadius = 65;   // raio necessário para haver coesão entre um peixe miúdo e um cardume
  private int sharkRadius = 200;   // raio necessário para haver repulsão de tubarões
  private int maxSpeed = 2;        // velocidade máxima do peixe miúdo

  // construtor dos peixes miúdo (mesmo nome que o da classe!)
  LittleFish(float xx, float yy, int id) {
    super(xx, yy);                                      // Usa o construtor da classe que extendemos (neste caso a classe LittleFish) para inicializar os atributos que vêem de lá                                         
    ID = id;                                            // E agroa inicializa os atributos que definimos na classe Shark
    closeLittleFishes = new ArrayList<LittleFish>();    // Inicializar a variável closeLittleFishes a uma lista vazia. Antes disto a variável não era uma lista vazia! Era um Null, ou seja, comparando com matéria nem sequer era "vácuo" pois o vácuo já subentende volume. A ausência de tudo é Null. Um conceito estranho mas importante!
  }

  // A função "move" foi declarada mas não definida na classe Fish, isto porque cada tipo de peixe se move de uma certa maneira.
  PVector move() {
    time++;                                           // incrementa a idade do tubarão
    getCopy();                                        // faz uma cópia da lista dos peixes miúdo próximos do atual

    PVector vel = this.getVel();                      // a velocidade começa por ser a velocidade atual

    // Há 6 fatores que influenciam o movimento de um peixe miúdo:
    PVector allign = getAverageDir();                                                                  // vetor que define a direção geral de movimento de um cardume
    PVector avoidDir = getAvoidLittleFishDir();                                                        // vetor que define a direção de repulsão de peixes miúdo
    PVector avoidSharkDir = getAvoidSharkDir();                                                        // vetor que define a direção de repulsão de tubarões
    PVector cohese = getCohesion();                                                                    // vetor que define a coesão de um certo cardume de peixes miúdo
    PVector avoidObstacles = getAvoidObstacles();                                                      // vetor que define a direção de repulsão de obstáculos
    PVector noise = new PVector(2*noise(time/800., ID*800) - 1, 2*noise(time/800., ID*800+10) - 1);    // vetor que define uma direção aleatória usando Perlin Noise (um tipo de aleatoriedade mais orgânica)

    // cada um dos seis fatores pode ter um peso diferente
    allign.mult(2);
    avoidDir.mult(1);
    avoidSharkDir.mult(30);
    avoidObstacles.mult(5);
    noise.mult(0.1);
    cohese.mult(0.005);

    // adiciona os fatores (vetores) à velocidade
    vel.add(allign);
    vel.add(avoidDir);
    vel.add(avoidSharkDir);
    vel.add(avoidObstacles);
    vel.add(noise);
    vel.add(cohese);

    vel.limit(maxSpeed);      // limita a velocidade em módulo (para não somar indefinidamente e estoirar)

    return vel;               // retorna a velocidade
  }

  // obtem os peixes miúdo próximos e copia-os para "closeLittleFish"
  void getCopy() {
    ArrayList<LittleFish> nearby = new ArrayList<LittleFish>();                                            // cria um array temporário
    for (LittleFish other : littleFishes) {                                                                // para cada peixe-miúdo "other":
      if (other != this && PVector.dist(other.getPos(), this.getPos()) < friendRadius) nearby.add(other);  // se não é o próprio peixe-miúdo (this) e se está a um raio próximo
    }
    closeLittleFishes = nearby;    // copia o vetor temporário para o vetor global
  }

  // A seguir definem-se mais 4 funções que modelam o comportamento da natação do peixe.
  
  // Obtem a velocidade média dos peixes vizinhos (não é bem verdade porque no fim não divide pelo número de elementos; ao invés disso normaliza e torna num versor)
  PVector getAverageDir () {
    PVector sum = new PVector(0, 0);

    for (LittleFish other : closeLittleFishes) {
      float d = PVector.dist(this.getPos(), other.getPos());
      if (d < friendRadius) {
        PVector copy = other.getVel().copy();
        copy.normalize();
        copy.div(d);
        sum.add(copy);
      }
    }
    return sum;
  }

  // Obtem a velocidade de repulsão entre peixes (para evitar altas densidades de peixes/m^2)
  PVector getAvoidLittleFishDir() {
    PVector steer = new PVector(0, 0);

    for (LittleFish other : closeLittleFishes) {
      float d = PVector.dist(this.getPos(), other.getPos());
      if (d < crowdRadius) {
        PVector diff = PVector.sub(this.getPos(), other.getPos());
        diff.normalize();
        diff.div(d);
        steer.add(diff);
      }
    }
    return steer;
  }
  
  // Obtem o vetor de repulsão entre o peixe-miúdo atual e os tubarões (para evitarem serem comidos)
  PVector getAvoidSharkDir() {
    PVector steer = new PVector(0, 0);

    for (Shark other : sharks) {
      float d = PVector.dist(this.getPos(), other.getPos());
      if (d < sharkRadius) {
        PVector diff = PVector.sub(this.getPos(), other.getPos());
        diff.normalize();
        diff.div(d);
        steer.add(diff);
      }
    }
    return steer;
  }
  
  // Obtem o vetor de coesão. Este vetor aponta para o centro de massa dos vizinhos num certo raio na tentativa do peixe se integrar de forma mais central no grupo.
  // A repulsão do getAvoidLittleFishDir() evita que os peixes convirjam para o mesmo ponto (o Centro de Massa de todos os peixes).
  PVector getCohesion () {
    PVector sum = new PVector(0, 0);
    for (LittleFish other : closeLittleFishes) {
      float d = PVector.dist(this.getPos(), other.getPos());
      if (d < coheseRadius) {
        PVector cohesion = PVector.sub(other.getPos(), this.getPos());
        cohesion.normalize();
        cohesion.div(d);
        sum.add(cohesion); // Add location
      }
    }
    return sum;
  }
}