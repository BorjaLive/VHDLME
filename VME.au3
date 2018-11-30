#include <Array.au3>
#include <VHDLutils.au3>

;Valores que luego iran definidos por parametros
$PARAM_noHeader = False
$PARAM_name = ""
$PARAM_file = "C:\Users\Arlin-T2\Desktop\test.vme"




;Leer y adaptar archivo
$script_lineas = StringSplit(FileRead($PARAM_file),@CRLF,1)

$script_lineas = eliminarComentarios($script_lineas)
$script_lineas = lineasOptimizar($script_lineas)

;Datos extraidos
$DATA_entidad = buscarNombre($script_lineas,"Entity","Entidad")
$DATA_arquitectura = buscarNombre($script_lineas,"Architecture","Arquitectura")
;ConsoleWrite($DATA_entidad&@CRLF&$DATA_arquitectura&@CRLF)

;Detectar librerias y paquetes
$paquetes_uso = detectarPaquetes($script_lineas,$paquetes_contenidos,$paquetes_nombres)
$librerias_uso = detectarLibrerias($paquetes_uso,$paquetes_libreria,$librerias_nombres)

;Asgnar nombres correctos y detectar variables
$script_lineas = cambiarNombres($script_lineas,$nombres)
;_ArrayDisplay($script_lineas)
;$ports = detectarExpression($script_lineas,$PORT_EXPRESSION)
;$signals = detectarExpression($script_lineas,$SIGNAL_EXPRESSION)
$logic = detectarExpression($script_lineas,$LOGIC_EXPRESSION)


;_ArrayDisplay($ports)
;_ArrayDisplay($signals)
_ArrayDisplay($logic)