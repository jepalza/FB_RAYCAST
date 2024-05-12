 ' ------------------------YouTube-3DSage----------------------------------------
' Full video: https://youtu.be/PC1RaETIx3Y
' WADS to move player.
'
' conversion a FreeBasic https://www.freebasic.net/ por Joseba Epalza (jepalza) 2024 
' (jepalza arroba gmail punto com)

#include "GL/glut.bi"

#Ifndef M_PI
	#Define M_PI 3.14159265359
	#Define PI M_PI
#EndIf

Function degToRad(a As Single) As Single 
	return a*M_PI/180.0
End Function

Function FixAng(a As Single) As Single 
	if(a>359) Then 
  		a-=360 
	EndIf
	if(a<0) Then 
	  a+=360 
	EndIf
   return a
End Function

Function distance(ax As Single , ay As Single , bx As Single , by As Single , ang As Single) As Single 
	return cos(degToRad(ang))*(bx-ax)-sin(degToRad(ang))*(by-ay)
End Function

Dim Shared As Single px,py,pdx,pdy,pa 
Dim Shared As Single frame1,frame2,fps 

Type ButtonKeys 
	As Integer w,a,d,s                      ' button state on off
End Type
Dim Shared As ButtonKeys Keys 



#include "texturas.bi"
#include "mapas.bi"



' -------------------------------DRAW MAPS -------------------------------------
Sub drawMap2D()

	Dim As Integer x,y,xo,yo 
	for y=0 To mapY -1      
		for x=0 To mapX -1      
			If (mapW(y*mapX+x)>0) Then 
				glColor3f(1,1,1)
			Else 
				glColor3f(0,0,0) 
			EndIf
			
			xo=x*mapS: yo=y*mapS 
			glBegin(GL_QUADS) 
			glVertex2i( 0   +xo+1, 0   +yo+1) 
			glVertex2i( 0   +xo+1, mapS+yo-1) 
			glVertex2i( mapS+xo-1, mapS+yo-1) 
			glVertex2i( mapS+xo-1, 0   +yo+1) 
			glEnd() 
		Next
	Next
 
End Sub
' -----------------------------------------------------------------------------


' ------------------------PLAYER------------------------------------------------
Sub drawPlayer2D()
	
	glColor3f(1,1,0)
	glPointSize(8)
	glLineWidth(4) 
	
	glBegin(GL_POINTS)
		glVertex2i(px,py)
	glEnd() 
	
	glBegin(GL_LINES)
		glVertex2i(px,py)
		glVertex2i(px+pdx*20,py+pdy*20)
	glEnd() 
	
End Sub' -----------------------------------------------------------------------------


' ---------------------------Draw Rays and Walls--------------------------------
Sub drawRays2D()

	glColor3f(0,1,1)
	glBegin(GL_QUADS)
		glVertex2i(526,  0)
		glVertex2i(1006,  0)
		glVertex2i(1006,160)
		glVertex2i(526,160)
	glEnd() 	
	
	glColor3f(0,0,1)
	glBegin(GL_QUADS)
		glVertex2i(526,160)
		glVertex2i(1006,160)
		glVertex2i(1006,320)
		glVertex2i(526,320)
	glEnd() 	 	
	
 Dim As Integer r,mx,my,mp,dof,side
 Dim As Single vx,vy,rx,ry,ra,xo,yo,disV,disH 

 ra=FixAng(pa+30) ' ray set back 30 degrees

 For r=0 To 59       
	  
	  Dim As Integer vmt=0,hmt=0 ' vertical and horizontal map texture number
	  
	  
	  ' ---Vertical---
	  dof=0
	  side=0
	  disV=100000 
	  Dim As Single Tang=tan(degToRad(ra)) 
	  If (cos(degToRad(ra))> 0.001) Then ' looking left
		 rx=((Int(px) Shr 6) Shl 6)+64
		 ry=(px-rx)*Tang+py
		 xo= 64
		 yo=-xo*Tang
	  ElseIf (cos(degToRad(ra))<-0.001) Then ' looking right
		 rx=((Int(px) Shr 6) Shl 6) -0.0001
		 ry=(px-rx)*Tang+py
		 xo=-64
		 yo=-xo*Tang
	  Else ' looking up or down. no hit
	    rx=px
	    ry=py
	    dof=8
	  EndIf
	                                                    
	  While (dof<8)
		   mx=Int(rx) Shr 6
		   my=int(ry) Shr 6
		   mp=my*mapX+mx 
		   If (mp>0) AndAlso (mp<mapX*mapY) AndAlso (mapW(mp)>0) Then ' hit
			  	vmt=mapW(mp)-1
			  	dof=8
			  	disV=cos(degToRad(ra))*(rx-px)-sin(degToRad(ra))*(ry-py)
		   else ' check next horizontal
			   rx+=xo
			   ry+=yo
			   dof+=1
		   EndIf                                      
	  Wend
	    
	  vx=rx
	  vy=ry 
	
	
	  ' ---Horizontal---
	  dof=0
	  disH=100000 
	  Tang=1.0/Tang 
	  If (sin(degToRad(ra))>0.001) Then ' looking up
	  		ry=((Int(py) Shr 6) Shl 6) -0.0001
	  		rx=(py-ry)*Tang+px
	  		yo=-64
	  		xo=-yo*Tang
	  ElseIf (sin(degToRad(ra))<-0.001) Then ' looking down
	  		ry=((Int(py) Shr 6) Shl 6)+64
	  		rx=(py-ry)*Tang+px
	  		yo= 64
	  		xo=-yo*Tang
	  Else ' looking straight left or right
	  		rx=px
	  		ry=py
	  		dof=8
	  EndIf
	                                                     
	
	  While (dof<8)
		   mx=Int(rx) Shr 6
		   my=int(ry) Shr 6
		   mp=my*mapX+mx 
		   If (mp>0) AndAlso (mp<mapX*mapY) AndAlso (mapW(mp)>0) Then ' hit
		  		hmt=mapW(mp)-1
		  		dof=8
		  		disH=cos(degToRad(ra))*(rx-px)-sin(degToRad(ra))*(ry-py)
		   else ' check next horizontal
		     	rx+=xo
		     	ry+=yo
		     	dof+=1
		   EndIf                                         
	  Wend
	  
	
	  Dim As Single shade=1 
	  glColor3f(0,0.8,0) 
	  If (disV<disH) Then ' horizontal hit first
	  		hmt=vmt
	  		shade=0.5
	  		rx=vx
	  		ry=vy
	  		disH=disV
	  		glColor3f(0,0.6,0)
	  EndIf
	  
	  ' draw 2D ray
	  glLineWidth(2)
	  glBegin(GL_LINES)
	  		glVertex2i(px,py)
	  		glVertex2i(rx,ry)
	  glEnd()
	
	  Dim As Integer ca=FixAng(pa-ra)
	  disH=disH*cos(degToRad(ca)) ' fix fisheye
	  Dim As Integer lineH = (mapS*320)/(disH) 
	  Dim As Single ty_step=32.0/lineH 
	  Dim As Single ty_off=0 
	  If (lineH>320) Then  ' line height and limit
	  		ty_off=(lineH-320)/2.0
	  		lineH=320
	  EndIf
	  Dim As Integer lineOff = 160 - (lineH Shr 1) ' line offset
	
	  ' ---draw walls---
	  Dim As Integer y 
	  Dim As Single ty=ty_off*ty_step+hmt*32 
	  Dim As Single tx 
	  If (shade=1) Then 
	  		tx=Int(rx/2.0) Mod 32
	  		if(ra>180) Then tx=31-tx   
	  Else
	    	tx=int(ry/2.0) Mod 32
	  		If (ra>90) AndAlso (ra<270) Then tx=31-tx 
	  EndIf
	  
	  for y=0 To lineH-1       
		   Dim As Single c=All_Textures(int(ty)*32 + int(tx))*shade 
		   if(hmt=0) Then glColor3f(c    , c/2.0, c/2.0) ' checkerboard red
		   if(hmt=1) Then glColor3f(c    , c    , c/2.0) ' Brick yellow
		   if(hmt=2) Then glColor3f(c/2.0, c/2.0, c    ) ' window blue
		   if(hmt=3) Then glColor3f(c/2.0, c    , c/2.0) ' door green
		   glPointSize(8) ' draw vertical wall
			   glBegin(GL_POINTS)
			   glVertex2i(r*8+530,y+lineOff)
		   glEnd()
		   ty+=ty_step 
	  Next
	
	  For y=lineOff+lineH To 319       
	  		' ---draw floors---
		  Dim As Single dy=y-(320/2.0), deg=degToRad(ra), raFix=cos(degToRad(FixAng(pa-ra))) 
		  tx=px/2 + cos(deg)*158*32/dy/raFix 
		  ty=py/2 - sin(deg)*158*32/dy/raFix 
		  Dim As Integer mp=mapF(int(ty/32.0)*mapX+Int(tx/32.0))*32*32 
		  Dim As Single c=All_Textures((int(ty) And 31)*32 + (Int(tx) And 31)+mp)*0.7 
		  glColor3f(c/1.3,c/1.3,c)
		  glPointSize(8)
		  glBegin(GL_POINTS)
		  		glVertex2i(r*8+530,y)
		  glEnd() 
		
		 ' ---draw ceiling---
		  mp=mapC(int(ty/32.0)*mapX+int(tx/32.0))*32*32 
		  c=All_Textures((Int(ty) And 31)*32 + (int(tx) And 31)+mp)*0.7 
		  glColor3f(c/2.0,c/1.2,c/2.0)
		  glPointSize(8)
		  glBegin(GL_POINTS)
		  		glVertex2i(r*8+530,320-y)
		  glEnd() 
		 
	  Next
	
	  ra=FixAng(ra-1)  ' go to next ray, 60 total
	 
 Next r
 
End Sub' -----------------------------------------------------------------------------


Sub init()
 glClearColor(0.3,0.3,0.3,0) 
 gluOrtho2D(0,1024,510,0) 
 px=150: py=400: pa=90 
 ' init player
 pdx=cos(degToRad(pa))
 pdy=-sin(degToRad(pa))
End Sub


Sub display cdecl()

	' frames per second
	frame2=glutGet(GLUT_ELAPSED_TIME)
	fps=(frame2-frame1)
	frame1=glutGet(GLUT_ELAPSED_TIME) 

 	' buttons
	if(Keys.a=1) Then 
		pa+=0.2*fps
		pa=FixAng(pa)
		pdx=cos(degToRad(pa))
		pdy=-sin(degToRad(pa)) 
	EndIf
	
	if(Keys.d=1) Then 
		pa-=0.2*fps
		pa=FixAng(pa)
		pdx=cos(degToRad(pa))
		pdy=-sin(degToRad(pa)) 
	EndIf
	
	
	Dim As Integer xo=0
	If (pdx<0) Then ' x offset to check map
		xo=-20 
	else
		xo=20 
	EndIf
	                                
	Dim As Integer yo=0
	If (pdy<0) Then  ' y offset to check map
		yo=-20 
	else
		yo=20 
	EndIf
                                     
	Dim As Integer ipx=px\64.0, ipx_add_xo=(px+xo)\64.0, ipx_sub_xo=(px-xo)\64.0 ' x position and offset
	Dim As Integer ipy=py\64.0, ipy_add_yo=(py+yo)\64.0, ipy_sub_yo=(py-yo)\64.0 ' y position and offset
	
	If (Keys.w=1) Then  ' move forward
		If(mapW(ipy*mapX        + ipx_add_xo)=0) Then  px+=pdx*0.2*fps 
		If(mapW(ipy_add_yo*mapX + ipx       )=0) Then  py+=pdy*0.2*fps 
	EndIf
	
	If (Keys.s=1) Then  ' move backward
		If(mapW(ipy*mapX        + ipx_sub_xo)=0) Then  px-=pdx*0.2*fps 
		if(mapW(ipy_sub_yo*mapX + ipx       )=0) Then  py-=pdy*0.2*fps 
	EndIf
	
	glutPostRedisplay() 
	
	glClear(GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT) 
	drawMap2D() 
	drawPlayer2D() 
	drawRays2D() 
	glutSwapBuffers() 
End Sub

Sub ButtonDown cdecl(ByVal key As UByte ,byval x As Integer ,byval y As Integer) ' keyboard button pressed down

 If key=Asc("a") Then Keys.a=1 
 If key=Asc("d") Then Keys.d=1 
 If key=Asc("w") Then Keys.w=1 
 If key=Asc("s") Then Keys.s=1 

 If key=Asc("e") Then  ' open doors
	
	Dim As Integer xo=0
	if(pdx<0) Then 
		xo=-25
	else
		xo=25 
	EndIf
	
	Dim As Integer yo=0
	if(pdy<0) Then 
		yo=-25
	else
		yo=25 
	EndIf
	
	Dim As Integer ipx=px\64.0, ipx_add_xo=(px+xo)\64.0 
	Dim As Integer ipy=py\64.0, ipy_add_yo=(py+yo)\64.0 
	If(mapW(ipy_add_yo*mapX+ipx_add_xo)=4) Then 
		mapW(ipy_add_yo*mapX+ipx_add_xo)=0 
	EndIf
	
 EndIf
  
 glutPostRedisplay() 
End Sub

Sub ButtonUp cdecl(ByVal key As UByte ,byval x As Integer ,byval y As Integer) ' keyboard button pressed up

 If key=Asc("a") Then Keys.a=0 
 If key=Asc("d") Then Keys.d=0 
 If key=Asc("w") Then Keys.w=0 
 If key=Asc("s") Then Keys.s=0 
  
 glutPostRedisplay() 
End Sub

Sub resize cdecl(w As Integer , h As Integer) ' screen window rescaled, snap back
	glutReshapeWindow(1024,512) 
End Sub


 glutinit(1," ") ' argc=1, argv=" "
 
 glutInitDisplayMode(GLUT_DOUBLE Or GLUT_RGB) 
 glutInitWindowSize(1024,510) 
 glutInitWindowPosition(200,200) 
 glutCreateWindow("YouTube-3DSage")
 
 init() 
 
 glutDisplayFunc(@display) 
 glutReshapeFunc(@resize) 
 glutKeyboardFunc(@ButtonDown) 
 glutKeyboardUpFunc(@ButtonUp) 
 glutMainLoop() 

