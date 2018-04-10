/*
  Code developed for a Java Workshop (22/03/2018)
  Developed by: Rafael Correia

    Este programa (ficheiro principal [WS_part2] e classes) é desenhado para simular
  o comportamento de certos animais (aves, peixes, humanos, ...) em se agregarem e
  moverem em grupo (flocking behaviour).
  
    Neste ficheiro (WS_part2) são implementados as funções "setup" e "draw" próprias do IDE Precessing (não existem em Java normal):
      - void setup: define o estado inicial do sketch (inicialização de variáveis, etc...)
      - void draw: é constantemente chamada para desenhar o sketch. Assim que a função "draw" acaba, é novamente chamada e o simulador desenvolve-se desta maneira.
    
    Definimos quatro classes:
      - Fish: classe abstrata que só é usada para transmitir características comuns de peixes para a classe LittleFish e Shark.
      - LittleFish: classe que implementa os peixes miúdos que vão ter comportamento de flocking. Para além das características de Fish são-lhe atribuidas novas características.
                    Estes peixes tentarão evitar o contacto com objetos do tipo Obstáculo e Tubarão!
      - Shark: classe que implementa os tubarões que vão nadar pelo sketch. Para além das características de Fish são-lhe atribuidas novas características.
      - Obstacle: classe que implementa obstáculos fixos no sketch. Usados para limitar o movimento dos objetos do tipo Fish (LittleFish e Shark).
      
*/


ArrayList<LittleFish> littleFishes;    // Declaração de um vetor de objetos do tipo LittleFish
ArrayList<Shark> sharks;               // Declaração de um vetor de objetos do tipo Shark
ArrayList<Obstacle> obstacles;         // Declaração de um vetor de objetos do tipo Obstacle

int countIDs = 0;    // Usado para atribuir um ID específico a cada objeto do tipo Fish (objetos Shark e LittleFish partilham esta variável)

// Função que inicializa o sketch
void setup () {
  size(1024, 576);                                  // Cria uma janela de sketch com tamanho 1024x576 (em pixels). Pode-se daqui para a frente usar a variável "width" para indicar largura (1024) e "height" para indicar a altura (576).
  colorMode(RGB);                                   // Define o modo de aplicação da cor como RGB (red, green, blue). Uma outra opção seria HSB (hue, saturation, brightness), entre outras. O RGB é o mais usado e mais fácil de usar.
  littleFishes = new ArrayList<LittleFish>();       // Inicializa-se a o vetor de objetos LittleFish. Antes desta linha a variável tinha o valor Null. Agora tem o valor {}. Nota: Null != {}
  sharks = new ArrayList<Shark>();                  // Inicializa-se a o vetor de objetos Shark. Antes desta linha a variável tinha o valor Null. Agora tem o valor {}. Nota: Null != {}
  obstacles = new ArrayList<Obstacle>();            // Inicializa-se a o vetor de objetos Obstacle. Antes desta linha a variável tinha o valor Null. Agora tem o valor {}. Nota: Null != {}

  setupWalls();                                     // Chama-se a função que cria e define a posição de novos obstáculos. Pode-se trocar pela função "setupSin()" para obter outra disposição! 
}

// Esta função cria e define a posição de novos obstáculos 
void setupWalls() {
  obstacles = new ArrayList<Obstacle>();                // Já fizemos esta operação no "setup" antes de chamar "setupWalls" mas é sempre melhor ter a certeza que começamos com um vetor vazio e por isso inicializamos de novo a variável.
  for (int x = 0; x < width; x+= 15) {                  // Para todos os pontos ao longo do eixo-x desde a coordenada x=0 até x=width com incrementos de 15 em 15:   0,15,30,45,...
    obstacles.add(new Obstacle(x, 10, 15));             // Cria uma linha de obstáculos na horizontal na parte superior do skecth (y = 10); O parâmetro 15 define o tamanho do obstáculo em pixels
    obstacles.add(new Obstacle(x, height - 10, 15));    // Cria uma linha de obstáculos na horizontal na parte inferior do skecth (y = height - 10); O parâmetro 15 define o tamanho do obstáculo em pixels
  }
}

// Esta função cria e define uma configuração alternativa à "setupWalls" de novos obstáculos 
void setupSin() {
  obstacles = new ArrayList<Obstacle>();                                    // Já fizemos esta operação no "setup" antes de chamar "setupWalls" mas é sempre melhor ter a certeza que começamos com um vetor vazio e por isso inicializamos de novo a variável.
  for (int x = 0; x < width; x+= 15) {                                      // Para todos os pontos ao longo do eixo-x desde a coordenada x=0 até x=width com incrementos de 15 em 15:   0,15,30,45,...
    obstacles.add(new Obstacle(x, 150 + 80 * sin(x/100.), 15));             // Cria uma onda sinusoidal de obstáculos na parte superior do skecth (amplitude: 80 pixels); O parâmetro 15 define o tamanho do obstáculo em pixels
    obstacles.add(new Obstacle(x, height - 150 + 80 * sin(x/100.), 15));    // Cria uma onda sinusoidal de obstáculos na parte inferior do skecth (amplitude: 80 pixels); O parâmetro 15 define o tamanho do obstáculo em pixels
  }
}

// draw: Função que corre indefinidamente após o "setup" correr uma vez.
void draw () {
  fill(0, 200, 255, 150);                    // Define a cor a ser usado no próximo elemento que for criado (neste caso um rectângulo na linha imediatamente abaixo). A cor é (red = 0, green = 200, blue = 255, alpha = 100); O valor de alpha permite definir a transparência do fundo e portanto permite ver os trilhos feitos pelos peixes
  rect(0, 0, width, height);                 // Desenha o rectângulo de fundo (blue background)

  for (LittleFish l_f : littleFishes) {      // Para cada peixe miúdo:
    l_f.swim();                              // Pedir ao peixe miúdo para nadar (calcular a velocidade que tem de tomar)
    l_f.draw_fish(color(0, 150, 0), .4);    // Desenhar o peixe miúdo que agora está numa nova coordenada. Desenhar com a cor (red = 0, green = 150, blue = 0) e tamanho = 0.7
  }

  for (Shark sk : sharks) {                  // Para cada tubarão:
    sk.swim();                               // Pedir ao tubarão para nadar (calcular a velocidade que tem de tomar)
    sk.draw_fish(color(250,0,0), .8);        // Desenhar o tubarão que agora está numa nova coordenada. Desenhar com a cor (red = 250, green = 0, blue = 0) e tamanho = 1.
  }

  for (Obstacle obs : obstacles) {           // Para cada obstáculo:
    obs.draw_obs();                          // Desenhar o obstáculo que agora está numa nova coordenada... just kidding... os obstáculos estão parados!
  }
}

void mousePressed () {                       // Se algum botão do rato por pressionado:
  if (mouseButton == LEFT) {                 // Se o botão pressionado for o Esquerdo:
    for (int i = 0; i < 20; i++) {           // Iterar a variável i 20 vezes (queremos desenhar 20 peixes miúdos em pontos aleatórios próximos do rato
                                             // Cria uma nova instância da classe LittleFish e adiciona ao vetor littleFishes. As coordenadas são as coordenadas do rato +- um valor aleatório até 100 pixels (em módulo).
      littleFishes.add(new LittleFish(mouseX + random(-100, 100), mouseY + random(-100, 100), countIDs++));
    }
  } else if (mouseButton == CENTER) {        // Se o botão pressionado for o Central (roda de scroll):
                                             // Cria uma nova instância da classe Obstacle e adiciona ao vetor obstacles. As coordenadas são as coordenadas do rato. O tamanho do obstáculo é de 15 pixels.
    obstacles.add(new Obstacle(mouseX, mouseY, 15));
  } else if (mouseButton == RIGHT) {         // Se o botão pressionado for o Direito:
                                             // Cria uma nova instância da classe Shark e adiciona ao vetor sharks. As coordenadas são as coordenadas do rato +- um valor aleatório até 50 pixels (em módulo).
    sharks.add(new Shark(mouseX + random(-50, 50), mouseY + random(-50, 50), countIDs++));
  }
}