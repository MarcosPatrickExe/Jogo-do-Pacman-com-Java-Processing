class PacMan{
   int X = 75;
   int Y = 75;
   char direcao = 'd'; //direção que o pacman irá olhar
  
   float arcoInicialD = 0+QUARTER_PI; //arco inicial da boca do pacman quando o mesmo estiver indo/olhando para direita
   float arcoFinalD = 3*PI/2+QUARTER_PI; //arco final da boca do pacman quando o mesmo estiver indo/olhando para direita

   float arcoInicialW = 3*PI/2+QUARTER_PI; //arco inicial da boca do pacman quando o mesmo estiver indo/olhando para cima
   float arcoFinalW = 3*PI+QUARTER_PI; //arco final da boca do pacman quando o mesmo estiver indo/olhando para cima
    
   float arcoInicialA = PI+QUARTER_PI; //arco inicial da boca do pacman quando o mesmo estiver indo/olhando para esquerda
   float arcoFinalA = 2.5*PI+QUARTER_PI; //arco final da boca do pacman quando o mesmo estiver indo/olhando para esquerda
    
   float arcoInicialS = HALF_PI+QUARTER_PI; //arco inicial da boca do pacman quando o mesmo estiver indo/olhando para baixo
   float arcoFinalS = 2*PI+QUARTER_PI; //arco final da boca do pacman quando o mesmo estiver indo/olhando para baixo
}

class Ghost{
   int X;
   int Y;
   int xMatriz;
   int yMatriz;
   String cor;
   char direcao;
   PImage imgA, imgW, imgD, imgS;
   boolean transicaoEsquerda = false;
   boolean transicaoDireita = false;
   boolean transicaoAcima = false;
   boolean transicaoAbaixo = false;
   
   Ghost(int x, int y, String c, char dir, int xm, int ym){
      this.X = x;
      this.Y = y;
      this.cor = c;
      this.direcao = dir;
      this.xMatriz = xm;
      this.yMatriz = ym;
   }
   
   Ghost(){};//essencial para a criação de um objeto do tipo 'Ghost' que servirá para guardar os atributos de cada um dos 4 ghosts do jogo temporariamente...
   
   void inicializarCarregamentoImagem(PImage a, PImage w, PImage d, PImage s){
     this.imgA = a;
     this.imgW = w;
     this.imgD = d;
     this.imgS = s;
   };
}

  
Ghost qualquerFantasma = new Ghost();

PacMan pac; 

Ghost redGhost;
Ghost cyanGhost;
Ghost pinkGhost;
Ghost orangeGhost;

/*
ghost positons on the matriz:

red: X-7, Y-3
ciano: X-13, Y-3
orange: X-7, Y-7
pink: X-13, Y-7
*/

//1050/50 = 21  | 650/50 = 13
int[][] matriz = {
 /* Essa matriz representa e posiciona todos os elementos do jogo (pacman, obstáculos e comida) 
    na tela através dos valores e posições dos números na matriz.*/
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1},
  {1, 3, 1, 1, 1, 3, 1, 1, 3, 1, 1, 1, 3, 1, 1, 3, 1, 1, 1, 3, 1},
  {1, 3, 1, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 1, 3, 1},
  {1, 3, 3, 3, 1, 1, 1, 3, 1, 1, 6, 1, 1, 3, 1, 1, 1, 3, 3, 3, 1},
  {1, 3, 1, 3, 3, 3, 3, 3, 1, 0, 4, 0, 1, 3, 3, 3, 3, 3, 1, 3, 1},
  {3, 3, 1, 1, 1, 3, 1, 3, 1, 1, 1, 1, 1, 3, 1, 3, 1, 1, 1, 3, 3},
  {1, 3, 3, 3, 1, 3, 1, 3, 3, 3, 3, 3, 3, 3, 1, 3, 1, 3, 3, 3, 1},
  {1, 3, 1, 3, 1, 3, 1, 1, 3, 1, 1, 1, 3, 1, 1, 3, 1, 3, 1, 3, 1},
  {1, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3, 1},
  {1, 3, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 3, 1},
  {1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
 // 0 => nada | 1 => obstáculo | 2 => pacman | 3 => comida |
};

PImage cereja;
PImage youWin;
PImage gameOver;
char tecla ='d';
char teclaTemporaria;

//Essas variáveis irão controlar os valores, em radianos, dos arcos que juntos irão representar o abrir e fechar boca do pacman
boolean fechandoArcoFinal = true;
boolean abrindoArcoFinal = false;
boolean fechandoArcoInicial = true;
boolean abrindoArcoInicial = false;

//Essas variáveis irão controlar a movimentação do pacman dentre as 4 direções possíveis
boolean transicaoAcima = false;
boolean transicaoDireita = false;
boolean transicaoEsquerda = false;
boolean transicaoBaixo = false;

void setup(){ 
    size(1050,650); 
    pac = new PacMan(); 
    redGhost = new Ghost(7*50, 3*50, "red", 'd', 7, 3);
    cyanGhost = new Ghost(13*50, 3*50, "ciano", 'a', 13, 3);
    pinkGhost = new Ghost(7*50, 7*50, "pink", 'd',  7, 7);
    orangeGhost = new Ghost(13*50, 7*50, "orange", 'a', 13, 7);
    cereja = loadImage("images/cereja.png");
    youWin = loadImage("images/youwin.png");
    gameOver = loadImage("images/gameover.png");
    
    redGhost.inicializarCarregamentoImagem(loadImage("images/left-red-ghost.png"), loadImage("images/top-red-ghost.png"), loadImage("images/right-red-ghost.png"), loadImage("images/down-red-ghost.png"));
    cyanGhost.inicializarCarregamentoImagem(loadImage("images/left-cyan-ghost.png"), loadImage("images/top-cyan-ghost.png"), loadImage("images/right-cyan-ghost.png"), loadImage("images/down-cyan-ghost.png"));
    pinkGhost.inicializarCarregamentoImagem(loadImage("images/left-pink-ghost.png"), loadImage("images/top-pink-ghost.png"), loadImage("images/right-pink-ghost.png"), loadImage("images/down-pink-ghost.png"));
    orangeGhost.inicializarCarregamentoImagem(loadImage("images/left-orange-ghost.png"), loadImage("images/top-orange-ghost.png"), loadImage("images/right-orange-ghost.png"), loadImage("images/down-orange-ghost.png"));
}

void keyTyped() { tecla= key; if(key=='q'){noLoop();}}

void draw(){
   background(0);
  
   verificarTecla();
   desenhaCenario();
   desenhaPacMan();
   desenhaFantasmas();
   verificarColisao();
   controlarFantasmas();
   
   if((pac.X == 525) && (pac.Y == 275)){
     image(youWin, -40, 10, 1400, 1000);//image(gameOver, 150,200, 700, 600);
     noLoop();
   }
}   

//----------------------------------------------------------------------------------------------------------------------------

void verificarColisao(){
  for(int X=0; X<matriz[0].length; X++){
    for(int Y=0; Y<matriz.length; Y++){
    /* Essa função irá verificar a colisão entre o pacman e os obstáculos e a comida. Assim como também terá a tarefa de movimentar 
    o personagem na mesma direção de qualquer uma das teclas disponíveis para o controle do mesmo: "w", "a", "s" e "d". */
    
        //Se na casa à esquerda do pacman não houver um obstáculo (representado por 1) e sim uma casa vazia (0) ou uma casa que acomoda uma comida (3) o pacman poderá ir até ela.
       if(X>0 && matriz[Y][X]==2 && (matriz[Y][X-1]==0 || matriz[Y][X-1]==3) && (pac.X >= ((X-1)*50)+25) && teclaTemporaria=='a' 
        && !transicaoDireita && transicaoEsquerda && !transicaoAcima && !transicaoBaixo){
          pac.X -=2;  
          if(pac.X == ((X-1)*50)+25){
             matriz[Y][X] = 0;  
             matriz[Y][X-1] = 2;
             transicaoEsquerda=false; 
          }
        }else if((X>0) && (matriz[Y][X]==2) && (matriz[Y][X-1]==1)){  transicaoEsquerda = false;
        }else if((X==0) && (matriz[Y][X]==2) && (teclaTemporaria=='a')){ //avalia se o pacman está na posição 0, ou seja, na saída localizada do lado esquerdo do cenário
           pac.X-=2;
           if(pac.X <= -50){ pac.X=width;}
           
           if((pac.X <= (width-25)) && (pac.X>(width-50))){
              pac.X = 1025;
              matriz[Y][X] = 0;
              matriz[Y][20] = 2;
              transicaoEsquerda = false;
           }
        }
        
        //Se na casa à direita do pacman não houver um obstáculo (representado por 1) e sim uma casa vazia (0) ou uma casa que acomoda uma comida (3) o pacman poderá ir até ela.
        if((X<matriz[0].length-1) && (matriz[Y][X+1]==0 || matriz[Y][X+1]==3) && matriz[Y][X]==2 && (pac.X <= ((X+1)*50+25)) && (teclaTemporaria=='d') 
        && transicaoDireita && !transicaoEsquerda && !transicaoAcima && !transicaoBaixo){
            pac.X +=2; 
            if(pac.X == ((X+1)*50)+25){
                transicaoDireita=false;
                matriz[Y][X] = 0;
                matriz[Y][X+1] = 2;
            }
        }else if((X<matriz[0].length-1) && matriz[Y][X]==2 && (matriz[Y][X+1]==1)){ transicaoDireita = false;
        }else if((X==20) && (matriz[Y][X]==2) && (teclaTemporaria=='d')){ 
           pac.X+=2;
           if(pac.X >= width+50){ pac.X =0;}
           
           if((pac.X >= (0+26)) && pac.X<(0+50)){
              pac.X=25;
              matriz[Y][X]=0;
              matriz[Y][0]=2;
              transicaoDireita=false;
           }
        }
       
        //Se na casa acima do pacman não houver um obstáculo (representado por 1) e sim uma casa vazia (0) ou uma casa que acomoda uma comida (3) o pacman poderá ir até ela.
        if(Y>0 && (matriz[Y-1][X]==0 || matriz[Y-1][X]==3) && matriz[Y][X]==2 && (pac.Y >= ((Y-1)*50)+25) && (teclaTemporaria=='w') 
        && !transicaoDireita && !transicaoEsquerda && transicaoAcima && !transicaoBaixo){
          pac.Y -=2; 
           if(pac.Y == ((Y-1)*50)+25){
              matriz[Y][X] = 0;
              matriz[Y-1][X]=2;
              transicaoAcima=false; 
           }
        }else if((Y>0) && (matriz[Y][X]==2) && (matriz[Y-1][X]==1)){ transicaoAcima = false;
        }else if((Y==0) && (matriz[Y][X]==2) && (teclaTemporaria=='w')){ 
           pac.Y-=2;
           
           if(pac.Y <= -50){ pac.Y=height;}
           
           if((pac.Y <= (height-25)) && (pac.Y>height-50)){
              pac.Y=625;
              matriz[Y][X] = 0;
              matriz[12][X] = 2;
              transicaoAcima = false;
           }
        }
        
        //println(pac.Y+" a "+pac.X);
        //Se na casa abaixo do pacman não houver um obstáculo (representado por 1) e sim uma casa vazia (0) ou uma casa que acomoda uma comida (3) o pacman poderá ir até ela.
        if(Y<(matriz.length-1) && (matriz[Y+1][X]==3 || matriz[Y+1][X]==0 || matriz[Y+1][X]==4) && (matriz[Y][X]==2) && (pac.Y <= ((Y+1)*50)+25) && (teclaTemporaria=='s') 
        && (!transicaoDireita) && (!transicaoEsquerda) && (!transicaoAcima) && (transicaoBaixo)){
          
          pac.Y +=2;  
            if(pac.Y == ((Y+1)*50)+25){
               pac.Y=(Y+1)*50+25;
               matriz[Y][X]=0;
               matriz[Y+1][X]=2;
               transicaoBaixo = false;  
            }
        }else if(Y<(matriz.length-1) && (matriz[Y+1][X]==1 || matriz[Y+1][X]==6) && (matriz[Y][X]==2)){ transicaoBaixo = false;
        }else if((Y==12) && (matriz[Y][X]==2) && (teclaTemporaria=='s')){ 
           pac.Y+=2;
           if(pac.Y >= height+50){ pac.Y=0;}
           
           if((pac.Y >= 25) && (pac.Y<40)){
              pac.Y = 25;
              matriz[12][X] = 0;
              matriz[0][X] = 2;
              transicaoBaixo = false;
           }
        }
        
    }//for
  }//for

  if(transicaoAcima==false && transicaoDireita==false 
     && transicaoEsquerda==false && transicaoBaixo==false){
       /*Se o pacman terminar o seu deslocamento ele irá para a próxima casa conforme a tecla clicada durante o seu movimento.
       Se nenhuma tecla foi clicada ao longo do seu movimento, ele continuará à ir para a próxima casa na mesma direção que antes
       estava. Mas, se na próxima casa houver um obstáculo o seu movimento é cessado e o pacman fica imóvel até que uma próxima tecla seja clicada.   */

       teclaTemporaria = tecla; /*a variável "teclaTemporária" guardará o valor da tecla que o usuário clicou e NÃO mudará até que o deslocamento 
       do pacman de uma casa à outra seja completo. Após isso, é que a variável "teclaTemporária" poderá ser alterada e receber o novo valor de "tecla"*/
       switch(teclaTemporaria){
           case 'a': transicaoEsquerda = true;  pac.direcao='a'; break;
           case 'w': transicaoAcima = true;  pac.direcao='w'; break;
           case 's': transicaoBaixo = true;  pac.direcao='s'; break;
           case 'd': transicaoDireita = true;  pac.direcao='d'; break;
           //default:  break;
       }
     
   }
}

//---------------------------------------------------------------------------------------------------------

void desenhaPacMan(){ //Função que desenha o pacman
  noStroke();
  
  //A partir da tecla clicada a direção que o pacman irá olhar, e consequentemente abrir e fechar a boca, será definida.
  switch(pac.direcao){
     case 'a':  
        fill(250,249,29);
        arc(pac.X, pac.Y, 50, 50, pac.arcoInicialA, pac.arcoFinalA); 
        fill(0);
        circle(pac.X, pac.Y-50/4, 10);
        break;
     case 'd':  
        fill(250,249,29);
        arc(pac.X, pac.Y, 50, 50, pac.arcoInicialD, pac.arcoFinalD);
        fill(0);
        circle(pac.X, pac.Y-50/4, 10);
        break;
     case 'w':  
        fill(250,249,29);
        arc(pac.X, pac.Y, 50, 50, pac.arcoInicialW, pac.arcoFinalW); 
        fill(0);
        circle(pac.X-50/4, pac.Y, 10);
        break;
     case 's':  
        fill(250,249,29);
        arc(pac.X, pac.Y, 50, 50, pac.arcoInicialS, pac.arcoFinalS);
        fill(0);
        circle(pac.X-50/4, pac.Y, 10);
        break;
  }
}

//---------------------------------------------------------------------------------------------------------

void desenhaCenario(){ //Função que desenha o cenário no qual contém um conjunto de quadrados azuis(obstáculos) e bolinhas brancas(comida)
  final float taxaBrilho = 4.047619047619048;// 255 -170=85 => 85/21
  float blue = 170;
  boolean temComida = false;

  for(int X=0; X<matriz[0].length; X++){
    for(int Y=0; Y<matriz.length; Y++){        
         if(matriz[Y][X]==1){
            fill(0, 0, blue); 
            square(X*50, Y*50, 50); //desenhando o quadrado azul (obstáculo)
            fill(0,0,117);
            triangle(X*50, Y*50, X*50+50, Y*50+50, X*50, Y*50+50);
            
         }else if(matriz[Y][X]==3){
            fill(255);  circle(X*50+25, Y*50+25, 10); //desenhando a bolinha de comida     
             temComida = true;
             
         }else if(matriz[Y][X]==6){//barra branca
            fill(255);
            rect(10*50, 4*50+23, 50, 5);  
            
         }else if(matriz[Y][X]==4){//cereja
            image(cereja, 10*50, 5*50, 50, 50);
         }
    } 
    
    blue += taxaBrilho;
  }
  
  if(matriz[4][10]==6 && temComida == false){
      matriz[4][10]=0;
  }
  
}

//---------------------------------------------------------------------------------------------------------

void verificarTecla(){ //Função que controla o abre-e-fecha da boca do pac man automaticamente
   
   if(pac.direcao=='d'){
       if(pac.arcoInicialD > 0 && fechandoArcoInicial == true){
          pac.arcoInicialD -= 0.029000;
        
       }else if(pac.arcoInicialD <0+QUARTER_PI && abrindoArcoInicial==true){
          pac.arcoInicialD += 0.029000;
          
       }if(pac.arcoInicialD <= 0){
          fechandoArcoInicial=false;
          abrindoArcoInicial=true;
          
       }if(pac.arcoInicialD >= 0+QUARTER_PI){
          fechandoArcoInicial=true;
          abrindoArcoInicial=false;
       }
       
     
       if(pac.arcoFinalD < 2*PI && fechandoArcoFinal==true){
          pac.arcoFinalD+=0.029000;
          
       }else if(pac.arcoFinalD >= 3*PI/2+QUARTER_PI && abrindoArcoFinal==true){
          pac.arcoFinalD -=0.029000;
          
       }if(pac.arcoFinalD >= 2*PI){
           fechandoArcoFinal=false;
           abrindoArcoFinal=true;
       }if(pac.arcoFinalD <= 3*PI/2+QUARTER_PI){
           fechandoArcoFinal=true;
           abrindoArcoFinal=false;
       }
   }
   
 //-----------------------------------------------------------------------------
   if(pac.direcao=='w'){
       if(pac.arcoInicialW > 3*PI/2 && fechandoArcoInicial==true){
          pac.arcoInicialW -=0.029000;
        
       }else if(pac.arcoInicialW < 3*PI/2+QUARTER_PI && abrindoArcoInicial==true){
          pac.arcoInicialW += 0.029000;
          
       }if(pac.arcoInicialW <= 3*PI/2){
          fechandoArcoInicial=false;
          abrindoArcoInicial=true; 
       }if(pac.arcoInicialW >= 3*PI/2+QUARTER_PI){
          fechandoArcoInicial=true;
          abrindoArcoInicial=false;
       }

       if(pac.arcoFinalW < 3.5*PI && fechandoArcoFinal==true){
          pac.arcoFinalW +=0.029000;
          
        }else if(pac.arcoFinalW>3*PI+QUARTER_PI && abrindoArcoFinal==true){
          pac.arcoFinalW -=0.029000;
          
       }if(pac.arcoFinalW >= 3.5*PI){
           fechandoArcoFinal=false;
           abrindoArcoFinal=true;
       }if(pac.arcoFinalW <= 3*PI+QUARTER_PI){
           fechandoArcoFinal=true;
           abrindoArcoFinal=false;
       }
   }
//-----------------------------------------------------------------------------
   
   if(pac.direcao=='a'){
       if(pac.arcoInicialA > PI && fechandoArcoInicial==true){
          pac.arcoInicialA -=0.029000;
        
       }else if(pac.arcoInicialA < PI+QUARTER_PI && abrindoArcoInicial==true){
          pac.arcoInicialA+=0.029000;
          
       }if(pac.arcoInicialA >= PI+QUARTER_PI){
          fechandoArcoInicial=true;
          abrindoArcoInicial=false; 
       }if(pac.arcoInicialA <= PI){
          fechandoArcoInicial = false;
          abrindoArcoInicial = true;
       }
       
       if(pac.arcoFinalA<3*PI && fechandoArcoFinal==true){
          pac.arcoFinalA +=0.029000;

       }else if(pac.arcoFinalA>2.5*PI+QUARTER_PI && abrindoArcoFinal==true){
          pac.arcoFinalA -=0.029000;
          
       }if(pac.arcoFinalA >= 3*PI){
           fechandoArcoFinal=false;
           abrindoArcoFinal=true;
       }if(pac.arcoFinalA <= 2.5*PI+QUARTER_PI){
           fechandoArcoFinal=true;
           abrindoArcoFinal=false;
       }
   }
//-----------------------------------------------------------------------------   
    
   if(pac.direcao=='s'){
       if(pac.arcoInicialS > HALF_PI && fechandoArcoInicial==true){
          pac.arcoInicialS -= 0.029000;
        
       }else if(pac.arcoInicialS < HALF_PI+QUARTER_PI && abrindoArcoInicial==true){
          pac.arcoInicialS += 0.029000;
          
       }if(pac.arcoInicialS >= HALF_PI+QUARTER_PI){
          fechandoArcoInicial=true;
          abrindoArcoInicial=false;
       }if(pac.arcoInicialS <= HALF_PI){
          fechandoArcoInicial=false;
          abrindoArcoInicial=true;
       }
       
       
       if(pac.arcoFinalS < 2*PI+QUARTER_PI+QUARTER_PI && fechandoArcoFinal==true){
          pac.arcoFinalS +=0.029000;

       }else if(pac.arcoFinalS > 2*PI+QUARTER_PI && abrindoArcoFinal==true){
          pac.arcoFinalS -=0.029000;
          
       }if(pac.arcoFinalS >= 2*PI+QUARTER_PI+QUARTER_PI){
           fechandoArcoFinal=false;
           abrindoArcoFinal=true;
       }if(pac.arcoFinalS <= 2*PI+QUARTER_PI){
           fechandoArcoFinal=true;
           abrindoArcoFinal=false;
       }
   }
}

//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------

void desenhaFantasmas(){
    //vermelho
    switch(redGhost.direcao){
      case'a':   image(redGhost.imgA, redGhost.X, redGhost.Y, 50, 50); break;
      case'w':   image(redGhost.imgW, redGhost.X, redGhost.Y, 50, 50); break;
      case's':   image(redGhost.imgS, redGhost.X, redGhost.Y, 50, 50); break;
      case'd':   image(redGhost.imgD, redGhost.X, redGhost.Y, 50, 50); break;
    }
    
    //ciano
    switch(cyanGhost.direcao){
      case'a':   image(cyanGhost.imgA, cyanGhost.X, cyanGhost.Y, 50, 50); break;
      case'w':   image(cyanGhost.imgW, cyanGhost.X, cyanGhost.Y, 50, 50); break;
      case's':   image(cyanGhost.imgS, cyanGhost.X, cyanGhost.Y, 50, 50); break;
      case'd':   image(cyanGhost.imgD, cyanGhost.X, cyanGhost.Y, 50, 50); break;
    }
                         
    //rosa
    switch(pinkGhost.direcao){
      case'a':   image(pinkGhost.imgA, pinkGhost.X, pinkGhost.Y, 50, 50); break;
      case'w':   image(pinkGhost.imgW, pinkGhost.X, pinkGhost.Y, 50, 50); break;
      case's':   image(pinkGhost.imgS, pinkGhost.X, pinkGhost.Y, 50, 50); break;
      case'd':   image(pinkGhost.imgD, pinkGhost.X, pinkGhost.Y, 50, 50); break;
    }
  
    //laranja
    switch(orangeGhost.direcao){
      case'a':   image(orangeGhost.imgA, orangeGhost.X, orangeGhost.Y, 50, 50); break;
      case'w':   image(orangeGhost.imgW, orangeGhost.X, orangeGhost.Y, 50, 50); break;
      case's':   image(orangeGhost.imgS, orangeGhost.X, orangeGhost.Y, 50, 50); break;
      case'd':   image(orangeGhost.imgD, orangeGhost.X, orangeGhost.Y, 50, 50); break;
    }
   
}

//-----------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------

void controlarFantasmas(){
      for(int c=0; c<4; c++){
          switch(c){
            case 0:
             qualquerFantasma = redGhost; break;
           
            case 1:
             qualquerFantasma = cyanGhost; break;
            
            case 2:
             qualquerFantasma = pinkGhost; break;
             
            case 3:
             qualquerFantasma = orangeGhost; break;
          }
        
          if(qualquerFantasma.transicaoAcima==false  &&  qualquerFantasma.transicaoDireita==false 
               && qualquerFantasma.transicaoEsquerda==false  &&  qualquerFantasma.transicaoAbaixo==false){
      
              int direcao = (int) random(0, 4); 
              switch(direcao){
                 case 0: qualquerFantasma.transicaoEsquerda = true;  qualquerFantasma.direcao='a'; break;
                 case 1: qualquerFantasma.transicaoAcima = true;  qualquerFantasma.direcao='w'; break;
                 case 2: qualquerFantasma.transicaoAbaixo = true;  qualquerFantasma.direcao='s'; break;
                 case 3: qualquerFantasma.transicaoDireita = true;  qualquerFantasma.direcao='d'; break;
              }
           }
      
           if((qualquerFantasma.xMatriz == (pac.X-25)/50) && (qualquerFantasma.yMatriz == (pac.Y-25)/50) ){
               image(gameOver, 150,200, 700, 600);
               noLoop();
           }
      
          //esquerda
          if( qualquerFantasma.direcao=='a' &&  (qualquerFantasma.xMatriz > 0) && matriz[qualquerFantasma.yMatriz][qualquerFantasma.xMatriz-1] != 1){
              qualquerFantasma.X -= 2;  
              
              if(qualquerFantasma.X == ((qualquerFantasma.xMatriz-1)*50)){
                 qualquerFantasma.xMatriz -= 1;
                 qualquerFantasma.transicaoEsquerda = false; 
              }
              
            }else if(qualquerFantasma.direcao=='a' && (qualquerFantasma.xMatriz != 0) && (matriz[qualquerFantasma.yMatriz][qualquerFantasma.xMatriz-1] == 1)){ qualquerFantasma.transicaoEsquerda = false;
            
            }else if(qualquerFantasma.direcao=='a' && (qualquerFantasma.xMatriz == 0)){
               qualquerFantasma.X -= 2;
               
               if(qualquerFantasma.X <= -50){ qualquerFantasma.X = width; }
               
               if((qualquerFantasma.X <= (width-25)) && (qualquerFantasma.X>(width-50))){
                  qualquerFantasma.X = 1000;
                  qualquerFantasma.xMatriz = 20;
                  qualquerFantasma.transicaoEsquerda = false;
               }
            }
            
            
            //direita
            if( qualquerFantasma.direcao=='d' &&  (qualquerFantasma.xMatriz <20) && (matriz[qualquerFantasma.yMatriz][qualquerFantasma.xMatriz+1] != 1)){
                qualquerFantasma.X += 2;  
                
                if(qualquerFantasma.X == ((qualquerFantasma.xMatriz+1)*50)){
                   qualquerFantasma.xMatriz += 1;
                   qualquerFantasma.transicaoDireita = false; 
                }
                
              }else if(qualquerFantasma.direcao=='d' && (qualquerFantasma.xMatriz != 20) && matriz[qualquerFantasma.yMatriz][qualquerFantasma.xMatriz+1] == 1){ qualquerFantasma.transicaoDireita = false;
              
              }else if(qualquerFantasma.direcao=='d' && (qualquerFantasma.xMatriz == 20)){
                 qualquerFantasma.X += 2;
                 
                 if(qualquerFantasma.X >= width+50){ qualquerFantasma.X = -50; }
                 
                 if((qualquerFantasma.X > 0) && (qualquerFantasma.X < 50)){
                    qualquerFantasma.X = 0;
                    qualquerFantasma.xMatriz = 0;
                    qualquerFantasma.transicaoDireita = false;
                 }
              }
              
              
            
            //cima
            if( (qualquerFantasma.direcao=='w') && (qualquerFantasma.yMatriz > 0) && (matriz[qualquerFantasma.yMatriz-1][qualquerFantasma.xMatriz] != 1)){
                qualquerFantasma.Y -= 2;  
                
                if(qualquerFantasma.Y == ((qualquerFantasma.yMatriz-1)*50)){
                   qualquerFantasma.yMatriz -= 1;
                   qualquerFantasma.transicaoAcima = false; 
                }
                
              }else if(qualquerFantasma.direcao=='w' && (qualquerFantasma.yMatriz !=0) && (matriz[qualquerFantasma.yMatriz-1][qualquerFantasma.xMatriz] == 1)){ qualquerFantasma.transicaoAcima = false;
              
              }else if(qualquerFantasma.direcao=='w' && (qualquerFantasma.yMatriz == 0)){
                 qualquerFantasma.Y -= 2;
                 
                 if(qualquerFantasma.Y <= -50){ qualquerFantasma.Y = height+50; }
                 
                 if((qualquerFantasma.Y > height-50) && (qualquerFantasma.Y < height-25)){
                    qualquerFantasma.Y = 600;
                    qualquerFantasma.yMatriz = 12;
                    qualquerFantasma.transicaoAcima = false;
                 }
              }
            
            //println("x: "+qualquerFantasma.xMatriz+" / Y: "+qualquerFantasma.yMatriz+"/ xF: "+qualquerFantasma.X+"/ yF: "+qualquerFantasma.Y);
            
            //baixo
            if( qualquerFantasma.direcao=='s' &&  (qualquerFantasma.yMatriz <12 ) && (matriz[qualquerFantasma.yMatriz+1][qualquerFantasma.xMatriz] != 1) && (matriz[qualquerFantasma.yMatriz+1][qualquerFantasma.xMatriz] != 6)){
                qualquerFantasma.Y += 2;  
                
                if(qualquerFantasma.Y == ((qualquerFantasma.yMatriz+1)*50)){
                   qualquerFantasma.yMatriz += 1;
                   qualquerFantasma.transicaoAbaixo = false; 
                }
                
              }else if(qualquerFantasma.direcao=='s' && (qualquerFantasma.yMatriz != 12) && (matriz[qualquerFantasma.yMatriz+1][qualquerFantasma.xMatriz] == 1 || matriz[qualquerFantasma.yMatriz+1][qualquerFantasma.xMatriz] == 6)){ qualquerFantasma.transicaoAbaixo = false;
              
              }else if(qualquerFantasma.direcao=='s' && (qualquerFantasma.yMatriz == 12)){
                 qualquerFantasma.Y += 2;
                 
                 if(qualquerFantasma.Y >= height+50){ qualquerFantasma.Y = -50; }
                 
                 if((qualquerFantasma.Y < 50) && (qualquerFantasma.Y >= 25)){
                    qualquerFantasma.Y = 0;
                    qualquerFantasma.yMatriz = 0;
                    qualquerFantasma.transicaoAbaixo = false;
                 }
              }
            
   
   }//for
}
