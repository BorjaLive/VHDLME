#include-once "Array.au3"

Const $librerias_nombres[] = ["IEEE"]
Const $paquetes_nombres[] = ["STD_LOGIC_1164","STD_LOGIC_ARITH","STD_LOGIC_UNSIGNED"]
Const $paquetes_libreria[] = [0,0,0]

Const $contenidos_LOGIC_1164[] = ["BINARY","BINARY[]"]
Const $paquetes_contenidos = [$contenidos_LOGIC_1164]

Const $nombres[][] = [["BINARY[]","STD_LOGIC_VECTOR"],["BINARY","STD_LOGIC"]]

Const $PORT_EXPRESSION = 1
Const $SIGNAL_EXPRESSION = 2
Const $LOGIC_EXPRESSION = 3

Const $ZONE_DELIMITER = [["",""],["VAR","VAREND"],["VAR","VAREND"],["LOGIC","LOGICEND"]]
Const $START = 0
Const $END = 1









Func eliminarComentarios($lineas)
   For $i = 1 To $lineas[0]
	  For $j = 1 To StringLen($lineas[$i])
		 If StringMid($lineas[$i],$j,2) = "//" Then
			$lineas[$i] = StringTrimRight($lineas[$i],StringLen($lineas[$i])-$j+1)
			ExitLoop
		 EndIf
	  Next
   Next
   Return $lineas
EndFunc
Func lineasOptimizar($lineas)
   Local $lineasN[1]
   $lineasN[0] = 0
   For $i = 1 To $lineas[0]
	  If $lineas[$i] Then $lineasN = _agregar($lineasN, StringReplace($lineas[$i],@TAB,""))
   Next
   Return $lineasN
EndFunc
Func buscarNombre($lineas, $buscar, $defecto)
   $buscar = StringUpper($buscar)
   For $i = 1 To $lineas[0]
	  $lineas[$i] = StringReplace(StringReplace($lineas[$i],@TAB,"")," ","")
	  If StringUpper(StringMid($lineas[$i],1,StringLen($buscar))) = $buscar Then Return StringTrimLeft($lineas[$i],StringLen($buscar))
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

Func cambiarNombres($lineas,$nombres)
   For $i = 1 To $lineas[0]
	  For $j = 0 To UBound($nombres)-1
		 $lineas[$i] = StringReplace($lineas[$i],$nombres[$j][0],$nombres[$j][1],0,2)
	  Next
   Next
   Return $lineas
EndFunc

Func detectarExpression($lineas, $expressionType)
   Local $partes[1]
   $partes[0] = 0

   $dentro = False
   For $i = 1 To $lineas[0]
	  If $dentro And checkExpression($lineas[$i], $expressionType) Then
		 $partes = _agregar($partes, $lineas[$i])
	  ElseIf $dentro And _estandar($lineas[$i]) = $ZONE_DELIMITER[$expressionType][$END] Then
		 $dentro = False
	  ElseIf (Not $dentro) And _estandar($lineas[$i]) = $ZONE_DELIMITER[$expressionType][$START] Then
		 $dentro = True
	  EndIf
   Next

   Return $partes
EndFunc

Func checkExpression($expression,$tipo)
   Switch($tipo)
   Case $PORT_EXPRESSION:
	  $in = StringInStr($expression,"in",2)
	  $out = StringInStr($expression,"out",2)
	  If Not(($in Or $out) And (Not($in And $out)))Then Return False
	  $expression = StringReplace(StringReplace($expression,"in","",0,2),"out","",0,2)
	  $divide = StringInStr($expression,":")
	  Return $divide And _ValidarIdentificador(StringTrimRight($expression,StringLen($expression)-$divide+1)) And _EsNombreReal(_estandar(StringTrimLeft($expression,$divide)))
   Case $SIGNAL_EXPRESSION:
	  $divide = StringInStr($expression,":")
	  Return $divide And _ValidarIdentificador(StringTrimRight($expression,StringLen($expression)-$divide+1)) And _EsNombreReal(_estandar(StringTrimLeft($expression,$divide)))
   Case $LOGIC_EXPRESSION:
   EndSwitch
   Return True
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