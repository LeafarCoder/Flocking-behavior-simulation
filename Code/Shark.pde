
/*
  Implementação da classe Shark
 Esta classe extende a classe abstrata Fish e por isso herda dela todos os seus atributos e métodos
 */

public class Shark extends Fish {

  ArrayList<Shark> closeSharks;    // vetor que vai manter guardado os tubarões próximos

  private int crowdRadius = 300;   // raio para o qual os tubarões começam repulsar-se uns aos outros
  private int maxSpeed = 1;        // velocidade máxima dos tubarões

  // construtor dos tubarões (mesmo nome que o da classe!)
  Shark(float xx, float yy, int id) {
    super(xx, yy);                                // Usa o construtor da classe que extendemos (neste caso a classe Shark) para inicializar os atributos que vêem de lá
    ID = id;                                      // E agroa inicializa os atributos que definimos na classe Shark
    closeSharks = new ArrayList<Shark>();         // Inicializar a variável closeSharks a uma lista vazia. Antes disto a variável não era uma lista vazia! Era um Null, ou seja, comparando com matéria nem sequer era "vácuo" pois o vácuo já subentende volume. A ausência de tudo é Null. Um conceito estranho mas importante!
  }

  // A função "move" foi declarada mas não definida na classe Fish, isto porque cada tipo de peixe se move de uma certa maneira.
  PVector move() {
    time++;                            // incrementa a idade do tubarão
    getCopy();                         // faz uma cópia da lista de tubarões próximos do atual

    PVector vel = this.getVel();       // a velocidade começa por ser a velocidade atual

    // Há 3 fatores que influenciam o movimento de um tubarão:
    PVector avoidObstacles = getAvoidObstacles();                                                      // vetor que define a direção de repulsão de obstáculos
    PVector avoidSharks = getAvoidSharks();                                                            // vetor que define a direção de repulsão de tubarões
    PVector noise = new PVector(2*noise(time/800., ID*800) - 1, 2*noise(time/800., ID*800+10) - 1);    // vetor que define uma direção aleatória usando Perlin Noise (um tipo de aleatoriedade mais orgânica)

    // cada um dos três fatores pode ter um peso diferente
    avoidObstacles.mult(3);
    avoidSharks.mult(1);
    noise.mult(0.1);    // quase não se considera o vetor aleatório (este serve só mesmo para alguma micro-variação)

    // adiciona os fatores (vetores) à velocidade
    vel.add(avoidObstacles);
    vel.add(avoidSharks);
    vel.add(noise);

    vel.limit(maxSpeed);    // limita a velocidade em módulo (para não somar indefinidamente e estoirar)

    return vel;             // retorna a velocidade
  }

  // obtem os tubarões próximos e copia-os para "closeSharks"
  void getCopy() {
    ArrayList<Shark> copy = new ArrayList<Shark>();                                                      // cria um array temporário
    for (Shark other : sharks) {                                                                         // para cada tubarão "other":
      if (other != this && PVector.dist(other.getPos(), this.getPos())< crowdRadius)copy.add(other);     // se não é o próprio tubarão (this) e se está a um raio próximo
    }
    closeSharks = copy;  // copia o vetor temporário para o vetor global
  }

  // Define-se o método que indica o vetor respulsão que um tubarão sente de outros:
  PVector getAvoidSharks() {
    PVector steer = new PVector(0, 0);                                    // O resultado final começa a zero (vetor nulo)
    for (Shark other : closeSharks) {                                     // Para cada tubarão existente "other":
      float d = PVector.dist(this.getPos(), other.getPos());              // Calcular a distância "d" a que esse tubarão (other) está do tubarão atual (this) 
      if (d < crowdRadius) {                                              // Se o tubarão "other" estiver dentro do raio "crowdRadius" então:
        PVector diff = PVector.sub(this.getPos(), other.getPos());        // Calcula o vetor repulsão (é a diferença entre os vetores posição)
        diff.normalize();                                                 // Normaliza o vetor diff
        diff.div(d);                                                      // Pondera localmente o vetor. Se "other" está muito próximo cria maior repulsão logo o vetor será maior e vice-versa.
        steer.add(diff);                                                  // Adiciona este vetor "diff" ao resultado final "steer"
      }
    }
    return steer;                                                         // retorna o resultado final "steer" que é o resultado das repulsões feitas pelos tubarões "other" próximos do tubarão atual (this)
  }
}