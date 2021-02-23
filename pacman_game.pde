PacMan pac; //Esse objeto irá representar o pacman 

class PacMan{
   int X=75;
   int Y=75;
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

//1050/50 = 21  | 650/50 = 13
int[][] matriz = {
 /* Essa matriz representa e posiciona todos os elementos do jogo (pacman, obstáculos e comida) 
    na tela através dos valores e posições dos números na matriz.*/
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1},
  {1, 3, 1, 1, 1, 3, 1, 1, 3, 1, 1, 1, 3, 1, 1, 3, 1, 1, 1, 3, 1},
  {1, 3, 1, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 1, 3, 1},
  {1, 3, 3, 3, 1, 1, 1, 3, 1, 1, 3, 1, 1, 3, 1, 1, 1, 3, 3, 3, 1},
  {1, 3, 1, 3, 3, 3, 3, 3, 1, 3, 3, 3, 1, 3, 3, 3, 3, 3, 1, 3, 1},
  {3, 3, 1, 1, 1, 3, 1, 3, 1, 1, 1, 1, 1, 3, 1, 3, 1, 1, 1, 3, 3},
  {1, 3, 3, 3, 1, 3, 1, 3, 3, 3, 3, 3, 3, 3, 1, 3, 1, 3, 3, 3, 1},
  {1, 3, 1, 3, 1, 3, 1, 1, 3, 1, 1, 1, 3, 1, 1, 3, 1, 3, 1, 3, 1},
  {1, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3, 1},
  {1, 3, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 1, 3, 1, 1, 3, 1},
  {1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
};

char tecla='d';
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

void setup(){ size(1050,650); pac = new PacMan(); /*instanciando o objeto "pacman"*/}

void keyTyped() { tecla= key; }

void draw(){
   background(0);
   verificarColisao();
   verificarTecla();
   desenhaCenario();
   desenhaPacMan();
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
             transicaoEsquerda=false; println("X: "+pac.X+" | Y: "+pac.Y);
          }
        }else if((X>0) && (matriz[Y][X]==2) && (matriz[Y][X-1]==1)){  transicaoEsquerda = false;
        }else if((X==0) && (matriz[Y][X]==2) && (teclaTemporaria=='a')){ 
           pac.X-=2;
           if(pac.X <= -50){ pac.X=width;}
           
           if((pac.X <= (width-25)) && (pac.X>(width-50))){
              pac.X = 1025;
              matriz[Y][X] = 0;
              matriz[Y][20] = 2;
              transicaoDireita = false;
           }
        }
        
        //Se na casa à esquerda do pacman não houver um obstáculo (representado por 1) e sim uma casa vazia (0) ou uma casa que acomoda uma comida (3) o pacman poderá ir até ela.
        if((X<matriz[0].length-1) && (matriz[Y][X+1]==0 || matriz[Y][X+1]==3) && matriz[Y][X]==2 && (pac.X <= ((X+1)*50+25)) && (teclaTemporaria=='d') 
        && transicaoDireita && !transicaoEsquerda && !transicaoAcima && !transicaoBaixo){
            pac.X +=2; 
            if(pac.X == ((X+1)*50)+25){
                transicaoDireita=false;
                matriz[Y][X] = 0;
                matriz[Y][X+1] = 2;println("X: "+pac.X+" | Y: "+pac.Y);
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
       
        //Se na casa à esquerda do pacman não houver um obstáculo (representado por 1) e sim uma casa vazia (0) ou uma casa que acomoda uma comida (3) o pacman poderá ir até ela.
        if(Y>0 && (matriz[Y-1][X]==0 || matriz[Y-1][X]==3) && matriz[Y][X]==2 && (pac.Y >= ((Y-1)*50)+25) && (teclaTemporaria=='w') 
        && !transicaoDireita && !transicaoEsquerda && transicaoAcima && !transicaoBaixo){
          pac.Y -=2; 
           if(pac.Y == ((Y-1)*50)+25){
              matriz[Y][X] = 0;
              matriz[Y-1][X]=2;
              transicaoAcima=false;  println("X: "+pac.X+" | Y: "+pac.Y);
           }
        }else if((Y>0) && (matriz[Y][X]==2) && (matriz[Y-1][X]==1)){ transicaoAcima = false;
        }else if((Y==0) && (matriz[Y][X]==2) && (teclaTemporaria=='w')){ 
           pac.Y-=2;
           
           if(pac.Y <= -50){ pac.Y=height;}
           
           if((pac.Y <= (height-25)) && (pac.Y>height-50)){
              pac.Y=625;
              matriz[Y][X]=0;
              matriz[12][X]=2;
              transicaoAcima=false;
           }
        }
        
        //Se na casa à esquerda do pacman não houver um obstáculo (representado por 1) e sim uma casa vazia (0) ou uma casa que acomoda uma comida (3) o pacman poderá ir até ela.
        if(Y<(matriz.length-1) && (matriz[Y+1][X]==0 || matriz[Y+1][X]==3) && (matriz[Y][X]==2) && (pac.Y <= ((Y+1)*50)+25) && (teclaTemporaria=='s') 
        && (!transicaoDireita) && (!transicaoEsquerda) && (!transicaoAcima) && (transicaoBaixo)){
          pac.Y +=2;  
            if(pac.Y == ((Y+1)*50)+25){
               pac.Y=(Y+1)*50+25;
               matriz[Y][X]=0;
               matriz[Y+1][X]=2;
               transicaoBaixo = false;  println("Y:"+Y+"| X: "+pac.X+" | pacY: "+pac.Y);
            }
        }else if(Y<(matriz.length-1) && (matriz[Y+1][X]==1) && (matriz[Y][X]==2)){ transicaoBaixo = false;
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
    }
  }

  if(transicaoAcima==false && transicaoDireita==false 
     && transicaoEsquerda==false && transicaoBaixo==false){
       /*Se o pacman terminar o seu deslocamento ele irá para a próxima casa conforme a tecla clicada durante o seu movimento.
       Se nenhuma tecla foi clicada ao longo do seu movimento, ele continuará à ir para a próxima casa na mesma direção que antes
       estava. Mas, se na próxima casa houver um obstáculo o seu movimento é cessado e o pacman fica imóvel até que uma próxima tecla seja clicada.   */

       teclaTemporaria = tecla; /*a variável "teclaTemporária" guardará o valor da tecla que o usuário clicou e NÃO mudará até que o deslocamento 
       do pacman de uma casa à outra seja completo. Após isso, é que a variável "teclaTemporária" poderá ser alterada e receber o novo valor de "tecla"*/
       switch(teclaTemporaria){
           case 'a': transicaoEsquerda = true; break;
           case 'w': transicaoAcima = true; break;
           case 's': transicaoBaixo = true; break;
           case 'd': transicaoDireita = true; break;
       }
       switch(teclaTemporaria){
           case 'a': pac.direcao='a'; break;
           case 'd': pac.direcao='d'; break;
           case 'w': pac.direcao='w'; break;
           case 's': pac.direcao='s'; break;
           default:  break;
       }
   }
}

//---------------------------------------------------------------------------------------------------------

void desenhaPacMan(){ //Função que desenha o pacman
  noStroke();
  fill(250,249,29);
  
  //A partir da tecla clicada a direção que o pacman irá olhar, e consequentemente abrir e fechar a boca, será definida.
  switch(pac.direcao){
     case 'a':  arc(pac.X, pac.Y, 50, 50, pac.arcoInicialA, pac.arcoFinalA); break;
     case 'd':  arc(pac.X, pac.Y, 50, 50, pac.arcoInicialD, pac.arcoFinalD); break;
     case 'w':  arc(pac.X, pac.Y, 50, 50, pac.arcoInicialW, pac.arcoFinalW); break;
     case 's':  arc(pac.X, pac.Y, 50, 50, pac.arcoInicialS, pac.arcoFinalS); break;
  }
}

//---------------------------------------------------------------------------------------------------------

void desenhaCenario(){ //Função que desenha o cenário no qual contém um conjunto de quadrados azuis(obstáculos) e bolinhas brancas(comida)
  for(int X=0; X<matriz[0].length; X++){
    for(int Y=0; Y<matriz.length; Y++){        
         if(matriz[Y][X]==1){
            fill(0,0,255); square(X*50 ,Y*50 ,50); //desenhando o quadrado azul (obstáculo)
         }else if(matriz[Y][X]==3){
            fill(255);  circle(X*50+25, Y*50+25, 10); //desenhando a bolinha de comida     
         }
       }
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
