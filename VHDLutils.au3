#include-once
#include <Array.au3>

Const $librerias_nombres[] = ["IEEE"]
Const $paquetes_nombres[] = ["STD_LOGIC_1164", "STD_LOGIC_ARITH", "STD_LOGIC_UNSIGNED"]
Const $paquetes_libreria[] = [0, 0, 0]

Const $contenidos_LOGIC_1164[] = ["BINARY"]
Const $paquetes_contenidos = [$contenidos_LOGIC_1164]

Const $PORT_EXPRESSION = 1
Const $SIGNAL_EXPRESSION = 2
Const $LOGIC_EXPRESSION = 3

Const $ZONE_DELIMITER[][] = [["", ""], ["VAR", "VAREND"], ["VAR", "VAREND"], ["LOGIC", "LOGICEND"]]
Const $START = 0
Const $END = 1

Const $FUNCIONES[] = ["AND?","OR?","NAND?","NOR?","XOR?","AND","OR","NAND","NOR","XOR","INV"]

Const $ERROR[] = ["BOKEY", "FILE_NOT_FOUND", "EMPTY_NAME_DEFINITION", "ILLEGAL_END_STATEMENT", "UNKNOWN_MODIFIER_FOR_OPEN/CLOSE_STATEMENT", "TOO_MANY_MODIFIERS_FOR_OPEN_STATEMENT", "ILLEGAL_OPEN_STATEMENT", "NOT_CLOSING_SECTION", "VARIABLE_BAD_FORMATED", "EXPLICIT_LOGIC_LINE_COULD_NOT_BE_PARSED", "INCORRECT_CONVERSION_TYPE","WORNG_PARALLEL_SWITCH_SYNTAX","INCORRECT_IFTHEN_SYNTAX","INCORRECT_SEQUENTIAL_SWITCH_SYNTAX"]
Const $ERROR_BOKEY = 0
Const $ERROR_FILE_NOT_FOUND = 1
Const $ERROR_EMPTY_NAME_DEFINITION = 2
Const $ERROR_ILLEGAL_END_STATEMENT = 3
Const $ERROR_UNKNOWN_MODIFIER_FOR_OPENCLOSE_STATEMENT = 4
Const $ERROR_TOO_MANY_MODIFIERS_FOR_OPEN_STATEMENT = 5
Const $ERROR_ILLEGAL_OPEN_STATEMENT = 6
Const $ERROR_NOT_CLOSING_SECTION = 7
Const $ERROR_VARIABLE_BAD_FORMATED = 8
Const $ERROR_EXPLICIT_LOGIC_LINE_COULD_NOT_BE_PARSED = 9
Const $ERROR_INCORRECT_CONVERSION_TYPE = 10
Const $ERROR_WORNG_PARALLEL_SWITCH_SYNTAX = 11
Const $ERROR_INCORRECT_IFTHEN_SYNTAX = 12
Const $ERROR_INCORRECT_SEQUENTIAL_SWITCH_SYNTAX = 13

Const $WARNING[] = ["CONGRATULATIONS", "NO_ELSE_TERMINATED_CONCURRENT_STATEMENT"]
Const $WARNING_CONGRATULATIONS = 0
Const $WARNING_NO_ELSE_TERMINATED_CONCURRENT_STATEMENT = 1

Global $VARIABLE_SECCTION

#cs
	--------------->Tipos de lecturas<---------------
	----   Estandar para funciones de busqueda   ----
	----   Elemento 0 es el numero de valores    ----
	----      utiles que contiene el array       ----
	-------------------------------------------------
	Variables************************************
	Declaracion:
	[posicion(0 fuera, 1 parallel, 2 sequential)],[nombre de variable],["" senal, "in" puerto entrada, "out" puerto salida],[tipo],[argumentos]
	Logica***************************************
		Asignacion:
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[nombre de variable asignada],[expresion]
		Funcion:
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[array de argumentos]
		Conversion:
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[nombre de variable asignada],[tipo a convertir],[nombre de variable a convertir]
		Switch con expresion (SetIf)(when else):
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[variable a asignar],[array de posibles valores],[array de expresiones a comprobar (siempre ultimo "else")]
		Switch con variable (SetSwitch)(with select):
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[variable a asignar],[variable a comprobar],[array de posibles valores],[array de valores a comprobar (siempre ultimo "else")]
		If Then Else (IfThen)(if elseif endif):
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[array de posibles sentencias],[array de expresiones a comprobar (siempre ultimo "else")]
		Switch (SwitchCase)(case is when others):
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[variable a comprobar],[array de posibles sentencias],[array de valores a comprobar (siempre ultimo "else")]
	Operaciones Logicas*************************
	Paralelas:
	1: Asignacion
	2: Conversion
	3: Switch con expresion (SetIf)
	4: Switch con variable (SetSwitch)
	7: Funcion
	Secuenciales:
	1: Asignacion
	2: Conversion
	5: If Then Else	(IfThen)
	6: Switch		(SwitchCase)

#ce


Func leerFuente($file)
	If Not FileExists($file) Then Return SetError(1, -1)
	Return StringSplit(FileRead($file), @CRLF, 1)
EndFunc   ;==>leerFuente
Func eliminarComentarios($lineas)
	$borron = False
	$lineIn = -1
	$lineOut = -1
	For $i = 1 To $lineas[0]
		For $j = 1 To StringLen($lineas[$i])
			If (Not $borron) And $lineIn = -1 And StringMid($lineas[$i], $j, 2) = "/*" Then
				$borron = True
				$lineIn = $j
				$j += 1
			EndIf
			If $borron And StringMid($lineas[$i], $j, 2) = "*/" Then
				$borron = False
				$lineOut = $j
				$j += 1
			EndIf
			If (Not $borron) And $lineIn = -1 And StringMid($lineas[$i], $j, 2) = "//" Then
				$lineIn = $j
				$j += 1
			EndIf
			If (Not $borron) And $lineIn <> -1 And StringMid($lineas[$i], $j, 2) = "\\" Then
				$lineOut = $j
				$j += 1
			EndIf
		Next

		If $lineIn = -1 Then
			If $lineOut = -1 Then
				If $borron Then $lineas[$i] = ""
			Else
				$lineas[$i] = StringTrimLeft($lineas[$i], $lineOut + 1)
			EndIf
		Else
			If $lineOut = -1 Then
				$lineas[$i] = StringTrimRight($lineas[$i], StringLen($lineas[$i]) - $lineIn + 1)
			Else
				$lineas[$i] = StringTrimRight($lineas[$i], StringLen($lineas[$i]) - $lineIn + 1) & StringTrimLeft($lineas[$i], $lineOut + 1)
			EndIf
		EndIf
		$lineIn = -1
		$lineOut = -1
	Next
	Return $lineas
EndFunc   ;==>eliminarComentarios
Func lineasOptimizar($lineas) ; Deprecated: Es necesario conservar las lineas intactas para poder decir donde se producen errores Usar en su lugar lineasLimpiar()
	Local $lineasN[1]
	$lineasN[0] = 0
	For $i = 1 To $lineas[0]
		If $lineas[$i] Then $lineasN = _agregar($lineasN, StringReplace($lineas[$i], @TAB, ""))
	Next
	Return $lineasN
EndFunc   ;==>lineasOptimizar
Func lineasLimpiar($lineas)
	For $i = 1 To $lineas[0]
		$lineas[$i] = StringReplace(StringReplace($lineas[$i], @TAB, ""), "  ", "")
		Do
			$c = StringMid($lineas[$i], 1, 1)
			If $c = " " Then $lineas[$i] = StringTrimLeft($lineas[$i], 1)
		Until (StringMid($lineas[$i], 1, 1) <> " ")
	Next
	Return $lineas
EndFunc   ;==>lineasLimpiar
Func buscarNombre($lineas, $buscar, $defecto)
	$buscar = StringUpper($buscar)
	For $i = 1 To $lineas[0]
		$lineas[$i] = StringReplace(StringReplace($lineas[$i], @TAB, ""), " ", "")
		If StringUpper(StringMid($lineas[$i], 1, StringLen($buscar))) = $buscar Then
			$nombre = StringTrimLeft($lineas[$i], StringLen($buscar))
			If $nombre Then
				Return $nombre
			Else
				Return SetError(2, $i, $i)
			EndIf
		EndIf
	Next
	Return $defecto
EndFunc   ;==>buscarNombre

Func detectarPaquetes($lineas, $contenidos, $nombres)
	Local $usos[UBound($nombres)]
	For $i = 0 To UBound($nombres) - 1
		$usos[$i] = False
	Next

	For $i = 0 To $lineas[0]
		For $j = 0 To UBound($contenidos) - 1
			If $usos[$j] Then ExitLoop
			$detector = $contenidos[$j]
			For $k = 0 To UBound($detector) - 1
				If StringInStr($lineas[$i], $detector[$k], 2) Then
					$usos[$j] = True
					ExitLoop
				EndIf
			Next
		Next
	Next

	Return $usos
EndFunc   ;==>detectarPaquetes
Func detectarLibrerias($paquetes, $librerias, $nombres)
	Local $usos[UBound($nombres)]
	For $i = 0 To UBound($nombres) - 1
		$usos[$i] = False
	Next

	For $i = 0 To UBound($paquetes) - 1
		If $usos[$librerias[$i]] Then ContinueLoop
		If $paquetes[$i] Then
			$usos[$librerias[$i]] = True
		EndIf
	Next

	Return $usos
EndFunc   ;==>detectarLibrerias

Func detectarVariables($lineas)
	$VARIABLE_SECCTION = False
	For $i = 0 To $lineas[0]
		If StringInStr($lineas[$i], "VAREND", 2) Then
			$VARIABLE_SECCTION = True
			ExitLoop
		EndIf
	Next

	Local $variables[1]
	$variables[0] = 0

	$estado = 0
	For $i = 1 To $lineas[0]
		$estado = _segmento($lineas[$i], $estado, "VAR", "parallel", "sequential", "VAREND", "LOGIC", "LOGICEND")
		If @error Then Return SetError(@error, $i)
		If $estado = 3 Then ContinueLoop
		If $VARIABLE_SECCTION And $estado > 0 Then
			$tipo = _comprobarVariable($lineas[$i], $estado)
			If @error Then
				Return SetError($ERROR_VARIABLE_BAD_FORMATED, $i)
			Else
				$variables = _agregar($variables, $tipo)
			EndIf
		ElseIf (Not $VARIABLE_SECCTION) And $estado = 0 Then
			$tipo = _comprobarVariable($lineas[$i], 0)
			If IsArray($tipo) And $tipo[1] And $tipo[3] Then $variables = _agregar($variables, $tipo)
		EndIf
	Next
	If $estado <> 0 Then Return SetError(7, $i) ; Error 7: Not every section is closed at the end of document
	Return $variables
EndFunc   ;==>detectarVariables
Func detectarLogica($lineas)
	Local $logica[1]
	$logica[0] = 0
	$fase = 0

	$VARIABLE_SECCTION = False
	For $i = 0 To $lineas[0]
		If StringInStr($lineas[$i], "LOGICEND", 2) Then
			$VARIABLE_SECCTION = True
			ExitLoop
		EndIf
	Next
	;ConsoleWrite("secciones: " & $VARIABLE_SECCTION & @CRLF)

	For $i = 0 To $lineas[0]
		$linea = _eliminarPrimerosEspacios($lineas[$i])
		$fase = _segmento($linea, $fase, "LOGIC", "parallel", "sequential", "LOGICEND", "VAR", "VAREND")

		If Abs($fase) = 3 Or ($fase <= 0 And $VARIABLE_SECCTION) Then ContinueLoop
		;ConsoleWrite("---->" & $fase & ": " & $linea & @CRLF)

		;Comprobar si es una funcion
		$partes = StringSplit($linea," ",1)
		If IsArray($partes) And _esFuncion($partes[1]) Then
			ConsoleWrite("Funciones: "&$partes[1]&@CRLF&$linea&@CRLF)
			Local $parametros[$partes[0]]
			$parametros[0] = $partes[0]-1
			For $j = 1 To $parametros[0]
				$parametros[$j] = $partes[$j+1]
			Next

			Local $instruccion[4] = [$fase,7,$partes[1],$parametros]
			$logica = _agregar($logica,$instruccion)

			ContinueLoop
		EndIf

		;Comprobar si es una asignacion / conversion
		$igual = StringInStr($linea, "=", 2)
		$asignacionConversion = $igual > 0 And Not _KeywordsEstructuras($linea)
		If $asignacionConversion Then
			$j = 1
			$asignacionConversion_nombre = ""
			While $asignacionConversion And $j < $igual
				$c = StringMid($linea, $j, 1)
				If $c = " " And Not StringMid($linea, $j + 1, 1) = "=" Then $asignacionConversion = False
				$j += 1
				$asignacionConversion_nombre &= $c
			WEnd
			$linea = _eliminarPrimerosEspacios(StringTrimLeft($linea, $igual))
			If $asignacionConversion Then

				;Determinar si es asignacion o conversion
				$parentesis = StringInStr($linea, "(", 2)
				$conversion = $parentesis > 0
				If $conversion Then
					;Es conversion
					$j = $parentesis + 1
					$conversion_tipo = ""
					While $conversion And $j <= StringLen($linea)
						$c = StringMid($linea, $j, 1)
						If $c = " " Then $conversion = False
						If $c = ")" Then ExitLoop
						$conversion_tipo &= $c
						$j += 1
					WEnd
					If $conversion And $c <> ")" Then $conversion = False
					If $conversion Then
						$linea = _eliminarPrimerosEspacios(StringTrimLeft($linea, $j))

						If StringInStr($linea, " ", 2) Then Return SetError(9, $i)
						Local $instruccion[5] = [$fase, 2, $asignacionConversion_nombre, $conversion_tipo, $linea]
						$logica = _agregar($logica, $instruccion)
					EndIf
				Else
					;Es asignacion
					Local $instruccion[4] = [$fase, 1, $asignacionConversion_nombre, $linea]
					$logica = _agregar($logica, $instruccion)
				EndIf
			EndIf

			ContinueLoop
		EndIf

		;Comprobar si hay un SetIf / SetSwitch
		$set = StringInStr($linea, "Set", 2)
		$setifSetswitch = ($set = 1)
		If $setifSetswitch And ((Not $VARIABLE_SECCTION) Or ($VARIABLE_SECCTION And $fase = 1)) Then
			$linea = _eliminarPrimerosEspacios(StringTrimLeft($linea, 3))
			$setifSetswitch_name = ""
			$j = 1
			While $j <= StringLen($linea)
				$c = StringMid($linea, $j, 1)
				If $c = " " Then ExitLoop
				$setifSetswitch_name &= $c
				$j += 1
			WEnd
			$linea = _eliminarPrimerosEspacios(StringTrimLeft($linea, $j))
			;Determinar si es SetIf o SetSwitch
			$switch = StringInStr($linea, "Switch", 2)
			$Setswitch = ($switch = 1)
			If $Setswitch Then
				;Es un SetSwitch
				$setSwitch_name = _eliminarPrimerosEspacios(StringTrimLeft($linea, 6))
				$divisor = "case"
				$identificador = 4
			Else
				;Es un SetIf
				$divisor = "if"
				$identificador = 3
			EndIf
			Local $valores[1]
			$valores[0] = 0
			Local $condiciones[1]
			$condiciones[0] = 0
			While (StringInStr($lineas[$i + 1], $divisor, 2))
				$i += 1
				$linea = _eliminarPrimerosEspacios($lineas[$i])
				$partes = StringSplit(StringReplace($linea,$divisor,$divisor,0,2), " " & $divisor & " ", 1)
				If $partes[0] = 2 Then
					$valores = _agregar($valores, $partes[1])
					$condiciones = _agregar($condiciones, $partes[2])
				Else
					Return SetError(11, $i)
				EndIf
			WEnd

			;Siempre debe acabar en un Else
			If StringUpper(StringReplace($condiciones[$condiciones[0]], " ", "")) <> "ELSE" Then
				warn(1, $i)
				$condiciones[$condiciones[0]] = "Else"
			EndIf
			If $identificador = 3 Then
				Local $instruccion[5] = [$fase, 3, $setifSetswitch_name, $valores, $condiciones]
			ElseIf $identificador = 4 Then
				Local $instruccion[6] = [$fase, 4, $setifSetswitch_name, $setSwitch_name, $valores, $condiciones]
			EndIf

			$logica = _agregar($logica, $instruccion)

			ContinueLoop
		EndIf

		;Comprobar si hay un IfThen
		$if = StringInStr($linea, "If", 2)
		$ifthen = ($if = 1)
		If $ifthen And ((Not $VARIABLE_SECCTION) Or ($VARIABLE_SECCTION And $fase = 2)) Then
			$linea = _eliminarPrimerosEspacios(StringTrimLeft($linea,2))
			$partes = StringSplit($linea," then ", 1)
			If $partes[0] <> 2 Then Return SetError(12,$i)

			Local $condiciones[2]
			$condiciones[0] = 1
			Local $instrucciones[21]
			$instrucciones[0] = 1
			$condiciones[1] = $partes[1]
			$instrucciones[1] = $partes[2]

			$final = False
			While (StringInStr($lineas[$i + 1], "else", 2)) And Not $final
				$i += 1
				$linea = _eliminarPrimerosEspacios(StringTrimLeft($lineas[$i],4))
				If StringUpper(StringMid($linea,1,2)) = "IF" Then
					$linea = _eliminarPrimerosEspacios(StringTrimLeft($linea,2))
					$partes = StringSplit(StringReplace($linea,"then","THEN",0,2), " THEN ", 1)
					If $partes[0] = 2 Then
						$condiciones = _agregar($condiciones, $partes[1])
						$instrucciones = _agregar($instrucciones, $partes[2])
					Else
						Return SetError(12, $i)
					EndIf
				Else
					$condiciones = _agregar($condiciones, "ELSE")
					$instrucciones = _agregar($instrucciones, $linea)
					$final = True
				EndIf
			WEnd

			;Siempre debe acabar en un Else
			If StringUpper(StringReplace($condiciones[$condiciones[0]], " ", "")) <> "ELSE" Then
				warn(1, $i)
				$condiciones[$condiciones[0]] = "Else"
			EndIf


			Local $instruccion[4] = [$fase,5,$instrucciones,$condiciones]
			$logica = _agregar($logica,$instruccion)

			ContinueLoop
		EndIf

		;Comrpobar si hay un SwitchCase
		$switch = StringInStr($linea, "Switch", 2)
		$switchCase = ($switch = 1)
		If $switchCase And ((Not $VARIABLE_SECCTION) Or ($VARIABLE_SECCTION And $fase = 2)) Then
			$linea = _eliminarPrimerosEspacios(StringTrimLeft($linea,6))
			$variable = $linea

			Local $valores[1]
			$valores[0] = 0
			Local $sentencias[1]
			$sentencias[0] = 0

			While (StringInStr($lineas[$i + 1], "case", 2))
				$i += 1
				$linea = _eliminarPrimerosEspacios($lineas[$i])
				$partes = StringSplit(StringReplace($linea,"case","case",0,2), " case ", 1)
				If $partes[0] = 2 Then
					$sentencias = _agregar($sentencias, $partes[1])
					$valores = _agregar($valores, $partes[2])
				Else
					Return SetError(13, $i)
				EndIf
			WEnd

			;Siempre debe acabar en un Else
			If StringUpper(StringReplace($valores[$valores[0]], " ", "")) <> "ELSE" Then
				warn(1, $i)
				$valores[$valores[0]] = "Else"
			EndIf

			Local $instruccion[5] = [$fase,6,$variable,$sentencias,$valores]
			$logica = _agregar($logica,$instruccion)

			ContinueLoop
		EndIf

		;If $VARIABLE_SECCTION And $linea Then Return setError(9,$i)
	Next

	Return $logica
EndFunc   ;==>detectarLogica










Func _comprobarVariable($linea, $lugar)
	Local $variable[5]
	$variable[1] = ""

	$puntos = StringInStr($linea, ":")
	$letras = False
	For $i = 1 To $puntos - 1
		$c = StringMid($linea, $i, 1)
		If $c <> " " Then
			$variable[1] &= $c
			If $letras Then
				Return SetError($ERROR_VARIABLE_BAD_FORMATED, 0, 0)
			Else
				$letras = True
			EndIf
		EndIf
	Next

	$in = StringInStr($linea, "in ", 2)
	$out = StringInStr($linea, "out ", 2)
	If $in And $out Then Return SetError($ERROR_VARIABLE_BAD_FORMATED, 0, 0)
	If $in Then $puntos += 3
	If $out Then $puntos += 4

	$corchete = StringInStr($linea, "[", 2) - 1
	If $corchete = -1 Then $corchete = StringLen($linea)
	$letras = False
	$variable[3] = ""
	For $i = $puntos + 1 To $corchete
		$c = StringMid($linea, $i, 1)
		If $c = " " Then
			If $letras Then
				Return SetError($ERROR_VARIABLE_BAD_FORMATED, 0, 0)
			Else
				$letras = True
			EndIf
		Else
			$variable[3] &= $c
		EndIf
	Next

	$linea = StringReplace(StringTrimLeft($linea, $puntos), " ", "")
	$corchete = False
	$variable[4] = ""
	For $i = 1 To StringLen($linea)
		$c = StringMid($linea, $i, 1)
		If $c = "[" Then
			If $corchete = False Then
				$corchete = True
			Else
				Return SetError($ERROR_VARIABLE_BAD_FORMATED, 0, 0)
			EndIf
		ElseIf $c = "]" Then
			If $corchete = True Then
				$corchete = False
			Else
				Return SetError($ERROR_VARIABLE_BAD_FORMATED, 0, 0)
			EndIf
		ElseIf $corchete Then
			$variable[4] &= $c
		EndIf
	Next
	If $corchete Then Return SetError($ERROR_VARIABLE_BAD_FORMATED, 0, 0)

	$variable[0] = $lugar
	If $in Then $variable[2] = "In"
	If $out Then $variable[2] = "Out"

	Return $variable
EndFunc   ;==>_comprobarVariable

Func _esFuncion($palabra)
	For $i = 0 To UBound($FUNCIONES)-1
		If __MismaFuncion($palabra,$FUNCIONES[$i]) Then	Return True
	Next
	Return False
EndFunc
Func __MismaFuncion($f1, $f2)
	If StringLen($f1) <> StringLen($f2) Then Return False
	For $i = 1 To StringLen($f1)
		If StringUpper(StringMid($f1,$i,1)) <> StringUpper(StringMid($f2,$i,1)) And StringMid($f2,$i,1) <> "?" Then Return False
	Next
	Return True
EndFunc
Func _KeywordsEstructuras($linea)
	Return StringInStr($linea, "set", 2) > 0 Or StringInStr($linea, "if", 2) > 0 Or StringInStr($linea, "else", 2) > 0 Or StringInStr($linea, "switch", 2) > 0 Or StringInStr($linea, "case", 2) > 0
EndFunc   ;==>_KeywordsEstructuras
Func _eliminarPrimerosEspacios($text)
	Do
		$c = StringMid($text, 1, 1)
		If $c = " " Then $text = StringTrimLeft($text, 1)
	Until (StringMid($text, 1, 1) <> " ")
	Return $text
EndFunc   ;==>_eliminarPrimerosEspacios
Func _segmento($linea, $prev, $modStart, $modDef, $modBis, $modExit, $modAvoidStart = "", $modAvoidExit = "")
	$partes = StringSplit($linea, " ")
	If $partes[0] <> 0 Then
		If $prev = 0 Then
			If StringUpper($partes[1]) = $modExit Then Return SetError(3) ; Error 3: End statement not closing any Open statement
			If StringUpper($partes[1]) = $modStart Then
				If $partes[0] = 2 Then
					If StringUpper($partes[2]) = $modDef Then Return -1
					If StringUpper($partes[2]) = $modBis Then Return -2
					Return SetError(4) ;  Error 4: Worng keyword for Open statement
				Else
					If $partes[0] > 2 Then Return SetError(5) ; Error 5: To many keywords after Open statement
					Return -1
				EndIf
			EndIf
			If StringUpper($partes[1]) = $modAvoidExit Then Return SetError(3)
			If StringUpper($partes[1]) = $modAvoidStart Then
				If $partes[0] > 2 Then Return SetError(5)
				Return -3
			EndIf
		Else
			If $partes[0] >= 1 Then
				If StringUpper($partes[1]) = $modStart Then Return SetError(6) ; Error 6: Two Open statements consecutive
				If StringUpper($partes[1]) = $modExit Or StringUpper($partes[1]) = $modAvoidExit Then
					If $partes[0] = 1 Then
						Return 0
					Else
						Return SetError(5) ; Error 5: To many keywords after Close statement
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	If $prev < 0 Then
		Return $prev * -1
	Else
		Return $prev
	EndIf
EndFunc   ;==>_segmento
Func _ValidarIdentificador($identificador)
	$letras = False
	$primero = True
	For $i = StringLen($identificador) To 1 Step -1
		$c = StringMid($identificador, $i, 1)
		If $c = " " Then
			If $letras Then
				Return False
			Else
				$identificador = StringTrimRight($identificador, 1)
			EndIf
		Else
			$letras = True
			If $primero Then
				If IsNumber($c) Then Return False
				$primero = False
			EndIf
		EndIf
	Next
	Return True
EndFunc   ;==>_ValidarIdentificador
Func _EsNombreReal($nombre) ; Deprecated
	$nombres = _estandar($nombre)
	For $i = 0 To UBound($nombres) - 1
		If $nombres[$i][1] = $nombre Then Return True
	Next
	Return False
EndFunc   ;==>_EsNombreReal
Func _estandar($string)
	Return StringUpper(StringReplace(StringReplace(StringUpper($string), @TAB, ""), " ", ""))
	;Return StringStripWS($string,8)
EndFunc   ;==>_estandar
Func _agregar($array, $elemento)
	ReDim $array[$array[0] + 2]
	$array[0] += 1
	$array[$array[0]] = $elemento
	Return $array
EndFunc   ;==>_agregar

Func warn($code, $line)
	MsgBox(48, "PARASER WARNING", "Warning " & $code & ": " & $WARNING[$code] & @CRLF & "Probably on line " & $line)
	Exit
EndFunc   ;==>warn
Func throw($code, $line)
	MsgBox(16, "PARASER ERROR", "Error " & $code & ": " & $ERROR[$code] & @CRLF & "Probably on line " & $line)
	Exit
EndFunc   ;==>throw
