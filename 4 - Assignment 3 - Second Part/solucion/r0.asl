// Agent r3 in project mars.mas2j

/* Initial beliefs and rules */

check(X,Y) :-
  horizontal(X,Y) |
  vertical(X,Y) |
  diagonal(X,Y).


horizontal(X,Y) :-
  (queen(X,_) & not block(X,_)) |
  (queen(X,YQ) & block(X,YB) & not (((Y < YB) & (YB < YQ)) | ((Y > YB) & (YB > YQ)))).

vertical(X,Y) :-
  (queen(_,Y) & not block(_,Y)) |
  (queen(XQ,Y) & block(XB,Y) & not (((X < XB) & (XB < XQ)) | ((X > XB) & (XB > XQ)))).

diagonal(X1,Y1) :-
  block(X1,Y1) |
  ( queen(X2,Y2) & ((X1-X2 == Y1-Y2) | (X2-X1 == Y1-Y2)) & not (block(X3,Y3) & ((X1-X3 == Y1-Y3) | (X3-X1 == Y1-Y3))) ) |
  ( queen(X2,Y2) & (X1-X2 == Y1-Y2) & block(X3,Y3) & (X1-X3 == Y1-Y3) & ((Y3<Y2 & Y2<Y1 & X3<X2 & X2<X1) | (Y3>Y2 & Y2>Y1 & X3>X2 & X2>X1)) ) |
  ( queen(X2,Y2) & (X2-X1 == Y1-Y2) & block(X3,Y3) & (X3-X1 == Y1-Y3) & ((Y3<Y2 & Y2<Y1 & X3>X2 & X2>X1) | (Y3>Y2 & Y2>Y1 & X3<X2 & X2<X1)) ).


/* Initial goals */

!start.

/* Plans */
+!start :playAs(0) <- queen(3,4); .wait(1000); block(3,2); block(1,6).
 // !ocupar;
 // !amenazadas;
 // !play.

+!start :playAs(1) <- true.

+size(N)<- !crearTablero(N).

/* ----- Crea un tablero de casillas libres con el numero de casillas que amenaza cada una ----- */
+!crearTablero(N) <-
	for(.range(X,0,N-1)){
		for(.range(Y,0,N-1)){
			+free(X,Y,N*N);
		}
	}.

+queen(X,Y) [source(percept)] : playAs(N) <-
	.print("Actualizando base de conocimientos");
	!ocupar(X,Y);
 // .findall(pos(PosX,PosY),free(PosX,PosY,_),Lista);
  .print(Lista);
	//!amenazadas;
  .

+block(X,Y) [source(percept)] : playAs(N) <-
  -free(X,Y,_);
	.print("Actualizando base de conocimientos");
  ?size(Size);
  for(.range(V,0,Size-1)){
    for(.range(W,0,Size-1)){
      if(not check(V,W) & not free(V,W,_)){
        +free(V,W,111);
      }
    }
  }
  .findall(pos(PosX,PosY),free(PosX,PosY,111),Lista);
  .print(Lista).

/* ----- Elimina casillas que no son libres ----- */
+!ocupar(X,Y) <-
  .print(X,",",Y);
	-free(X,Y,_);
  //Filas
  !filaDerecha(X+1,Y);
  !filaIzquierda(X-1,Y);

  //Columnas
  !columnaSuperior(X,Y-1);
  !columnaInferior(X,Y+1);

  //Diagonales
  !diagonalSI(X-1,Y-1);
  !diagonalSD(X+1,Y-1);
  !diagonalII(X-1,Y+1);
  !diagonalID(X+1,Y+1).
-!ocupar(X,Y).

//Filas
+!filaDerecha(X,Y) : size(N) & not block(X,Y) & X<N <-
  .print(X,",",Y);
  -free(X,Y,_);
  !filaDerecha(X+1,Y).
+!filaDerecha(X,Y).

+!filaIzquierda(X,Y) : size(N) & not block(X,Y) & X>=0 <-
  .print(X,",",Y);
  -free(X,Y,_);
  !filaIzquierda(X-1,Y).
+!filaIzquierda(X,Y).

//Columnas
+!columnaSuperior(X,Y) : size(N) & not block(X,Y) & Y>=0 <-
  .print(X,",",Y);
  -free(X,Y,_);
  !columnaSuperior(X,Y-1).
+!columnaSuperior(X,Y).

+!columnaInferior(X,Y) : size(N) & not block(X,Y) & Y<N <-
  .print(X,",",Y);
  -free(X,Y,_);
  !columnaSuperior(X,Y+1).
+!columnaInferior(X,Y).

//Diagonales
+!diagonalSI(X,Y) : size(N) & not block(X,Y) & Y>=0 & X>=0 <-
  .print(X,",",Y);
  -free(X,Y,_);
  !diagonalSI(X-1,Y-1).
+!diagonalSI(X,Y).

+!diagonalSD(X,Y) : size(N) & not block(X,Y) & Y>=0 & X<N <-
  .print(X,",",Y);
  -free(X,Y,_);
  !diagonalSD(X+1,Y-1).
+!diagonalSD(X,Y).

+!diagonalII(X,Y) : size(N) & not block(X,Y) & Y<N & X>=0 <-
  .print(X,",",Y);
  -free(X,Y,_);
  !diagonalII(X-1,Y+1).
+!diagonalII(X,Y).

+!diagonalID(X,Y) : size(N) & not block(X,Y) & Y<N & X<N <-
  .print(X,",",Y);
  -free(X,Y,_);
  !diagonalID(X+1,Y+1).
+!diagonalID(X,Y).


/* ----- Actualiza el contador de casillas libres amenazadas ----- */
+!amenazadas <-
	?size(N);
  +cont(0);
	for(free(X,Y,AM)){
    -+cont(0);

    // Número de casillas amenazadas en filas y columnas
    .findall(pos(_,X,Y),
            //Condiciones
            free(X,_,_) |
            free(_,Y,_) ,
            //Salida
            FilaColumna);

    // Número de casillas amenazadas en diagonales
    for(.range(I,0,N-1)){
			for(.range(J,0,N-1)){
        if(free(I,J,_)&((X-I == Y-J)|(I-X == Y-J))){
          ?cont(AUX);
          -+cont(AUX+1);
				}
      }
    }

    .length(FilaColumna,FC);
    ?cont(Diagonales);

		-free(X,Y,AM);
    //La casilla X,Y se cuenta como amenazada tanto en filas como columnas como diagonales (-2)
		+free(X,Y,FC+Diagonales-2);
	}
  .abolish(cont(_)).
-!amenazadas<-.print("ERROR AMENAZADAS").


+player(N) : playAs(N) <- .wait(300);.// !play.

+player(N) : playAs(M) & not N==M <- .wait(300); .print("No es mi turno.").

/* ----- Turno Blancas ----- */
/*
+player(0):playAs(0) <-
	-player(0)[source(percept)];
	!play.
*/

/* ----- Turno Negras ----- */
/*
+player(1):playAs(1) <-
	-player(1)[source(percept)];
	!play.
*/
/* ----- Jugar ----- */
+!play <-
	!select(Max);
  .print("Maximo: ", Max);
  !getPosition(Max, X,Y);
  queen(X,Y).
-!play <-.print("Juego Finalizado").

+!getPosition(pos(N,X,Y),X,Y).


/* ----- Seleccionar la Posición con mayor número de amenazadas ----- */
+!select(Max) <-
	.wait(700);
  //NumAmenazadas,X,Y
  .findall(pos(N,X,Y),free(X,Y,N),ListaPosiciones);
  .print("Posiciones posibles: ",ListaPosiciones);
  .max(ListaPosiciones,Max).
-!select(Max) <- Max = [].
