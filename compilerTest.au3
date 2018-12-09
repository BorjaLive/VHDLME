#include <Array.au3>
#include <VHDLME.au3>

;Valores definidos por parametros
$PARAM_noHeader = False
$PARAM_libStrict = False
$PARAM_verbose = False
$PARAM_file = "test.vme"
$PARAM_silent = False

#Region Analisis
$SILENT_MODE = $PARAM_silent
$VERBOSE_MODE = False
$LOG_EDIT = False

;Leer y adaptar archivo
$script_lineas = leerFuente($PARAM_file)
If @error Then throw(@error,0)

$script_lineas = eliminarComentarios($script_lineas)
$script_lineas = lineasLimpiar($script_lineas)

;Datos extraidos
$DATA_entidad = buscarNombre($script_lineas,"Entity","Entidad")
If @error Then throw(@error,@extended)

$DATA_arquitectura = buscarNombre($script_lineas,"Architecture","Arquitectura")
If @error Then throw(@error,@extended)

;Detectar librerias y paquetes
If $PARAM_libStrict Then
	$librerias_uso = setLibrerias("IEEE",$librerias_nombres)
	$paquetes_uso = setPaquetes($librerias_uso,$paquetes_libreria)
Else
	$paquetes_uso = detectarPaquetes($script_lineas,$paquetes_contenidos,$paquetes_nombres)
	$librerias_uso = detectarLibrerias($paquetes_uso,$paquetes_libreria,$librerias_nombres)
EndIf


;Detectar variables e instrucciones
$vars = detectarVariables($script_lineas)
If @error Then throw(@error,@extended)

$logic = detectarLogica($script_lineas)
If @error Then throw(@error,@extended)
#EndRegion

#Region Escritura
$VHDL_lineas = writeInicio(Not $PARAM_noHeader, $DATA_entidad, $DATA_arquitectura, $PARAM_file)
If @error Then throw(@error,@extended)
$VHDL_lineas = writeIncludes($VHDL_lineas, $librerias_uso, $paquetes_uso, $librerias_nombres, $paquetes_nombres)
If @error Then throw(@error,@extended)
$VHDL_lineas = writeEntidad($VHDL_lineas, $DATA_entidad, $vars)
If @error Then throw(@error,@extended)
$VHDL_lineas = writeArquitectura($VHDL_lineas, $DATA_arquitectura, $DATA_entidad, $logic, $vars, $PARAM_libStrict)
If @error Then throw(@error,@extended)

writeDocument($VHDL_lineas, $PARAM_file)
If @error Then throw(@error,@extended)

_ArrayDisplay($VHDL_lineas)
#EndRegion