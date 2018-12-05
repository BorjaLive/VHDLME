#include <Array.au3>
#include <VHDLutils.au3>

;Valores que luego iran definidos por parametros
$PARAM_noHeader = False
$PARAM_name = ""
$PARAM_file = "C:\Users\Arlin-T2\Desktop\VHDLME\test.vme"




;Leer y adaptar archivo
$script_lineas = leerFuente($PARAM_file)
If @error Then throw(@error,0)

$script_lineas = eliminarComentarios($script_lineas)
$script_lineas = lineasLimpiar($script_lineas)
;_ArrayDisplay($script_lineas)

;Datos extraidos
$DATA_entidad = buscarNombre($script_lineas,"Entity","Entidad")
If @error Then throw(@error,@extended)

$DATA_arquitectura = buscarNombre($script_lineas,"Architecture","Arquitectura")
If @error Then throw(@error,@extended)

;ConsoleWrite($DATA_entidad&@CRLF&$DATA_arquitectura&@CRLF)

;Detectar librerias y paquetes
$paquetes_uso = detectarPaquetes($script_lineas,$paquetes_contenidos,$paquetes_nombres)
$librerias_uso = detectarLibrerias($paquetes_uso,$paquetes_libreria,$librerias_nombres)

;Asgnar nombres correctos y detectar variables

;Detectar variables e instrucciones
$vars = detectarVariables($script_lineas)
If @error Then throw(@error,@extended)

$logic = detectarLogica($script_lineas)
If @error Then throw(@error,@extended)

For $i = 1 To $logic[0]
   $sentencia = $logic[$i]
   _ArrayDisplay($sentencia)
   ;If $sentencia[1] = 4 Or $sentencia[1] = 3 Then _ArrayDisplay($sentencia[3])
   ;If $sentencia[1] = 4 Or $sentencia[1] = 3 Then _ArrayDisplay($sentencia[4])
Next

;_ArrayDisplay($signals)
;_ArrayDisplay($logic)




