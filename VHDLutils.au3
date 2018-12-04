#include-once "Array.au3"

Const $librerias_nombres[] = ["IEEE"]
Const $paquetes_nombres[] = ["STD_LOGIC_1164","STD_LOGIC_ARITH","STD_LOGIC_UNSIGNED"]
Const $paquetes_libreria[] = [0,0,0]

Const $contenidos_LOGIC_1164[] = ["BINARY"]
Const $paquetes_contenidos = [$contenidos_LOGIC_1164]

Const $PORT_EXPRESSION = 1
Const $SIGNAL_EXPRESSION = 2
Const $LOGIC_EXPRESSION = 3

Const $ZONE_DELIMITER[][] = [["",""],["VAR","VAREND"],["VAR","VAREND"],["LOGIC","LOGICEND"]]
Const $START = 0
Const $END = 1

Const $ERROR[] = ["BOKEY","FILE_NOT_FOUND","EMPTY_NAME_DEFINITION","ILLEGAL_END_STATEMENT","UNKNOWN_MODIFIER_FOR_OPEN/CLOSE_STATEMENT","TOO_MANY_MODIFIERS_FOR_OPEN_STATEMENT","ILLEGAL_OPEN_STATEMENT","NOT_CLOSING_SECTION","VARIABLE_BAD_FORMATED"]
Const $ERROR_BOKEY = 0
Const $ERROR_FILE_NOT_FOUND = 1
Const $ERROR_EMPTY_NAME_DEFINITION = 2
Const $ERROR_ILLEGAL_END_STATEMENT = 3
Const $ERROR_UNKNOWN_MODIFIER_FOR_OPENCLOSE_STATEMENT = 4
Const $ERROR_TOO_MANY_MODIFIERS_FOR_OPEN_STATEMENT = 5
Const $ERROR_ILLEGAL_OPEN_STATEMENT = 6
Const $ERROR_NOT_CLOSING_SECTION = 7
Const $ERROR_VARIABLE_BAD_FORMATED = 8

Global $VARIABLE_SECCTION





Func leerFuente($file)
   If Not FileExists($file) Then Return SetError(1, -1)
   Return StringSplit(FileRead($file),@CRLF,1)
EndFunc
Func eliminarComentarios($lineas)
   $borron = False
   $lineIn = -1
   $lineOut = -1
   For $i = 1 To $lineas[0]
	  For $j = 1 To StringLen($lineas[$i])
		  If (Not $borron) And $lineIn = -1 And StringMid($lineas[$i],$j,2) = "/*" Then
			$borron = True
			$lineIn = $j
			$j += 1
		 EndIf
		 If $borron And StringMid($lineas[$i],$j,2) = "*/" Then
			$borron = False
			$lineOut = $j
			$j += 1
		 EndIf
		 If (Not $borron) And $lineIn = -1 And StringMid($lineas[$i],$j,2) = "//" Then
			$lineIn = $j
			$j += 1
		 EndIf
		 If (Not $borron) And $lineIn <> -1 And StringMid($lineas[$i],$j,2) = "\\" Then
			$lineOut = $j
			$j += 1
		 EndIf
	  Next

	  If $lineIn = -1 Then
		 If $lineOut = -1 Then
			If $borron Then $lineas[$i] = ""
		 Else
			$lineas[$i] = StringTrimLeft($lineas[$i],$lineOut+1)
		 EndIf
	  Else
		 If $lineOut = -1 Then
			$lineas[$i] = StringTrimRight($lineas[$i],StringLen($lineas[$i])-$lineIn+1)
		 Else
			$lineas[$i] = StringTrimRight($lineas[$i],StringLen($lineas[$i])-$lineIn+1) & StringTrimLeft($lineas[$i],$lineOut+1)
		 EndIf
	  EndIf
	  $lineIn = -1
	  $lineOut = -1
   Next
   Return $lineas
EndFunc
Func lineasOptimizar($lineas); Deprecated: Es necesario conservar las lineas intactas para poder decir donde se producen errores Usar en su lugar lineasLimpiar()
   Local $lineasN[1]
   $lineasN[0] = 0
   For $i = 1 To $lineas[0]
	  If $lineas[$i] Then $lineasN = _agregar($lineasN, StringReplace($lineas[$i],@TAB,""))
   Next
   Return $lineasN
EndFunc
Func lineasLimpiar($lineas)
   For $i = 1 To $lineas[0]
	  $lineas[$i] = StringReplace($lineas[$i],@TAB,"")
   Next
   Return $lineas
EndFunc
Func buscarNombre($lineas, $buscar, $defecto)
   $buscar = StringUpper($buscar)
   For $i = 1 To $lineas[0]
	  $lineas[$i] = StringReplace(StringReplace($lineas[$i],@TAB,"")," ","")
	  If StringUpper(StringMid($lineas[$i],1,StringLen($buscar))) = $buscar Then
		 $nombre = StringTrimLeft($lineas[$i],StringLen($buscar))
		 If $nombre Then
			Return $nombre
		 Else
			Return SetError(2, $i,$i)
		 EndIf
	  EndIf
   Next
   Return $defecto
EndFunc

Func detectarPaquetes($lineas,$contenidos,$nombres)
   Local $usos[UBound($nombres)]
   For $i = 0 To UBound($nombres)-1
	  $usos[$i] = False
   Next

   For $i = 0 To $lineas[0]
	  For $j = 0 To UBound($contenidos)-1
		 If $usos[$j] Then ExitLoop
		 $detector = $contenidos[$j]
		 For $k = 0 To UBound($detector)-1
			If StringInStr($lineas[$i],$detector[$k],2) Then
			   $usos[$j] = True
			   ExitLoop
			EndIf
		 Next
	  Next
   Next

   Return $usos
EndFunc
Func detectarLibrerias($paquetes,$librerias,$nombres)
   Local $usos[UBound($nombres)]
   For $i = 0 To UBound($nombres)-1
	  $usos[$i] = False
   Next

   For $i = 0 To UBound($paquetes)-1
	  If $usos[$librerias[$i]] Then ContinueLoop
	  If $paquetes[$i] Then
		 $usos[$librerias[$i]] = True
	  EndIf
   Next

   Return $usos
EndFunc

Func detectarVariables($lineas)
   $VARIABLE_SECCTION = False
   For $i = 0 To $lineas[0]
	  If StringInStr($lineas[$i],"VAREND",2) Then
		 $VARIABLE_SECCTION = True
		 ExitLoop
	  EndIf
   Next

   Local $variables[1]
   $variables[0] = 0

   $estado = 0
   For $i = 1 To $lineas[0]
	  $estado = _segmento($lineas[$i], $estado, "VAR", "parallel", "sequential", "VAREND")
	  If @error Then Return SetError(@error,$i)
	  If $VARIABLE_SECCTION And $estado > 0 Then
		 $tipo = _comprobarVariable($lineas[$i], $estado)
		 If @error Then
			Return SetError($ERROR_VARIABLE_BAD_FORMATED,$i)
		 Else
			$variables = _agregar($variables, $tipo)
		 EndIf
	  ElseIf (Not $VARIABLE_SECCTION) And $estado = 0 Then
		 $tipo = _comprobarVariable($lineas[$i], 0)
		 If IsArray($tipo) And $tipo[1] And $tipo[3] Then $variables =  _agregar($variables, $tipo)
	  EndIf
   Next
   If $estado <> 0 Then Return SetError(7,$i); Error 7: Not every section is closed at the end of document
   Return $variables
EndFunc











Func _comprobarVariable($linea, $lugar)
   Local $variable[5]
   $variable[1] = ""

   $puntos = StringInStr($linea,":")
   $letras = False
   For $i = 1 To $puntos-1
	  $c = StringMid($linea,$i,1)
	  If $c <> " " Then
		 $variable[1] &= $c
		 If $letras Then
			Return SetError($ERROR_VARIABLE_BAD_FORMATED,0,0)
		 Else
			$letras = True
		 EndIf
	  EndIf
   Next

   $in = StringInStr($linea,"in ",2)
   $out = StringInStr($linea,"out ",2)
   If $in And $out Then Return SetError($ERROR_VARIABLE_BAD_FORMATED,0,0)
   If $in Then $puntos+=3
   If $out Then $puntos+=4

   $corchete = StringInStr($linea,"[",2)-1
   If $corchete = -1 Then $corchete = StringLen($linea)
   $letras = False
   $variable[3] = ""
   For $i = $puntos+1 To $corchete
	  $c = StringMid($linea,$i,1)
	  If $c = " " Then
		 If $letras Then
			Return SetError($ERROR_VARIABLE_BAD_FORMATED,0,0)
		 Else
			$letras = True
		 EndIf
	  Else
		 $variable[3] &= $c
	  EndIf
   Next

   $linea = StringReplace(StringTrimLeft($linea,$puntos)," ","")
   $corchete = False
   $variable[4] = ""
   For $i = 1 To StringLen($linea)
	  $c = StringMid($linea,$i,1)
	  If $c = "[" Then
		 If $corchete = False Then
			$corchete = True
		 Else
			Return SetError($ERROR_VARIABLE_BAD_FORMATED,0,0)
		 EndIf
	  ElseIf $c = "]" Then
		 If $corchete = True Then
			$corchete = False
		 Else
			Return SetError($ERROR_VARIABLE_BAD_FORMATED,0,0)
		 EndIf
	  ElseIf $corchete Then
		 $variable[4] &= $c
	  EndIf
   Next
   If $corchete Then Return SetError($ERROR_VARIABLE_BAD_FORMATED,0,0)

   $variable[0] = $lugar
   If $in Then $variable[2] = "In"
   If $out Then $variable[2] = "Out"

   Return $variable
EndFunc

Func _segmento($linea, $prev, $modStart, $modDef, $modBis, $modExit)
   $partes = StringSplit($linea," ")
   If $partes[0] <> 0 Then
	  If $prev = 0 Then
		 If StringUpper($partes[1]) = $modExit Then Return SetError(3); Error 3: End statement not closing any Open statement
		 If StringUpper($partes[1]) = $modStart Then
			If $partes[0] = 2 Then
			   If StringUpper($partes[2]) = $modDef Then Return -1
			   If StringUpper($partes[2]) = $modBis Then Return -2
			   Return SetError(4);  Error 4: Worng keyword for Open statement
			Else
			   If $partes[0] > 2 Then Return SetError(5); Error 5: To many keywords after Open statement
			   Return -1
			EndIf
		 EndIf
	  Else
		 If $partes[0] >= 1 Then
			If StringUpper($partes[1]) = $modStart Then Return SetError(6); Error 6: Two Open statements consecutive
			If StringUpper($partes[1]) = $modExit Then
			   If $partes[0] = 1 Then
				  Return 0
			   Else
				  Return SetError(5); Error 5: To many keywords after Close statement
			   EndIf
			EndIf
		 EndIf
	  EndIf
   EndIf
   If $prev < 0 Then
	  Return $prev*-1
   Else
	  Return $prev
   EndIf
EndFunc
Func _ValidarIdentificador($identificador)
   $letras = false
   For $i = StringLen($identificador) To 1 Step -1
	  If StringMid($identificador,$i,1) = " " Then
		 If $letras Then
			Return False
		 Else
			$identificador = StringTrimRight($identificador,1)
		 EndIf
	  Else
		 $letras = True
	  EndIf
   Next
   Return True
EndFunc
Func _EsNombreReal($nombre)
   $nombre = _estandar($nombre)
   For $i = 0 To UBound($nombres)-1
	  If $nombres[$i][1] = $nombre Then Return True
   Next
   Return False
EndFunc
Func _estandar($string)
   Return StringUpper(StringReplace(StringReplace(StringUpper($string),@TAB,"")," ",""))
   ;Return StringStripWS($string,8)
EndFunc
Func _agregar($array, $elemento)
   ReDim $array[$array[0]+2]
   $array[0]+= 1
   $array[$array[0]] = $elemento
   Return $array
EndFunc