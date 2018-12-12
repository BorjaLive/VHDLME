#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\icon.ico
#AutoIt3Wrapper_Outfile=VMEgui_CUI_i386.Exe
#AutoIt3Wrapper_Outfile_x64=VMEgui_CUI_AMD64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=A python like sintax parser for VHDL. By BorjaLive (B0vE)
#AutoIt3Wrapper_Res_Description=VHDL Made Easy
#AutoIt3Wrapper_Res_Fileversion=1.0.1.4
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductName=VHDL ME GUI
#AutoIt3Wrapper_Res_ProductVersion=1.0.1
#AutoIt3Wrapper_Res_CompanyName=LivePloyers
#AutoIt3Wrapper_Res_LegalCopyright=B0vE
#AutoIt3Wrapper_Res_LegalTradeMarks=BorjaLive
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <WindowsConstants.au3>
#include <VHDLME.au3>

Opt("GUIOnEventMode",True)

#Region GUI
$GUI = GUICreate("VME parser",500,750)
GUISetFont(14)
GUICtrlCreateLabel("Registro de eventos",20,5,480,25)
$edit_log = GUICtrlCreateEdit("",10,30,470,300,$WS_VSCROLL)
_GUICtrlEdit_SetReadOnly($edit_log, True)
GUICtrlSetFont($edit_log,11,400, 0, "Consolas")
GUICtrlCreateLabel("Archivo vme de entrada",20,340,480,25)
$input_fileI = GUICtrlCreateInput("",10,365,360,25)
$button_selectI = GUICtrlCreateButton("Seleccionar",380,360,110,35)
GUICtrlCreateLabel("Archivo vhd de salida",20,400,480,25)
$input_fileO = GUICtrlCreateInput("",10,425,360,25)
$button_selectO = GUICtrlCreateButton("Seleccionar",380,420,110,35)
GUICtrlCreateLabel("Opciones de compilacion",20,470,480,25)
$check_noheader = GUICtrlCreateCheckbox("No header: Desactiva la cabecera en el archivo de salida",10,500)
$check_libstrict = GUICtrlCreateCheckbox("Lib Strict: Fuerza el uso exclusivo de la libreria IEEE",10,530)
$check_verbose = GUICtrlCreateCheckbox("Verbose: Muestra todos los mensajes del compilador",10,560)
$check_silent = GUICtrlCreateCheckbox("Silent: Evita mostrar ventanas emergentes",10,590)
$button_compilar = GUICtrlCreateButton("Compilar",150,630,200,60)
GUICtrlSetFont($button_compilar,20,800)
$loadingbar = GUICtrlCreateProgress(20,700,460,35)

GUICtrlSetOnEvent($button_selectI, "setIn")
GUICtrlSetOnEvent($button_selectO, "setOut")
GUICtrlSetOnEvent($button_compilar, "compilar")
GUISetOnEvent($GUI_EVENT_CLOSE, "salir")
GUISetState(@SW_SHOW,$GUI)
#EndRegion

While True
	Sleep(10)
WEnd

Func compilar()
	GUICtrlSetData($edit_log,"------- Llamando al parser -------"&@CRLF)
	autoCompilar((GUICtrlRead($check_noheader)=$GUI_CHECKED ), (GUICtrlRead($check_libstrict)=$GUI_CHECKED), (GUICtrlRead($check_verbose)=$GUI_CHECKED), _
					StringReplace(GUICtrlRead($input_fileI),"/","\"), (GUICtrlRead($check_silent)=$GUI_CHECKED), $edit_log, StringReplace(GUICtrlRead($input_fileO),"/","\"), $loadingbar)
	Elog(@CRLF&"------- Proceso terminado -------", True)
EndFunc
Func setIn()
	$file = FileOpenDialog("Selecciona un archivo fuente vme",@DesktopDir,"Archivo VME (*.vme)|Todos los archivos (*)")
	$file = StringReplace($file,@ScriptDir,"")
	GUICtrlSetData($input_fileI, $file)
	$file = StringInStr($file,".")>0?StringTrimRight($file,StringLen($file)-StringInStr($file,".",2,-1))&"vhd":$file&".vhd"
	GUICtrlSetData($input_fileO, $file)
EndFunc
Func setOut()
	$file = FileOpenDialog("Selecciona un archivo fuente vme",@DesktopDir,"Archivo VME (*.vme)|Todos los archivos (*)")
	$file = StringReplace($file,@ScriptDir&"\","")
	GUICtrlSetData($input_fileO, $file)
EndFunc
Func salir()
	exit
EndFunc
