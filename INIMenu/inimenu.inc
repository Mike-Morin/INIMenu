include windows.inc
include user32.inc
include kernel32.inc
include shell32.inc
include comctl32.inc
include comdlg32.inc
include masm32.inc

includelib user32.lib
includelib kernel32.lib
includelib shell32.lib
includelib comctl32.lib
includelib comdlg32.lib
includelib masm32.lib

WinMain				PROTO :DWORD,:DWORD,:DWORD,:DWORD
WndProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD




;Menu Builder.dlg
IDD_DIALOG						equ 1000
IDC_LST1						equ 1001
IDC_BTN1						equ 1002
IDC_EDT1						equ 1003
IDC_BTN3						equ 1004
IDC_BTN4						equ 1005

;Menu Builder.Rc

;Res\Menu BuilderRes.rc
ICO_1							equ 10
MAXPATH							equ 260


WM_SHELLNOTIFY equ WM_USER+5 
.const

ClassName			db 'MenuClass',0
zero                db 0

;Errors
NoINIFileText	db "The .ini file that is used to display the contents of this menu seems to be missing, corrupt, or otherwise unavailable!  Please contact the author of this menu and request menu.ini, or move menu.ini into this directory",0
NoINIFileCaption db "Fatal Error",0
NoFileButton	DB "Button Undefined in Menu.ini.",0
NoFileText		db "Text Undefined in Menu.ini.",0

.data?
; Dialog Handls...and stuff like that=====
hInstance			dd ?
CommandLine			dd ?
hWnd				dd ?
;=========================================
;Others===================================
MainBuffer			db 4000 DUP (?)
DescriptionBuffer	db 4000 DUP (?)
DescriptionBuffer1	db 4000	DUP	(?)

MainBuffer1			db 4000 DUP (?)
CurrentSelection	db 4000 DUP (?)



;=========================================
inipath			db MAXPATH DUP(?) 



.data
page1				db "PAGE",0
numpage			db 4000 DUP (0)
CurrentPage		db 4000 DUP (0)
ItemBuffer		db 4000 DUP (0)
ItemBuffer1		db 4000 DUP (0)
ItemBuffer2		db 4000 DUP (0)
PathBuffer		db 4000 DUP (0)
CommandBuffer	db 4000 DUP (0)


;INI Data       ------------------------------------------
;Path========================================
ininame			db "\menu.ini",0

;[PageData]==================================
paged           db "PageData",0
pages           db "Pages",0
npage			db "NextPage",0
ppage			db "PreviousPage",0

;[Interface]=================================
inter           db "Interface",0
wintitle        db "Title",0 

;[Items]=====================================
items           db "Items",0
Item            db "Item",0
number          db "Number",0

;[Descriptions]==============================
defdesc         db "Default",0
desc            db "Descriptions",0
predesc        	db "Description",0

;[Paths]=====================================
paths           db "Paths",0
pathd           db "Path",0


;[ButtonCaptions]============================
bdef            db "Default",0
bcaps           db "ButtonCaptions",0
bcap            db "ButtonCaption",0

;[Commands]==================================
defcom		db "Default",0
coms		db "Commands",0
com			db "Command",0

;---------------------------------------------
