	.386
	.model flat, stdcall ;32 bit memory model
	option casemap :none ;case sensitive
	
	include MyMenu.inc
	
	.code
	
	start:
	
		invoke GetModuleHandle,NULL
	mov		hInstance,eax
	invoke GetCommandLine
	mov		CommandLine,eax
	invoke InitCommonControls
	mov		iccex.dwSize,sizeof INITCOMMONCONTROLSEX	;prepare common control structure
	mov		iccex.dwICC,ICC_DATE_CLASSES
	invoke InitCommonControlsEx,addr iccex
	invoke LoadLibrary,addr RichEditDLL
	mov		hRichEdDLL,eax
	;Show dialogbox
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,NULL,addr DlgProc,NULL
	push	eax
	invoke FreeLibrary,hRichEdDLL
	pop		eax
	invoke ExitProcess,0
	
	;########################################################################
	
	
	DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	
	mov		eax,uMsg
	.if eax==WM_INITDIALOG
	
	invoke LoadIcon,hInstance,ICO_1
	invoke SendMessage,hWin,WM_SETICON,ICON_BIG,eax
	invoke LoadIcon,hInstance,OFFSET ICO_1
	invoke SendMessage,hWin,WM_SETICON,ICON_SMALL,eax
	invoke GetDlgItem,hWin,IDC_BTN1
	invoke ShowWindow,eax,SW_HIDE
	mov ButtonShow,FALSE

mov PageBuffer,"0"
mov button2,0
	.elseif eax==WM_ACTIVATE
	retryscanforini:
	invoke GetCurrentDirectory,SIZEOF PathBuffer1,addr PathBuffer1
	invoke lstrcpy,addr PathBuffer2,addr PathBuffer1 ;buffer 2 is disposable
	invoke lstrcat,addr PathBuffer2,addr Inisuffixa ;add \*.imnu to is
	invoke FindFirstFile,addr PathBuffer2,addr wfd ;see if it exists
	.if eax==INVALID_HANDLE_VALUE ;if not
		invoke lstrcpy,addr MainBuffer1,addr nimnut ;build the error message complete with directory info
		invoke GetCurrentDirectory,SIZEOF PathBuffer2,addr PathBuffer2
		invoke lstrcat,addr MainBuffer1,addr PathBuffer2
		invoke lstrcat,addr MainBuffer1,addr nimnut2
		invoke MessageBox,hWin,addr MainBuffer1,addr nimnuc,MB_RETRYCANCEL+MB_ICONERROR
			.if eax==IDRETRY
				jmp retryscanforini 
				.elseif eax==IDCANCEL
					invoke EndDialog,hWin,0
					invoke ExitProcess,0 ;nice and clean
						.else
							
			.endif
	.endif
	
	invoke FindClose,eax
	invoke lstrcpy,addr inipath,addr PathBuffer1 ; copy the non disposable PathBuffer1 to inipath
	invoke lstrcat,addr inipath,addr slash ;add a slash
	invoke lstrcat,addr inipath,addr wfd.cFileName ;add the INI NAME

	mov eax,OFFSET FillList ;mov the proc of ReadPageData into eax
	invoke CreateThread,NULL,NULL,eax,hWin,0,addr readpthread ;create a thread because it's CPU intensive
	invoke CloseHandle,eax ;we don't need a handle
		
	invoke ReadPageData,hWin ;set all default captions and stuff for page

	;invoke FillList,hWin ;fill the item listbox

	
	.elseif eax==WM_COMMAND
		mov		eax,wParam
		mov		edx,eax
		shr		edx,16
		and		eax,0FFFFh
		
		.if edx==BN_CLICKED
		
	mov timerstop,1
			.if eax==IDC_BTN1 ;Action Button
	invoke ExecuteCommand,hWin,addr SelectionBuffer,uMsg;execute selected command
			.elseif eax==IDM_FILE_EXIT
			invoke SendMessage,hWin,WM_CLOSE,0,0
			.elseif eax==IDM_HELP_ABOUT
			invoke MessageBox,hWin,addr aboutt,addr aboutc,MB_OK+MB_ICONINFORMATION
			.elseif eax==IDM_HELP_CONTENTS
				invoke ShellExecute,hWin,NULL,addr help,NULL,NULL,SW_SHOW
			.endif
		.elseif edx==LBN_SELCHANGE ;if listbox select changes
		mov timerstop,1
		.if eax==IDC_LST1
	invoke SendDlgItemMessage,hWin,IDC_LST1,LB_GETCURSEL,0,0 ;get the selection
	invoke dwtoa,eax,addr SelectionBuffer ;move it into eax
	invoke ShowDetails,hWin,addr SelectionBuffer ;Show the description for the item
	.endif
	.elseif edx==LBN_DBLCLK
		mov timerstop,1
		.if eax==IDC_LST1
		.if dclick==1
		invoke ExecuteCommand,hWin,addr SelectionBuffer,uMsg ;execute on double click
		.endif
		.endif
				
		.endif

	
	.elseif eax==WM_SIZE ; size support?  uuh YES~!
	.if ButtonShow==TRUE
	invoke ButtonSize,hWin,FALSE
	.endif
 	mov	ecx, lParam	; Get width
 	push ecx
 and  ecx, 0ffffh  ; Lowword
 pop edx
 shr edx,16
push edx
mov size3,edx
pop windowheight
;.if size3<10
;	ret
;.endif
.if windowheight<200
	ret
.endif
push ecx
shr ecx,1
mov size1,ecx
pop windowwidth
push windowwidth
pop size5 ;width
;--------------------------------------------------------------------------------
;Size Controls
push size1
mov ecx,size1
pop size1
push ecx
add ecx,38
mov esi,ecx
push esi
invoke GetDlgItem,hWin,IDC_LST1
pop ecx
sub ecx,75
push size3
sub size3,40
invoke MoveWindow,eax,25,11,ecx,size3,TRUE
pop size3
invoke GetDlgItem,hWin,IDC_RED1
push size1
mov ecx,size1
pop size1
pop esi
sub ecx,31
push size3
sub size3,40
invoke MoveWindow,eax,esi,11,ecx,size3,TRUE
pop size3
push size3
invoke GetDlgItem,hWin,IDC_GRP1
push windowwidth
mov ecx,windowwidth
pop windowwidth
sub ecx,45
sub size3,24
invoke MoveWindow,eax,20,0,ecx,size3,TRUE
pop size3
invoke GetDlgItem,hWin,IDC_BTN1
push size1
mov ecx,size1
pop size1
pop esi
sub ecx,80
push size3
sub size3,40
invoke MoveWindow,eax,ecx,size3,145,31,TRUE
	.if ButtonShow==TRUE
	invoke ButtonSize,hWin,TRUE
	.endif



;--------------------------------------------------------------------------------

.elseif eax==WM_TIMER

	.if timerstop==0
	invoke MessageBeep,0FFFFFFFFh
	.if seconds=="0"
		invoke KillTimer,hWin,timerid
		invoke ExitProcess,0
	.else
		invoke lstrcpy,addr aftertitle,addr pretitle
		invoke lstrcat,addr aftertitle,addr timertext1
		invoke lstrcat,addr aftertitle,addr seconds
		invoke lstrcat,addr aftertitle,addr timertext2
		invoke SetWindowText,hWin,addr aftertitle
		invoke atodw,addr seconds
		dec eax
		invoke dwtoa,eax,addr seconds
		invoke SetTimer,hWin,timerid,1000,NULL
	.endif
	.else
		invoke KillTimer,NULL,timerid
		invoke SetWindowText,hWin,addr pretitle
		ret
		.endif
	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret
	
	DlgProc endp
	ExecuteCommand PROC hWin:DWORD,Index:DWORD,uMsg:UINT ;Executes the Action Attribute
		invoke RtlZeroMemory,addr Command,SIZEOF Command
		Action:
		
		.if Command==NULL
		
		invoke GetINI,addr it,addr ia,Index,0 ;get the action
		.elseif Command==1
			invoke GetINI,addr it,addr action2a,Index,0 ;get the action2
			.if IReturn==NULL
				ret
			.endif
			.else
			ret
			.endif
			
;--------------------------------------------------------------------------------
;page
;.if Command==0
;push offset PageBuffer
;pop ecx
;invoke lstrcpy,addr PageBuffer1,ecx
;.endif

		invoke IntlStrEqWorker,TRUE,addr IReturn,addr pagech,6 ;check for {PAGE}
		.if eax==TRUE ;if it exists
			mov ebx,OFFSET IReturn ;move the string containing {PAGE} into ebx
			add DWORD PTR ebx,6 ;add 6 to the pointer to ebx
			invoke lstrcpy,addr PageBuffer,ebx ;move this value into pagebuffer (its the page number)
		
		invoke ButtonSize,hWin,FALSE
		invoke lstrcpy,addr MainBuffer1,addr edt
		invoke lstrcpy,addr MainBuffer2,addr pd
		invoke lstrcat,addr MainBuffer2,addr PageBuffer
		invoke GetPrivateProfileString,addr MainBuffer2,addr MainBuffer1,NULL\
		,addr MainBuffer3,SIZEOF MainBuffer3,addr inipath
		
		.if MainBuffer3=="0"
		mov dclick,0
		.elseif MainBuffer3=="1"
		mov dclick,1
		.else
			mov dclick,0
			.endif
			
			
			invoke SendMessage,hWin,WM_ACTIVATE,0,0 ;refresh
			.if Command==1
			ret
		.endif
		ret
		.endif
		
;--------------------------------------------------------------------------------
;Mbox		
		.if Command==0
		invoke GetINI,addr it,addr ia,Index,0
		.elseif Command==1
		invoke GetINI,addr it,addr action2a,Index,0
		.else
			ret
		.endif
		invoke IntlStrEqWorker,TRUE,addr IReturn,addr window,8 	;Check for {WINDOW}
		.if eax==TRUE											;it's in the string
		;push ebx
		mov ebx,OFFSET IReturn
		add DWORD PTR ebx,8
		invoke lstrcpy,addr Caption,ebx						;Window text in PageBuffer
		;pop ebx
;-------------------
				;Get Caption
		.if Command==0
		invoke GetINI,addr it,addr windowc,Index,0
		invoke GetINI,addr it,addr windowi,Index,1
		.elseif Command==1
		invoke GetINI,addr it,addr windowc2,Index,0
		invoke GetINI,addr it,addr windowi2,Index,1
		.else
			ret
		.endif
		invoke atodw,addr IReturn1
			mov ecx,eax
			push ecx
		invoke MessageBox,hWin,addr Caption,addr IReturn,ecx
		.if Command==1
			ret
			.endif
			mov Command,1
			jmp Action
		.endif



;--------------------------------------------------------------------------------
;Execute Parameters
invoke RtlZeroMemory,addr IReturn,SIZEOF IReturn
invoke RtlZeroMemory,addr IReturn1,SIZEOF IReturn1
.if Command==1
	jmp action2
.endif

		invoke GetINI,addr it,addr ip,Index,1 ;get parameters
		invoke GetINI,addr it,addr ia,Index,0 ;get action
		.if IReturn!=NULL ;if action isn't null
		invoke ShellExecute,NULL,NULL,addr IReturn,addr IReturn1,NULL,SW_SHOWDEFAULT ;execute it
		.endif
		mov Command,1
		jmp Action
		
		action2:
		invoke GetINI,addr it,addr action2a,Index,0 ;the same for action 2
		invoke GetINI,addr it,addr ip2,Index,1
		.if IReturn!=NULL
		invoke ShellExecute,hWin,NULL,addr IReturn,addr IReturn1,NULL,SW_SHOWDEFAULT
		.endif
		
;--------------------------------------------------------------------------------
		
		invoke RtlZeroMemory,addr Command,SIZEOF Command
		ret	

	ExecuteCommand endp

	ShowDetails PROC hWin:DWORD,Index:DWORD

		invoke lstrcpy,addr MainBuffer1,addr id
		invoke lstrcat,addr MainBuffer1,Index
		invoke lstrcpy,addr MainBuffer2,addr it
		invoke lstrcat,addr MainBuffer2,addr PageBuffer
		invoke GetPrivateProfileString,addr MainBuffer2,addr MainBuffer1,NULL,addr MainBuffer3,SIZEOF MainBuffer3,addr inipath
		invoke GetDlgItem,hWin,IDC_RED1
		invoke SetWindowText,eax,addr MainBuffer3
		invoke lstrcpy,addr MainBuffer1,addr capt
		invoke lstrcat,addr MainBuffer1,Index
		invoke lstrcpy,addr MainBuffer2,addr it
		invoke lstrcat,addr MainBuffer2,addr PageBuffer
		invoke GetPrivateProfileString,addr MainBuffer2,addr MainBuffer1,NULL,addr MainBuffer3,SIZEOF MainBuffer3,addr inipath
		.if MainBuffer3!=NULL
			mov ButtonShow,TRUE
			invoke ButtonSize,hWin,TRUE
			invoke SetDlgItemText,hWin,IDC_BTN1,addr MainBuffer3
		.else
			.if ButtonShow==TRUE
			mov ButtonShow,FALSE
			invoke ButtonSize,hWin,FALSE
			.endif
		.endif
		
		invoke lstrcpy,addr MainBuffer1,addr edt
		invoke lstrcpy,addr MainBuffer2,addr pd
		invoke lstrcat,addr MainBuffer2,addr PageBuffer
		invoke GetPrivateProfileString,addr MainBuffer2,addr MainBuffer1,NULL,addr MainBuffer3,SIZEOF MainBuffer3,addr inipath
		.if MainBuffer3=="0"
		mov dclick,0
		.elseif MainBuffer3=="1"
		mov dclick,1
		.else
			mov dclick,0
			.endif
		ret

	ShowDetails endp
	GetINI PROC Section:DWORD,Key:DWORD,SIndex:DWORD,RBuffer:DWORD

		invoke lstrcpy,addr MainBuffer1,Section
		invoke lstrcat,addr MainBuffer1,addr PageBuffer
		
		invoke lstrcpy,addr MainBuffer2,Key
		invoke lstrcat,addr MainBuffer2,SIndex
		
		.if RBuffer==0
		invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer2,NULL,\
		addr IReturn,SIZEOF IReturn,addr inipath
		.else
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer2,NULL,\
		addr IReturn1,SIZEOF IReturn1,addr inipath
		.ENDIF
		

		ret

	GetINI endp
	
	
	ReadPageData PROC hWin:DWORD
	
	invoke lstrcpy,addr PageRead,addr pd
	invoke lstrcat,addr PageRead,addr PageBuffer
	invoke GetPrivateProfileString,addr PageRead,addr pdt,NULL,addr PageRead1,SIZEOF PageRead1,addr inipath
	Invoke SetWindowText,hWin,addr PageRead1
	
	invoke GetPrivateProfileString,addr timerdatapage,addr timerdata,NULL,addr seconds,SIZEOF seconds,addr inipath
	invoke atodw,addr seconds
	.if eax > 0
		invoke lstrcpy,addr pretitle,addr PageRead1
		invoke SetTimer,hWin,timerid,1000,NULL
	.endif

	invoke lstrcpy,addr PageRead,addr pd
	invoke lstrcat,addr PageRead,addr PageBuffer
	invoke GetPrivateProfileString,addr PageRead,addr capt,NULL,addr PageRead1,SIZEOF PageRead1,addr inipath
	.if PageRead1!=NULL
		invoke ButtonSize,hWin,TRUE
		mov ButtonShow,TRUE
	.else
	.if ButtonShow==TRUE
		invoke ButtonSize,hWin,FALSE
		mov ButtonShow,FALSE
	.endif
		
	.endif
	
	invoke lstrcpy,addr PageRead,addr pd
	invoke lstrcat,addr PageRead,addr PageBuffer
	invoke GetPrivateProfileString,addr PageRead,addr id,NULL,addr PageRead1,SIZEOF PageRead1,addr inipath
	invoke GetDlgItem,hWin,IDC_RED1
	invoke SetWindowText,eax,addr PageRead1
	
	
	ret
	
	ReadPageData endp
	StreamInProc proc hFile:DWORD,pBuffer:DWORD, NumBytes:DWORD, pBytesRead:DWORD
	invoke ReadFile,hFile,pBuffer,NumBytes,pBytesRead,0
	xor eax,1
	ret
	StreamInProc endp
	
	FillList PROC hWin:DWORD

	invoke SendDlgItemMessage,hWin,IDC_LST1,LB_RESETCONTENT,0,0 ;Clear the listbox
invoke GetDlgItem,hWin,IDC_LST1 ;Get listbox handle
mov hList2,eax ;move it into hList2
mov ItemBuffer,"0" ;Start Itembuffer at 0
invoke RtlZeroMemory,addr MainBuffer4,SIZEOF MainBuffer4;Clear the previous largest
	FillLoop:

	invoke lstrcpy,addr MainBuffer2,addr it ;get the item (#=ItemBuffer)
	invoke lstrcat,addr MainBuffer2,addr PageBuffer
	invoke lstrcpy,addr MainBuffer1,addr itm
	invoke lstrcat,addr MainBuffer1,addr ItemBuffer
	invoke GetPrivateProfileString,addr MainBuffer2,addr MainBuffer1,NULL\
	,addr MainBuffer3,SIZEOF MainBuffer3,addr inipath

	.if MainBuffer3!=NULL;If the item exists
	invoke SendDlgItemMessage,hWin,IDC_LST1,LB_ADDSTRING,0,addr MainBuffer3 ;add it
	


	invoke lstrlen,addr MainBuffer3 ;get the length of the string added
	mov edx,eax
	invoke lstrlen,addr MainBuffer4 ;and the previous length
	
	.if edx>eax ;If the Current is larger than the previous (buffer4), 
		invoke lstrcpy,addr MainBuffer4,addr MainBuffer3;move the current into MainBuffer4
		invoke RtlZeroMemory,addr MainBuffer3,SIZEOF MainBuffer3;Clear the previous
;--------------------------------------------------------------------------------
;Horizantal bar procedure	
invoke GetDC,hList2
mov 	hDC,eax
invoke SendMessage,hList2, WM_GETFONT,0,0
invoke SelectObject,hDC, eax

invoke lstrlen,addr MainBuffer4
invoke DrawText,hDC,addr MainBuffer4,eax,addr rcText, DT_CALCRECT

invoke GetSystemMetrics,SM_CXVSCROLL
add eax,rcText.right
mov ecx,eax
invoke SendDlgItemMessage,hWin,IDC_LST1,LB_SETHORIZONTALEXTENT,ecx,0
invoke ReleaseDC,hWin,hDC
	.endif
;--------------------------------------------------------------------------------
	
	;inc ItemBuffer 
	
	invoke atodw,addr ItemBuffer;Increment the item buffer  The long way... the one that works
	inc eax
	invoke dwtoa,eax,addr ItemBuffer
	jmp FillLoop ;Jump to the top
	.endif


	
	ret ;If the item doesn't exist end here.
	
	FillList endp
	ButtonSize PROC hWin:DWORD,BtnShow:DWORD
	
		LOCAL button1:DWORD
		LOCAL buttonstate:DWORD
		LOCAL buttonstate1:DWORD

			;.if button2==0
			;mov button2,1
			
.if BtnShow==TRUE
	jmp ShowButton
	.elseif BtnShow==FALSE
		jmp HideButton
		.else
			jmp UseBuffer
			.endif
	UseBuffer:
.if ButtonShow==TRUE
	ShowButton:
			invoke GetDlgItem,hWin,IDC_LST1
			push eax
			invoke GetWindowRect,eax,addr rect
		mov edx, rect.right
		mov ecx, rect.left
		sub edx,ecx
		mov ecx,edx
		push ecx
		mov edx, rect.bottom
		mov ecx, rect.top
		sub edx,ecx
		mov Buffer,edx
		sub Buffer,24
pop ecx
		pop button1
		invoke SetWindowPos,button1,HWND_TOP,1,1,ecx,Buffer,SWP_NOMOVE

		
		
		invoke GetDlgItem,hWin,IDC_GRP1
			push eax
			invoke GetWindowRect,eax,addr rect
		mov edx, rect.right
		mov ecx, rect.left
		sub edx,ecx
		mov ecx,edx
		push ecx
		mov edx, rect.bottom
		mov ecx, rect.top
		sub edx,ecx
		mov Buffer,edx
		sub Buffer,24
pop ecx
		pop button1
		invoke SetWindowPos,button1,HWND_TOP,1,1,ecx,Buffer,SWP_NOMOVE
	
	
	invoke GetDlgItem,hWin,IDC_RED1
			push eax
			invoke GetWindowRect,eax,addr rect
		mov edx, rect.right
		mov ecx, rect.left
		sub edx,ecx
		mov ecx,edx
		push ecx
		mov edx, rect.bottom
		mov ecx, rect.top
		sub edx,ecx
		mov Buffer,edx
		sub Buffer,24
pop ecx
		pop button1
		invoke SetWindowPos,button1,HWND_TOP,1,1,ecx,Buffer,SWP_NOMOVE
		
		invoke GetDlgItem,hWin,IDC_BTN1
		invoke ShowWindow,eax,SW_SHOW
		ret
;--------------------------------------------------------------------------------
	;.endif
		.else
		HideButton:
		invoke GetDlgItem,hWin,IDC_LST1
			push eax
			invoke GetWindowRect,eax,addr rect
		mov edx, rect.right
		mov ecx, rect.left
		sub edx,ecx
		mov ecx,edx
		push ecx
		mov edx, rect.bottom
		mov ecx, rect.top
		sub edx,ecx
		mov Buffer,edx
		add Buffer,24
pop ecx
		pop button1
		invoke SetWindowPos,button1,HWND_TOP,1,1,ecx,Buffer,SWP_NOMOVE
		
		invoke GetDlgItem,hWin,IDC_GRP1
			push eax
			invoke GetWindowRect,eax,addr rect
		mov edx, rect.right
		mov ecx, rect.left
		sub edx,ecx
		mov ecx,edx
		push ecx
		mov edx, rect.bottom
		mov ecx, rect.top
		sub edx,ecx
		mov Buffer,edx
		add Buffer,24
pop ecx
		pop button1
		invoke SetWindowPos,button1,HWND_TOP,1,1,ecx,Buffer,SWP_NOMOVE
	
	
	invoke GetDlgItem,hWin,IDC_RED1
			push eax
			invoke GetWindowRect,eax,addr rect
		mov edx, rect.right
		mov ecx, rect.left
		sub edx,ecx
		mov ecx,edx
		push ecx
		mov edx, rect.bottom
		mov ecx, rect.top
		sub edx,ecx
		mov Buffer,edx
		add Buffer,24
pop ecx
		pop button1
		invoke SetWindowPos,button1,HWND_TOP,1,1,ecx,Buffer,SWP_NOMOVE
		invoke GetDlgItem,hWin,IDC_BTN1
		invoke ShowWindow,eax,SW_HIDE
				ret
.endif
		ret

	ButtonSize endp

	
	end start
