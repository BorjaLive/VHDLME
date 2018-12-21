;Ejemplo de uso: vme.exe test.vme --noHeader

#include <Array.au3>
#include <VHDLME.au3>


$PARAM_noHeader = False
$PARAM_libStrict = False
$PARAM_verbose = False
$PARAM_file = ""
$PARAM_silent = False
$PARAM_implement = False
$PARAM_bypass = False

For $i = 1 To $cmdLine[0]
	If $cmdLine[$i] = "--noHeader" Then
		$PARAM_noHeader = True
	ElseIf $cmdLine[$i] = "--libStrict" Then
		$PARAM_libStrict = True
	ElseIf $cmdLine[$i] = "--verbose" or $cmdLine[$i] = "-v" Then
		$PARAM_verbose = True
	ElseIf $cmdLine[$i] = "--silent" or $cmdLine[$i] = "-s" Then
		$PARAM_silent = True
	ElseIf $cmdLine[$i] = "--implement" Then
		$PARAM_implement = True
	ElseIf $cmdLine[$i] = "--bypass" Then
		$PARAM_bypass = True
	Else
		$PARAM_file = $cmdLine[$i]
	EndIf
Next

autoCompilar($PARAM_noHeader, $PARAM_libStrict, $PARAM_verbose, $PARAM_file, $PARAM_silent)