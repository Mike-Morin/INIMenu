.386
.model flat,stdcall
option casemap:none

include Menu Editor.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov	hInstance,eax
	invoke GetCommandLine
	invoke InitCommonControls
	mov		CommandLine,eax
	invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	invoke ExitProcess,eax

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL	wc:WNDCLASSEX
	LOCAL	msg:MSG
	
	mov		wc.cbSize,sizeof WNDCLASSEX
	mov		wc.style,CS_HREDRAW or CS_VREDRAW
	mov		wc.lpfnWndProc,offset WndProc
	mov		wc.cbClsExtra,NULL
	mov		wc.cbWndExtra,DLGWINDOWEXTRA
	push	hInst
	pop		wc.hInstance
	mov		wc.hbrBackground,COLOR_BTNFACE+1
	mov		wc.lpszMenuName,IDM_MENU
	mov		wc.lpszClassName,offset ClassName
	invoke LoadIcon,hInstance,offset ICO_1
	mov		wc.hIcon,eax
	mov		wc.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov		wc.hCursor,eax
	invoke RegisterClassEx,addr wc
	invoke CreateDialogParam,hInstance,IDD_DIALOG,NULL,addr WndProc,NULL
	invoke ShowWindow,hWnd,SW_SHOWNORMAL
	invoke UpdateWindow,hWnd
	.while TRUE
		invoke GetMessage,addr msg,NULL,0,0
	  .BREAK .if !eax
		invoke TranslateMessage,addr msg
		invoke DispatchMessage,addr msg
	.endw
	
	mov		eax,msg.wParam
	ret

WinMain endp

WndProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM



	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		push	hWin
		pop		hWnd
		
	
		
		mov CurrentPage,"1"
	
		.elseif eax==WM_ACTIVATE
			jmp focus
		.elseif eax==WM_SETFOCUS
focus:
	
		
	.if inipath==0
		invoke GetDlgItem,hWin,IDC_LST1
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hWin,IDC_EDT1
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hWin,IDC_BTN5
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hWin,IDC_BTN8
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hWin,IDC_BTN12
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hWin,IDC_BTN7
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hWin,IDC_BTN11
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hWin,IDC_BTN6
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hWin,IDC_BTN8
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hWin,IDC_BTN1
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hWin,IDC_BTN10
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hWin,IDC_BTN13
		invoke ShowWindow,eax,TRUE
		.else
		
		invoke GetPrivateProfileString,addr paged,addr pages,NULL,addr numpage,SIZEOF numpage,addr inipath
		.endif
		
		.if inipath!=0
		.if numpage!=0

		invoke GetDlgItem,hWin,IDC_BTN1
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hWin,IDC_LST1
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hWin,IDC_EDT1
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hWin,IDC_BTN5
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hWin,IDC_BTN8
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hWin,IDC_BTN12
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hWin,IDC_BTN7
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hWin,IDC_BTN11
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hWin,IDC_BTN6
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hWin,IDC_BTN8
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hWin,IDC_BTN10
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hWin,IDC_BTN13
		invoke ShowWindow,eax,FALSE

	;===================================================================
	; Set button states (no Page data)	++++++++++++++++++++++++++++++++++++++++++++++++

			;Previous Button	=========================
			.if numpage!="0"
			.if CurrentPage!="1"
			invoke GetDlgItem,hWin,IDC_BTN5
			invoke EnableWindow,eax,TRUE
			invoke GetPrivateProfileString,addr paged,addr ppage,addr NoFileButton,addr MainBuffer,sizeof MainBuffer,addr inipath
			invoke SetDlgItemText,hWin,IDC_BTN5,addr MainBuffer
			invoke RtlZeroMemory,addr MainBuffer,SIZEOF MainBuffer
			.elseif CurrentPage=="1"
			invoke SetDlgItemText,hWin,IDC_BTN5,addr zero
			invoke GetDlgItem,hWin,IDC_BTN5
			invoke EnableWindow,eax,FALSE
			invoke SetDlgItemText,hWin,IDC_BTN5,addr zero
			.endif
			.endif
			;============================================
			;Next Button	=============================
			.if numpage!="0"
			invoke lstrcmp,addr numpage,addr CurrentPage
			.if eax!=NULL
			invoke GetPrivateProfileString,addr paged,addr npage,addr NoFileButton,addr MainBuffer,sizeof MainBuffer,addr inipath
			invoke GetDlgItem,hWin,IDC_BTN12
			invoke EnableWindow,eax,TRUE
			invoke SetDlgItemText,hWin,IDC_BTN12,addr MainBuffer
			invoke RtlZeroMemory,addr MainBuffer,SIZEOF MainBuffer
			.else
				invoke SetDlgItemText,hWin,IDC_BTN12,addr zero
				invoke GetDlgItem,hWin,IDC_BTN12
			invoke EnableWindow,eax,FALSE
			.endif
			.endif
			
			;============================================
			;Command Button	=============================
			invoke GetDlgItem,hWin,IDC_BTN8
			invoke ShowWindow,eax,FALSE
			;============================================
	;END BUTTONSTATES	++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;--------------------------------------------------------------------------------
	
		; Set Window Title
			invoke lstrcpy,addr MainBuffer1,addr inter
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr wintitle
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr ItemBuffer2,SIZEOF ItemBuffer2,addr inipath
			invoke lstrcpy,addr movebuffer1,addr mainn
			invoke lstrcat,addr movebuffer1,addr ItemBuffer2
			invoke SendMessage,hWnd,WM_SETTEXT,0,addr movebuffer1
		
		
		
;--------------------------------------------------------------------------------
		
		; Add Menu Items (PAGE DATA)++++++++++++++++++++++++++++++++++++++++++++++++
	
			;Set Default Text for page ==================
				invoke lstrcpy,addr MainBuffer,addr desc
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke GetPrivateProfileString,addr MainBuffer,addr defdesc,addr NoFileText,addr DescriptionBuffer,SIZEOF DescriptionBuffer,addr inipath
			.if DescriptionBuffer=="0"
			invoke SetDlgItemText,hWin,IDC_EDT1,addr zero
			.endif
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke SetDlgItemText,hWin,IDC_EDT1,addr DescriptionBuffer
			invoke RtlZeroMemory,addr DescriptionBuffer,SIZEOF DescriptionBuffer
			;============================================
			;Set Default Command Button State for Page	=
			invoke lstrcpy,addr MainBuffer,addr bcaps
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke GetPrivateProfileString,addr MainBuffer,addr bdef,addr NoFileButton,addr DescriptionBuffer,SIZEOF DescriptionBuffer,addr inipath
			.if DescriptionBuffer=="0"
			invoke SetDlgItemText,hWin,IDC_BTN8,addr zero
			invoke GetDlgItem,hWin,IDC_BTN8
			invoke ShowWindow,eax,FALSE
			.else
			invoke GetDlgItem,hWin,IDC_BTN8
			invoke ShowWindow,eax,TRUE
			invoke SetDlgItemText,hWin,IDC_BTN8,addr DescriptionBuffer
			.endif
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,addr DescriptionBuffer,SIZEOF DescriptionBuffer
			;============================================
					invoke SendDlgItemMessage,hWin,IDC_LST1,LB_RESETCONTENT,0,0			
			;Add Menu Items	=============================
			invoke lstrcpy,addr MainBuffer,addr items
			invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke GetPrivateProfileString,addr MainBuffer,addr number,NULL,addr ItemBuffer, SIZEOF ItemBuffer,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			mov ItemBuffer1,"0"
			
			
			;Start the loop
			Addstrings1:
			
			
			invoke lstrcpy,addr MainBuffer1,addr items
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr ItemBuffer1
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr ItemBuffer2,SIZEOF ItemBuffer2,addr inipath
			.if ItemBuffer2==NULL
			jmp out1
			.endif
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			invoke lstrcpy,addr DescriptionBuffer,addr ItemBuffer1
			invoke lstrcat,addr DescriptionBuffer,addr space
			invoke lstrcat,addr DescriptionBuffer,addr ItemBuffer2
			
			invoke SendDlgItemMessage,hWin,IDC_LST1,LB_ADDSTRING,0,addr DescriptionBuffer
			invoke RtlZeroMemory,ADDR ItemBuffer2,SIZEOF ItemBuffer2
			invoke atodw,addr ItemBuffer1
			inc eax
			invoke dwtoa,eax,addr ItemBuffer1
			invoke lstrcmp,addr ItemBuffer,addr ItemBuffer1
			.if eax==0
				jmp out1
				.else
					jmp Addstrings1
			.endif
			
			out1:
			invoke RtlZeroMemory,ADDR ItemBuffer,SIZEOF ItemBuffer
			invoke RtlZeroMemory,ADDR ItemBuffer1,SIZEOF ItemBuffer1
			invoke RtlZeroMemory,ADDR ItemBuffer2,SIZEOF ItemBuffer2
			;End the loop
			
			
			;============================================
	; END Add Menu Items (PAGE DATA)++++++++++++++++++++++++++++++++++++++++++++

		.elseif numpage==0
		invoke RtlZeroMemory,addr inipath,SIZEOF inipath
		invoke MessageBox,hWin,addr notinit,addr notinic,MB_OK + MB_ICONERROR
		ret
		.endif
			.endif
			
	
	
	invoke atodw,addr CurrentSelection
	invoke SendDlgItemMessage,hWnd,IDC_LST1,LB_SETCURSEL,eax,0

	.elseif eax==WM_COMMAND
		mov		eax,wParam
		and		eax,0FFFFh
		
		;EDITOR ONLY +++++++++++++++++++++++++++++++++++++
		
		.if eax==IDC_BTN13
		shr eax,16
		.if ax==BN_CLICKED
		invoke RtlZeroMemory,addr ofn,SIZEOF ofn
			mov ofn.lStructSize,SIZEOF ofn
	    push hWnd
	    pop  ofn.hwndOwner
	    push hInstance
	    pop  ofn.hInstance
	    mov  ofn.lpstrFilter, OFFSET FilterString
	    mov  ofn.lpstrFile, OFFSET inipath
	    mov  ofn.nMaxFile,260
	    mov  ofn.Flags, OFN_FILEMUSTEXIST or \
		OFN_PATHMUSTEXIST or OFN_LONGNAMES or\
		OFN_EXPLORER
	    mov  ofn.lpstrTitle, OFFSET OpenTitle
	    invoke GetOpenFileName, ADDR ofn
	    invoke SendMessage,hWin,WM_SETFOCUS,0,0
		.endif
		.endif
		
		.if eax==IDM_OPEN
		invoke RtlZeroMemory,addr ofn,SIZEOF ofn
			mov ofn.lStructSize,SIZEOF ofn
	    push hWnd
	    pop  ofn.hwndOwner
	    push hInstance
	    pop  ofn.hInstance
	    mov  ofn.lpstrFilter, OFFSET FilterString
	    mov  ofn.lpstrFile, OFFSET inipath
	    mov  ofn.nMaxFile,260
	    mov  ofn.Flags, OFN_FILEMUSTEXIST or \
		OFN_PATHMUSTEXIST or OFN_LONGNAMES or\
		OFN_EXPLORER
	    mov  ofn.lpstrTitle, OFFSET OpenTitle
	   
	    invoke GetOpenFileName, ADDR ofn
	    invoke SendMessage,hWin,WM_SETFOCUS,0,0
		.endif
		
		.if eax==IDM_Chkp
			shr eax,16
			.if ax==BN_CLICKED
				invoke DialogBoxParam,NULL,IDD_DLG8,NULL,addr ChkMen,SW_SHOWDEFAULT
			.endif
		.endif
		
		.if eax==IDC_BTN10
		shr eax,16
		.if ax==BN_CLICKED
			invoke DialogBoxParam,hInstance,IDD_DLG2,hWnd,addr NewMenu,SW_SHOWDEFAULT
		.endif
		.endif
		
		.if eax==IDC_BTN6
			shr eax,16
			.if ax==BN_CLICKED
			invoke DialogBoxParam,NULL,IDD_DLG5,NULL,addr AddItem,SW_SHOWDEFAULT
			.endif
		.endif
		
		.if eax==IDC_BTN11
			shr eax,16
			.if ax==BN_CLICKED
			invoke DialogBoxParam,hInstance,IDD_DLG1,hWnd,addr PageEdit,SW_SHOWDEFAULT
			.endif
		.endif
		
		.if eax==IDM_Auto
			invoke DialogBoxParam,NULL,IDD_DLG7,NULL,addr Autorun,SW_SHOWDEFAULT
		.endif
		
		.if eax==IDM_NM
			invoke DialogBoxParam,hInstance,IDD_DLG2,hWnd,addr NewMenu,SW_SHOWDEFAULT
		.endif
		
		.if eax==IDC_BTN7
			shr eax,16
			.if ax==BN_CLICKED
				invoke SendDlgItemMessage,hWin,IDC_LST1,LB_GETCURSEL,0,0
				.if eax==LB_ERR
					invoke MessageBox,NULL,addr noselt,addr noselc,MB_OK + MB_ICONERROR
				.else
				invoke dwtoa,eax,addr CurrentSelection
				invoke DialogBoxParam,NULL,IDD_DLG3,NULL,EditItem,SW_SHOWDEFAULT
				.endif
			.endif
		.endif

.if eax==IDM_FILE_EXIT
			invoke SendMessage,hWin,WM_CLOSE,0,0
.elseif eax==IDM_HELP_ABOUT
			invoke ShellAbout,hWin,addr AppName,addr AboutMsg,NULL
.endif

.if eax==IDC_BTN1
	shr eax,16
	.if ax==BN_CLICKED
		invoke SendDlgItemMessage,hWin,IDC_LST1,LB_GETCURSEL,0,0
		.if eax==LB_ERR
					invoke MessageBox,NULL,addr noselt,addr noselc,MB_OK + MB_ICONERROR
				.else
				invoke dwtoa,eax,addr PositionBuffer3
		invoke MessageBox,hWnd,addr delt,addr delc,MB_ICONQUESTION	+ MB_OKCANCEL
		.if eax==IDCANCEL
			ret
			.elseif eax==IDOK
			
;--------------------------------------------------------------------------------
;Setup Loop1
invoke RtlZeroMemory,addr movebuffer,SIZEOF movebuffer

			invoke lstrcpy,addr movebuffer,addr CurrentSelection
			invoke lstrcpy,addr MainBuffer,addr items
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr number
			invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr movebuffer3,SIZEOF movebuffer3,addr inipath
			
			invoke atodw,addr movebuffer3
			sub eax,1
			invoke dwtoa,eax,addr movebuffer3
			
			invoke lstrcpy,addr MainBuffer,addr items
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr number
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,addr movebuffer3,addr inipath


			
			invoke SendMessage,hWnd,WM_SETFOCUS,0,0
			invoke SendDlgItemMessage,hWin,IDC_LST1,LB_GETCOUNT,0,0
			invoke dwtoa,eax,addr count
			
			
			invoke lstrcmp,addr CurrentSelection,addr count
			.if eax==0
			invoke lstrcpy,addr movebuffer,addr CurrentSelection
			invoke lstrcpy,addr MainBuffer,addr items
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr Item
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr inipath
			invoke lstrcpy,addr MainBuffer,addr desc
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr predesc
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr inipath
			invoke lstrcpy,addr MainBuffer,addr paths
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr pathd
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr inipath
			invoke lstrcpy,addr MainBuffer,addr bcaps
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr bcap
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr inipath
			invoke lstrcpy,addr MainBuffer,addr coms
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr com
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr inipath
			
			invoke SendMessage,hWnd,WM_SETFOCUS,0,0
			invoke RtlZeroMemory,addr count,SIZEOF count
			invoke RtlZeroMemory,addr movebuffer,SIZEOF movebuffer
			invoke SendDlgItemMessage,hWin,IDC_LST1,LB_GETCOUNT,0,0
			invoke dwtoa,eax,addr count
			ret
			.endif
			

			invoke lstrcpy,addr movebuffer,addr CurrentSelection
			invoke atodw,addr movebuffer
			ADD eax,1
			invoke dwtoa,eax,addr movebuffer
			jmp deli
			.endif
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
			
			deli:
			invoke SendMessage,hWnd,WM_SETFOCUS,0,0
			invoke SendDlgItemMessage,hWin,IDC_LST1,LB_GETCOUNT,0,0
			invoke dwtoa,eax,addr count
			
			
     		invoke lstrcpy,addr MainBuffer,addr items
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr Item
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr cpy,SIZEOF cpy,addr inipath
			invoke lstrcpy,addr MainBuffer,addr desc
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr predesc
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr cpy1,SIZEOF cpy,addr inipath
			invoke lstrcpy,addr MainBuffer,addr paths
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr pathd
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr cpy2,SIZEOF cpy,addr inipath
			invoke lstrcpy,addr MainBuffer,addr bcaps
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr bcap
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr cpy3,SIZEOF cpy,addr inipath
			invoke lstrcpy,addr MainBuffer,addr coms
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr com
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr cpy4,SIZEOF cpy,addr inipath
			
			
			invoke atodw,addr movebuffer
			sub eax,1
			invoke dwtoa,eax,addr movebuffer
			
			
			invoke lstrcpy,addr MainBuffer,addr items
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr Item
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,addr cpy,addr inipath
			invoke lstrcpy,addr MainBuffer,addr desc
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr predesc
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,addr cpy1,addr inipath
			invoke lstrcpy,addr MainBuffer,addr paths
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr pathd
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,addr cpy2,addr inipath
			invoke lstrcpy,addr MainBuffer,addr bcaps
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr bcap
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,addr cpy3,addr inipath
			invoke lstrcpy,addr MainBuffer,addr coms
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr com
			invoke lstrcat,addr MainBuffer1,ADDR movebuffer
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,addr cpy4,addr inipath
			
			invoke SendMessage,hWnd,WM_SETFOCUS,0,0
			invoke SendDlgItemMessage,hWin,IDC_LST1,LB_GETCOUNT,0,0
			invoke dwtoa,eax,addr count
			
			
			
			
;--------------------------------------------------------------------------------
;invoke MessageBox,NULL,addr movebuffer,addr count,MB_OK
			invoke lstrcmp,addr movebuffer,addr count
			.if eax!=0
			invoke atodw,addr movebuffer
			add eax,2
			invoke dwtoa,eax,addr movebuffer
				jmp deli
.else
			;invoke RtlZeroMemory,addr count,SIZEOF count
			invoke RtlZeroMemory,addr movebuffer,SIZEOF movebuffer
			invoke SendMessage,hWnd,WM_SETFOCUS,0,0
			invoke SendDlgItemMessage,hWin,IDC_LST1,LB_GETCOUNT,0,0
			invoke dwtoa,eax,addr count
			
			
			invoke lstrcpy,addr MainBuffer,addr items
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr Item
			invoke lstrcat,addr MainBuffer1,ADDR count
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr inipath
			invoke lstrcpy,addr MainBuffer,addr desc
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr predesc
			invoke lstrcat,addr MainBuffer1,ADDR count
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr inipath
			invoke lstrcpy,addr MainBuffer,addr paths
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr pathd
			invoke lstrcat,addr MainBuffer1,ADDR count
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr inipath
			invoke lstrcpy,addr MainBuffer,addr bcaps
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr bcap
			invoke lstrcat,addr MainBuffer1,ADDR count
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr inipath
			invoke lstrcpy,addr MainBuffer,addr coms
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke lstrcpy,addr MainBuffer1,addr com
			invoke lstrcat,addr MainBuffer1,ADDR count
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr inipath
			
;--------------------------------------------------------------------------------
		
			.endif
			
			
;--------------------------------------------------------------------------------
				
		
		.endif
	.endif
.endif

;END EDITOR ONLY ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;##################################################################################################



;The Button actions		++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;NEXT	====================================	
     .if eax==IDC_BTN12
     	shr eax,16
     	.if ax==BN_CLICKED
     		      invoke SendDlgItemMessage,hWin,IDC_LST1,LB_RESETCONTENT,0,0
	    	invoke SetDlgItemText,hWin,IDC_EDT1,addr zero
	    	invoke GetDlgItem,hWin,IDC_BTN8
	    	invoke ShowWindow,eax,FALSE
	    	invoke SetDlgItemText,hWin,IDC_BTN8,addr zero
     	invoke atodw,addr CurrentPage
     		inc eax
     	invoke dwtoa,eax,addr CurrentPage
     		invoke SendMessage,hWin,WM_SETFOCUS,0,0
     	.endif
     .endif
     		;============================================
     		;Previous	=================================
     .if eax==IDC_BTN5
     	shr eax,16
     	.if ax==BN_CLICKED
     		      invoke SendDlgItemMessage,hWin,IDC_LST1,LB_RESETCONTENT,0,0
	    	invoke SetDlgItemText,hWin,IDC_EDT1,addr zero
	    	invoke GetDlgItem,hWin,IDC_BTN8
	    	invoke ShowWindow,eax,FALSE
	    	invoke SetDlgItemText,hWin,IDC_BTN8,addr zero
     	invoke atodw,addr CurrentPage
     	dec eax
     	invoke dwtoa,eax,addr CurrentPage
     			invoke SendMessage,hWin,WM_SETFOCUS,0,0
     	.endif
     .endif
     		;============================================
     		;Command	=================================
     		
     		.if eax==IDC_BTN8
	    	shr eax,16
	    	.if ax==BN_CLICKED
     		.if PathBuffer!=0
	    		invoke ShellExecute,NULL,NULL,addr PathBuffer,addr CommandBuffer,NULL,SW_SHOWDEFAULT
	    		.endif
	    	.endif
	    .endif
     		;============================================
     ;END The Button actions		++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     ;LISTBOX ACTIONS				++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     .if eax==IDC_LST1
     	shr eax,16
     	.if ax==BN_CLICKED
     		invoke SendDlgItemMessage,hWin,IDC_LST1,LB_GETCURSEL,0,0
     		.if eax!=LB_ERR
     		invoke dwtoa,eax,addr CurrentSelection
     		.if eax==NULL
     		mov eax,0
     		invoke atodw,addr CurrentSelection
     		.endif
     		
     		;Set Command Button Caption=================
     		invoke lstrcpy,addr MainBuffer1,addr bcap
			invoke lstrcat,addr MainBuffer1,ADDR CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr bcaps
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,ADDR DescriptionBuffer,SIZEOF DescriptionBuffer,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			.if DescriptionBuffer!="0"
			invoke GetDlgItem,hWin,IDC_BTN8
			invoke ShowWindow,eax,TRUE
			invoke EnableWindow,eax,TRUE
			.endif
			invoke SetDlgItemText,hWin,IDC_BTN8,addr DescriptionBuffer
			invoke RtlZeroMemory,addr MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,addr MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr DescriptionBuffer,SIZEOF DescriptionBuffer
     		;============================================
     		;Set Command Path	=========================
     		invoke lstrcpy,addr MainBuffer1,addr pathd
			invoke lstrcat,addr MainBuffer1,addr CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr paths
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr PathBuffer,SIZEOF PathBuffer,addr inipath
			invoke RtlZeroMemory,addr MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,addr MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr DescriptionBuffer,SIZEOF DescriptionBuffer
     		;============================================
     		;Set Command...Command	=====================
     		invoke lstrcpy,addr MainBuffer1,addr com
			invoke lstrcat,addr MainBuffer1,addr CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr coms
		invoke lstrcat,addr MainBuffer,addr CurrentPage
     		invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr CommandBuffer,SIZEOF CommandBuffer,addr inipath
     		invoke RtlZeroMemory,addr MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,addr MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr DescriptionBuffer,SIZEOF DescriptionBuffer
     		;============================================
     		;Set Description	=========================
     		invoke lstrcpy,addr MainBuffer1,addr predesc
			invoke lstrcat,addr MainBuffer1,addr CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr desc
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,ADDR DescriptionBuffer,SIZEOF DescriptionBuffer,addr inipath
			invoke SetDlgItemText,hWin,IDC_EDT1,ADDR DescriptionBuffer
     		invoke RtlZeroMemory,addr MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,addr MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr DescriptionBuffer,SIZEOF DescriptionBuffer
     		;============================================
     		.endif
     	.endif
	.endif
     ;END LISTBOX ACTIONS			++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




;END Command Data	##########################################################################################################	
	.elseif eax==WM_CLOSE
		invoke DestroyWindow,hWin
	.elseif uMsg==WM_DESTROY
		invoke PostQuitMessage,NULL
	.else
		invoke DefWindowProc,hWin,uMsg,wParam,lParam
		ret
	.endif
	xor	eax,eax
	ret

WndProc endp

NewMenu proc hNew:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM


mov	eax,uMsg
	.if eax==WM_INITDIALOG

	

	.elseif eax==WM_COMMAND
		mov		eax,wParam
		and		eax,0FFFFh
		
		.if eax==IDC_BTN3
		shr eax,16
		.if ax==BN_CLICKED
			invoke BrowseForFolder,hNew,ADDR MainBuffer,addr FOLDTL,addr FOLDT
			.if MainBuffer!=0
			invoke lstrcat,addr MainBuffer,addr ininame
			invoke SetDlgItemText,hNew,IDC_EDT7,addr MainBuffer
 			.endif
	       
		.endif
		.endif
		
		.if eax==IDC_BTN4
		shr eax,16
		.if ax==BN_CLICKED
			invoke GetDlgItemText,hNew,IDC_EDT6,addr ProjectName,sizeof ProjectName
			invoke GetDlgItemText,hNew,IDC_EDT7,addr inipath,SIZEOF inipath
			.if ProjectName!=0
			.if inipath!=0
			invoke lstrcpy,addr MainBuffer,addr windtitle
			invoke lstrcat,addr MainBuffer,addr ProjectName
			invoke lstrcpy,addr MainTitle,addr MainBuffer
			invoke SendMessage,hWnd,WM_GETTEXT,40000,OFFSET MainBuffer1
			invoke SendMessage,hWnd,WM_SETTEXT,0,OFFSET MainTitle
			.endif
			.else 	
			invoke MessageBox,hNew,addr noptt,addr noptc,MB_OK + MB_ICONERROR
			ret
			.endif
			.if inipath!=0
			.if ProjectName!=0
			retry1:
			INVOKE CreateFile,addr inipath,NULL, NULL, NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL
			.if eax==INVALID_HANDLE_VALUE
				invoke MessageBox,hNew,addr aexistst,addr aexistsc,MB_ABORTRETRYIGNORE + MB_ICONERROR
				.if eax==IDABORT
				invoke RtlZeroMemory,addr inipath,SIZEOF inipath
				invoke SendMessage,hWnd,WM_SETTEXT,0,OFFSET MainBuffer1
				ret
				.elseif eax==IDRETRY
				jmp retry1
				.endif
			.endif
			invoke WritePrivateProfileString,addr paged,addr pages,addr one,addr inipath
			invoke SetFocus,hWnd
			invoke DestroyWindow,hNew
			.endif
			.elseif inipath==0
				invoke MessageBox,hNew,addr noinipt,addr noinipc,MB_OK + MB_ICONERROR
				ret
				.endif
			.endif
		.endif
	      
		
.elseif eax==WM_CLOSE
invoke SetFocus,hWnd
invoke EndDialog,hNew,0


	.ELSE
		MOV		EAX,FALSE
		RET
			
	.ENDIF
	MOV		EAX,TRUE
	RET
	
	
NewMenu endp

PageEdit proc hadpg:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM


mov		eax,uMsg
	

	.if eax==WM_INITDIALOG
	.if movebuffer==NULL
		invoke GetDlgItem,hadpg,IDC_EDT2
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_EDT2
		
		invoke GetDlgItem,hadpg,IDC_STC3
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_STC3
		
		invoke GetDlgItem,hadpg,IDC_STC4
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_STC4
		
		invoke GetDlgItem,hadpg,IDC_EDT3
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_EDT3
		
		invoke GetDlgItem,hadpg,IDC_STC5
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_STC5
		
		invoke GetDlgItem,hadpg,IDC_EDT4
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_EDT4
		
		invoke GetDlgItem,hadpg,IDC_BTN2
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_BTN2
		
		invoke GetDlgItem,hadpg,IDC_STC13
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_STC13
		
		invoke GetDlgItem,hadpg,IDC_EDT13
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_EDT13
		
		invoke GetDlgItem,hadpg,IDC_STC21
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_STC21
		
		invoke GetDlgItem,hadpg,IDC_STC22
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_STC22
		
		invoke GetDlgItem,hadpg,IDC_BTN14
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_BTN14
		

			
;		invoke GetDlgItem,hadpg,IDC_BTN15
;		invoke ShowWindow,eax,FALSE
;		invoke GetDlgItem,hadpg,IDC_BTN15
		
		invoke GetDlgItem,hadpg,IDC_GRP2
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_GRP2
		
		invoke SetWindowPos,hadpg,HWND_TOP,1,1,367,133,SWP_NOMOVE
		
		.else
		invoke GetDlgItem,hadpg,IDC_BTN15
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_BTN15
		
		invoke GetDlgItem,hadpg,IDC_BTN16
		invoke ShowWindow,eax,FALSE
		invoke GetDlgItem,hadpg,IDC_BTN16
		
		invoke GetDlgItem,hadpg,IDC_EDT2
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_EDT2
		
		invoke GetDlgItem,hadpg,IDC_STC3
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_STC3
		
		invoke GetDlgItem,hadpg,IDC_STC4
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_STC4
		
		invoke GetDlgItem,hadpg,IDC_EDT3
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_EDT3
		
		invoke GetDlgItem,hadpg,IDC_STC5
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_STC5
		
		invoke GetDlgItem,hadpg,IDC_EDT4
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_EDT4
		
		invoke GetDlgItem,hadpg,IDC_BTN2
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_BTN2
		
		invoke GetDlgItem,hadpg,IDC_STC13
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_STC13
		
		invoke GetDlgItem,hadpg,IDC_EDT13
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_EDT13
		
		invoke GetDlgItem,hadpg,IDC_STC21
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_STC21
		
		invoke GetDlgItem,hadpg,IDC_STC22
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_STC22	
		
		invoke GetDlgItem,hadpg,IDC_BTN14
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_BTN14
		

	
		invoke GetDlgItem,hadpg,IDC_GRP2
		invoke ShowWindow,eax,TRUE
		invoke GetDlgItem,hadpg,IDC_GRP2
		
		invoke SetWindowPos,hadpg,HWND_TOP,1,1,370,493,SWP_NOMOVE
	


		
;initialize page dropdown...


mov eax,2
invoke dwtoa,eax,addr movebuffer
invoke SendDlgItemMessage,hadpg,IDC_CBO2,CB_RESETCONTENT,0,0
	invoke lstrcpy,addr MainBuffer1,addr inter
			invoke lstrcat,addr MainBuffer1,addr movebuffer
			invoke lstrcpy,addr MainBuffer,addr wintitle
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1,addr inipath
.if movebuffer1==NULL
					invoke GetDlgItem,hadpg,IDC_CBO2
					invoke EnableWindow,eax,FALSE
					jmp end111
				.endif	

		mov eax,1
	invoke dwtoa,eax,addr movebuffer
		invoke lstrcpy,addr MainBuffer1,addr paged
		invoke lstrcpy,addr MainBuffer,addr pages
		invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer4,SIZEOF movebuffer4,addr inipath
			invoke lstrcpy,addr MainBuffer1,addr inter
			invoke lstrcat,addr MainBuffer1,addr movebuffer
			invoke lstrcpy,addr MainBuffer,addr wintitle
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1,addr inipath
				.if movebuffer1==NULL
					invoke GetDlgItem,hadpg,IDC_CBO2
					invoke EnableWindow,eax,FALSE
					jmp end111
				.endif	
				
			invoke SendDlgItemMessage,hadpg,IDC_CBO2,CB_ADDSTRING,0,addr first
			invoke RtlZeroMemory,addr movebuffer5,SIZEOF movebuffer5
			
			place1:
			invoke lstrcmp,addr movebuffer,addr movebuffer4
			.if eax==0
				invoke SendDlgItemMessage,hadpg,IDC_CBO2,CB_ADDSTRING,0,addr last
				jmp done11
			.endif
			
			invoke lstrcpy,addr MainBuffer1,addr inter
			invoke lstrcat,addr MainBuffer1,addr movebuffer
			invoke lstrcpy,addr MainBuffer,addr wintitle
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1,addr inipath
				.if movebuffer1==NULL
				
					jmp end111
				.endif	
				
			invoke atodw,addr movebuffer
			add eax,2
			invoke dwtoa,eax,addr movebuffer
			
		invoke lstrcpy,addr MainBuffer1,addr items
			invoke lstrcpy,addr MainBuffer1,addr inter
			invoke lstrcat,addr MainBuffer1,addr movebuffer
			invoke lstrcpy,addr MainBuffer,addr wintitle
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer2,SIZEOF movebuffer2,addr inipath
				.if movebuffer1==NULL
					jmp end111
				.endif	
			invoke lstrcpy,addr movebuffer3,addr between1
			invoke lstrcat,addr movebuffer3,addr movebuffer1
			invoke lstrcat,addr movebuffer3,addr and1
			invoke lstrcat,addr movebuffer3,addr movebuffer2
			invoke SendDlgItemMessage,hadpg,IDC_CBO2,CB_ADDSTRING,0,addr movebuffer3

			
			
			
			
				
			invoke lstrcmp,addr movebuffer,addr movebuffer4
			.if eax==0
			done11:
				invoke SendDlgItemMessage,hadpg,IDC_CBO2,CB_ADDSTRING,0,addr last
				
				invoke GetDlgItem,hadpg,IDC_CBO2
				jmp end111
			.else
			invoke atodw,addr movebuffer
			sub eax,1
			invoke dwtoa,eax,addr movebuffer
			
		jmp place1
			.endif




end111:
invoke atodw,addr editpage
sub eax,1
invoke SendDlgItemMessage,hadpg,IDC_CBO2,CB_SETCURSEL,eax,0

;--------------------------------------------------------------------------------




; fill in Title
invoke lstrcpy,addr MainBuffer,addr inter
invoke lstrcat,addr MainBuffer,addr editpage
invoke GetPrivateProfileString,addr MainBuffer,addr wintitle,addr NoFileText,addr DescriptionBuffer,SIZEOF DescriptionBuffer,addr inipath
invoke SetDlgItemText,hadpg,IDC_EDT4,Addr DescriptionBuffer
;Fill in Text
invoke lstrcpy,addr MainBuffer,addr desc
invoke lstrcat,addr MainBuffer,addr editpage
invoke GetPrivateProfileString,addr MainBuffer,addr defdesc,addr NoFileText,addr DescriptionBuffer,SIZEOF DescriptionBuffer,addr inipath
invoke SetDlgItemText,hadpg,IDC_EDT2,Addr DescriptionBuffer
;Fill in Button Text
invoke lstrcpy,addr MainBuffer,addr bcaps
invoke lstrcat,addr MainBuffer,addr editpage
invoke GetPrivateProfileString,addr MainBuffer,addr bdef,NULL,addr DescriptionBuffer,SIZEOF DescriptionBuffer,addr inipath
invoke SetDlgItemText,hadpg,IDC_EDT3,Addr DescriptionBuffer
;Fill in button command
invoke lstrcpy,addr MainBuffer,addr defcom
invoke lstrcat,addr MainBuffer,addr editpage
invoke lstrcpy,addr MainBuffer1,addr coms
invoke lstrcat,addr MainBuffer1,addr editpage
invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,addr zero1,addr CommandBuffer,SIZEOF CommandBuffer,addr inipath
invoke SetDlgItemText,hadpg,IDC_EDT13,Addr CommandBuffer
;Fill in page number
invoke atodw,addr editpage
			invoke SendDlgItemMessage,hadpg,IDC_CBO1,CB_SETCURSEL,eax,0
.endif





	.elseif eax==WM_COMMAND
		mov		eax,wParam
		and		eax,0FFFFh
		
.if eax==IDC_BTN14
shr eax,16
.if ax==BN_CLICKED
invoke SetFocus,hWnd
invoke RtlZeroMemory,addr editpage,SIZEOF editpage
	invoke EndDialog,hadpg,0
.endif
.endif

.if eax==IDC_BTN15
shr eax,16
.if ax==BN_CLICKED
invoke EndDialog,hadpg,0
	invoke DialogBoxParam,hInstance,IDD_DLG6,hWnd,addr PageList,NULL
	
	.endif
	
.endif

.if eax==IDC_BTN2
shr eax,16
.if ax==BN_CLICKED
	;yaaaaaawn...
	
	;edit or add....?
	
	
;--------------------------------------------------------------------------------
;Edit Current Page
EditP:
	;Error Check
invoke lstrcpy,addr MainBuffer1,addr paged
invoke lstrcpy,addr MainBuffer,addr pages
invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,ADDR movebuffer,SIZEOF movebuffer,addr inipath

invoke lstrcpy,addr pagess,addr movebuffer
invoke SendDlgItemMessage,hadpg,IDC_CBO2,CB_GETCURSEL,0,0
			invoke dwtoa,eax,addr movebuffer1
			
invoke lstrcmp,addr movebuffer,addr movebuffer1
.if eax==-1

invoke GetDlgItem,hadpg,IDC_CBO2
invoke IsWindowEnabled,eax
.if eax==0

invoke lstrcpy,addr movebuffer1,addr editpage
.else
invoke MessageBox,hadpg,addr ptoohight,addr ptoohighc,MB_OK
ret
.endif
.endif
	
	;save the title
	
	invoke GetDlgItemText,hadpg,IDC_EDT4,Addr DescriptionBuffer,SIZEOF DescriptionBuffer
	invoke lstrcpy,addr MainBuffer,addr inter
	invoke lstrcat,addr MainBuffer,addr movebuffer
	invoke WritePrivateProfileString,addr MainBuffer,addr wintitle,ADDR DescriptionBuffer,addr inipath
	
	; save the darn default text
	
	invoke GetDlgItemText,hadpg,IDC_EDT2,Addr DescriptionBuffer,SIZEOF DescriptionBuffer
	invoke lstrcpy,addr MainBuffer,addr desc
	invoke lstrcat,addr MainBuffer,addr movebuffer
	invoke WritePrivateProfileString,addr MainBuffer,addr defdesc,ADDR DescriptionBuffer,addr inipath
	
	;save the button text
	
invoke GetDlgItemText,hadpg,IDC_EDT3,Addr DescriptionBuffer,SIZEOF DescriptionBuffer
invoke lstrcpy,addr MainBuffer,addr bcaps
invoke lstrcat,addr MainBuffer,addr movebuffer
invoke WritePrivateProfileString,addr MainBuffer,addr bdef,ADDR DescriptionBuffer,addr inipath

	;save the button command
	
invoke GetDlgItemText,hadpg,IDC_EDT13,Addr DescriptionBuffer,SIZEOF DescriptionBuffer
invoke lstrcpy,addr MainBuffer,addr defcom
invoke lstrcpy,addr MainBuffer1,addr coms
invoke lstrcat,addr MainBuffer1,addr movebuffer
invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,ADDR DescriptionBuffer,addr inipath
	
	; Save the page number
	;set up loop

invoke GetPrivateProfileSection,addr paged,Addr pagemover,SIZEOF pagemover,addr inipath
invoke lstrcpy,addr MainBuffer,addr inter
invoke lstrcat,addr MainBuffer,addr movebuffer
invoke GetPrivateProfileSection,addr MainBuffer,Addr pagemover1,SIZEOF pagemover1,addr inipath
invoke lstrcpy,addr MainBuffer,addr items
invoke lstrcat,addr MainBuffer,addr movebuffer
invoke GetPrivateProfileSection,addr MainBuffer,Addr pagemover2,SIZEOF pagemover2,addr inipath	
invoke lstrcpy,addr MainBuffer,addr desc
invoke lstrcat,addr MainBuffer,addr movebuffer
invoke GetPrivateProfileSection,addr MainBuffer,Addr pagemover3,SIZEOF pagemover2,addr inipath		
invoke lstrcpy,addr MainBuffer,addr paths
invoke lstrcat,addr MainBuffer,addr movebuffer
invoke GetPrivateProfileSection,addr MainBuffer,Addr pagemover4,SIZEOF pagemover2,addr inipath		
invoke lstrcpy,addr MainBuffer,addr bcaps
invoke lstrcat,addr MainBuffer,addr movebuffer
invoke GetPrivateProfileSection,addr MainBuffer,Addr pagemover5,SIZEOF pagemover2,addr inipath		
invoke lstrcpy,addr MainBuffer,addr coms
invoke lstrcat,addr MainBuffer,addr movebuffer
invoke GetPrivateProfileSection,addr MainBuffer,Addr pagemover6,SIZEOF pagemover2,addr inipath
invoke lstrcpy,addr pagemover7,addr movebuffer

invoke atodw,addr pagemover7
	add eax,1
invoke dwtoa,eax,addr pagemover7







	;Done with edits=====
	invoke SetFocus,hWnd
	invoke RtlZeroMemory,addr movebuffer,SIZEOF movebuffer
invoke EndDialog,hadpg,0
;--------------------------------------------------------------------------------
	NewP:
	
	
	
	
.endif
.endif


.elseif eax==WM_CLOSE
		invoke SetFocus,hWnd
invoke RtlZeroMemory,addr movebuffer,SIZEOF movebuffer
	invoke EndDialog,hadpg,0
		
	.ELSE
		MOV		EAX,FALSE
		RET
			
	.ENDIF
	MOV		EAX,TRUE
	RET






PageEdit endp


EditItem	PROC	hEdit:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

mov		eax,uMsg
	.if eax==WM_INITDIALOG
	;initialize item placement list
	invoke SendDlgItemMessage,hEdit,IDC_CBO1,CB_RESETCONTENT,0,0
		mov eax,0
	invoke dwtoa,eax,addr movebuffer
		invoke lstrcpy,addr MainBuffer1,addr items
		invoke lstrcat,addr MainBuffer1,addr CurrentPage
		invoke lstrcpy,addr MainBuffer,addr number
		invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer4,SIZEOF movebuffer4,addr inipath
			invoke lstrcpy,addr MainBuffer1,addr items
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr movebuffer
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1,addr inipath
				.if movebuffer1==NULL
					invoke GetDlgItem,hEdit,IDC_CBO1
					invoke ShowWindow,eax,FALSE
					jmp end11
				.endif	
				
			invoke SendDlgItemMessage,hEdit,IDC_CBO1,CB_ADDSTRING,0,addr first
			invoke RtlZeroMemory,addr movebuffer5,SIZEOF movebuffer5
			place:
			invoke lstrcmp,addr movebuffer,addr movebuffer4
			.if eax==0
				invoke SendDlgItemMessage,hEdit,IDC_CBO1,CB_ADDSTRING,0,addr last
				jmp end11
			.endif
				invoke lstrcpy,addr MainBuffer1,addr items
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr movebuffer
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1,addr inipath
				.if movebuffer1==NULL
					jmp end11
				.endif	
			invoke atodw,addr movebuffer
			add eax,2
			invoke dwtoa,eax,addr movebuffer
			
			invoke lstrcmp,addr movebuffer,addr movebuffer4
			.if eax==0
				invoke SendDlgItemMessage,hEdit,IDC_CBO1,CB_ADDSTRING,0,addr last
				jmp end11
			.endif
			
		invoke lstrcpy,addr MainBuffer1,addr items
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr movebuffer
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer2,SIZEOF movebuffer2,addr inipath
				.if movebuffer1==NULL
					jmp done1
				.endif	
			invoke lstrcpy,addr movebuffer3,addr between1
			invoke lstrcat,addr movebuffer3,addr movebuffer1
			invoke lstrcat,addr movebuffer3,addr and1
			invoke lstrcat,addr movebuffer3,addr movebuffer2
			
			invoke atodw,addr movebuffer5
			add eax,20
			invoke dwtoa,eax,addr movebuffer5
			
			
			invoke SendDlgItemMessage,hEdit,IDC_CBO1,CB_ADDSTRING,0,addr movebuffer3
				
			invoke lstrcmp,addr movebuffer,addr movebuffer4
			.if eax==0
			done1:
				invoke SendDlgItemMessage,hEdit,IDC_CBO1,CB_ADDSTRING,0,addr last
				
				invoke GetDlgItem,hEdit,IDC_CBO1
				invoke SetWindowPos,eax,HWND_NOTOPMOST,5,5,300,500,NULL
				jmp end11
			.else
			invoke atodw,addr movebuffer
			sub eax,1
			invoke dwtoa,eax,addr movebuffer
			
		jmp place
			.endif
			
			end11:
			;Command Button	------
			invoke lstrcpy,addr MainBuffer1,addr bcap
			invoke lstrcat,addr MainBuffer1,ADDR CurrentSelection
    		invoke lstrcpy,addr MainBuffer,addr bcaps
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,ADDR DescriptionBuffer,SIZEOF DescriptionBuffer,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			
			invoke SetDlgItemText,hEdit,IDC_EDT11,addr DescriptionBuffer
			invoke RtlZeroMemory,addr MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,addr MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr DescriptionBuffer,SIZEOF DescriptionBuffer
			;----------------------
			;Path
			
			invoke SetDlgItemText,hEdit,IDC_EDT9,addr PathBuffer
	
			;----------------------
			;Command
			
			invoke lstrcpy,addr MainBuffer1,addr com
			invoke lstrcat,addr MainBuffer1,addr CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr coms
		invoke lstrcat,addr MainBuffer,addr CurrentPage
     		invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr CommandBuffer,SIZEOF CommandBuffer,addr inipath
     		invoke SetDlgItemText,hEdit,IDC_EDT12,addr CommandBuffer
     		invoke RtlZeroMemory,addr MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,addr MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr DescriptionBuffer,SIZEOF DescriptionBuffer
			
			;----------------------
			;Description
			
			invoke lstrcpy,addr MainBuffer1,addr predesc
			invoke lstrcat,addr MainBuffer1,addr CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr desc
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,ADDR DescriptionBuffer,SIZEOF DescriptionBuffer,addr inipath
			invoke SetDlgItemText,hEdit,IDC_EDT8,ADDR DescriptionBuffer
     		invoke RtlZeroMemory,addr MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,addr MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr DescriptionBuffer,SIZEOF DescriptionBuffer
			
			;-----------------------
			;Position
			invoke atodw,addr CurrentSelection
			invoke SendDlgItemMessage,hEdit,IDC_CBO1,CB_SETCURSEL,eax,0
			
			;-----------------------
			;Name
			
			invoke lstrcpy,addr MainBuffer1,addr items
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr CurrentSelection
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr ItemBuffer2,SIZEOF ItemBuffer2,addr inipath
			invoke SetDlgItemText,hEdit,IDC_EDT5,addr ItemBuffer2
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr ItemBuffer2,SIZEOF ItemBuffer2
			invoke GetDlgItemText,hEdit,IDC_EDT5,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke SendMessage,hWnd,WM_SETFOCUS,0,0
			invoke lstrcpy,addr movebuffer1,addr Edit
			invoke lstrcat,addr movebuffer1,addr ItemBuffer1
			invoke SendMessage,hEdit,WM_SETTEXT,0,addr movebuffer1
		

.elseif eax==WM_COMMAND
		mov		eax,wParam
		and		eax,0FFFFh
		
	.if eax==IDC_BTN9
		shr eax,16
		.if ax==BN_CLICKED
savedata:

			;SaveItemName	-------------------------------------
			invoke GetDlgItemText,hEdit,IDC_EDT5,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr movebuffer1,addr ItemBuffer1
			invoke lstrcat,addr movebuffer1,addr Edit
			invoke SendMessage,hEdit,WM_SETTEXT,addr movebuffer1,0
			invoke lstrcpy,addr MainBuffer1,addr items
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr CurrentSelection
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr ItemBuffer1,addr inipath
			.if eax==0
				invoke MessageBox,hWnd,addr noiniwt,addr noiniwc,MB_RETRYCANCEL + MB_ICONERROR
				.if eax==IDRETRY
					jmp savedata
					.else
					
				.endif
			.endif
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr ItemBuffer1,SIZEOF ItemBuffer1
			;-----------------------------------------------------
			;SaveCaption
			invoke GetDlgItemText,hEdit,IDC_EDT11,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr bcap
			invoke lstrcat,addr MainBuffer1,ADDR CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr bcaps
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,ADDR ItemBuffer1,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr ItemBuffer1,SIZEOF ItemBuffer1
			;------------------------------------------------------
			;SavePath
			invoke GetDlgItemText,hEdit,IDC_EDT9,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr pathd
			invoke lstrcat,addr MainBuffer1,addr CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr paths
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,addr ItemBuffer1,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr ItemBuffer1,SIZEOF ItemBuffer1
			;------------------------------------------------------
			;save command
			invoke GetDlgItemText,hEdit,IDC_EDT12,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr com
			invoke lstrcat,addr MainBuffer1,addr CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr coms
		invoke lstrcat,addr MainBuffer,addr CurrentPage
     		invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,addr ItemBuffer1,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr ItemBuffer1,SIZEOF ItemBuffer1
			;-------------------------------------------------------
			;Save Description
			invoke GetDlgItemText,hEdit,IDC_EDT8,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr predesc
			invoke lstrcat,addr MainBuffer1,addr CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr desc
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,ADDR ItemBuffer1,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr ItemBuffer1,SIZEOF ItemBuffer1
			;-------------------------------------------------------
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
			
			;Positions
			invoke SendDlgItemMessage,hEdit,IDC_CBO1,CB_GETCURSEL,0,0
			invoke dwtoa,eax,addr PositionBuffer
			invoke lstrcmp,addr PositionBuffer,addr CurrentSelection
			.if eax==0
			invoke DestroyWindow,hEdit
				ret
			.endif
			.if eax==-1
			invoke SendDlgItemMessage,hWnd,IDC_LST1,LB_GETCOUNT,0,0
			sub eax,1
			invoke dwtoa,eax,addr count
				invoke lstrcpy,addr MainBuffer1,addr items
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr CurrentSelection
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr PositionBuffer2,SIZEOF PositionBuffer2 ,addr inipath
				invoke lstrcpy,addr movebuffer,addr CurrentSelection
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
			up:		
				invoke lstrcpy,addr MainBuffer1,addr items
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer			
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke atodw,addr movebuffer
				sub eax,2
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcmp,addr movebuffer,addr PositionBuffer
				.if eax==0
				invoke lstrcpy,addr MainBuffer1,addr items
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr PositionBuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr PositionBuffer2,addr inipath
					invoke DestroyWindow,hEdit
					invoke SendMessage,hWnd,WM_SETFOCUS,0,0
					.else
					jmp up
					.endif
					
				invoke lstrcpy,addr MainBuffer1,addr desc
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr predesc
				invoke lstrcat,addr MainBuffer,addr CurrentSelection
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr PositionBuffer2,SIZEOF PositionBuffer2 ,addr inipath
				invoke lstrcpy,addr movebuffer,addr CurrentSelection
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
			updes:		
				invoke lstrcpy,addr MainBuffer1,addr desc
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr predesc
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer			
				invoke lstrcpy,addr MainBuffer,addr predesc
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke atodw,addr movebuffer
				sub eax,2
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcmp,addr movebuffer,addr PositionBuffer
				.if eax==0
				invoke lstrcpy,addr MainBuffer1,addr desc
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr predesc
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr predesc
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke lstrcpy,addr MainBuffer,addr predesc
				invoke lstrcat,addr MainBuffer,addr PositionBuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr PositionBuffer2,addr inipath
					invoke DestroyWindow,hEdit
					invoke SendMessage,hWnd,WM_SETFOCUS,0,0
					.else
					jmp updes
					.endif
					
				invoke lstrcpy,addr MainBuffer1,addr paths
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr pathd
				invoke lstrcat,addr MainBuffer,addr CurrentSelection
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr PositionBuffer2,SIZEOF PositionBuffer2 ,addr inipath
				invoke lstrcpy,addr movebuffer,addr CurrentSelection
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
			uppth:		
				invoke lstrcpy,addr MainBuffer1,addr paths
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr pathd
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer			
				invoke lstrcpy,addr MainBuffer,addr pathd
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke atodw,addr movebuffer
				sub eax,2
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcmp,addr movebuffer,addr PositionBuffer
				.if eax==0
				invoke lstrcpy,addr MainBuffer1,addr paths
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr pathd
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr pathd
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke lstrcpy,addr MainBuffer,addr pathd
				invoke lstrcat,addr MainBuffer,addr PositionBuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr PositionBuffer2,addr inipath
					invoke DestroyWindow,hEdit
					invoke SendMessage,hWnd,WM_SETFOCUS,0,0
					.else
					jmp uppth
					.endif
					
					
					
					invoke lstrcpy,addr MainBuffer1,addr bcaps
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr bcap
				invoke lstrcat,addr MainBuffer,addr CurrentSelection
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr PositionBuffer2,SIZEOF PositionBuffer2 ,addr inipath
				invoke lstrcpy,addr movebuffer,addr CurrentSelection
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
			upbtn:		
				invoke lstrcpy,addr MainBuffer1,addr bcaps
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr bcap
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer			
				invoke lstrcpy,addr MainBuffer,addr bcap
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke atodw,addr movebuffer
				sub eax,2
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcmp,addr movebuffer,addr PositionBuffer
				.if eax==0
				invoke lstrcpy,addr MainBuffer1,addr bcaps
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr bcap
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr bcap
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke lstrcpy,addr MainBuffer,addr bcap
				invoke lstrcat,addr MainBuffer,addr PositionBuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr PositionBuffer2,addr inipath
					invoke DestroyWindow,hEdit
					invoke SendMessage,hWnd,WM_SETFOCUS,0,0
					.else
					jmp upbtn
					.endif
					
					
					
				invoke lstrcpy,addr MainBuffer1,addr coms
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr com
				invoke lstrcat,addr MainBuffer,addr CurrentSelection
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr PositionBuffer2,SIZEOF PositionBuffer2 ,addr inipath
				invoke lstrcpy,addr movebuffer,addr CurrentSelection
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
			upcom:		
				invoke lstrcpy,addr MainBuffer1,addr coms
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr com
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer			
				invoke lstrcpy,addr MainBuffer,addr com
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke atodw,addr movebuffer
				sub eax,2
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcmp,addr movebuffer,addr PositionBuffer
				.if eax==0
				invoke lstrcpy,addr MainBuffer1,addr coms
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr com
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr com
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke lstrcpy,addr MainBuffer,addr com
				invoke lstrcat,addr MainBuffer,addr PositionBuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr PositionBuffer2,addr inipath
					invoke DestroyWindow,hEdit
					invoke SendMessage,hWnd,WM_SETFOCUS,0,0
					.else
					jmp upcom
					.endif
					
					
;--------------------------------------------------------------------------------

			;-------------------------------------------------------
		.else
				invoke lstrcpy,addr MainBuffer1,addr items
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr CurrentSelection
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr PositionBuffer2,SIZEOF PositionBuffer2 ,addr inipath
				invoke lstrcpy,addr movebuffer,addr CurrentSelection
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer
			down:		
				invoke lstrcpy,addr MainBuffer1,addr items
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke atodw,addr movebuffer
				add eax,2
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcmp,addr movebuffer,addr PositionBuffer
				.if eax==0
				invoke lstrcpy,addr MainBuffer1,addr items
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr PositionBuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr PositionBuffer2,addr inipath
					invoke DestroyWindow,hEdit
					invoke SendMessage,hWnd,WM_SETFOCUS,0,0
					.else
					jmp down
					.endif

				invoke lstrcpy,addr MainBuffer1,addr desc
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr predesc
				invoke lstrcat,addr MainBuffer,addr CurrentSelection
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr PositionBuffer2,SIZEOF PositionBuffer2 ,addr inipath
				invoke lstrcpy,addr movebuffer,addr CurrentSelection
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer
			
			downdes:	
			
				invoke lstrcpy,addr MainBuffer1,addr desc
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr predesc
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr predesc
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke atodw,addr movebuffer
				add eax,2
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcmp,addr movebuffer,addr PositionBuffer
				.if eax==0
				invoke lstrcpy,addr MainBuffer1,addr desc
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr predesc
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr predesc
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke lstrcpy,addr MainBuffer,addr predesc
				invoke lstrcat,addr MainBuffer,addr PositionBuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr PositionBuffer2,addr inipath
					invoke DestroyWindow,hEdit
					invoke SendMessage,hWnd,WM_SETFOCUS,0,0
					.else
					jmp downdes
					.endif
					
					
				invoke lstrcpy,addr MainBuffer1,addr paths
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr pathd
				invoke lstrcat,addr MainBuffer,addr CurrentSelection
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr PositionBuffer2,SIZEOF PositionBuffer2 ,addr inipath
				invoke lstrcpy,addr movebuffer,addr CurrentSelection
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer
			downpth:		
				invoke lstrcpy,addr MainBuffer1,addr paths
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr pathd
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr pathd
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke atodw,addr movebuffer
				add eax,2
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcmp,addr movebuffer,addr PositionBuffer
				.if eax==0
				invoke lstrcpy,addr MainBuffer1,addr paths
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr pathd
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr pathd
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke lstrcpy,addr MainBuffer,addr pathd
				invoke lstrcat,addr MainBuffer,addr PositionBuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr PositionBuffer2,addr inipath
					invoke DestroyWindow,hEdit
					invoke SendMessage,hWnd,WM_SETFOCUS,0,0
					.else
					jmp downpth
					.endif
				
				invoke lstrcpy,addr MainBuffer1,addr bcaps
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr bcap
				invoke lstrcat,addr MainBuffer,addr CurrentSelection
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr PositionBuffer2,SIZEOF PositionBuffer2 ,addr inipath
				invoke lstrcpy,addr movebuffer,addr CurrentSelection
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer
			downbtn:		
				invoke lstrcpy,addr MainBuffer1,addr bcaps
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr bcap
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr bcap
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke atodw,addr movebuffer
				add eax,2
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcmp,addr movebuffer,addr PositionBuffer
				.if eax==0
				invoke lstrcpy,addr MainBuffer1,addr bcaps
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr bcap
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr bcap
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke lstrcpy,addr MainBuffer,addr bcap
				invoke lstrcat,addr MainBuffer,addr PositionBuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr PositionBuffer2,addr inipath
					invoke DestroyWindow,hEdit
					invoke SendMessage,hWnd,WM_SETFOCUS,0,0
					.else
					jmp downbtn
					.endif
					
				invoke lstrcpy,addr MainBuffer1,addr coms
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr com
				invoke lstrcat,addr MainBuffer,addr CurrentSelection
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr PositionBuffer2,SIZEOF PositionBuffer2 ,addr inipath
				invoke lstrcpy,addr movebuffer,addr CurrentSelection
				invoke atodw,addr movebuffer
				add eax,1
				invoke dwtoa,eax,addr movebuffer
			downcom:		
				invoke lstrcpy,addr MainBuffer1,addr coms
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr com
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath

				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr com
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke atodw,addr movebuffer
				add eax,2
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcmp,addr movebuffer,addr PositionBuffer
				.if eax==0
				invoke lstrcpy,addr MainBuffer1,addr coms
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr com
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer
				sub eax,1
				invoke dwtoa,eax,addr movebuffer
				invoke lstrcpy,addr MainBuffer,addr com
				invoke lstrcat,addr MainBuffer,addr movebuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer1,addr inipath
				invoke lstrcpy,addr MainBuffer,addr com
				invoke lstrcat,addr MainBuffer,addr PositionBuffer
				invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr PositionBuffer2,addr inipath
					invoke DestroyWindow,hEdit
					invoke SendMessage,hWnd,WM_SETFOCUS,0,0
					.else
					jmp downcom
					.endif	
;--------------------------------------------------------------------------------
;GASP!!!!....gasp.... gasp..... /faint/
					
				.endif
			

			invoke DestroyWindow,hEdit
			invoke SendMessage,hWnd,WM_SETFOCUS,0,0
			invoke SendDlgItemMessage,hWnd,IDC_LST1,LB_SETCURSEL,addr CurrentSelection,0
			
		.endif
	.endif
	
	.if eax==IDC_BTN17
		shr eax,16
		.if ax==BN_CLICKED
			invoke DestroyWindow,hEdit
			invoke SendMessage,hWnd,WM_SETFOCUS,0,0
			invoke SendDlgItemMessage,hWnd,IDC_LST1,LB_SETCURSEL,addr CurrentSelection,0
		.endif
		
	.endif
	

	
.elseif eax==WM_CLOSE
		invoke DestroyWindow,hEdit
		invoke SendDlgItemMessage,hWnd,IDC_LST1,LB_SETCURSEL,addr CurrentSelection,0
		invoke SendMessage,hWnd,WM_SETFOCUS,0,0
	.ELSE
		MOV		EAX,FALSE
		RET
			
	.ENDIF
	MOV		EAX,TRUE
	RET
	
EditItem endp

AddItem	PROC	hAdd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

mov		eax,uMsg
	.if eax==WM_INITDIALOG
	


	.elseif eax==WM_COMMAND
		mov		eax,wParam
		and		eax,0FFFFh
		
		.if eax==IDC_BTN20
			shr eax,16
			.if ax==BN_CLICKED
			
			savedata2:
				invoke GetDlgItemText,hAdd,IDC_EDT25,addr PositionBuffer,SIZEOF PositionBuffer
				invoke lstrcpy,addr MainBuffer1,addr items
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr number
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer1,SIZEOF movebuffer1 ,addr inipath
				invoke atodw,addr movebuffer1
				add eax,1
				invoke dwtoa,eax,addr movebuffer1
				invoke WritePrivateProfileString,addr MainBuffer1,addr number,addr movebuffer1,addr inipath
				.if eax==0
				invoke MessageBox,hWnd,addr noiniwt,addr noiniwc,MB_RETRYCANCEL
				.if eax==IDRETRY
					jmp savedata2
				.endif
			.endif
;--------------------------------------------------------------------------------
				invoke lstrcpy,addr MainBuffer1,addr items
				invoke lstrcat,addr MainBuffer1,addr CurrentPage
				invoke lstrcpy,addr MainBuffer,addr Item
				invoke lstrcat,addr MainBuffer,addr PositionBuffer
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer,SIZEOF movebuffer ,addr inipath
				.if movebuffer!=NULL
					jmp loops
				.endif
				;SaveItemName	-------------------------------------
			invoke GetDlgItemText,hAdd,IDC_EDT20,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr items
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr PositionBuffer
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr ItemBuffer1,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr ItemBuffer1,SIZEOF ItemBuffer1
			;-----------------------------------------------------
			;SaveCaption
			invoke GetDlgItemText,hAdd,IDC_EDT21,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr bcap
			invoke lstrcat,addr MainBuffer1,ADDR PositionBuffer
     		invoke lstrcpy,addr MainBuffer,addr bcaps
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,ADDR ItemBuffer1,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr ItemBuffer1,SIZEOF ItemBuffer1
			;------------------------------------------------------
			;SavePath
			invoke GetDlgItemText,hAdd,IDC_EDT22,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr pathd
			invoke lstrcat,addr MainBuffer1,addr PositionBuffer
     		invoke lstrcpy,addr MainBuffer,addr paths
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,addr ItemBuffer1,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr ItemBuffer1,SIZEOF ItemBuffer1
			;------------------------------------------------------
			;save command
			invoke GetDlgItemText,hAdd,IDC_EDT23,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr com
			invoke lstrcat,addr MainBuffer1,addr PositionBuffer
     		invoke lstrcpy,addr MainBuffer,addr coms
		invoke lstrcat,addr MainBuffer,addr CurrentPage
     		invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,addr ItemBuffer1,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr ItemBuffer1,SIZEOF ItemBuffer1
			;-------------------------------------------------------
			;Save Description
			invoke GetDlgItemText,hAdd,IDC_EDT24,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr predesc
			invoke lstrcat,addr MainBuffer1,addr PositionBuffer
     		invoke lstrcpy,addr MainBuffer,addr desc
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke WritePrivateProfileString,addr MainBuffer,addr MainBuffer1,ADDR ItemBuffer1,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke DestroyWindow,hAdd
			invoke SetFocus,hWnd
			ret
			;-------------------------------------------------------
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
			loops:
			invoke lstrcpy,addr MainBuffer1,addr items
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr PositionBuffer
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer4,SIZEOF movebuffer4 ,addr inipath
			invoke SendDlgItemMessage,hWnd,IDC_LST1,LB_GETCOUNT,0,0
			sub eax,1
			invoke dwtoa,eax,addr count
			invoke lstrcpy,addr movebuffer2,addr count
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr count	
			insi:
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer3,SIZEOF movebuffer3 ,addr inipath
				invoke atodw,addr movebuffer2
				add eax,1
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr movebuffer2
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer3,addr inipath
				invoke atodw,addr movebuffer2
				sub eax,2
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr movebuffer2	
;--------------------------------------------------------------------------------
			
				invoke lstrcmp,addr movebuffer2,addr PositionBuffer
				.if eax==0
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer3,SIZEOF movebuffer3 ,addr inipath
				invoke atodw,addr movebuffer2
				add eax,1
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr movebuffer2
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer3,addr inipath
			invoke GetDlgItemText,hAdd,IDC_EDT20,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr items
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr Item
			invoke lstrcat,addr MainBuffer,addr PositionBuffer
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr ItemBuffer1,addr inipath
				.else
				jmp insi
				.endif
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
			invoke lstrcpy,addr MainBuffer1,addr desc
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr predesc
			invoke lstrcat,addr MainBuffer,addr PositionBuffer
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer4,SIZEOF movebuffer4 ,addr inipath
			invoke SendDlgItemMessage,hWnd,IDC_LST1,LB_GETCOUNT,0,0
			sub eax,1
			invoke dwtoa,eax,addr count
			invoke lstrcpy,addr movebuffer2,addr count
			invoke lstrcpy,addr MainBuffer,addr predesc
			invoke lstrcat,addr MainBuffer,addr count	
			insdes:
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer3,SIZEOF movebuffer3 ,addr inipath
				invoke atodw,addr movebuffer2
				add eax,1
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr predesc
			invoke lstrcat,addr MainBuffer,addr movebuffer2
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer3,addr inipath
				invoke atodw,addr movebuffer2
				sub eax,2
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr predesc
			invoke lstrcat,addr MainBuffer,addr movebuffer2	
;--------------------------------------------------------------------------------
			
				invoke lstrcmp,addr movebuffer2,addr PositionBuffer
				.if eax==0
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer3,SIZEOF movebuffer3 ,addr inipath
				invoke atodw,addr movebuffer2
				add eax,1
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer1,addr desc
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr predesc
			invoke lstrcat,addr MainBuffer,addr movebuffer2
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer3,addr inipath
			invoke GetDlgItemText,hAdd,IDC_EDT24,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr desc
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr predesc
			invoke lstrcat,addr MainBuffer,addr PositionBuffer
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr ItemBuffer1,addr inipath
			
				.else
				jmp insdes
				.endif				
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
			invoke lstrcpy,addr MainBuffer1,addr paths
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr pathd
			invoke lstrcat,addr MainBuffer,addr PositionBuffer
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer4,SIZEOF movebuffer4 ,addr inipath
			invoke SendDlgItemMessage,hWnd,IDC_LST1,LB_GETCOUNT,0,0
			sub eax,1
			invoke dwtoa,eax,addr count
			invoke lstrcpy,addr movebuffer2,addr count
			invoke lstrcpy,addr MainBuffer,addr pathd
			invoke lstrcat,addr MainBuffer,addr count	
			inspth:
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer3,SIZEOF movebuffer3 ,addr inipath
				invoke atodw,addr movebuffer2
				add eax,1
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr pathd
			invoke lstrcat,addr MainBuffer,addr movebuffer2
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer3,addr inipath
				invoke atodw,addr movebuffer2
				sub eax,2
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr pathd
			invoke lstrcat,addr MainBuffer,addr movebuffer2	
;--------------------------------------------------------------------------------
			
				invoke lstrcmp,addr movebuffer2,addr PositionBuffer
				.if eax==0
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer3,SIZEOF movebuffer3 ,addr inipath
				invoke atodw,addr movebuffer2
				add eax,1
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr pathd
			invoke lstrcat,addr MainBuffer,addr movebuffer2
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer3,addr inipath
			invoke GetDlgItemText,hAdd,IDC_EDT22,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr paths
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr pathd
			invoke lstrcat,addr MainBuffer,addr PositionBuffer
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr ItemBuffer1,addr inipath
				.else
				jmp inspth
				.endif
				
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
			invoke lstrcpy,addr MainBuffer1,addr bcaps
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr bcap
			invoke lstrcat,addr MainBuffer,addr PositionBuffer
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer4,SIZEOF movebuffer4 ,addr inipath
			invoke SendDlgItemMessage,hWnd,IDC_LST1,LB_GETCOUNT,0,0
			sub eax,1
			invoke dwtoa,eax,addr count
			invoke lstrcpy,addr movebuffer2,addr count
			invoke lstrcpy,addr MainBuffer,addr bcap
			invoke lstrcat,addr MainBuffer,addr count	
			inscap:
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer3,SIZEOF movebuffer3 ,addr inipath
				invoke atodw,addr movebuffer2
				add eax,1
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr bcap
			invoke lstrcat,addr MainBuffer,addr movebuffer2
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer3,addr inipath
				invoke atodw,addr movebuffer2
				sub eax,2
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr bcap
			invoke lstrcat,addr MainBuffer,addr movebuffer2	
;--------------------------------------------------------------------------------
			
				invoke lstrcmp,addr movebuffer2,addr PositionBuffer
				.if eax==0
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer3,SIZEOF movebuffer3 ,addr inipath
				invoke atodw,addr movebuffer2
				add eax,1
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr bcap
			invoke lstrcat,addr MainBuffer,addr movebuffer2
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer3,addr inipath
			invoke GetDlgItemText,hAdd,IDC_EDT21,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr bcaps
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr bcap
			invoke lstrcat,addr MainBuffer,addr PositionBuffer
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr ItemBuffer1,addr inipath
				.else
				jmp inscap
				.endif		
;--------------------------------------------------------------------------------
;--------------------------------------------------------------------------------
			invoke lstrcpy,addr MainBuffer1,addr coms
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr com
			invoke lstrcat,addr MainBuffer,addr PositionBuffer
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer4,SIZEOF movebuffer4 ,addr inipath
			invoke SendDlgItemMessage,hWnd,IDC_LST1,LB_GETCOUNT,0,0
			sub eax,1
			invoke dwtoa,eax,addr count
			invoke lstrcpy,addr movebuffer2,addr count
			invoke lstrcpy,addr MainBuffer,addr com
			invoke lstrcat,addr MainBuffer,addr count	
			inscom:
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer3,SIZEOF movebuffer3 ,addr inipath
				invoke atodw,addr movebuffer2
				add eax,1
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr com
			invoke lstrcat,addr MainBuffer,addr movebuffer2
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer3,addr inipath
				invoke atodw,addr movebuffer2
				sub eax,2
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr com
			invoke lstrcat,addr MainBuffer,addr movebuffer2	
;--------------------------------------------------------------------------------
			
				invoke lstrcmp,addr movebuffer2,addr PositionBuffer
				.if eax==0
				invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer3,SIZEOF movebuffer3 ,addr inipath
				invoke atodw,addr movebuffer2
				add eax,1
				invoke dwtoa,eax,addr movebuffer2
			invoke lstrcpy,addr MainBuffer,addr com
			invoke lstrcat,addr MainBuffer,addr movebuffer2
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr movebuffer3,addr inipath
			invoke GetDlgItemText,hAdd,IDC_EDT23,addr ItemBuffer1,SIZEOF ItemBuffer1
			invoke lstrcpy,addr MainBuffer1,addr coms
			invoke lstrcat,addr MainBuffer1,addr CurrentPage
			invoke lstrcpy,addr MainBuffer,addr com
			invoke lstrcat,addr MainBuffer,addr PositionBuffer
			invoke WritePrivateProfileString,addr MainBuffer1,addr MainBuffer,addr ItemBuffer1,addr inipath
				.else
				jmp inscom
				.endif
				
				invoke DestroyWindow,hAdd
					invoke SetFocus,hWnd
			.endif
		.endif
		
		.if eax==IDC_BTN21
		shr eax,16
		.if ax==BN_CLICKED
			invoke DestroyWindow,hAdd
			invoke SetFocus,hWnd
			MOV		EAX,FALSE
			ret
		.endif
		.endif

.elseif eax==WM_CLOSE
invoke SetFocus,hWnd
		invoke DestroyWindow,hAdd
	.ELSE
		MOV		EAX,FALSE
		RET
			
	.ENDIF
	MOV		EAX,TRUE
	RET
AddItem endp

PageList	PROC	hPls:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

mov		eax,uMsg
	.if eax==WM_INITDIALOG
	

mov eax,1
invoke dwtoa,eax,addr movebuffer
invoke lstrcpy,addr MainBuffer1,addr paged
invoke lstrcpy,addr MainBuffer,addr pages
invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,ADDR movebuffer4,SIZEOF movebuffer4,addr inipath

invoke SendDlgItemMessage,hPls,IDC_LST2,LB_RESETCONTENT,0,0



fillpages:
invoke lstrcpy,addr MainBuffer1,addr inter
invoke lstrcat,addr MainBuffer1,addr movebuffer
invoke lstrcpy,addr MainBuffer,addr wintitle
invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,ADDR movebuffer3,SIZEOF movebuffer3,addr inipath
invoke lstrcpy,addr movebuffer5,addr movebuffer
invoke lstrcat,addr movebuffer5,addr space
invoke lstrcat,addr movebuffer5,addr movebuffer3
invoke SendDlgItemMessage,hPls,IDC_LST2,LB_ADDSTRING,0,addr movebuffer5

invoke atodw,addr movebuffer
add eax,1
invoke dwtoa,eax,addr movebuffer



invoke lstrcmp,addr movebuffer,ADDR movebuffer4
.if eax==1
invoke SendDlgItemMessage,hPls,IDC_LST2,LB_SETCURSEL,0,0
ret
.else
jmp fillpages
.endif

.elseif eax==WM_ACTIVATE


	

	.elseif eax==WM_COMMAND
		mov		eax,wParam
		and		eax,0FFFFh
		
		.if eax==IDC_BTN18
		shr eax,16
		.if ax==BN_CLICKED
			invoke SendDlgItemMessage,hPls,IDC_LST2,LB_GETCURSEL,0,0
			add eax,1
			invoke dwtoa,eax,addr editpage
			
			invoke DialogBoxParam,hInstance,IDD_DLG1,hWnd,addr PageEdit,SW_SHOWDEFAULT
			
		.endif
		.endif
		
		
		

		

		

.elseif eax==WM_CLOSE
invoke RtlZeroMemory,addr movebuffer,SIZEOF movebuffer
		invoke EndDialog,hPls,0
	.ELSE
		MOV		EAX,FALSE
		RET
			
	.ENDIF
	MOV		EAX,TRUE
	RET
	
	
	PageList endp
	
	Autorun proc hAuto:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
	
	invoke GetCurrentDirectory,260,addr movebuffer1
	.elseif eax==WM_COMMAND
		mov		eax,wParam
		mov		edx,eax
		shr		edx,16
		and		eax,0FFFFh
		
		.if edx==BN_CLICKED
			.if eax==IDC_BTN19
			
			invoke RtlZeroMemory,addr ofn,SIZEOF ofn
			mov ofn.lStructSize,SIZEOF ofn
	    pop  ofn.hInstance
	    mov ofn.lpstrInitialDir,OFFSET movebuffer1
	    mov  ofn.lpstrFilter, OFFSET FilterString1
	    mov ofn.lpstrFileTitle, OFFSET movebuffer
	    mov  ofn.nMaxFileTitle,260
	    mov  ofn.Flags, OFN_FILEMUSTEXIST or \
		OFN_PATHMUSTEXIST or OFN_LONGNAMES or\
		OFN_EXPLORER
	    mov  ofn.lpstrTitle, OFFSET OpenTitle1
	    invoke GetOpenFileName, ADDR ofn
	    .if movebuffer!=NULL
	    invoke SetDlgItemText,hAuto,IDC_EDT10,addr movebuffer
			.endif
		
			
			
			.elseif eax==IDC_BTN23
			
			invoke RtlZeroMemory,addr ofn,SIZEOF ofn
			mov ofn.lStructSize,SIZEOF ofn
	    pop  ofn.hInstance
	    mov ofn.lpstrInitialDir,OFFSET movebuffer1
	    mov  ofn.lpstrFilter, OFFSET FilterString2
	    mov ofn.lpstrFileTitle, OFFSET movebuffer
	    mov  ofn.nMaxFileTitle,260
	    mov  ofn.Flags, OFN_FILEMUSTEXIST or \
		OFN_PATHMUSTEXIST or OFN_LONGNAMES or\
		OFN_EXPLORER
	    mov  ofn.lpstrTitle, OFFSET OpenTitle2
	    invoke GetOpenFileName, ADDR ofn
	    .if movebuffer!=NULL
	    invoke SetDlgItemText,hAuto,IDC_EDT14,addr movebuffer
	    .endif
			.elseif eax==IDC_BTN25
			invoke BrowseForFolder,hAuto,ADDR movebuffer,addr FOLDTL,addr FOLDT1
			invoke SetDlgItemText,hAuto,IDC_EDT16,addr movebuffer
			
			.elseif eax==IDC_BTN26
			aabb:
			invoke GetDlgItemText,hAuto,IDC_EDT16,addr movebuffer2,SIZEOF movebuffer2
			.if movebuffer2==NULL
			invoke MessageBox,hWnd,addr noptht,addr nopthc,MB_RETRYCANCEL + MB_ICONERROR
			
			.if eax==IDRETRY
			jmp aabb
			.else
				invoke SetFocus,hAuto
				ret
			.endif
			.endif
			invoke lstrcat,addr movebuffer2,addr autof
			
			
			INVOKE CreateFile,addr movebuffer2,NULL, NULL, NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL
			aab:
			invoke GetDlgItemText,hAuto,IDC_EDT14,addr movebuffer3,SIZEOF movebuffer3
			.if movebuffer3==NULL
			invoke MessageBox,hWnd,addr noopt,addr noopc,MB_RETRYCANCEL + MB_ICONERROR
			
			.if eax==IDRETRY
			jmp aab
			.else
				invoke SetFocus,hAuto
				ret
			.endif
			.endif
			
			
			invoke WritePrivateProfileString,addr auto,addr open,addr movebuffer3,addr movebuffer2
			invoke GetDlgItemText,hAuto,IDC_EDT10,addr movebuffer3,SIZEOF movebuffer3
			invoke WritePrivateProfileString,addr auto,addr icon,addr movebuffer3,addr movebuffer2
			invoke GetDlgItemText,hAuto,IDC_EDT15,addr movebuffer3,SIZEOF movebuffer3
			invoke WritePrivateProfileString,addr auto,addr label1,addr movebuffer3,addr movebuffer2
			invoke MessageBox,hAuto,addr autot,addr autoc,MB_OK + MB_ICONINFORMATION
			invoke EndDialog,hAuto,0
			.endif
		.endif
	.elseif eax==WM_CLOSE
		invoke EndDialog,hAuto,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

Autorun endp

ChkMen proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
	.elseif eax==WM_COMMAND
		mov		eax,wParam
		mov		edx,eax
		shr		edx,16
		and		eax,0FFFFh
		
		.if edx==BN_CLICKED
			.if eax==IDC_BTN22
			invoke RtlZeroMemory,addr ofn,SIZEOF ofn
			mov ofn.lStructSize,SIZEOF ofn
	    pop  ofn.hInstance
	    mov ofn.lpstrInitialDir,OFFSET movebuffer1
	    mov  ofn.lpstrFilter, OFFSET FilterString
	    mov ofn.lpstrFile, OFFSET movebuffer
	    mov  ofn.nMaxFile,SIZEOF movebuffer
	    mov  ofn.Flags, OFN_FILEMUSTEXIST or \
		OFN_PATHMUSTEXIST or OFN_LONGNAMES or\
		OFN_EXPLORER
	    mov  ofn.lpstrTitle, OFFSET OpenTitle4
	    invoke GetOpenFileName, ADDR ofn
	    .if movebuffer!=NULL
	    invoke SetDlgItemText,hWin,IDC_EDT17,addr movebuffer
			.endif
			
			
			.elseif eax==IDC_BTN24
			invoke BrowseForFolder,hWin,ADDR movebuffer,addr FOLDTL,addr FOLDT2
			invoke SetDlgItemText,hWin,IDC_EDT18,addr movebuffer
			
			.elseif eax==IDC_BTN27
			invoke GetDlgItemText,hWin,IDC_EDT17,addr movebuffer1,SIZEOF movebuffer1
			.if movebuffer1==NULL
				invoke MessageBox,hWin,addr noment,addr nomenc,MB_OK + MB_ICONERROR
				ret
			.endif
			invoke GetDlgItemText,hWin,IDC_EDT18,addr movebuffer2,SIZEOF movebuffer2
			.if movebuffer2==NULL
				invoke MessageBox,hWin,addr noroott,addr norootc,MB_OK + MB_ICONERROR
				ret
			.endif
			
			
			invoke lstrcpy,addr MainBuffer1,addr paged
			invoke lstrcpy,addr MainBuffer,addr pages
			invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,addr movebuffer4,SIZEOF movebuffer4,addr movebuffer1
;--------------------------------------------------------------------------------

;June 10 - dialog for page selection... 
;then
			mov eax,0
			invoke dwtoa,eax,addr movebuffer3
			
			mov eax,0
			invoke dwtoa,eax,addr movebuffer4
			
invoke lstrcpy,addr MainBuffer1,addr items
invoke lstrcat,addr MainBuffer1,addr movebuffer
invoke lstrcpy,addr MainBuffer,addr wintitle
invoke GetPrivateProfileString,addr MainBuffer1,addr MainBuffer,NULL,ADDR movebuffer3,SIZEOF movebuffer3,addr inipath

			;get path movebuffer3...open file... if exists inc movebuffer3...if not add error to list

;--------------------------------------------------------------------------------
			.endif
		.endif
	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

ChkMen endp

	
	
end start