#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\icon.ico
#AutoIt3Wrapper_Outfile=VMEgui_i386.Exe
#AutoIt3Wrapper_Outfile_x64=VMEgui_AMD64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=A python like sintax parser for VHDL. By BorjaLive (B0vE)
#AutoIt3Wrapper_Res_Description=VHDL Made Easy
#AutoIt3Wrapper_Res_Fileversion=1.2.0.2
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductName=VHDL ME GUI
#AutoIt3Wrapper_Res_ProductVersion=1.2.0
#AutoIt3Wrapper_Res_CompanyName=LivePloyers
#AutoIt3Wrapper_Res_LegalCopyright=B0vE
#AutoIt3Wrapper_Res_LegalTradeMarks=BorjaLive
#AutoIt3Wrapper_Res_Language=1034
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <winapi.au3>
#include <VHDLME.au3>

Opt("GUIOnEventMode", True)
HotKeySet("{F1}","ayuda")
HotKeySet("^{ENTER}","secret")

#Region GUI principal
$GUI_main = GUICreate("VME parser", 500, 475)
GUISetFont(14)
GUICtrlCreateLabel("Archivo vme de entrada", 20, 10, 480, 25)
$input_fileI = GUICtrlCreateInput("", 10, 35, 360, 25)
$button_selectI = GUICtrlCreateButton("Seleccionar", 380, 30, 110, 35)
GUICtrlCreateLabel("Archivo vhd de salida", 20, 70, 480, 25)
$input_fileO = GUICtrlCreateInput("", 10, 95, 360, 25)
$button_selectO = GUICtrlCreateButton("Seleccionar", 380, 90, 110, 35)
GUICtrlCreateLabel("Opciones de compilacion", 20, 140, 480, 25)
$check_noheader = GUICtrlCreateCheckbox("No header: Desactiva la cabecera en el archivo de salida", 10, 170)
$check_libstrict = GUICtrlCreateCheckbox("Lib Strict: Fuerza el uso exclusivo de la libreria IEEE", 10, 200)
$check_verbose = GUICtrlCreateCheckbox("Verbose: Muestra todos los mensajes del compilador", 10, 230)
$check_silent = GUICtrlCreateCheckbox("Silent: Evita mostrar ventanas emergentes", 10, 260)
$check_implement = GUICtrlCreateCheckbox("Implement: Generar restricciones", 10, 290)
$check_bypass = GUICtrlCreateCheckbox("Bypass: No comprobará expresiones", 10, 320)
$button_compilar = GUICtrlCreateButton("Compilar", 150, 360, 200, 60)
GUICtrlSetFont($button_compilar, 20, 800)
$button_ayuda = GUICtrlCreateButton("Ayuda", 20, 390, 75, 30)
GUICtrlSetFont($button_ayuda, 12, 600)
$loadingbar = GUICtrlCreateProgress(20, 430, 460, 35)

$label = GUICtrlCreateLabel("NEW",305,292)
GUICtrlSetFont($label,15,800)
GUICtrlSetColor($label,0xFF0000)
$label = GUICtrlCreateLabel("NEW",330,322)
GUICtrlSetFont($label,15,800)
GUICtrlSetColor($label,0xFF0000)

GUICtrlSetOnEvent($button_selectI, "setIn")
GUICtrlSetOnEvent($button_selectO, "setOut")
GUICtrlSetOnEvent($button_compilar, "compilar")
GUICtrlSetOnEvent($button_ayuda, "ayuda")
GUISetOnEvent($GUI_EVENT_CLOSE, "salir")

GUISetState(@SW_SHOW, $GUI_main)
#EndRegion
#Region GUI LOG
$GUI_log = GUICreate("VME Log", 420, 640,50,50)
GUISetFont(14)
GUICtrlCreateLabel("Registro de eventos", 20, 5, 480, 25)
$edit_log = GUICtrlCreateEdit("", 10, 30, 400, 600, $WS_VSCROLL)
_GUICtrlEdit_SetReadOnly($edit_log, True)
GUICtrlSetFont($edit_log, 11, 400, 0, "Consolas")

GUISetOnEvent($GUI_EVENT_CLOSE, "cerrarLog")

GUISetState(@SW_HIDE, $GUI_log)
#EndRegion

While True
	Sleep(50)
WEnd

Func compilar()
	If GUICtrlRead($check_verbose) = $GUI_CHECKED Then
		GUISetState(@SW_SHOW, $GUI_log)
	EndIf
	GUICtrlSetData($edit_log, "------- Llamando al parser -------" & @CRLF)
	autoCompilar((GUICtrlRead($check_noheader) = $GUI_CHECKED), (GUICtrlRead($check_libstrict) = $GUI_CHECKED), (GUICtrlRead($check_verbose) = $GUI_CHECKED), _
			StringReplace(GUICtrlRead($input_fileI), "/", "\"), (GUICtrlRead($check_silent) = $GUI_CHECKED), $edit_log, StringReplace(GUICtrlRead($input_fileO), "/", "\"), _
			$loadingbar, (GUICtrlRead($check_implement) = $GUI_CHECKED), (GUICtrlRead($check_bypass) = $GUI_CHECKED))
	Elog(@CRLF & "------- Proceso terminado -------", True)
	GUICtrlSetData($loadingbar,100)
EndFunc   ;==>compilar
Func setIn()
	$file = FileOpenDialog("Selecciona un archivo fuente vme", @DesktopDir, "Archivo VME (*.vme)|Todos los archivos (*)")
	$file = StringReplace($file, @ScriptDir, "")
	GUICtrlSetData($input_fileI, $file)
	$file = StringInStr($file, ".") > 0 ? StringTrimRight($file, StringLen($file) - StringInStr($file, ".", 2, -1)) & "vhd" : $file & ".vhd"
	GUICtrlSetData($input_fileO, $file)
EndFunc   ;==>setIn
Func setOut()
	$file = FileOpenDialog("Selecciona un archivo fuente vme", @DesktopDir, "Archivo VHDL (*.vhd)|Todos los archivos (*)")
	$file = StringReplace($file, @ScriptDir & "\", "")
	GUICtrlSetData($input_fileO, $file)
EndFunc   ;==>setOut
Func cerrarLog()
	GUISetState(@SW_HIDE, $GUI_log)
EndFunc
Func salir()
	Exit
EndFunc   ;==>salir

;Cosas EXTRA cosas
Func ayuda()
	ShellExecute("https://github.com/BorjaLive/VHDLME/blob/master/Manual.pdf")
EndFunc
Func secret()
	$secret = @TempDir&"\VMEs"
	Local $secrets[] = ["https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/intermediary/f/03d1d16c-44c1-4437-b0d5-0453606be7c8/dcvy1ei-4e018e74-0ff9-4247-9c6f-13c39c5670de.png", _
						"https://pbs.twimg.com/media/DhQl000VMAALVZv.jpg", _
						"http://i.imgur.com/xDV5xER.jpg", _
						"https://fit-cats.com/wp-content/uploads/2016/08/cat-begging-for-food-667x1024.jpg", _
						"http://3.bp.blogspot.com/-SURI-X4p_H4/TqNe9Rw9gMI/AAAAAAAAA84/akWG5gvZCWg/s1600/265172_1906569113384_1516489272_31780353_2262810_n.jpg", _
						"https://i.pinimg.com/originals/4f/f8/b2/4ff8b24cdba7b84e9e370fab44866433.jpg", _
						"http://atomix.vg/wp-content/uploads/2014/09/Sonic-x-Hello-Kitty-Poster.jpg", _
						"https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/intermediary/f/ec368c14-4f7f-4283-9e1a-f0b8e33155b6/dah0b5u-ef3a3407-0646-431a-88c1-1fa9a56cb826.png"]
	$i = floor(Random(0,UBound($secrets)))
	InetGet($secrets[$i],$secret)

	_GDIPlus_Startup()
	Local $msg
	$hImage = _GDIPlus_ImageLoadFromFile($secret)
	$iX_ImageDisplay = _GDIPlus_ImageGetWidth($hImage)
	$iY_ImageDisplay = _GDIPlus_ImageGetHeight($hImage)
	$iFactor_ImageDisplay = 1
	If $iX_ImageDisplay > @DesktopWidth Or $iY_ImageDisplay > @DesktopHeight Then
		$iX_ImageDisplay = $iX_ImageDisplay * (@DesktopHeight / $iY_ImageDisplay)
		$iFactor_ImageDisplay = @DesktopHeight / $iY_ImageDisplay
		$iY_ImageDisplay = @DesktopHeight
		If $iX_ImageDisplay > @DesktopWidth Then
			$iY_ImageDisplay = $iY_ImageDisplay * (@DesktopWidth / $iX_ImageDisplay)
			$iFactor_ImageDisplay = @DesktopWidth / $iX_ImageDisplay
			$iX_ImageDisplay = @DesktopWidth
		EndIf
	EndIf
	$iX_ImageDisplay = Int($iX_ImageDisplay)
	$iY_ImageDisplay = Int($iY_ImageDisplay)
	$GUIsecret = GUICreate("My GUI", $iX_ImageDisplay,$iY_ImageDisplay, @DesktopWidth /2 - $iX_ImageDisplay /2 ,@DesktopHeight /2 - $iY_ImageDisplay /2 , $WS_POPUP); will create a dialog box that when displayed is centered
	$pic_image_display = GUICtrlCreatePic("", 0, 0, $iX_ImageDisplay, $iY_ImageDisplay)
	$hBMP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	_WinAPI_DeleteObject(GUICtrlSendMsg($pic_image_display, 0x0172, $IMAGE_BITMAP, $hBMP))
	_GDIPlus_ImageDispose($hImage)
	_WinAPI_DeleteObject($hBMP)
	_GDIPlus_Shutdown()
	GUICtrlSetPos($pic_image_display, 0, 0, $iX_ImageDisplay, $iY_ImageDisplay)
	GUICtrlSetPos($pic_image_display, 0, 0, $iX_ImageDisplay-1, $iY_ImageDisplay-1)
	GUICtrlSetPos($pic_image_display, 0, 0, $iX_ImageDisplay, $iY_ImageDisplay)
	GUISetState(@SW_SHOW)
	Sleep(5000)
	GUIDelete($GUIsecret)
EndFunc