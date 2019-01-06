#include-once
#include <Array.au3>
#include <SendMessage.au3>

#Region Constantes
Const $librerias_nombres[] = ["IEEE", "LCDF_VHDL"]
Const $paquetes_nombres[] = ["STD_LOGIC_1164", "STD_LOGIC_ARITH", "STD_LOGIC_UNSIGNED", "FUNC_PRIMS"]
Const $paquetes_libreria[] = [0, 0, 0, 1]

Const $contenidos_LOGIC_1164[] = ["BINARY"]
Const $contenidos_LOGIC_ARITH[] = ["&"]
Const $contenidos_LOGIC_UNSIGNED[] = ["INTEGER", "(INTEGER)"]
Const $contenidos_FUNC_PRIMS[] = ["AND2", "AND3", "AND4", "AND5", "NAND2", "NAND3", "NAND4", "NAND5", "NOR2", "NOR3", "NOR4", "NOR5", "NOT1", "OR2", "OR3", "OR4", "OR5", "XOR2", "XNOR2", "INV"]
Const $paquetes_contenidos = [$contenidos_LOGIC_1164, $contenidos_LOGIC_ARITH, $contenidos_LOGIC_UNSIGNED, $contenidos_FUNC_PRIMS]

Const $VAR_TYPES[] = ["BINARY","INTEGER"]

Const $ZONE_DELIMITER[][] = [["", ""], ["VAR", "VAREND"], ["VAR", "VAREND"], ["LOGIC", "LOGICEND"]]
Const $START = 0
Const $END = 1

Const $FUNCIONES[] = ["AND?", "OR?", "NAND?", "NOR?", "XOR?", "AND", "OR", "NAND", "NOR", "XOR", "XNOR", "INV"]
Const $OPERADORES_VANILLA[] = ["AND", "OR", "NOT", "&", "+", "-", "NAND", "XOR", "XNOR", "NOR"]
Const $RESERVADAS[] = ["SET", "IF", "SWITCH", "CASE", "THEN", "FOR", "NEXT"]

Const $IMPLEMENT_PARAMS[][] = [["LED?",8," | IOSTANDARD = LVTTL | SLEW = SLOW | DRIVE = 8 ;"],["LEVER?",4," | IOSTANDARD = LVTTL | PULLUP ;"],["LCD?",7," | IOSTANDARD = LVCMOS33 | DRIVE = 4 | SLEW = SLOW ;"], _
["BTN?",4," | IOSTANDARD = LVTTL | PULLDOWN ;"],["HEADER?!",4," | IOSTANDARD = LVTTL | SLEW = SLOW | DRIVE = 6 ;"],["STICK?",2," | IOSTANDARD = LVTTL | PULLUP ;"],["STICC",1," | IOSTANDARD = LVTTL | PULLDOWN ;"]]
Const $IMPLEMENT_PIN[][] = [["LEVER1","L13"],["LEVER2","L14"],["LEVER3","H18"],["LEVER4","N17"], _
["BTN1","H13"],["BTN2","V4"],["BTN3","K17"],["BTN4","D18"],["LCD1","M18"],["LCD2","L18"],["LCD3","L17"],["LCD4","R15"],["LCD5","R16"],["LCD6","P17"],["LCD7","M15"], _
["LED1","F12"],["LED2","E12"],["LED3","E11"],["LED4","F11"],["LED5","C11"],["LED6","D11"],["LED7","E9"],["LED8","F9"], _
["HEADER1A","B4"],["HEADER1B","A4"],["HEADER1C","D5"],["HEADER1D","C5"],["HEADER2A","A6"],["HEADER2B","B6"],["HEADER2C","E7"],["HEADER2D","F7"], _
["STICK1","K18"],["STICK2","G18"],["STICC","V16"]]

#Region Errores y avisos
Const $ERROR[] = ["BOKEY", "FILE_NOT_FOUND", "EMPTY_NAME_DEFINITION", "ILLEGAL_END_STATEMENT", "UNKNOWN_MODIFIER_FOR_OPEN/CLOSE_STATEMENT", _
		"TOO_MANY_MODIFIERS_FOR_OPEN_STATEMENT", "ILLEGAL_OPEN_STATEMENT", "NOT_CLOSING_SECTION", "VARIABLE_BAD_FORMATED", "EXPLICIT_LOGIC_LINE_COULD_NOT_BE_PARSED", _
		"INCORRECT_CONVERSION_TYPE", "WORNG_PARALLEL_SWITCH_SYNTAX", "INCORRECT_IFTHEN_SYNTAX", "INCORRECT_SEQUENTIAL_SWITCH_SYNTAX", "INCORRECT_FOR_SYNTAX", "NOT_MATCHING_NEXT_FOR_FOR", _
		"ARRAY_BAD_ARGUMENTS", "INTEGER_BOUNDAGES_NOT_DEFINED", "UNKNOWN_VAR_TYPE", "UNESPECTED_PROBLEM_BUILDING_PORTS", "UNESPECTED_PROBLEM_BUILDING_LOGIC", "INVALID_EXPRESION", _
		"UNKNOWN_CONVERSION_TYPE", "INVALID_TARGET_TYPE_SIZE", "UNKNOWN_FUNCTION_NAME", "INCORRECT_NUMBER_OF_PARAMETERS", "PRECHECK_FAILED_UNKNOWN_FUNCTION_NAME", "INVALID_PARAMETER", _
		"VARIABLE_DOES_NOT_EXIST", "NOT_MATCHING_VALUES_AND_CONDITIONS", "ELSE_CONDITION_IN_NOT_LAST_POSITION", "CAN_NOT_HAPPEND_DESTINATION_FILE", "OUTPUT_FILE_ALREADY_EXIST", _
		"INECESARY_KEY_WORDS", "EXTRA_PARAMETERS_IN_SWITCH-CASE","UNKNOWN_EXPRESSION_IN_IMPLEMENT_SEGMENT","UNKNOWN_IO_PORT","IO_ELEMENT_EXEED","UNKNOWN_VARIABLE_TYPE"]
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
Const $ERROR_INCORRECT_FOR_SYNTAX = 14
Const $ERROR_NOT_MATCHING_NEXT_FOR_FOR = 15
Const $ERROR_ARRAY_BAD_ARGUMENTS = 16
Const $ERROR_INTEGER_BOUNDAGES_NOT_DEFINED = 17
Const $ERROR_UNKNOWN_VAR_TYPE = 18
Const $ERROR_UNESPECTED_PROBLEM_BUILDING_PORTS = 19
Const $ERROR_UNESPECTED_PROBLEM_BUILDING_LOGIC = 20
Const $ERROR_INVALID_EXPRESION = 21
Const $ERROR_UNKNOWN_CONVERSION_TYPE = 22
Const $ERROR_INVALID_TARGET_TYPE_SIZE = 23
Const $ERROR_UNKNOWN_FUNCTION_NAME = 24
Const $ERROR_INCORRECT_NUMBER_OF_PARAMETERS = 25
Const $ERROR_PRECHECK_FAILED_UNKNOWN_FUNCTION_NAME = 26
Const $ERROR_INVALID_PARAMETER = 27
Const $ERROR_VARIABLE_DOES_NOT_EXIST = 28
Const $ERROR_NOT_MATCHING_VALUES_AND_CONDITIONS = 29
Const $ERROR_ELSE_CONDITION_IN_NOT_LAST_POSITION = 30
Const $ERROR_CAN_NOT_HAPPEND_DESTINATION_FILE = 31
Const $ERROR_OUTPUT_FILE_ALREADY_EXIST = 32
Const $ERROR_INECESARY_KEY_WORDS = 33
Const $ERROR_EXTRA_PARAMETERS_IN_SWITCH_CASE = 34
Const $ERROR_UNKNOWN_EXPRESSION_IN_IMPLEMENT_SEGMENT = 35
Const $ERROR_UNKNOWN_IO_PORT = 36
Const $ERROR_IO_ELEMENT_EXEED = 37
Const $ERROR_UNKNOWN_VARIABLE_TYPE = 38

Const $WARNING[] = ["CONGRATULATIONS", "NO_ELSE_TERMINATED_CONCURRENT_STATEMENT", "INICIALIZATION_NOT_NEEDED", "SEQUENTIAL-ONLY-OPERATION_OUT_OF_PLACE", "IFSWITCH_CHANGED_INTO_IFTHEN", _
"SWITCHCASE_CHANGED_INTO_IFTHEN","VARIABLE_IS_NEVER_USED"]
Const $WARNING_CONGRATULATIONS = 0
Const $WARNING_NO_ELSE_TERMINATED_CONCURRENT_STATEMENT = 1
Const $WARNING_INICIALIZATION_NOT_NEEDED = 2
Const $WARNING_SEQUENTIAL_ONLY_OPERATION_OUT_OF_PLACE = 3
Const $WARNING_IFSWITCH_CHANGED_INTO_IFTHEN = 4
Const $WARNING_SWITCHCASE_CHANGED_INTO_IFTHEN = 5
Const $WARNING_VARIABLE_IS_NEVER_USED = 6
#EndRegion Errores y avisos
#EndRegion Constantes
Global $VARIABLE_SECCTION, $LAST_WRITE, $SILENT_MODE, $LOG_EDIT, $PROGRESS_BAR, $VERBOSE_MODE, $FUNCTION_COUNT, $BYPASS_MODE

#cs
	--------------->Tipos de lecturas<---------------
	----   Estandar para funciones de busqueda   ----
	----   Elemento 0 es el numero de valores    ----
	----      utiles que contiene el array       ----
	-------------------------------------------------
	Variables************************************
	Declaracion:
	[posicion(0 fuera, 1 parallel, 2 sequential)],[Nombres de variable],["" senal, "in" puerto entrada, "out" puerto salida],[tipo],[argumentos],[inicializacion],[Linea inicial],[Modificador],[bool Usada en process]
	Usos:
	[bool Se ha inicializado][bool Se reescribe][bool Se lee][bool Se usa en process]
	Logica***************************************
	Asignacion:
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[nombre de variable asignada],[expresion],[Linea inicial]
	Funcion:
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[Funcion],[nombre de la funcion],[array de argumentos],[Linea inicial]
	Conversion:
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[nombre de variable asignada],[tipo a convertir],[nombre de variable a convertir],[Linea inicial]
	Switch con expresion (SetIf)(when else):
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[variable a asignar],[array de posibles valores],[array de expresiones a comprobar (siempre ultimo "else")],[Linea inicial]
	Switch con variable (SetSwitch)(with select):
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[variable a asignar],[variable a comprobar],[array de posibles valores],[array de valores a comprobar (siempre ultimo "else")],[Linea inicial]
	If Then Else (IfThen)(if elseif endif):
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[array de posibles sentencias],[array de expresiones a comprobar (siempre ultimo "else")],[Linea inicial]
	Switch (SwitchCase)(case is when others):
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[variable a comprobar],[array de posibles sentencias],[array de valores a comprobar (siempre ultimo "else")],[Linea inicial]
	For (ForNext) (ForIn):
	[posicion(0 fuera, 1 parallel, 2 sequential)],[operacion],[inicio],[fin],[interior],[Linea inicial]
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
	5: If Then Else	(IfThen)		ONLY
	6: Switch		(SwitchCase)	ONLY
	8: For 			(ForNext)		ONLY
	Implementacion***************************************
	Asociacion:
	[posicion(0 fuera, 1 dentro)][Elemento IO][Variable asignada][Configuracion IO][Linea de declaracion]
#ce

#Region Lectura
Func leerFuente($file)
	If Not FileExists($file) Then Return SetError(1, -1)
	$text = FileRead($file)
	If StringInStr($text,@CRLF) > 0 Then
		; Es un niño bueno, tiene regalos
		Return StringSplit($text, @CRLF, 1)
	Else
		; Termina las lineas en LF, Merece ir al infierno
		Return StringSplit($text, @LF, 1)
	EndIf
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
Func lineasLimpiar($lineas)
	For $i = 1 To $lineas[0]
		While StringMid($lineas[$i],1,1) = @TAB
			$lineas[$i] = StringTrimLeft($lineas[$i],1)
		WEnd
		$lineas[$i] = StringReplace($lineas[$i], @TAB, " ")
		$lineas[$i] = __eliminarCaracteres($lineas[$i], ";|--|#")
		$lineas[$i] = _eliminarDoblesEspacios($lineas[$i])
		$lineas[$i] = _eliminarPrimerosEspacios($lineas[$i])
		$lineas[$i] = _eliminarUltimosEspacios($lineas[$i])
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

	For $i = 1 To $lineas[0]
		For $j = 0 To UBound($contenidos) - 1
			If $usos[$j] Then ContinueLoop
			$detector = $contenidos[$j]
			For $k = 0 To UBound($detector) - 1
				If StringInStr($lineas[$i], $detector[$k], 2) > 0 Then
					$usos[$j] = True
					ExitLoop 1
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
Func setLibrerias($libreria, $nombres)
	$usos = _getArray($nombres)

	For $i = 0 To UBound($nombres) - 1
		$usos[$i] = ($nombres[$i] = $libreria)
	Next

	Return $usos
EndFunc   ;==>setLibrerias
Func setPaquetes($librerias, $paquetes)
	$usos = _getArray($paquetes)

	For $i = 0 To UBound($librerias) - 1
		If $librerias[$i] Then
			For $j = 0 To UBound($paquetes) - 1
				$usos[$j] = ($i = $paquetes[$j])
			Next
		EndIf
	Next

	Return $usos
EndFunc   ;==>setPaquetes

Func detectarVariables($lineas)
	$VARIABLE_SECCTION = False
	For $i = 0 To $lineas[0]
		If StringInStr($lineas[$i], "VAREND", 2) Then
			$VARIABLE_SECCTION = True
			ExitLoop
		EndIf
	Next

	$variables = _getArray_WithIndex()

	$estado = 0
	For $i = 1 To $lineas[0]
		$estado = _segmento($lineas[$i], $estado, "VAR", "parallel", "sequential", "VAREND", "LOGIC IMPLEMENT", "LOGICEND IMPLEMENTEND")
		If @error Then Return SetError(@error, $i)
		If $estado = 3 Then ContinueLoop

		$goForLunch = False

		If $VARIABLE_SECCTION And $estado > 0 Then
			$tipo = _comprobarVariable($lineas[$i], $estado, $i)
			If @error Then Return SetError($ERROR_VARIABLE_BAD_FORMATED, $i)
			$goForLunch = True
		ElseIf (Not $VARIABLE_SECCTION) And $estado = 0 Then
			$tipo = _comprobarVariable($lineas[$i], $estado, $i)
			$goForLunch = (IsArray($tipo) And $tipo[0] > 0)
		EndIf
		;_ArrayDisplay($tipo)
		If $goForLunch Then
			Vlog("Detected Vars in " & $i)
			For $j = 1 To $tipo[0]
				$var = $tipo[$j]
				;_ArrayDisplay($var)
				VlogRec($var)
				If $var[1] And $var[3] Then $variables = _agregar($variables, $var)
			Next
		EndIf
	Next

	If $estado <> 0 Then Return SetError($ERROR_NOT_CLOSING_SECTION, $i)
	Return $variables
EndFunc   ;==>detectarVariables
Func detectarLogica($lineas, $primary = True, $desfase = 0)
	Local $logica[1]
	$logica[0] = 0
	$fase = 0

	If $primary Then
		$VARIABLE_SECCTION = False
		For $i = 0 To $lineas[0]
			If StringInStr($lineas[$i], "LOGICEND", 2) Then
				$VARIABLE_SECCTION = True
				ExitLoop
			EndIf
		Next
		;ConsoleWrite("secciones: " & $VARIABLE_SECCTION & @CRLF)
	EndIf

	For $i = 1 To $lineas[0]
		$linea = _eliminarPrimerosEspacios($lineas[$i])
		$fase = _segmento($linea, $fase, "LOGIC", "parallel", "sequential", "LOGICEND", "VAR IMPLEMENT", "VAREND IMPLEMENTEND")

		If $primary And ((Abs($fase) = 3) Or ($fase <= 0 And $VARIABLE_SECCTION) Or (Not $linea)) Then ContinueLoop
		;If Not $primary Then ConsoleWrite("---->" & $fase & ": " & $linea & @CRLF)

		;Comprobar si es una funcion
		$partes = StringSplit($linea, " ", 1)
		If IsArray($partes) And _esFuncion($partes[1]) Then
			Local $parametros[$partes[0]]
			$parametros[0] = $partes[0] - 1
			For $j = 1 To $parametros[0]
				$parametros[$j] = $partes[$j + 1]
			Next

			Local $instruccion[5] = [$fase, 7, $partes[1], $parametros, $i]
			$logica = _agregar($logica, $instruccion)

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
			$asignacionConversion_nombre = _eliminarUltimosEspacios($asignacionConversion_nombre)
			$linea = _eliminarPrimerosEspacios(StringTrimLeft($linea, $igual))
			If $asignacionConversion Then
				;Determinar si es asignacion o conversion
				$parentesis = StringInStr($linea, "(", 2)
				$conversion = $parentesis > 0 And StringInStr(StringTrimLeft($linea,$parentesis), "(", 2) = 0
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
						If StringInStr($linea, " ", 2) Then Return SetError($ERROR_EXPLICIT_LOGIC_LINE_COULD_NOT_BE_PARSED, $i + $desfase)
						Local $instruccion[6] = [$fase, 2, $asignacionConversion_nombre, $conversion_tipo, $linea, $i]
						$logica = _agregar($logica, $instruccion)
					EndIf
					If Not $conversion Then
						Local $instruccion[5] = [$fase, 1, $asignacionConversion_nombre, $linea, $i]
						$logica = _agregar($logica, $instruccion)
					EndIf
				Else
					;Es asignacion
					Local $instruccion[5] = [$fase, 1, $asignacionConversion_nombre, $linea, $i]
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
			$valores = _getArray_WithIndex()
			$condiciones = _getArray_WithIndex()
			While $i + 1 <= $lineas[0] And (StringInStr($lineas[$i + 1], $divisor, 2))
				$i += 1
				$linea = _eliminarPrimerosEspacios($lineas[$i])
				$partes = StringSplit(StringReplace($linea, $divisor, $divisor, 0, 2), " " & $divisor & " ", 1)
				If $partes[0] = 2 Then
					$valores = _agregar($valores, $partes[1])
					$condiciones = _agregar($condiciones, StringReplace($partes[2], ",", "|"))
				Else
					_ArrayDisplay($partes)
					Return SetError($ERROR_WORNG_PARALLEL_SWITCH_SYNTAX, $i + $desfase)
				EndIf
			WEnd

			;Siempre debe acabar en un Else
			If _eliminarUltimosEspacios(StringUpper(StringReplace($condiciones[$condiciones[0]], " ", ""))) <> "ELSE" Then
				warn(1, $i + $desfase)
				$condiciones[$condiciones[0]] = "Else"
			EndIf
			If $identificador = 3 Then
				Local $instruccion[6] = [$fase, 3, $setifSetswitch_name, $valores, $condiciones, $i]
			ElseIf $identificador = 4 Then
				;Un SetSwitch que intenta comparar arrays se cambia por un SetIf
				If StringInStr($condiciones[1], '"') > 0 Then
					warn($WARNING_IFSWITCH_CHANGED_INTO_IFTHEN, $i)
					For $k = 1 To $condiciones[0] - 1
						$condiciones[$k] = $setSwitch_name & " = " & $condiciones[$k]
					Next
					Local $instruccion[6] = [$fase, 3, $setifSetswitch_name, $valores, $condiciones, $i]
				Else
					Local $instruccion[7] = [$fase, 4, $setifSetswitch_name, $setSwitch_name, $valores, $condiciones, $i]
				EndIf
			EndIf

			$logica = _agregar($logica, $instruccion)

			ContinueLoop
		EndIf

		;Comprobar si hay un IfThen
		$if = StringInStr($linea, "If", 2)
		$ifthen = ($if = 1)
		If $ifthen And ((Not $VARIABLE_SECCTION) Or ($VARIABLE_SECCTION And $fase = 2)) Or (Not $primary) Then
			$linea = _eliminarPrimerosEspacios(StringTrimLeft($linea, 2))
			$partes = StringSplit(StringReplace($linea, "then", "THEN", 0, 2), " THEN ", 1)
			If $partes[0] <> 2 Then Return SetError(12, $i)

			$condiciones = _getArray_WithIndex()
			$instrucciones = _getArray_WithIndex()
			$condiciones = _agregar($condiciones, $partes[1])
			$instrucciones = _agregar($instrucciones, $partes[2])

			$final = False
			While $lineas[0] > $i And (StringInStr($lineas[$i + 1], "else", 2)) And Not $final
				$i += 1
				$linea = _eliminarPrimerosEspacios(StringTrimLeft($lineas[$i], 4))
				If StringUpper(StringMid($linea, 1, 2)) = "IF" Then
					$linea = _eliminarPrimerosEspacios(StringTrimLeft($linea, 2))
					$partes = StringSplit(StringReplace($linea, "then", "THEN", 0, 2), " THEN ", 1)
					If $partes[0] = 2 Then
						$condiciones = _agregar($condiciones, $partes[1])
						$instrucciones = _agregar($instrucciones, $partes[2])
					Else
						Return SetError(12, $i + $desfase)
					EndIf
				Else
					$condiciones = _agregar($condiciones, "ELSE")
					$instrucciones = _agregar($instrucciones, $linea)
					$final = True
				EndIf
			WEnd

			;Siempre debe acabar en un Else
			If _eliminarUltimosEspacios(StringUpper(StringReplace($condiciones[$condiciones[0]], " ", ""))) <> "ELSE" Then
				warn(1, $i + $desfase)
				$condiciones[$condiciones[0]] = "Else"
			EndIf

			Local $instruccion[5] = [$fase, 5, $instrucciones, $condiciones, $i]
			$logica = _agregar($logica, $instruccion)

			ContinueLoop
		EndIf

		;Comrpobar si hay un SwitchCase
		$switch = StringInStr($linea, "Switch", 2)
		$switchCase = ($switch = 1)
		If $switchCase And ((Not $VARIABLE_SECCTION) Or ($VARIABLE_SECCTION And $fase = 2)) Then
			$linea = _eliminarUltimosEspacios(_eliminarPrimerosEspacios(StringTrimLeft($linea, 6)))
			$set = StringInStr($linea, "Set", 2)
			$variableAsignada = ""
			If $set > 0 Then
				$partes = StringSplit($linea, " ")
				If Not IsArray($partes) Or $partes[0] <> 3 Or StringUpper($partes[2]) <> "SET" Then Return SetError($ERROR_EXTRA_PARAMETERS_IN_SWITCH_CASE)
				$variableAsignada = $partes[3]
				$variable = $partes[1]
			Else
				$variable = $linea
			EndIf

			$valores = _getArray_WithIndex()
			$sentencias = _getArray_WithIndex()

			While $i + 1 <= $lineas[0] And (StringInStr($lineas[$i + 1], "case", 2))
				$i += 1
				$linea = _eliminarPrimerosEspacios($lineas[$i])
				$partes = StringSplit(StringReplace($linea, "case", "case", 0, 2), " case ", 1)
				If $partes[0] = 2 Then
					If $variableAsignada <> "" Then
						$sentencias = _agregar($sentencias, $variableAsignada & "=" & $partes[1])
					Else
						$sentencias = _agregar($sentencias, $partes[1])
					EndIf
					$valores = _agregar($valores, StringReplace($partes[2], ",", "|"))
				Else
					Return SetError(13, $i + $desfase)
				EndIf
			WEnd

			;Siempre debe acabar en un Else
			If _eliminarUltimosEspacios(StringUpper(StringReplace($valores[$valores[0]], " ", ""))) <> "ELSE" Then
				warn(1, $i + $desfase)
				$valores[$valores[0]] = "Else"
			EndIf

			;Si usa cadenas, remplazar por un IfThen
			If StringInStr($valores[1],'"') > 0 Then
				warn($WARNING_SWITCHCASE_CHANGED_INTO_IFTHEN, $i)
				$instrucciones = _getArray_WithIndex()
				$condiciones = _getArray_WithIndex()

				For $l = 1 To $valores[0]-1
					If StringInStr($valores[$l],"|") Then
						$partes = StringSplit($valores[$l],"|")
						For $j = 1 To $partes[0]
							$instrucciones = _agregar($instrucciones,$sentencias[$l])
							$condiciones = _agregar($condiciones,$variable &" = "&$partes[$j])
						Next
					Else
						$instrucciones = _agregar($instrucciones,$sentencias[$l])
						$condiciones = _agregar($condiciones,$variable &" = "&$valores[$l])
					EndIf
				Next

				Local $instruccion[5] = [$fase, 5, $instrucciones, $condiciones, $i]
				$logica = _agregar($logica, $instruccion)
			Else
				Local $instruccion[6] = [$fase, 6, $variable, $sentencias, $valores, $i]
				$logica = _agregar($logica, $instruccion)
			EndIf

			ContinueLoop
		EndIf

		;Comprobar si hay un ForNext
		$for = StringInStr($linea, "for", 2)
		$forNext = ($for = 1)
		If $forNext And ((Not $VARIABLE_SECCTION Or Not $primary) Or ($VARIABLE_SECCTION And $fase = 2)) Then
			$linea = _eliminarPrimerosEspacios(StringTrimLeft($linea, 3))
			$partes = StringSplit($linea, " ", 1)
			If $partes[0] <> 3 Then Return SetError(14, $i)
			If StringUpper($partes[2]) <> "in" Then Return SetError(14, $i + $desfase)

			$lineasInterior = _getArray_WithIndex()

			$iOriginal = $i
			$i += 1
			While StringReplace(StringUpper($lineas[$i]), " ", "") <> "next"
				$lineasInterior = _agregar($lineasInterior, $lineas[$i])
				$i += 1
				If $i > $lineas[0] Then Return SetError(15, $i)
			WEnd
			$logi = detectarLogica($lineasInterior, False, $iOriginal)

			For $j = 1 To $logi[0]
				$log = $logi[$j]
				$log[0] = $fase
				$log[UBound($log) - 1] += $i
				$logi[$j] = $log
			Next

			Local $instruccion[6] = [$fase, 8, $partes[1], $partes[3], $logi, $i]
			$logica = _agregar($logica, $instruccion)

			ContinueLoop
		EndIf

		If $VARIABLE_SECCTION And $linea Then Return SetError(9, $i)
	Next

	Return $logica
EndFunc   ;==>detectarLogica
Func completarVariables($logics, $vars)
	For $i = 1 to $vars[0]
		$var = $vars[$i]

		$iniciada = ($var[5] <> "")
		$varUsos = _varEsUsada($var[1],$logics)
		$escrita = $varUsos[0]
		$leida = $varUsos[1]
		$process = $varUsos[2]

		If StringUpper($var[1]) = "SALIDA" Then
			;MsgBox(0,$var,$varIn2a&" "&$varIn2b&" "&$varIn3)
			;MsgBox(0,$var,$escrita&" "&$leida&" "&$process)
		EndIf

		If $iniciada And (Not $escrita) Then $var[7] = "Constant"
		If (Not $iniciada) And (Not $escrita) And $leida Then
			$var[2] = "In"
		ElseIf (Not $iniciada) And (Not $leida) And $escrita Then
			$var[2] = "Out"
		ElseIf $leida or $escrita Then
			$var[2] = ""
		Else
			warn($WARNING_VARIABLE_IS_NEVER_USED,$var)
		EndIf
		$var[8] = $process

		$vars[$i] = $var
	Next

	Return $vars
EndFunc
Func detectarImplementacion($lineas, $vars)
	$implement = _getArray_WithIndex()

	$VARIABLE_SECCTION = False
	For $i = 0 To $lineas[0]
		If StringInStr($lineas[$i], "IMPLEMENTEND", 2) Then
			$VARIABLE_SECCTION = True
			ExitLoop
		EndIf
	Next

	$estado = 0
	For $i = 1 To $lineas[0]
		If $lineas[$i] = "" Then ContinueLoop
		$estado = _segmento($lineas[$i], $estado, "IMPLEMENT", "", "", "IMPLEMENTEND", "LOGIC VAR", "LOGICEND VAREND")
		$asign = _ImplementCheck($lineas[$i], $vars,  $i, $estado)
		If @error Then Return SetError(@error,$i)
		If $VARIABLE_SECCTION And $estado = 1 and Not IsArray($asign) Then Return SetError($ERROR_UNKNOWN_EXPRESSION_IN_IMPLEMENT_SEGMENT,$i)
		If IsArray($asign) Then
			$implement = _agregar($implement,$asign)
		EndIf
	Next

	Return $implement
EndFunc
#EndRegion Lectura

#Region Escritura
Func writeInicio($header, $entidad, $arquitectura, $file)
	$lineas = _getArray_WithIndex()

	If $header Then
		$lineas = _agregar($lineas, "----------------------------------------------------------------------------------")
		$lineas = _agregar($lineas, "-- Enginer:        ")
		$lineas = _agregar($lineas, "-- Create Date:    " & @HOUR & ":" & @MIN & ":" & @SEC & " " & @MDAY & "/" & @MON & "/" & @YEAR)
		$lineas = _agregar($lineas, "-- Module Name:    " & $entidad & " - " & $arquitectura)
		$lineas = _agregar($lineas, "-- Project Name:   " & _getFileName($file))
		$lineas = _agregar($lineas, "-- Description:    ")
		$lineas = _agregar($lineas, "--")
		$lineas = _agregar($lineas, "-- Created with VHDL ME. Parser by B0vE, powered by Temis (De mesa)")
		$lineas = _agregar($lineas, "----------------------------------------------------------------------------------")
	EndIf

	Return $lineas
EndFunc   ;==>writeInicio
Func writeIncludes($lineas, $librerias, $paquetes, $libreriasNombre, $paquetesNombre)
	$lineaLibrerias = "library "
	For $i = 0 To UBound($librerias) - 1
		If $librerias[$i] Then $lineaLibrerias &= $libreriasNombre[$i] & ", "
	Next
	$lineas = _agregar($lineas, StringTrimRight($lineaLibrerias, 2) & ";")

	For $i = 0 To UBound($paquetes) - 1
		If $paquetes[$i] Then $lineas = _agregar($lineas, "use " & $libreriasNombre[$paquetes_libreria[$i]] & "." & $paquetesNombre[$i] & ".ALL;")
	Next
	$lineas = _agregar($lineas, "")

	Return $lineas
EndFunc   ;==>writeIncludes
Func writeEntidad($lineas, $nombre, $vars)
	$lineas = _agregar($lineas, "Entity " & $nombre & " is")

	$variables = writeVariables($vars, True)
	If @error Then Return SetError(@error, @extended)
	If Not IsArray($variables) Or $variables[0] < 1 Then Return SetError($ERROR_UNESPECTED_PROBLEM_BUILDING_PORTS, @extended)

	$agrego = @TAB & "Port("
	For $i = 1 To $variables[0]
		$agrego &= $variables[$i]
		If $i = $variables[0] Then
			$agrego = StringTrimRight($agrego, 1)
			$agrego &= ");"
		EndIf
		$lineas = _agregar($lineas, $agrego)
		$agrego = @TAB & @TAB & "  "
	Next
	$lineas = _agregar($lineas, "End " & $nombre & ";")
	$lineas = _agregar($lineas, "")

	Return $lineas
EndFunc   ;==>writeEntidad
Func writeVariables($vars, $ports)
	$lineas = _getArray_WithIndex()
	For $i = 1 To $vars[0]
		$var = $vars[$i]
		If ($ports And $var[2] = "") Or (Not $ports And $var[2] <> "") Then ContinueLoop
		$variable = _varConstructor($var)
		If @error Then Return SetError(@error, @extended)
		$lineas = _agregar($lineas, $variable & ";")
	Next

	$LAST_WRITE = 0
	Return $lineas
EndFunc   ;==>writeVariables
Func writeArquitectura($lineas, $nombre, $entidad, $logics, $vars, $LibreriasEstrictas)
	$lineas = _agregar($lineas, "Architecture " & $nombre & " of " & $entidad & " is")

	$variables = writeVariables($vars, False)
	If @error Then Return SetError(@error, @extended)
	For $i = 1 To $variables[0]
		$lineas = _agregar($lineas, @TAB & $variables[$i])
	Next

	$lineas = _agregar($lineas, "Begin")
	$logicParallel = _getArray_WithIndex()
	$logicSequential = _getArray_WithIndex()

	For $i = 1 To $logics[0]
		$logic = $logics[$i]

		$sequential = ($logic[1] = 5 Or $logic[1] = 6 Or $logic[1] = 8)
		If $VARIABLE_SECCTION And $sequential And $logic[0] <> 2 Then warn($WARNING_SEQUENTIAL_ONLY_OPERATION_OUT_OF_PLACE, $logic[UBound($logic) - 1])
		If $logic[0] = 2 Or $sequential Then
			$logicSequential = _agregar($logicSequential, $logic)
		Else
			$logicParallel = _agregar($logicParallel, $logic)
		EndIf
	Next

	$FUNCTION_COUNT = 0

	For $i = 1 To $logicParallel[0]
		$logic = $logicParallel[$i]
		If $LAST_WRITE <> $logic[1] Then
			If $LAST_WRITE <> 0 Then $lineas = _agregar($lineas, "")
			$LAST_WRITE = $logic[1]
		EndIf

		$instrucciones = _logicConstructor($logic, $vars, $LibreriasEstrictas)
		If @error Then Return SetError(@error, @extended)
		If Not IsArray($instrucciones) Or $instrucciones[0] < 1 Then Return SetError($ERROR_UNESPECTED_PROBLEM_BUILDING_LOGIC, $i)
		For $j = 1 To $instrucciones[0]
			$lineas = _agregar($lineas, @TAB & $instrucciones[$j])
		Next
	Next

	If $logicSequential[0] <> 0 Then
		$LAST_WRITE = 0
		$lineas = _agregar($lineas, "")
		$lineas = _agregar($lineas, @TAB & "Process(" & _variablesUsadasProcess($logicSequential, $vars) & ")")
		$lineas = _agregar($lineas, @TAB & "Begin")
		For $i = 1 To $logicSequential[0]
			$logic = $logicSequential[$i]
			If $LAST_WRITE <> $logic[1] Then
				If $LAST_WRITE <> 0 Then $lineas = _agregar($lineas, "")
				$LAST_WRITE = $logic[1]
			EndIf

			$instrucciones = _logicConstructor($logic, $vars, $LibreriasEstrictas)
			If @error Then Return SetError(@error, @extended)
			If Not IsArray($instrucciones) Or $instrucciones[0] < 1 Then Return SetError($ERROR_UNESPECTED_PROBLEM_BUILDING_LOGIC, $i)
			For $j = 1 To $instrucciones[0]
				$lineas = _agregar($lineas, @TAB & @TAB & $instrucciones[$j])
			Next
		Next
		$lineas = _agregar($lineas, @TAB & "End Process;")
	Else
		Elog("Process skiped, no sequential statements.")
	EndIf

	$lineas = _agregar($lineas, "End " & $nombre & ";")
	Return $lineas
EndFunc   ;==>writeArquitectura
Func writeImplement($lineas, $asignations)
	$lineas = _agregar($lineas, "")
	$lineas = _agregar($lineas, "--#Implementation, copy this into constrictions file and remove '--' coments.")

	For $i = 1 To $asignations[0]
		$asignation = $asignations[$i]
		$lineas = _agregar($lineas, '--NET "'&$asignation[2]&'" LOC = "'&_implementGetPin($asignation[1])&'" '&$asignation[3])
		If @error Then Return SetError(@error, $asignation[4])
	Next

	$lineas = _agregar($lineas, "--#Implementation finished")
	Return $lineas
EndFunc

#EndRegion Escritura

#Region subUDF
Func _comprobarVariable($linea, $lugar, $Nlinea = -1) ;Esto antes media 120 lineas
	Local $variable[9] ; [0. posicion],[1. Nombres],[2. IO],[3. tipo],[4. argumentos],[5. inicializacion],[6. Linea inicial],[7. Modificador],[8. process]
	;Linea: binary[7,0] B = '0' -> [0. 4][1. tipo][2. nombre][3. "="][4. inicializacion]
	;Linea: binary F -> [0. 2][1. tipo][2. nombre]

	$variable[0] = $lugar
	$variable[2] = ""
	$variable[6] = $Nlinea
	$variable[7] = ""
	$variable[8] = False

	$partes = StringSplit(StringReplace($linea,", ",",")," ")
	If Not IsArray($partes) or $partes[0] = 0 Then Return SetError($ERROR_VARIABLE_BAD_FORMATED, $Nlinea)
	$tipo2 = ($partes[0] = 2)
	$tipo4 = ($partes[0] = 4 And $partes[3] = "=")
	If Not ($tipo2 or $tipo4) Then Return SetError($ERROR_VARIABLE_BAD_FORMATED, $Nlinea)

	If Not __esNombreTipoVariable($partes[1],$VAR_TYPES) Then Return SetError($ERROR_UNKNOWN_VARIABLE_TYPE, $Nlinea)

	If $tipo2 or $tipo4 Then
		$nombres = $partes[2]
		If StringInStr($partes[1],"[") > 0 Then
			$variable[3] = StringMid($partes[1],1,StringInStr($partes[1],"[")-1)
			$variable[4] = StringMid($partes[1],StringInStr($partes[1],"[")+1,StringInStr($partes[1],"]",2,-1)-StringInStr($partes[1],"[")-1)
		Else
			$variable[3] = $partes[1]
			$variable[4] = ""
		EndIf
	EndIf
	If $tipo4 Then
		$variable[5] = $partes[4]
	EndIf

	$variables = _getArray_WithIndex()
	If StringInStr($nombres,",") > 0 Then
		$partes = StringSplit($nombres,",")
		If IsArray($partes) And $partes[0] > 0 Then
			For $i = 1 To $partes[0]
				$variable[1] = $partes[$i]
				$variables = _agregar($variables, $variable)
			Next
		EndIf
	Else
		$variable[1] = $nombres
		$variables = _agregar($variables, $variable)
	EndIf

	#cs
	$variable[1] = ""
	$puntos = StringInStr($linea, ":", 2, 1)
	If $puntos <= 0 Then Return SetError($ERROR_VARIABLE_BAD_FORMATED, 0, 0)

	$nombre = _eliminarPrimerosEspacios(StringTrimRight($linea, StringLen($linea) - $puntos + 1))
	If StringInStr($nombre, ",") > 0 Then
		$nombre = StringSplit($nombre, ",")
	Else
		$tmp = $nombre
		Local $nombre[2]
		$nombre[0] = 1
		$nombre[1] = $tmp
	EndIf

	For $i = 1 To $nombre[0]
		$nombre[$i] = _eliminarPrimerosEspacios($nombre[$i])
		While StringMid($nombre[$i], StringLen($nombre[$i]), 1) = " "
			$nombre[$i] = StringTrimRight($nombre[$i], 1)
		WEnd
		If StringInStr($nombre[$i], " ") > 0 Then Return SetError($ERROR_VARIABLE_BAD_FORMATED, 0, 0)
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
		If StringMid($linea, $i, 2) = " :" Then ExitLoop
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


	If StringInStr($linea, ":") Then
		If $variable[4] = "" Then
			;warn($WARNING_INICIALIZATION_NOT_NEEDED,$Nlinea) Esto habrá que cambiarlo algún día.
			$variable[5] = StringReplace(StringSplit($linea, ":", 1)[2], " ", "")
		Else
			$variable[5] = StringReplace(StringSplit($linea, ":", 1)[2], " ", "")
		EndIf
	Else
		$variable[5] = ""
	EndIf

	;ConsoleWrite("Final: "&$linea&@CRLF)

	$variable[0] = $lugar
	If $in Then $variable[2] = "In"
	If $out Then $variable[2] = "Out"

	$variable[6] = $Nlinea

	Local $variables[$nombre[0] + 1]
	$variables[0] = $nombre[0]
	For $i = 1 To $variables[0]
		$variable[1] = $nombre[$i]
		$variables[$i] = $variable
	Next

	$variable[7] = ""
	$variable[8] = False
	$variable[2] = ""
	#ce

	Return $variables
EndFunc   ;==>_comprobarVariable
Func _ImplementCheck($linea, $vars, $Nlinea = -1, $segmento = -1)
	$partes = StringSplit($linea," ")
	If Not IsArray($partes) or $partes[0] <> 2 Then Return False
	$params = _tieneFormatoImplement($partes[1])
	If @error Then Return SetError(@error,$Nlinea)

	If StringInStr($partes[2],"[") > 0 Then
		If StringInStr($partes[2],"]") > 0 Then
			$var = __eliminarInteriores($partes[2])
			$partes[2] = StringReplace(StringReplace($partes[2],"]",")"),"[","(")
		Else
			Return SetError($ERROR_ARRAY_BAD_ARGUMENTS,$Nlinea)
		EndIf
	Else
		$var = $partes[2]
	EndIf
	If (Not $params) or (Not __esNombreVariable($var,$vars)) Then Return False

	Local $implement[5] = [$segmento,$partes[1],$partes[2],$params,$Nlinea]

	Return $implement
EndFunc

Func _varConstructor($var)
	; [0. posicion],[1. Nombres],[2. IO],[3. tipo],[4. argumentos],[5. inicializacion],[6. Linea inicial],[7. Modificador],[8. process]
	$text = $var[7] & ($var[7]=""?"":" ") & ($var[2]=""?"Signal ":" ") & $var[1] & " : " & $var[2] & " "
	If StringUpper($var[3]) = "BINARY" Then
		If $var[4] Then
			$text &= "STD_LOGIC_VECTOR("
			$partes = StringSplit($var[4], ",")
			If Not IsArray($partes) Or $partes[0] <> 2 Then Return SetError($ERROR_ARRAY_BAD_ARGUMENTS, $var[6])
			$text &= $partes[1] & " "
			If $partes[1] > $partes[2] Then
				$text &= "downto "
			Else
				$text &= "to "
			EndIf
			$text &= $partes[2] & ")"
			If $var[5] Then $text &= " := (others => " & $var[5] & ")"
		Else
			$text &= "STD_LOGIC"
			If $var[5] Then $text &= " := " & $var[5]
		EndIf
	ElseIf StringUpper($var[3]) = "INTEGER" Then
		If $var[4] Then
			$text &= "INTEGER range "
			$partes = StringSplit($var[4], ",")
			If Not IsArray($partes) Or $partes[0] <> 2 Then Return SetError($ERROR_ARRAY_BAD_ARGUMENTS, $var[6])
			$text &= $partes[1] & " "
			If $partes[1] > $partes[2] Then
				$text &= "downto "
			Else
				$text &= "to "
			EndIf
			$text &= $partes[2]
			If $var[5] Then $text &= " := " & $var[5]
		Else
			Return SetError($ERROR_INTEGER_BOUNDAGES_NOT_DEFINED, $var[6])
		EndIf
	Else
		Return SetError($ERROR_UNKNOWN_VAR_TYPE, $var[6])
	EndIf

	Return $text
EndFunc   ;==>_varConstructor
Func _logicConstructor($logic, $vars, $LibreriasEstrictas)
	$lineas = _getArray_WithIndex()

	__seHaColadoRec($logic, $logic[UBound($logic) - 1])
	If @error Then Return SetError(@error, @extended)

	$logic = __corchetes2Parentesis($logic)

	Switch $logic[1]
		Case 1 ;Asignacion	[posicion],[operacion],[nombre de variable asignada],[expresion],[Linea inicial]
			If Not __comprobarExpresion($logic[3], $vars) Then Return SetError($ERROR_INVALID_EXPRESION, $logic[4])
			$lineas = _agregar($lineas, $logic[2] & " <= " & $logic[3] & ";")
		Case 2 ;Conversion	[posicion],[operacion],[nombre de variable asignada],[tipo a convertir],[nombre de variable a convertir],[Linea inicial]
			If Not __comprobarExpresion($logic[2], $vars) Or Not __comprobarExpresion($logic[4], $vars) Then Return SetError($ERROR_INVALID_EXPRESION, $logic[5])
			If StringInStr($logic[3], "(") > 0 Then
				$tipoConversion = StringTrimRight($logic[3], StringLen($logic[3]) - StringInStr($logic[3], "(") + 1)
				$tamano = StringTrimRight(StringTrimLeft($logic[3], StringInStr($logic[3], "(")), 1)
				If Not StringIsDigit($tamano) Then Return SetError($ERROR_INVALID_TARGET_TYPE_SIZE, $logic[5])
				If StringUpper($tipoConversion) = "BINARY" Then
					$lineas = _agregar($lineas, $logic[2] & " <= CONV_STD_LOGIC_VECTOR(" & $logic[4] & ", " & $tamano & ");")
				Else
					Return SetError($ERROR_UNKNOWN_CONVERSION_TYPE, $logic[5])
				EndIf
			Else
				If StringUpper($logic[3]) = "INTEGER" Then
					$lineas = _agregar($lineas, $logic[2] & " <= CONV_INTEGER(" & $logic[4] & ");")
				Else
					Return SetError($ERROR_UNKNOWN_CONVERSION_TYPE, $logic[4])
				EndIf
			EndIf
		Case 3 ;SetIf		[posicion],[operacion],[variable a asignar],[array de posibles valores],[array de expresiones a comprobar],[Linea inicial]
			If Not __esNombreVariable($logic[2], $vars) Then Return SetError($ERROR_VARIABLE_DOES_NOT_EXIST, $logic[5])
			$valores = $logic[3]
			$condiciones = $logic[4]

			$espacios = ""
			For $i = 1 To StringLen($logic[2])
				$espacios &= " "
			Next

			If $valores[0] <> $condiciones[0] Then Return SetError($ERROR_NOT_MATCHING_VALUES_AND_CONDITIONS, $logic[5] - $condiciones[0])
			$linea = $logic[2] & " <= "
			For $i = 1 To $valores[0]
				If StringUpper(StringReplace($condiciones[$i], " ", "")) = "ELSE" Then
					If $i <> $valores[0] Then Return SetError($ERROR_ELSE_CONDITION_IN_NOT_LAST_POSITION, $logic[5] - $condiciones[0] + $i)
					$linea &= $valores[$i] & ";"
				Else
					If StringInStr($condiciones[$i], "|") > 0 Then
						$comun = StringMid($condiciones[$i], 1, StringInStr($condiciones[$i], "="))
						$partes = StringSplit($condiciones[$i], "|")
						For $j = 1 To $partes[0]
							$linea &= $valores[$i] & " When " & ($j <> 1 ? $comun & " " : "") & $partes[$j] & " else"
							$lineas = _agregar($lineas, $linea)
							$linea = @TAB & " " & $espacios
						Next
						$linea = ""
					Else
						$linea &= $valores[$i] & " When " & $condiciones[$i] & " else"
					EndIf
				EndIf
				If $linea Then $lineas = _agregar($lineas, $linea)
				$linea = @TAB & " " & $espacios
			Next
		Case 4 ;SetSwitch	[posicion],[operacion],[variable a asignar],[variable a comprobar],[array de posibles valores],[array de valores a comprobar],[Linea inicial]
			If Not __esNombreVariable($logic[2], $vars) Or Not __esNombreVariable($logic[3], $vars) Then Return SetError($ERROR_VARIABLE_DOES_NOT_EXIST, $logic[6])
			$valores = $logic[4]
			$condiciones = $logic[5]

			$espacios = ""
			For $i = 1 To StringLen($logic[2])
				$espacios &= " "
			Next

			If $valores[0] <> $condiciones[0] Then Return SetError($ERROR_NOT_MATCHING_VALUES_AND_CONDITIONS, $logic[6])
			$lineas = _agregar($lineas, "With " & $logic[3] & " select")
			$linea = $logic[2] & " <= "
			For $i = 1 To $valores[0]
				If StringUpper(StringReplace($condiciones[$i], " ", "")) = "ELSE" Then
					If $i <> $valores[0] Then Return SetError($ERROR_ELSE_CONDITION_IN_NOT_LAST_POSITION, $logic[6] - $condiciones[0] + $i)
					$linea &= $valores[$i] & " When others;"
				Else
					If Not __comprobarExpresion($valores[$i], $vars) Or Not __comprobarExpresion($condiciones[$i], $vars) Then
						Return SetError($ERROR_INVALID_EXPRESION, $logic[6] - $condiciones[0] + $i)
					EndIf
					$linea &= $valores[$i] & " When " & $condiciones[$i] & ","
				EndIf
				$lineas = _agregar($lineas, $linea)
				$linea = @TAB & " " & $espacios
			Next
		Case 5 ;IfThen		[posicion],[operacion],[array de posibles sentencias],[array de expresiones a comprobar],[Linea inicial]
			$sentencias = $logic[2]
			$condiciones = $logic[3]
			If $sentencias[0] <> $condiciones[0] Then Return SetError($ERROR_NOT_MATCHING_VALUES_AND_CONDITIONS, $logic[4] - $condiciones[0])
			$linea = "If "
			For $i = 1 To $condiciones[0]
				$sentencias[$i] = StringReplace($sentencias[$i], "=", "<=", 1, 2)
				If StringUpper(StringReplace($condiciones[$i], " ", "")) = "ELSE" Then
					If $i <> $condiciones[0] Then Return SetError($ERROR_ELSE_CONDITION_IN_NOT_LAST_POSITION, $logic[4] - $condiciones[0] + $i)
					$linea = @TAB & "Else " & $sentencias[$i] & ";"
				Else
					$linea &= $condiciones[$i] & " Then " & $sentencias[$i] & ";"
				EndIf
				$lineas = _agregar($lineas, $linea)
				$linea = @TAB & "Elsif "
			Next
			$lineas = _agregar($lineas, "End If;")
		Case 6 ;SwitchCase	[posicion],[operacion],[variable a comprobar],[array de posibles sentencias],[array de valores a comprobar],[Linea inicial]
			If Not __esNombreVariable($logic[2], $vars) Then Return SetError($ERROR_VARIABLE_DOES_NOT_EXIST, $logic[5])
			$sentencias = $logic[3]
			$condiciones = $logic[4]
			If $sentencias[0] <> $condiciones[0] Then Return SetError($ERROR_NOT_MATCHING_VALUES_AND_CONDITIONS, $logic[5] - $condiciones[0])
			$lineas = _agregar($lineas, "Case " & $logic[2] & " is")
			$linea = @TAB & "When "
			For $i = 1 To $condiciones[0]
				$sentencias[$i] = StringReplace($sentencias[$i], "=", "<=", 1, 2)
				If StringUpper(StringReplace($condiciones[$i], " ", "")) = "ELSE" Then
					If $i <> $condiciones[0] Then Return SetError($ERROR_ELSE_CONDITION_IN_NOT_LAST_POSITION, $logic[5] - $condiciones[0] + $i)
					$linea &= "others => " & $sentencias[$i] & ";"
				Else
					$linea &= $condiciones[$i] & " => " & $sentencias[$i] & ";"
				EndIf
				$lineas = _agregar($lineas, $linea)
				$linea = @TAB & "When "
			Next
			$lineas = _agregar($lineas, "End Case;")
		Case 7 ;Funcion	[posicion],[operacion],[array de argumentos],[Linea inicial]
			$logic[2] = __comprobarFuncion($logic[2], $logic[3], $LibreriasEstrictas, $vars)
			If @error Then Return SetError(@error, $logic[4])
			$parametros = $logic[3]
			If $LibreriasEstrictas Then
				$linea = $parametros[$parametros[0]] & " <= "
				$n = StringMid($logic[2], StringLen($logic[2]), 1)
				$nombre = StringUpper(StringTrimRight($logic[2], 1))
				If $nombre = "AND" Then
					For $i = 1 To $parametros[0] - 1
						$linea &= $parametros[$i]
						If $i < $parametros[0] - 1 Then $linea &= " And "
					Next
					$linea &= ";"
				ElseIf $nombre = "OR" Then
					For $i = 1 To $parametros[0] - 1
						$linea &= $parametros[$i]
						If $i < $parametros[0] - 1 Then $linea &= " Or "
					Next
					$linea &= ";"
				ElseIf $nombre = "NAND" Then
					$linea &= "Not("
					For $i = 1 To $parametros[0] - 1
						$linea &= $parametros[$i]
						If $i < $parametros[0] - 1 Then $linea &= " And "
					Next
					$linea &= ");"
				ElseIf $nombre = "NOR" Then
					$linea &= "Not("
					For $i = 1 To $parametros[0] - 1
						$linea &= $parametros[$i]
						If $i < $parametros[0] - 1 Then $linea &= " Or "
					Next
					$linea &= ");"
				ElseIf $nombre = "XOR" Then
					$linea &= "("
					For $i = 1 To $parametros[0] - 1
						For $j = 1 To $parametros[0] - 1
							If $i <> $j Then $linea &= "Not "
							$linea &= $parametros[$j]
							If $j < $parametros[0] - 1 Then $linea &= " And "
						Next
						If $i < $parametros[0] - 1 Then $linea &= ") Or ("
					Next
					$linea &= ");"
				ElseIf $nombre = "XNOR" Then
					$linea &= "Not(("
					For $i = 1 To $parametros[0] - 1
						For $j = 1 To $parametros[0] - 1
							If $i <> $j Then $linea &= "Not "
							$linea &= $parametros[$j]
							If $j < $parametros[0] - 1 Then $linea &= " And "
						Next
						If $i < $parametros[0] - 1 Then $linea &= ") Or ("
					Next
					$linea &= "));"
				ElseIf $nombre = "INV" Then
					$linea &= "Not " & $parametros[1] &";"
				Else
					Return SetError($ERROR_PRECHECK_FAILED_UNKNOWN_FUNCTION_NAME)
				EndIf
			Else
				$linea = "p" & $FUNCTION_COUNT & ": " & $logic[2] & " port map("
				If $logic[2] = "INV" Then
					$linea &= "in1 => " & $parametros[1] & ", out1 => " & $parametros[2] & ");"
				Else
					$n = StringMid($logic[2], StringLen($logic[2]), 1)
					For $i = 1 To $parametros[0] - 1
						$linea &= " in" & $i & " => " & $parametros[$i] & ", "
					Next
					$linea &= " out1 => " & $parametros[$parametros[0]] & ");"
				EndIf
			EndIf

			$FUNCTION_COUNT += 1
			$lineas = _agregar($lineas, $linea)
		Case 8 ;For		[posicion],[operacion],[inicio],[fin],[interior],[Linea inicial]
			If __esNombreVariable($logic[3], $vars) Then $logic[3] &= "'range"
			$lineas = _agregar($lineas, "For " & $logic[2] & " in " & $logic[3] & " loop")

			$logicaInner = $logic[4]
			For $i = 1 To $logicaInner[0]
				$interior = _logicConstructor($logicaInner[$i], $vars, $LibreriasEstrictas)
				If @error Then Return SetError(@error, @extended)
				For $j = 1 To $interior[0]
					$lineas = _agregar($lineas, @TAB & $interior[$j])
				Next
			Next

			$lineas = _agregar($lineas, "End Loop;")
		Case Else
			Return SetError($ERROR_UNESPECTED_PROBLEM_BUILDING_LOGIC, -1)
	EndSwitch

	Return $lineas
EndFunc   ;==>_logicConstructor

Func __esNombreTipoVariable($text,$types)
	For $i = 0 To UBound($types)-1
		If StringUpper(__eliminarInteriores($text)) = StringUpper($types[$i]) Then Return True
	Next
	Return False
EndFunc
Func _varEsUsada($var,$logics)
	$escrita = False
	$leida = False
	$process = False

	For $j = 1 To $logics[0]
		If $escrita And $leida And $process Then ExitLoop
		$logic = $logics[$j]
		Switch $logic[1]
			Case 1 ;Asignacion	[posicion],[operacion],[nombre de variable asignada],[expresion],[Linea inicial]
				$varIn2 = _varIsIn($var,$logic[2])
				$varIn3 = _varIsIn($var,$logic[3])

				If $varIn2 Then $escrita = True
				If $varIn3 Then $leida = True
				If $logic[0] = 2 And ($varIn2 Or $varIn3) Then $process = True
			Case 2 ;Conversion	[0. posicion],[1. operacion],[2. nombre de variable asignada],[3. tipo a convertir],[4. nombre de variable a convertir],[5. Linea inicial]
				$varIn2 = _varIsIn($var,$logic[2])
				$varIn4 = _varIsIn($var,$logic[4])
				If $varIn2 Then $escrita = True
				If $varIn4 Then $leida = True
				If $logic[0] = 2 And ($varIn2 Or $varIn4) Then $process = True
			Case 3 ;SetIf		[posicion],[operacion],[variable a asignar],[array de posibles valores],[array de expresiones a comprobar],[Linea inicial]
				$varIn2 = _varIsIn($var,$logic[2])
				$varIn3 = _varIsIn($var,$logic[3])
				$varIn4 = _varIsIn($var,$logic[4])
				If $varIn2 Then $escrita = True
				If $varIn3 or $varIn4 Then $leida = True
				If $logic[0] = 2 And ($varIn2 Or $varIn3 or $varIn4) Then $process = True
			Case 4 ;SetSwitch	[posicion],[operacion],[variable a asignar],[variable a comprobar],[array de posibles valores],[array de valores a comprobar],[Linea inicial]
				$varIn2 = _varIsIn($var,$logic[2])
				$varIn3 = _varIsIn($var,$logic[3])
				$varIn4 = _varIsIn($var,$logic[4])
				$varIn5 = _varIsIn($var,$logic[5])
				If $varIn2 Then $escrita = True
				If $varIn3 or $varIn4 or $varIn5 Then $leida = True
				If $logic[0] = 2 And ($varIn2 Or $varIn3 or $varIn4 or $varIn5) Then $process = True
			Case 5 ;IfThen		[0. posicion],[1. operacion],[2. array de posibles sentencias],[3. array de expresiones a comprobar],[4. Linea inicial]
				$sentencias = $logic[2]
				$varIn2a = False
				$varIn2b = False
				For $i = 1 To $sentencias[0]
					$partes = StringSplit($sentencias[$i],"=")
					If IsArray($partes) And $partes[0] = 2 Then
						If _varIsIn($var,$partes[1]) Then $varIn2a = True
						If _varIsIn($var,$partes[2]) Then $varIn2b = True
					EndIf
				Next

				$varIn3 = _varIsIn($var,$logic[3])
				If $varIn2a Then $escrita = True
				If $varIn2b or $varIn3 Then $leida = True
				If $varIn2a or $varIn2b or $varIn3 Then	$process = True
			Case 6 ;SwitchCase	[posicion],[operacion],[variable a comprobar],[array de posibles sentencias],[array de valores a comprobar],[Linea inicial]
				$varIn2 = _varIsIn($var,$logic[2])

				$varIn3a = False
				$varIn3b = False
				$sentencias = $logics[3]
				For $i = 1 To $sentencias[$i]
					$partes = StringSplit($logic[3],"=")
					If IsArray($partes) And $partes[0] = 2 Then
						If _varIsIn($var,$partes[1]) Then $varIn3a = True
						If _varIsIn($var,$partes[2]) Then $varIn3b = True
					EndIf
				Next

				$varIn4 = _varIsIn($var,$logic[4])
				If $varIn3a Then $escrita = True
				If $varIn2 or $varIn3b or $varIn4 Then $leida = True
				If $varIn2 or $varIn3a or $varIn3b or $varIn4 Then $process = True
			Case 7 ;Funcion		[posicion],[operacion],[Funcion],[array de argumentos],[Linea inicial]
				$read = False
				$write = False
				$argumentos = $logic[3]
				For $i = 1 To $argumentos[0]
					If $i = $argumentos[0] Then
						If _varIsIn($var,$argumentos[$i]) Then $write = True
					Else
						If _varIsIn($var,$argumentos[$i]) Then $read = True
					EndIf
				Next
				If $read Then $leida = True
				If $write Then $escrita = True
				If $logic[0] = 2 And ($read or $write) Then $process = True
			Case 8 ;For			[0. posicion],[1. operacion],[2. inicio],[3. fin],[4. interior],[5. Linea inicial]
				$varIn2 = _varIsIn($var,$logic[2])
				$varIn3 = _varIsIn($var,$logic[3])
				;If $varIn2 or $varIn3 Then $leida = True		Ten en cuenta que una salida se puede pasar para indicar el final del bucle

				$usoIner = _varEsUsada($var,$logic[4])
				If $usoIner[0] Then $escrita = True
				If $usoIner[1] Then $leida = True
				If $usoIner[2] Then $process = True

				If $varIn2 or $varIn3 or $usoIner[0] or $usoIner[1] Then $process = True
			Case Else
				Return SetError($ERROR_UNESPECTED_PROBLEM_BUILDING_LOGIC, -1)
		EndSwitch
	Next

	Local $uso[] = [$escrita, $leida, $process]
	Return $uso
EndFunc
Func _varIsIn($name,$text)
	If IsArray($text) Then
		If $text[0] = UBound($text)-1 Then
			For $i = 1 To $text[0]
				If _varIsIn($name,$text[$i]) Then Return True
			Next
		Else
			For $i = 0 To UBound($text)-1
				If _varIsIn($name,$text[$i]) Then Return True
			Next
		EndIf
		Return False
	EndIf

	$name = _eliminarUltimosEspacios(_eliminarPrimerosEspacios(StringUpper($name)))
	$text = StringReplace(__eliminarInteriores(StringReplace(StringReplace(_eliminarUltimosEspacios(_eliminarPrimerosEspacios(StringUpper($text))),"(",""),")",""),False,False,False),"="," ")
	;MsgBox(0,"",$text)

	If $name = $text Then Return True
	$partes = StringSplit($text," ")
	If IsArray($partes) And $partes[0] > 0 Then
		For $i = 1 To $partes[0]
			If $partes[$i] = $name Then Return True
		Next
	EndIf
	$partes = StringSplit($text,",")
	If IsArray($partes) And $partes[0] > 0 Then
		For $i = 1 To $partes[0]
			If _eliminarUltimosEspacios(_eliminarPrimerosEspacios($partes[$i])) = $name Then Return True
		Next
	EndIf
	$partes = StringSplit($text,"|")
	If IsArray($partes) And $partes[0] > 0 Then
		For $i = 1 To $partes[0]
			If _eliminarUltimosEspacios(_eliminarPrimerosEspacios($partes[$i])) = $name Then Return True
		Next
	EndIf

	If StringInStr($text,"&") Then
		If __eliminarInteriores(StringTrimLeft($text,StringInStr($text,"&"&$name)+StringLen($name))) = "" Then Return True
		If __eliminarInteriores(StringMid($text,StringInStr($text,$name&"&")+StringLen($name&"&"))) = "" Then Return True
	EndIf

	;MsgBox(0,"Nope","No vale")
	Return False
EndFunc
Func _implementGetPin($port)
	For $i = 0 To UBound($IMPLEMENT_PIN)-1
		If StringUpper($IMPLEMENT_PIN[$i][0]) = StringUpper($port) Then Return $IMPLEMENT_PIN[$i][1]
	Next
	Return SetError($ERROR_UNKNOWN_IO_PORT)
EndFunc
Func _tieneFormatoImplement($text)
	For $i = 0 To UBound($IMPLEMENT_PARAMS)-1
		If StringLen($text) <> StringLen($IMPLEMENT_PARAMS[$i][0]) Then ContinueLoop
		For $j = 1 To StringLen($text)
			$c1 = StringMid($text,$j,1)
			$c2 = StringMid($IMPLEMENT_PARAMS[$i][0],$j,1)
			If $c2 = "?" Then
				If Not StringIsAlNum($c1) Then ContinueLoop 2
				If Not ($c1 > 0 And $c1 <= $IMPLEMENT_PARAMS[$i][1]) Then Return SetError($ERROR_IO_ELEMENT_EXEED)
			ElseIf $c2 = "!" Then
				If Not StringIsAlpha($c1) Then ContinueLoop 2
			Else
				If $c1 <> $c2 Then ContinueLoop 2
			EndIf
		Next
		Return $IMPLEMENT_PARAMS[$i][2]
	Next
	Return False
EndFunc
Func __corchetes2Parentesis($text)
	If IsArray($text) Then
		For $i = 0 To UBound($text) - 1
			$text[$i] = __corchetes2Parentesis($text[$i])
		Next
		Return $text
	Else
		If StringInStr($text, "[") > 0 And StringInStr($text, "]") > 0 Then $text = StringReplace(StringReplace($text, "[", "("), "]", ")")
		Return $text
	EndIf
EndFunc   ;==>__corchetes2Parentesis
Func __seHaColadoRec($text, $linea)
	If IsArray($text) Then
		For $i = 0 To UBound($text) - 1
			__seHaColadoRec($text[$i], $linea)
			If @error Then Return SetError(@error, @extended)
		Next
	Else
		For $i = 0 To UBound($RESERVADAS) - 1
			If StringInStr(StringUpper($text), $RESERVADAS[$i], 2) > 0 Then Return SetError($ERROR_INECESARY_KEY_WORDS, $linea)
		Next
		Return True
	EndIf
EndFunc   ;==>__seHaColadoRec
Func _variablesUsadasProcess($logicSequential, $vars)
	$txt = ""

	For $i = 1 To $vars[0]
		$var = $vars[$i]
		If $var[8] And StringUpper($var[2]) <> "OUT" Then $txt &= $var[1] & ", "
	Next

	Return StringTrimRight($txt, 2)
EndFunc   ;==>_variablesUsadasProcess
Func __esNombreVariable($name, $vars)
	If $BYPASS_MODE Then Return True

	$name = StringUpper(_eliminarUltimosEspacios(_eliminarPrimerosEspacios($name)))
	For $i = 1 To $vars[0]
		$var = $vars[$i]
		;MsgBox(0,$name = StringUpper($var[1]),$name &"<_>"& StringUpper($var[1]))
		If $name = StringUpper($var[1]) Then Return True
	Next
	Return False
EndFunc   ;==>__esNombreVariable
Func __comprobarFuncion($nombre, $parametros, $estricto, $vars)
	If $BYPASS_MODE Then Return True

	If Not $estricto Then
		$existe = False
		For $i = 0 To UBound($contenidos_FUNC_PRIMS) - 1
			If $nombre = $contenidos_FUNC_PRIMS[$i] Then $existe = True
		Next
		If Not $existe Then Return SetError($ERROR_UNKNOWN_FUNCTION_NAME)
	EndIf
	$n = StringMid($nombre, StringLen($nombre), 1)
	If Not StringIsDigit($n) And $estricto Then
		If StringUpper($n) = "V" Then
			$nombre &= "1"
			$n = 1
		Else
			$nombre &= "2"
			$n = 2
		EndIf
	EndIf
	If StringMid($nombre, 1, 3) = "INV" And Not $estricto Then
		If $parametros[0] <> 2 Then Return SetError($ERROR_INCORRECT_NUMBER_OF_PARAMETERS)
	Else
		If $parametros[0] <> (1 + $n) Then Return SetError($ERROR_INCORRECT_NUMBER_OF_PARAMETERS)
	EndIf

	;Comprobacion de parametros
	For $i = 1 To $parametros[0]
		$parametros[$i] &= " "
		For $j = 1 To $vars[0]
			$var = $vars[$j]
			If StringUpper($parametros[$i]) = StringUpper($var[1] & " ") Then
				$parametros[$i] = ""
				ExitLoop
			Else
				$parametros[$i] = StringReplace($parametros[$i], $var[1] & " ", "", 0, 2)
			EndIf
		Next
		Vlog("->" & __eliminarInteriores($parametros[$i]))
		If __eliminarInteriores($parametros[$i]) <> "" Then Return SetError($ERROR_INVALID_PARAMETER)
	Next

	Return $nombre
EndFunc   ;==>__comprobarFuncion
Func __comprobarExpresion($expresion, $vars)
	If $BYPASS_MODE Then Return True; Esto es mano de santo

	If StringInStr($expresion, "&") > 0 Then
		$expresion = StringReplace($expresion, "Not", "", 0, 2)
		$partes = StringSplit($expresion, "&")
		;_ArrayDisplay($partes)
		For $i = 1 To $partes[0]
			$trazas = StringSplit(__eliminarCaracteres($partes[$i],"(|)")," ")
			For $j = 1 To $trazas[0]
				$traza = __eliminarCaracteres($trazas[$j],"+|-")
				If Not (__esNombreVariable($traza, $vars) or __isChar($traza) or StringIsAlNum($traza) or $traza = "") Then Return False
			Next
		Next
		Return True
	EndIf
	If StringInStr($expresion, "|") > 0 Then
		$expresion = StringReplace($expresion, "Not", "", 0, 2)
		$partes = StringSplit($expresion, "|")
		For $i = 1 To $partes[0]
			If (Not StringReplace(StringReplace(StringIsAlNum($partes[$i]),"'",""),'"',"")) And (Not __esNombreVariable(StringReplace($partes[$i], " ", ""), $vars)) Then Return False
		Next
		Return True
	EndIf
	If StringIsAlNum($expresion) Then Return True
	$expresion = _eliminarPrimerosEspacios($expresion) & " "
	For $i = 0 To UBound($OPERADORES_VANILLA) - 1
		$expresion = StringReplace($expresion, $OPERADORES_VANILLA[$i] & " ", "", 0, 2)
	Next
	For $i = 1 To $vars[0]
		$var = $vars[$i]
		$expresion = StringReplace($expresion, $var[1] & " ", "", 0, 2)
	Next

	For $i = 0 To 9
		$expresion = StringReplace($expresion,$i&"","")
	Next

	MsgBox(0,"",__eliminarInteriores($expresion))
	Return __eliminarInteriores($expresion) = ""
EndFunc   ;==>__comprobarExpresion
Func __isChar($text)
	Return StringLen($text) = 3 And StringMid($text,1,1) = "'" And StringMid($text,3,1) = "'"
EndFunc
Func __eliminarCaracteres($text, $characters)
	$characters = StringSplit($characters,"|")
	For $i = 1 To $characters[0]
		$text = StringReplace($text,$characters[$i],"",0,2)
	Next
	Return $text
EndFunc
Func __eliminarInteriores($text,$del1=True,$del2=True,$del3=True)
	$levelSC = False
	$levelDC = False
	$levelPA = 0
	$levelCO = 0
	For $j = 1 To StringLen($text)
		$del = True
		$c = StringMid($text, $j, 1)
		If $levelSC Or $levelDC Or $levelPA > 0 Or $levelCO > 0 Then
			$text = StringReplace($text, StringMid($text, $j), StringTrimLeft(StringMid($text, $j), 1))
			$del = False
			$j -= 1
		EndIf
		If $c = "'" Then $levelSC = Not $levelSC
		If $c = '"' Then $levelDC = Not $levelDC
		If $c = "(" Then $levelPA += 1
		If $c = ")" Then $levelPA -= 1
		If $c = "[" Then $levelCO += 1
		If $c = "]" Then $levelCO -= 1
		If ($levelSC Or $levelDC Or $levelPA > 0 Or $levelCO > 0) And $del Then
			$text = StringReplace($text, StringMid($text, $j), StringTrimLeft(StringMid($text, $j), 1))
			$j -= 1
		EndIf
	Next
	If $del1 Then $text = StringReplace($text, " ", "")
	If $del2 Then $text = StringReplace($text, "|", "")
	If $del3 Then $text = StringReplace($text, "=", "")
	Return $text
EndFunc   ;==>__eliminarInteriores
Func _esFuncion($palabra)
	For $i = 0 To UBound($FUNCIONES) - 1
		If __MismaFuncion($palabra, $FUNCIONES[$i]) Then Return True
	Next
	Return False
EndFunc   ;==>_esFuncion
Func __MismaFuncion($f1, $f2)
	If StringLen($f1) <> StringLen($f2) Then Return False
	For $i = 1 To StringLen($f1)
		If StringUpper(StringMid($f1, $i, 1)) <> StringUpper(StringMid($f2, $i, 1)) And StringMid($f2, $i, 1) <> "?" Then Return False
	Next
	Return True
EndFunc   ;==>__MismaFuncion
Func _KeywordsEstructuras($linea)
	Return StringInStr($linea, "set", 2) > 0 Or StringInStr($linea, "if", 2) > 0 Or StringInStr($linea, "else", 2) > 0 Or StringInStr($linea, "switch", 2) > 0 Or StringInStr($linea, "case", 2) > 0
EndFunc   ;==>_KeywordsEstructuras
Func _eliminarDoblesEspacios($text)
	While StringInStr($text,"  ",2) > 0
		$text = StringReplace($text,"  "," ")
	WEnd
	Return $text
EndFunc
Func _eliminarUltimosEspacios($text)
	While StringMid($text, StringLen($text), 1) = " "
		$text = StringTrimRight($text, 1)
	WEnd
	Return $text
EndFunc   ;==>_eliminarUltimosEspacios
Func _eliminarPrimerosEspacios($text)
	While StringMid($text, 1, 1) = " "
		$text = StringTrimLeft($text, 1)
	WEnd
	Return $text
EndFunc   ;==>_eliminarPrimerosEspacios
Func _segmento($linea, $prev, $modStart, $modDef, $modBis, $modExit, $modAvoidStart = "", $modAvoidExit = "")
	If $linea = "" or $linea = " " Then
		If $prev < 0 Then
			Return $prev * -1
		Else
			Return $prev
		EndIf
	EndIf
	$modAvoidStart = " "&$modAvoidStart&" "
	$modAvoidExit = " "&$modAvoidExit&" "
	$partes = StringSplit($linea, " ")
	If $partes[0] <> 0 Then
		If $prev = 0 Then
			If StringUpper($partes[1]) = $modExit Then Return SetError($ERROR_ILLEGAL_END_STATEMENT)
			If StringUpper($partes[1]) = $modStart Then
				If $partes[0] = 2 Then
					If StringUpper($partes[2]) = $modDef Then Return -1
					If StringUpper($partes[2]) = $modBis Then Return -2
					Return SetError(4) ;  Error 4: Worng keyword for Open statement
				Else
					If $partes[0] > 2 Then Return SetError($ERROR_TOO_MANY_MODIFIERS_FOR_OPEN_STATEMENT)
					Return -1
				EndIf
			EndIf
			If $partes[1] <> "" And StringInStr($modAvoidExit," "&$partes[1]&" ",2) > 0 Then Return SetError($ERROR_ILLEGAL_END_STATEMENT)
			If $partes[1] <> "" And StringInStr($modAvoidStart," "&$partes[1]&" ",2) > 0 Then
				If $partes[0] > 2 Then Return SetError($ERROR_TOO_MANY_MODIFIERS_FOR_OPEN_STATEMENT)
				Return -3
			EndIf
		Else
			If $partes[0] >= 1 Then
				If StringUpper($partes[1]) = $modStart Then Return SetError(6) ; Error 6: Two Open statements consecutive
				If StringUpper($partes[1]) = $modExit Or ($partes[1] <> "" And StringInStr($modAvoidExit," "&$partes[1]&" ",2)) > 0 Then
					If $partes[0] = 1 Then
						Return 0
					Else
						Return SetError($ERROR_TOO_MANY_MODIFIERS_FOR_OPEN_STATEMENT)
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
Func _ValidarIdentificador($identificador); Deprecated
	If $BYPASS_MODE Then Return True

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
Func _getArray_WithIndex()
	Local $array[1]
	$array[0] = 0
	Return $array
EndFunc   ;==>_getArray_WithIndex
Func _getArray($size, $default = False)
	If IsArray($size) Then $size = UBound($size)
	Local $array[$size]
	For $i = 0 To $size - 1
		$array[$i] = $default
	Next
	Return $array
EndFunc   ;==>_getArray
Func _getFileName($file)
	If StringInStr($file, "/") > 0 Then
		Return StringTrimLeft($file, StringInStr($file, "/", 2, -1))
	ElseIf StringInStr($file, "\") > 0 Then
		Return StringTrimLeft($file, StringInStr($file, "\", 2, -1))
	Else
		Return $file
	EndIf
EndFunc   ;==>_getFileName

Func writeDocument($lineas, $origin, $target = False)
	If Not $target Then $target = StringTrimRight($origin, StringLen($origin) - StringInStr($origin, ".", 2, -1)) & "vhd"
	If FileExists($target) Then
		Sleep(500)
		If FileExists($target) Then
			If $SILENT_MODE Then
				FileDelete($target)
			Else
			If $PROGRESS_BAR Then _SendMessage(GUICtrlGetHandle($PROGRESS_BAR), 0x0410, 3)
			;Este boton fue generado automaticamente, como puede verse
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox(52,"Output file already exist","Do you want to overwrite it?")
			Select
				Case $iMsgBoxAnswer = 6 ;Yes
					FileDelete($target)
					If $PROGRESS_BAR Then _SendMessage(GUICtrlGetHandle($PROGRESS_BAR), 0x0410, 1)
				Case $iMsgBoxAnswer = 7 ;No
					Return SetError($ERROR_OUTPUT_FILE_ALREADY_EXIST, -1)
			EndSelect
		EndIf
		EndIf
	EndIf
	$file = FileOpen($target, 1)
	If $file = -1 Then Return SetError($ERROR_CAN_NOT_HAPPEND_DESTINATION_FILE, -1)
	For $i = 1 To $lineas[0]
		FileWriteLine($file, $lineas[$i])
	Next
	FileClose($file)
EndFunc   ;==>writeDocument
Func warn($code, $line)
	$mess = "Warning " & $code & ": " & $WARNING[$code]
	If $line <> -1 Then $mess &= @CRLF & "Probably on line " & $line
	If Not ($SILENT_MODE Or $VERBOSE_MODE) Then MsgBox(48, "PARASER WARNING", $mess)
	Elog($mess)
	If $PROGRESS_BAR Then _SendMessage(GUICtrlGetHandle($PROGRESS_BAR), 0x0410, 3)
EndFunc   ;==>warn
Func throw($code, $line)
	$mess = "Error " & $code & ": " & $ERROR[$code]
	If $line <> -1 Then $mess &= @CRLF & "Probably on line " & $line
	If Not ($SILENT_MODE Or $VERBOSE_MODE) Then MsgBox(16, "PARASER ERROR", $mess)
	Elog($mess, True)
	If $PROGRESS_BAR Then _SendMessage(GUICtrlGetHandle($PROGRESS_BAR), 0x0410, 2)
EndFunc   ;==>throw
Func Elog($text, $bypass = False) ; Echo basic data
	If $LOG_EDIT And (Not $SILENT_MODE Or $bypass) Then GUICtrlSetData($LOG_EDIT, GUICtrlRead($LOG_EDIT) & $text & @CRLF)
EndFunc   ;==>Elog
Func Vlog($text, $bypass = False) ; Echo in-time data
	If $LOG_EDIT And ($VERBOSE_MODE Or $bypass) Then GUICtrlSetData($LOG_EDIT, GUICtrlRead($LOG_EDIT) & $text & @CRLF)
EndFunc   ;==>Vlog
Func VlogRec($text, $bypass = False, $level = 0)
	$pre = ""
	For $i = 1 To $level * 2
		$pre &= "-"
	Next
	If IsArray($text) Then
		For $i = 0 To UBound($text) - 1
			VlogRec($text[$i], $bypass, $level + 1)
		Next
	Else
		Vlog($pre & $text, $bypass)
	EndIf
EndFunc   ;==>VlogRec
#EndRegion subUDF

Func autoCompilar($PARAM_noHeader, $PARAM_libStrict, $PARAM_verbose, $PARAM_file, $PARAM_silent, $PARAM_log = False, $PARAM_output = False, $PARAM_progress = False, $PARAM_implement = False, $PARAM_bypass = False)
	Elog("Arguments: " & $PARAM_noHeader & " " & $PARAM_libStrict & " " & $PARAM_verbose & " " & $PARAM_file & " " & $PARAM_silent & " " & $PARAM_output & " " & $PARAM_implement)

	;Opciones de salida
	$SILENT_MODE = $PARAM_silent
	$LOG_EDIT = $PARAM_log
	$PROGRESS_BAR = $PARAM_progress
	$VERBOSE_MODE = $PARAM_verbose
	$BYPASS_MODE = $PARAM_bypass
	If StringMid($PARAM_file, 1, 1) = "\" Then $PARAM_file = @ScriptDir & $PARAM_file
	If StringMid($PARAM_output, 1, 1) = "\" Then $PARAM_output = @ScriptDir & $PARAM_output

	Vlog("----Current paraemters ----------------")
	Vlog("No Header: " & $PARAM_noHeader)
	Vlog("Lib Strict: " & $PARAM_libStrict)
	Vlog("Verbose mode: " & $PARAM_verbose)
	Vlog("Silent mode: " & $PARAM_silent)
	Vlog("Implementation: " & $PARAM_implement)
	Vlog("Bypass Mode: " & $PARAM_bypass)
	Vlog("Input file: " & $PARAM_file)
	Vlog("Output file: " & $PARAM_output)
	Vlog("Log GUI: " & $PARAM_log)
	Vlog("Progress GUI: " & $PARAM_progress)
	Vlog("----Current paraemters ----------------" & @CRLF)
	If $PROGRESS_BAR Then GUICtrlSetData ($PROGRESS_BAR, 5)

	;Leer y adaptar fuente
	$script_lineas = leerFuente($PARAM_file)
	If @error Then Return throw(@error, @extended)
	$script_lineas = eliminarComentarios($script_lineas)
	$script_lineas = lineasLimpiar($script_lineas)

	Elog("File readed, coments and tabs deleted.")
	If $PROGRESS_BAR Then GUICtrlSetData ($PROGRESS_BAR, 10)

	;Datos extraidos
	$DATA_entidad = buscarNombre($script_lineas, "Entity", "Entidad")
	If @error Then Return throw(@error, @extended)
	$DATA_arquitectura = buscarNombre($script_lineas, "Architecture", "Arquitectura")
	If @error Then Return throw(@error, @extended)

	Elog("Entity name: " & $DATA_entidad & @CRLF & "Architecture name: " & $DATA_arquitectura)
	If $PROGRESS_BAR Then GUICtrlSetData ($PROGRESS_BAR, 15)

	;Detectar librerias y paquetes
	If $PARAM_libStrict Then
		$librerias_uso = setLibrerias("IEEE", $librerias_nombres)
		$paquetes_uso = setPaquetes($librerias_uso, $paquetes_libreria)
	Else
		$paquetes_uso = detectarPaquetes($script_lineas, $paquetes_contenidos, $paquetes_nombres)
		$librerias_uso = detectarLibrerias($paquetes_uso, $paquetes_libreria, $librerias_nombres)
	EndIf

	Elog(@CRLF & "----Libraries -----------------")
	Elog($PARAM_libStrict ? "Using only standard IEEE libraries" : "Library auto-detection tool deloyed")
	For $i = 0 To UBound($librerias_uso) - 1
		If $librerias_uso[$i] Then Elog("->" & $librerias_nombres[$i])
	Next
	Elog("Packages used:")
	For $i = 0 To UBound($paquetes_uso) - 1
		If $paquetes_uso[$i] Then Elog("->" & $paquetes_nombres[$i])
	Next
	Elog("----Libraries -----------------" & @CRLF)
	If $PROGRESS_BAR Then GUICtrlSetData ($PROGRESS_BAR, 25)


	;Detectar variables e instrucciones
	$vars = detectarVariables($script_lineas)
	If @error Then Return throw(@error, @extended)
	$logics = detectarLogica($script_lineas)
	If @error Then Return throw(@error, @extended)
	$vars = completarVariables($logics,$vars)

	Elog("----Vars -----------------")
	For $i = 1 To $vars[0]
		$var = $vars[$i]
		Elog("Name     ->" & $var[1])
		If $var[0] <> "" Then Vlog("Position ->" & $var[0])
		If $var[2] <> "" Then Vlog("IO Type  ->" & $var[2])
		If $var[3] <> "" Then Vlog("Var Type ->" & $var[3])
		If $var[4] <> "" Then Vlog("Array CF ->" & $var[4])
		If $var[5] <> "" Then Vlog("Initial  ->" & $var[5])
		If $var[6] <> "" Then Vlog("Line     ->" & $var[6])
		If $var[7] <> "" Then Vlog("Mod      ->" & $var[7])
		If $var[8] <> "" Then Vlog("Process  ->" & $var[8])
		Vlog("")
	Next
	Elog("----Vars -----------------" & @CRLF)
	If $PROGRESS_BAR Then GUICtrlSetData ($PROGRESS_BAR, 55)
	Elog("----Logic -----------------")
	Local $operacionesNombre[] = ["Asignacion", "Conversion", "SetIf", "SetSwitch", "IfThen", "SwitchCase", "Function", "ForNext"]
	For $i = 1 To $logics[0]
		$logic = $logics[$i]
		Elog("Operation    ->" & $operacionesNombre[$logic[1] - 1] & "   Line: " & $logic[UBound($logic) - 1])
		VlogRec($logic)
		Vlog("")
	Next
	Elog("----Logic -----------------" & @CRLF)
	If $PROGRESS_BAR Then GUICtrlSetData ($PROGRESS_BAR, 85)

	;Escribir el documento final
	$VHDL_lineas = writeInicio(Not $PARAM_noHeader, $DATA_entidad, $DATA_arquitectura, $PARAM_file)
	If @error Then Return throw(@error, @extended)
	$VHDL_lineas = writeIncludes($VHDL_lineas, $librerias_uso, $paquetes_uso, $librerias_nombres, $paquetes_nombres)
	If @error Then Return throw(@error, @extended)
	$VHDL_lineas = writeEntidad($VHDL_lineas, $DATA_entidad, $vars)
	If @error Then Return throw(@error, @extended)
	$VHDL_lineas = writeArquitectura($VHDL_lineas, $DATA_arquitectura, $DATA_entidad, $logics, $vars, $PARAM_libStrict)
	If @error Then Return throw(@error, @extended)

	;Implementacion
	If $PARAM_implement Then
		Vlog("----Implementation -----------------")

		$restrictions = detectarImplementacion($script_lineas, $vars)
		If @error Then Return throw(@error, @extended)
		If IsArray($restrictions) and $restrictions[0] > 0 Then
			VlogRec($restrictions)
		Else
			Vlog("Implementation data not found")
		EndIf
		$VHDL_lineas = writeImplement($VHDL_lineas, $restrictions)
		If @error Then Return throw(@error, @extended)

		Vlog("----Implementation -----------------")
	Else
		Vlog("Implementation will be skipped")
	EndIf

	Elog("Everithing written")
	If $PROGRESS_BAR Then GUICtrlSetData ($PROGRESS_BAR, 90)

	;Crear el archivo
	writeDocument($VHDL_lineas, $PARAM_file, $PARAM_output)
	If @error Then Return throw(@error, @extended)

	Elog(@CRLF & "File parsed successfuly")
	If $PROGRESS_BAR Then GUICtrlSetData ($PROGRESS_BAR, 100)
	;If $PROGRESS_BAR Then _SendMessage(GUICtrlGetHandle($PROGRESS_BAR), 0x0410, 1)

	Return True
EndFunc   ;==>autoCompilar

; TODO: Arreglar todo lo que sigua roto

#Region UDF de la comunidad

#EndRegion