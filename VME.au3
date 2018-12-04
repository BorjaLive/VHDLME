#include <Array.au3>
#include <VHDLutils.au3>

;Valores que luego iran definidos por parametros
$PARAM_noHeader = False
$PARAM_name = ""
$PARAM_file = "C:\Users\Arlin-T2\Desktop\test.vme"




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

ConsoleWrite($DATA_entidad&@CRLF&$DATA_arquitectura&@CRLF)

;Detectar librerias y paquetes
$paquetes_uso = detectarPaquetes($script_lineas,$paquetes_contenidos,$paquetes_nombres)
$librerias_uso = detectarLibrerias($paquetes_uso,$paquetes_libreria,$librerias_nombres)

;Asgnar nombres correctos y detectar variables

;Detectar variables e instrucciones
$vars = detectarVariables($script_lineas)
;Distinguir entre las de fuera, las que estan dentro de una seccion y que seccion
;	seccion, nombre, puerto, tipo, argumentos EJ: "A:in binary" = 0,A,in,binary,"" EJ: "F:binary[0,7]" = 1,F,"",binary,"0,7"
If @error Then throw(@error,@extended)

;$logic = detectarExpression($script_lineas,$LOGIC_EXPRESSION)

For $i = 1 To $vars[0]
   _ArrayDisplay($vars[$i])
Next

;_ArrayDisplay($signals)
;_ArrayDisplay($logic)




Func throw($code, $line)
   MsgBox(16,"PARASER ERROR","Error "&$code&": "&$ERROR[$code]&@CRLF&"Probably on line "&$line)
   Exit
EndFunc