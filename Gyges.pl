jugar(Turno, Tablero, NuevoTablero, Movimiento) :- guitracer,Turno=1, movimiento(Tablero,1,2,NuevoTablero,Movimiento). 
jugar(Turno, Tablero, NuevoTablero, Movimiento) :- Turno=2, movimiento(Tablero,2,1,NuevoTablero,Movimiento).

%------------------------------------------------------------------------------
%Relaciona la fila de la que se puede mover una ficha en un turno con Res
filaMover(Turno,Tablero,Res) :- Turno = 1, filaMoverAux(Turno, Tablero, 0, Res).
filaMover(Turno,Tablero,Res) :- Turno = 2, filaMoverAux(Turno, Tablero, 4, Res).
filaMoverAux(_, [], Res, Res).
filaMoverAux(Turno, [(_,Fila,_) | RestoTablero], Actual, Res) :- Turno = 1, Fila >= Actual, filaMoverAux(Turno,RestoTablero,Fila,Res).
filaMoverAux(Turno, [(_,Fila,_) | RestoTablero], Actual, Res) :- Turno = 1, Fila < Actual, filaMoverAux(Turno,RestoTablero,Actual,Res).
filaMoverAux(Turno, [(_,Fila,_) | RestoTablero], Actual, Res) :- Turno = 2, Fila >= Actual, filaMoverAux(Turno,RestoTablero,Actual,Res).
filaMoverAux(Turno, [(_,Fila,_) | RestoTablero], Actual, Res) :- Turno = 2, Fila < Actual, filaMoverAux(Turno,RestoTablero,Fila,Res).
%------------------------------------------------------------------------------
%Mueve Ficha de Tablero y relaciona el resultado con Res.
mover(Turno, (Numero,Fila,Columna), Tablero, Sol):-delete(Tablero, (Ficha,Fila,Columna), NuevoTablero), %borrar la posicion antigua de la ficha
											findall(Res,moverAux(Turno, (Numero,Fila,Columna), Numero, NuevoTablero,[(Fila,Columna)], Res),List), %encontrar todas las soluciones y asociarlo a List
											list_to_set(List,Set), %Eliminar las casillas repetidas.
											member(Sol,Set),  \+ tableroInvalido(Sol).		%Listar cada una de los posibles movimientos.

%MOVER AUX: Mueve "Ficha" "Numero" posiciones en "Tablero" sin pasar por casillas ya visitadas en la lista "Mov", generando "NuevoTablero"  
moverAux(Turno, Ficha, 0, Tablero, Mov, NuevoTablero) :- 	ocupado(Tablero, Ficha, Numero), %Si al final del movimiento se tiene una casilla ocupada
													moverAux(Turno, Ficha,Numero,Tablero,Mov, NuevoTablero).%volver a mover la ficha la cantidad de espacios que representa la ficha en esa posicion.
moverAux(Turno, Ficha, 0, Tablero, Mov, NuevoTablero) :- !, append(Tablero, [Ficha], NuevoTablero).%Agregar la nueva posicion de la ficha al tablero.
moverAux(Turno, (Ficha, Fila, Columna), Numero, Tablero, Mov, Res):-	NuevoNumero is Numero-1, NuevaFila is Fila +1, NuevaFila =< 5,%moverse una fila
															Turno = 2,
															libre(Tablero, NuevaFila, Columna, NuevoNumero),%asegurarse que el espacio este libre
															valido(NuevaFila, Columna, Mov),%asegurarse que el movimiento no sea hacia atras
															append(Mov, [(NuevaFila, Columna)], NuevoMov),%agregar la casilla a la lista de movimientos
															moverAux(Turno, (Ficha, NuevaFila, Columna), NuevoNumero, Tablero, NuevoMov, Res).%recursivamente llamar hasta que se hayan movido todas las casillas necesarias
moverAux(Turno, (Ficha, Fila, Columna), Numero, Tablero, Mov, Res):-	NuevoNumero is Numero-1, NuevaFila is Fila -1, NuevaFila >= -1,
															Turno = 1,
															libre(Tablero, NuevaFila, Columna, NuevoNumero),
															valido(NuevaFila, Columna, Mov),
															append(Mov, [(NuevaFila, Columna)], NuevoMov),
															moverAux(Turno, (Ficha, NuevaFila, Columna), NuevoNumero, Tablero, NuevoMov, Res).
moverAux(Turno, (Ficha, Fila, Columna), Numero, Tablero, Mov, Res):-	NuevoNumero is Numero-1, NuevaColumna is Columna+1, NuevaColumna =< 5,
															libre(Tablero, Fila, NuevaColumna, NuevoNumero),
															valido(Fila, NuevaColumna, Mov),
															append(Mov, [(Fila, NuevaColumna)], NuevoMov),
															moverAux(Turno, (Ficha, Fila, NuevaColumna), NuevoNumero, Tablero, NuevoMov, Res).
moverAux(Turno, (Ficha, Fila, Columna), Numero, Tablero, Mov, Res):-	NuevoNumero is Numero-1, NuevaColumna is Columna-1, NuevaColumna >= 0,
															libre(Tablero, Fila, NuevaColumna, NuevoNumero),
															valido(Fila, NuevaColumna), Mov),
															append(Mov, [(Fila, NuevaColumna)], NuevoMov),
															moverAux(Turno, (Ficha, Fila, NuevaColumna), NuevoNumero, Tablero, NuevoMov, Res).
%------------------------------------------------------------------------------
%LIBRE: Revisa si la posicion "Columna" "Fila" esta libre 
libre([],_,_,_).%si se llega a la lista vacia, la casilla esta vacía.
libre(_,Fila,_,Num):- Fila = 5, Num > 0, !,fail.%si se logra llegar a la meta (5), debe ser en el ultimo movimiento (Num=0)
libre(_,Fila,_,Num):- Fila = -1, Num > 0, !,fail.%si se logra llegar a la meta(-1), debe ser en el ultimo movimiento (Num=0)
libre(_,_,_,0):- !. %si no quedan movimientos por hacer, es exitoso.  Otra regla se encarga de asegurarse que dicha posicion este vacia
libre([(_,FilaActual, ColumnaActual) | _], Fila, Columna,_) :- FilaActual = Fila, ColumnaActual=Columna, !,fail.%Si Fila y Columna existen en la lista, fallar
libre([(_,_, _) | Resto], Fila, Columna,Numero) :- libre(Resto,Fila,Columna,Numero).%llamada recursiva.

%LIBRE: Revisa si la posicion de "Ficha" esta ocupada por otra, unificando el valor de la ficha en esa posicion con el ultimpo parametro. 
ocupado([],_,Ficha) :- fail.
ocupado([(FichaActual,FilaActual, ColumnaActual)|_], (Ficha,Fila, Columna), FichaActual) :- 
				FilaActual = Fila, ColumnaActual = Columna, !.
ocupado([(_,_, _) | RestoTablero], (Ficha, Fila, Columna),FichaActual) :- 
				ocupado(RestoTablero, (Ficha, Fila, Columna), FichaActual).

%VALIDO: Revisa que el movimiento que se vaya hacer no se haga a una casilla ya visitada.
valido(Fila,Columna,Mov) :- member((Fila,Columna),Mov), !, fail.
valido(_,_,_).

tableroInvalido([]) :- !,fail.
tableroInvalido([(_,Fila,Columna) | RestoFichas]) :- member((1,Fila,Columna),RestoFichas) ; member((2,Fila,Columna),RestoFichas) ; member((3,Fila,Columna),RestoFichas). 
tableroInvalido([_| RestoFichas]) :- tableroInvalido(RestoFichas).
%-----------------------------------------------------------------------------
movimiento(Tablero, Turno, TurnoOponente, NuevoTablero, Solucion):-movimientoGanador(Tablero, Tablero, Turno, NuevoTablero,Solucion), !.
movimiento(Tablero, Turno, TurnoOponente, NuevoTablero, Solucion):-findall([Res|NuevoTablero],movimientoNormal(Tablero, Tablero, Turno, TurnoOponente, NuevoTablero,Res),Lista), randomElem(Lista, [Solucion|NuevoTablero]),!.

%MOVIMIENTO GANADOR: Realiza un movimiento ganador si existiera
movimientoGanador([],_,_,_,_) :- !,fail.
movimientoGanador([(NumFicha,Fila,Columna) | RestoFichas], Tablero, Turno, NuevoTablero, Solucion) :- 	
										filaMover(Turno, Tablero, NumFila), 
										Fila=NumFila, ganador((NumFicha,Fila,Columna),Tablero,Turno,NuevoTablero),
										last(NuevoTablero,NuevaFicha),
										Solucion=[(NumFicha,Fila,Columna),NuevaFicha], !.
movimientoGanador([_| RestoFichas], Tablero, Turno, NuevoTablero, Solucion) :- 	
										movimientoGanador(RestoFichas, Tablero,Turno,NuevoTablero,Solucion).
%MOVIMIENTO NORMAL: Realiza un movimiento normal si un ganador no existiera
movimientoNormal([],_,_,_,_,_) :- !,fail.
movimientoNormal([(NumFicha,Fila,Columna) | RestoFichas], trace,Tablero, Turno, TurnoOponente, NuevoTablero, Solucion) :- 
										Turno=1,	
										filaMover(Turno, Tablero, NumFila), 
										Fila=NumFila, mover(Turno, (NumFicha,Fila,Columna), Tablero, NuevoTablero), 
										last(NuevoTablero,NuevaFicha), 
										not(movimientoGanador(NuevoTablero,NuevoTablero,TurnoOponente,_,_)),
										NuevaFicha=(_,FilaNueva,_), Fila >= FilaNueva,
										Solucion = [(NumFicha,Fila,Columna),NuevaFicha].
movimientoNormal([(NumFicha,Fila,Columna) | RestoFichas], Tablero, Turno, TurnoOponente, NuevoTablero, Solucion) :- 
										Turno=2,	
										filaMover(Turno, Tablero, NumFila), 
										Fila=NumFila, mover(Turno, (NumFicha,Fila,Columna), Tablero, NuevoTablero), 
										last(NuevoTablero,NuevaFicha), 
										not(movimientoGanador(NuevoTablero,NuevoTablero,TurnoOponente,_,_)),
										NuevaFicha=(_,FilaNueva,_), Fila =< FilaNueva,
										Solucion = [(NumFicha,Fila,Columna),NuevaFicha].
movimientoNormal([_| RestoFichas], Tablero, Turno,TurnoOponente, NuevoTablero, Solucion) :- 
										movimientoNormal(RestoFichas,Tablero,Turno,TurnoOponente,NuevoTablero,Solucion).


ganador(Ficha, Tablero, Turno, NuevoTablero) :- Turno = 1, mover(Turno, Ficha, Tablero, NuevoTablero), last(NuevoTablero,Sol), Sol=(_,Fila,_), Fila = -1.
ganador(Ficha, Tablero, Turno, NuevoTablero) :- Turno = 2, mover(Turno, Ficha, Tablero, NuevoTablero), last(NuevoTablero,Sol), Sol=(_,Fila,_), Fila = 5.

%Escoge un elemento al azar de una lista.
randomElem([], []).
randomElem(List, Elem) :-
        length(List, Length),
        random(0, Length, Index),
        nth0(Index, List, Elem).
%[(2,0,0),(3,0,1),(2,0,2),(1,0,3),(1,0,4),(3,0,5) , (1,4,0),(3,4,1),(2,4,2),(2,4,3),(3,4,4),(1,4,5)]
%mover(2,(1,0,3),[ (1, 0, 3), (1, 0, 4), (3, 0, 5), (1, 3, 0)],X).