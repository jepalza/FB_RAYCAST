
' he separado la matriz de mapas, para hacer mas comoda su edicion

' --------- MAPA DE 8x8 ------------
#define mapX  8      ' map width
#define mapY  8      ' map height
#define mapS mapX*MapY  ' map cube size 64

' Edit these 3 arrays with values 0-4 to create your own level!
' nota jepalza: el "4" es la "puerta(door)" que podemos abrir con la tecla "e"
Dim Shared As Integer mapW(mapS -1)=_          ' walls
{_
 1,1,1,1,1,3,1,1,_
 1,0,0,1,0,0,0,1,_
 1,0,0,4,0,2,0,1,_ ' 4=puerta 1
 1,1,4,1,0,0,0,1,_ ' 4=puerta 2
 2,0,0,0,0,0,0,1,_
 2,0,0,0,0,1,0,1,_
 2,0,0,0,0,0,0,1,_
 1,1,3,1,3,1,3,1 _
} 

Dim Shared As Integer mapF(mapS -1)=_          ' floors
{_
 0,0,0,0,0,0,0,0,_
 0,0,0,0,1,1,0,0,_
 0,0,0,0,2,0,0,0,_
 0,0,0,0,0,0,0,0,_
 0,0,2,0,0,0,0,0,_
 0,0,0,0,0,0,0,0,_
 0,1,1,1,1,0,0,0,_
 0,0,0,0,0,0,0,0 _
} 

Dim Shared As Integer mapC(mapS -1)=_          ' ceiling
{_
 0,0,0,0,0,0,0,0,_
 0,0,0,0,0,0,0,0,_
 0,0,0,0,0,0,0,0,_
 0,0,0,0,0,0,1,0,_
 0,1,3,1,0,0,0,0,_
 0,0,0,0,0,0,0,0,_
 0,0,0,0,0,0,0,0,_
 0,0,0,0,0,0,0,0 _
} 
