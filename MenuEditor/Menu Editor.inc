include windows.inc
include user32.inc
include kernel32.inc
include shell32.inc
include comctl32.inc
include comdlg32.inc
include ole32.inc
include masm32.inc
include shlwapi.inc

includelib user32.lib
includelib kernel32.lib
includelib shell32.lib
includelib comctl32.lib
includelib comdlg32.lib
includelib ole32.lib
includelib masm32.lib
includelib shlwapi.lib




WinMain				PROTO :DWORD,:DWORD,:DWORD,:DWORD
WndProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD
NewMenu				PROTO :DWORD,:DWORD,:DWORD,:DWORD
PageEdit			PROTO :DWORD,:DWORD,:DWORD,:DWORD
EditItem			PROTO :DWORD,:DWORD,:DWORD,:DWORD
AddItem				PROTO :DWORD,:DWORD,:DWORD,:DWORD
PageList			PROTO :DWORD,:DWORD,:DWORD,:DWORD
Autorun				PROTO :DWORD,:DWORD,:DWORD,:DWORD
ChkMen				PROTO :HWND,:UINT,:WPARAM,:LPARAM




;AddInsertItem.dlg
IDD_DLG5						equ 50000
IDC_STC15						equ 5001
IDC_EDT20						equ 5002
IDC_STC16						equ 5003
IDC_EDT21						equ 5004
IDC_STC17						equ 5005
IDC_EDT22						equ 5006
IDC_EDT23						equ 5007
IDC_STC18						equ 5008
IDC_STC19						equ 5009
IDC_EDT24						equ 5010
IDC_STC20						equ 5011
IDC_EDT25						equ 5012
IDC_BTN20						equ 5013
IDC_BTN21						equ 5014

;Autorun.dlg
IDD_DLG7						equ 7000
IDC_EDT10						equ 7001
IDC_STC23						equ 7002
IDC_STC24						equ 7003
IDC_EDT14						equ 7004
IDC_STC25						equ 7005
IDC_EDT15						equ 7006
IDC_BTN19						equ 7007
IDC_BTN23						equ 7009
IDC_STC26						equ 7010
IDC_STC27						equ 7011
IDC_EDT16						equ 7012
IDC_BTN25						equ 7013
IDC_BTN26						equ 7014

;EditItem.dlg
IDD_DLG3						equ 4000
IDC_EDT5						equ 4001
IDC_STC1						equ 4002
IDC_STC7						equ 4003
IDC_EDT8						equ 4004
IDC_STC8						equ 4005
IDC_EDT9						equ 4006
IDC_STC9						equ 4007
IDC_BTN9						equ 4009
IDC_EDT11						equ 4010
IDC_STC11						equ 4011
IDC_STC12						equ 4012
IDC_EDT12						equ 4013
IDC_BTN17						equ 4011
IDC_STC14						equ 4008
IDC_CBO1						equ 4015

;Menu Editor.dlg
IDD_DIALOG						equ 1000
IDC_LST1						equ 1001
IDC_BTN6						equ 1005
IDC_BTN10						equ 1010
IDC_EDT1						equ 1002
IDC_GRP1						equ 1003
IDC_BTN11						equ 1009
IDC_BTN5						equ 1006
IDC_BTN8						equ 1007
IDC_BTN12						equ 1008
IDC_BTN7						equ 1013
IDC_BTN13						equ 1012
IDC_BTN1						equ 1004

;Menu Editor.mnu
IDM_MENU						equ 10000
IDM_NM							equ 10006
IDM_OPEN						equ 10007
IDM_FILE_EXIT					equ 10001
IDM_							equ 10002
IDM_Wiz							equ 10003
IDM_Chkp						equ 10004
IDM_Auto						equ 10005
IDM_HELP_ABOUT					equ 10101

;Menu Editor.Rc

;MenuDefaults.dlg
IDD_DLG1						equ 2000
IDC_GRP2						equ 2001
IDC_EDT2						equ 2002
IDC_STC3						equ 2003
IDC_STC4						equ 2004
IDC_EDT3						equ 2005
IDC_STC5						equ 2006
IDC_EDT4						equ 2007
IDC_BTN2						equ 2008
IDC_STC13						equ 2009
IDC_EDT13						equ 2010
IDC_STC22						equ 2013
IDC_BTN14						equ 2015
IDC_BTN15						equ 2018
IDC_BTN16						equ 2011
IDC_CBO2						equ 2012

;MWizard1.dlg
IDD_DLG4						equ 5000
IDC_STC10						equ 5001

;NewMenu.dlg
IDD_DLG2						equ 3000
IDC_EDT6						equ 3001
IDC_STC2						equ 3002
IDC_STC6						equ 2003
IDC_EDT7						equ 3004
IDC_BTN3						equ 3005
IDC_BTN4						equ 3006

;Page List.dlg
IDD_DLG6						equ 6000
IDC_LST2						equ 6001
IDC_STC21						equ 6002
IDC_BTN18						equ 6003

;PathCheck.dlg
IDD_DLG8						equ 8000
IDC_GRP4						equ 8007
IDC_GRP3						equ 8004
IDC_STC28						equ 8001
IDC_EDT17						equ 8002
IDC_BTN22						equ 8003
IDC_EDT18						equ 8005
IDC_BTN24						equ 8006
IDC_BTN27						equ 8008




;--------------------------------------------------------------------------------
	
ICO_1							equ 10				
MAXPATH							equ 260



.const
one					db "1",0
mainn				db "The Menu Editor  -",0
Edit				db "Edit Menu Item: ",0
NoFileButton		DB "Button Undefined in Menu.ini.",0
;Path
ininame				db "\Menu.ini",0
notinic				db "Cannot load specified file",0
notinit				db "The file you have chosen is not a menu ini.",0
;Page data
paged           	db "PageData",0
pages           	db "Pages",0
npage				db "NextPage",0
ppage				db "PreviousPage",0

;[Interface]
inter           	db "Interface",0
wintitle            db "Title",0 

;[Items]
items           	db "Items",0
Item            	db "Item",0
number          	db "Number",0

;[Descriptions]
defdesc         	db "Default",0
desc            	db "Descriptions",0
predesc       		db "Description",0

;[Paths]
paths            	db "Paths",0
pathd            	db "Path",0


;[ButtonCaptions]

bdef            	db "Default",0
bcaps          		db "ButtonCaptions",0
bcap            	db "ButtonCaption",0

;[Commands]
defcom				db "Default",0
coms				db "Commands",0
com					db "Command",0

;--------------------------------------------------------------------------------

;Autorun.inf
autof				db "\Autorun.inf",0
auto				db "autorun",0
open				db "open",0
icon				db "icon",0
label1				db "label",0
;--------------------------------------------------------------------------------


;General==========================================================
ClassName			db 'MenuEditClass',0
AppName				db 'The Menu Builder',0
AboutMsg			db 'The Menu Builder',13,10,'Copyright © Michael Morin 2005',0

;Openfile Dialogs=================================================
FilterString 		db "Menu INI files",0,"menu.ini",0,0
FilterString1		db "All Files",0,"*.*",0
					db "Windows Icon Files (.ico)",0,"*.ico",0,0
FilterString2		db "Executable Files (.exe)",0,"*.exe",0
					db "All Files",0,"*.*",0,0
FilterString3		db ".inf",0
            
					
OpenTitle			db "Choose a menu file to load into the editor",0
OpenTitle1			db "Choose an icon to be displayed as the CD drive when the disk is inserted",0
OpenTitle2			db "Choose a program to be executed when the CD is inserted",0
OpenTitle3			db "Choose a path to save the Autorun.inf file",0
OpenTitle4			db "Choose a menu file to scan for errors.",0

;Misc.============================================================
zero                db 0
ini					db "ini",0
windtitle			db "The Menu Editor     -",0
NoFileText			db "Text Undefined in Menu.ini.",0
zero1				db "0",0
space				db "  ",0

FOLDT				db "Choose a folder to save menu.ini to.",0
FOLDT1				db "Choose a folder to save Autorun.inf to.",0
FOLDT2				db "Please select the root folder of your cd.",0
FOLDTL				db "Browse for folder...",0

adpage				db "Add New Page",0
edpage				db "Edit Page (p. ",0
rpar				db ")",0
between				db "Save page between ",0
paget				db "pages ",0
andt				db "and ",0
autot				db "Place Autorun.inf, the icon file and any other files you specified in the root directory of your cd.",0
autoc				db "Autorun Created...",0
;=================================================================

;Errors
aexistst			db "A menu file already exists in the selected folder.  Click abort to save to a different folder, retry to try to save to the specified folder again, or click ignore to edit the specified file.",0
aexistsc			db "ERROR: File already exists",0 

ptoohight			db "The page number you have chosen is too large.  Example: If your last page is page 5, you cannot create page 7 yet  --You must create page 6 first.  If you are trying to add a page, select add page from the dropdown list above.",0
ptoohighc			db "ERROR: Page value too high",0

noiniwt				db "The Menu Editor cannot write changes to the ini file.  Please make sure this file is not write protected.",0
noiniwc				db "ERROR: Cannot Write File",0

noselt				db "Please select an item on the menu at left to edit.",0
noselc				db "Error: No Item Selected",0

noptt				db "Please specify a project description",0
noptc				db "Error: No Project Description Specified",0

noinipt				db "Please specify a folder to save your project in",0
noinipc				db "ERROR: No project folder specified",0

delc				db "Delete Item?",0
delt				db "Are you sure you want to delete the selected item?",0	



;--------------------------------------------------------------------------------
;ERROR: No path specified
noptht				db "Please choose a folder to save your Autorun.inf file in",0
nopthc				db "ERROR: No path specified",0

noopt				db "Please specify a program to startup when you put your CD in a CD drive",0
noopc				db "ERROR: No path specified",0

noment				db "Please specify a Menu.ini file to check for errors",0
nomenc				db "ERROR: No path specified",0

noroott				db "Please specify the root folder of your menu.",0
norootc				db "ERROR: No path specified",0
;================================================================

;Item Positions
first				db "Frist",0
last				db "Last",0
between1			db "Between ",0
and1				db " and ",0

;================================================================
.data?
;Buffers

pagemover			db 40000 DUP (?)
pagemover1			db 40000 DUP (?)
pagemover2			db 40000 DUP (?)
pagemover3			db 40000 DUP (?)
pagemover4			db 40000 DUP (?)
pagemover5			db 40000 DUP (?)
pagemover6			db 40000 DUP (?)
pagemover7			db 40000 DUP (?)
pagess				db 4000	 DUP (?)

PositionBuffer		db 4000 DUP (?)
PositionBuffer1		db 4000 DUP (?)
PositionBuffer2		db 4000 DUP (?)
PositionBuffer3		db 4000 DUP (?)
PositionBuffer4		db 4000 DUP (?)

cpy					db 4000 DUP (?)
cpy1				db 4000 DUP (?)
cpy2				db 4000 DUP (?)
cpy3				db 4000 DUP (?)
cpy4				db 4000 DUP (?)

inipath				db 260 DUP	(?)
ProjectName			db 4000 DUP	(?)
MainBuffer			db 4000 DUP (?)
MainTitle			db 4000 DUP	(?)
DescriptionBuffer	db 4000 DUP (?)
MainBuffer1			db 4000 DUP (?)
CurrentSelection	db 4000 DUP (?)
cursel				db 4000 DUP (?)

editpage			db 4000 DUP (?)
;MoveBuffers
movebuffer			db 4000 DUP (?)
movebuffer1			db 4000 DUP (?)
movebuffer2			db 4000 DUP (?)
movebuffer3			db 4000 DUP (?)
movebuffer4			db 4000 DUP (?)
movebuffer5			db 4000 DUP (?)
movebuffer6			db 4000 DUP (?)

count				dd ?
count1				dd ?
;Structure Data
ofn					OPENFILENAME		<>
bi					BROWSEINFO			<>
it					ITEMIDLIST			<>

hInstance			dd ?
CommandLine			dd ?
hWnd				dd ?

.data

numpage				db 4000 DUP (0)
CurrentPage			db 4000 DUP (0)
ItemBuffer			db 4000 DUP (0)
ItemBuffer1			db 4000 DUP (0)
ItemBuffer2			db 4000 DUP (0)
PathBuffer			db 4000 DUP (0)
CommandBuffer		db 4000 DUP (0)