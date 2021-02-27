.386
.model flat,stdcall
option casemap:none

include INIMenu.inc

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
	mov		wc.style,CS_HREDRAW or CS_VREDRAW or CS_DBLCLKS
	mov		wc.lpfnWndProc,offset WndProc
	mov		wc.cbClsExtra,NULL
	mov		wc.cbWndExtra,DLGWINDOWEXTRA
	push	hInst
	pop		wc.hInstance
	mov		wc.hbrBackground,COLOR_BTNFACE+1
	mov		wc.lpszMenuName,NULL
	mov		wc.lpszClassName,offset ClassName
	invoke LoadIcon,hInstance,ICO_1
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
		
		
		
			 
		.elseif eax==WM_SETFOCUS
		
		;Check to see if ini file exists and retrieve total pages========
	Checkini:
	invoke GetCurrentDirectory,SIZEOF MAXPATH,addr inipath
	invoke lstrcat,addr inipath,addr ininame
	INVOKE GetPrivateProfileString,addr paged,addr pages,NULL,addr numpage,SIZEOF numpage,addr inipath
	.if numpage==NULL

		invoke MessageBox,NULL,addr NoINIFileText,addr NoINIFileCaption,MB_RETRYCANCEL + MB_ICONERROR
		.if eax==IDRETRY
			jmp Checkini
		.else
			invoke ExitProcess,0
		.endif
	.endif
	;===================================================================
	; Set button states (no Page data)	++++++++++++++++++++++++++++++++++++++++++++++++

			;Previous Button	=========================
			.if numpage!="0"
			.if CurrentPage!="1"
			invoke GetDlgItem,hWin,IDC_BTN3
			invoke ShowWindow,eax,TRUE
			invoke GetPrivateProfileString,addr paged,addr ppage,addr NoFileButton,addr MainBuffer,sizeof MainBuffer,addr inipath
			invoke SetDlgItemText,hWin,IDC_BTN3,addr MainBuffer
			invoke RtlZeroMemory,addr MainBuffer,SIZEOF MainBuffer
			.elseif CurrentPage=="1"
			invoke SetDlgItemText,hWin,IDC_BTN3,addr zero
			invoke GetDlgItem,hWin,IDC_BTN3
			invoke ShowWindow,eax,FALSE
			invoke SetDlgItemText,hWin,IDC_BTN3,addr zero
			.endif
			.endif
			;============================================
			;Next Button	=============================
			.if numpage!="0"
			invoke lstrcmp,addr numpage,addr CurrentPage
			.if eax!=NULL
			invoke GetPrivateProfileString,addr paged,addr npage,addr NoFileButton,addr MainBuffer,sizeof MainBuffer,addr inipath
			invoke GetDlgItem,hWin,IDC_BTN4
			invoke ShowWindow,eax,TRUE
			invoke SetDlgItemText,hWin,IDC_BTN4,addr MainBuffer
			invoke RtlZeroMemory,addr MainBuffer,SIZEOF MainBuffer
			.else
				invoke SetDlgItemText,hWin,IDC_BTN4,addr zero
				invoke GetDlgItem,hWin,IDC_BTN4
			invoke ShowWindow,eax,FALSE
			.endif
			.endif
			
			;============================================
			
			
			
			;Command Button	=============================
			invoke GetDlgItem,hWin,IDC_BTN1
			invoke ShowWindow,eax,FALSE
			;============================================
	;END BUTTONSTATES	++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	; Add Menu Items (PAGE DATA)++++++++++++++++++++++++++++++++++++++++++++++++
	
			;Set Title for page	=========================
			invoke lstrcpy,addr MainBuffer,addr inter
			invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke GetPrivateProfileString,addr MainBuffer,addr wintitle,addr NoFileText,addr DescriptionBuffer,SIZEOF DescriptionBuffer,addr inipath
			.if DescriptionBuffer=="0"
			invoke SendMessage,hWin,WM_SETTEXT,NULL,NULL
			.else
			invoke SendMessage,hWin,WM_SETTEXT,NULL,addr DescriptionBuffer
			.endif
			invoke RtlZeroMemory,addr DescriptionBuffer,SIZEOF DescriptionBuffer
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			;============================================
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
			invoke GetPrivateProfileString,addr MainBuffer,addr bdef,NULL,addr DescriptionBuffer,SIZEOF DescriptionBuffer,addr inipath
			.if DescriptionBuffer==NULL
			invoke GetDlgItem,hWin,IDC_BTN1
			invoke ShowWindow,eax,FALSE
			;invoke MoveWindow,hWnd,0,0,535,298,TRUE
			.else
			invoke GetDlgItem,hWin,IDC_BTN1
			invoke ShowWindow,eax,TRUE
			;invoke MoveWindow,hWnd,0,0,535,352,TRUE
			.if DescriptionBuffer=="0"
			invoke GetDlgItem,hWin,IDC_BTN1
			invoke ShowWindow,eax,FALSE
			;invoke MoveWindow,hWnd,0,0,535,298,TRUE
			.else
			invoke SetDlgItemText,hWin,IDC_BTN1,addr DescriptionBuffer
			.endif
			.endif
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,addr DescriptionBuffer,SIZEOF DescriptionBuffer
			;============================================
			;Set Default Command for Page================
			invoke lstrcpy,addr MainBuffer1,addr defcom
			;invoke lstrcat,addr MainBuffer1,addr CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr coms
		invoke lstrcat,addr MainBuffer,addr CurrentPage
     		invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,addr CommandBuffer,SIZEOF CommandBuffer,addr inipath
     		invoke RtlZeroMemory,addr MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,addr MainBuffer1,SIZEOF MainBuffer1
			invoke RtlZeroMemory,addr DescriptionBuffer,SIZEOF DescriptionBuffer
			
			
			
			;============================================
					invoke SendDlgItemMessage,hWin,IDC_LST1,LB_RESETCONTENT,0,0			
			;Add Menu Items	=============================
			invoke lstrcpy,addr MainBuffer,addr items
			invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke GetPrivateProfileString,addr MainBuffer,addr number,NULL,addr ItemBuffer, SIZEOF ItemBuffer,addr inipath
			.if ItemBuffer==NULL
		invoke MessageBox,NULL,addr NoINIFileText,addr NoINIFileCaption,MB_RETRYCANCEL + MB_ICONERROR
		.if eax==IDRETRY
			jmp Checkini
		.else
			invoke ExitProcess,0
		.endif
		.endif
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
		invoke MessageBox,NULL,addr NoINIFileText,addr NoINIFileCaption,MB_RETRYCANCEL + MB_ICONERROR
		.if eax==IDRETRY
			jmp Checkini
		.else
			invoke ExitProcess,0
		.endif
		.endif
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke RtlZeroMemory,ADDR MainBuffer1,SIZEOF MainBuffer1
			.if ItemBuffer2=="0"
			invoke SendDlgItemMessage,hWin,IDC_LST1,LB_ADDSTRING,0,addr zero
			.else
			invoke SendDlgItemMessage,hWin,IDC_LST1,LB_ADDSTRING,0,addr ItemBuffer2
			.endif
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
	
		
	.elseif eax==WM_COMMAND
		mov		eax,wParam
		and		eax,0FFFFh
	;The Button actions		++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			;NEXT	====================================	
			.if eax==WM_LBUTTONDBLCLK
	    	invoke MessageBox,NULL,addr desc,addr desc,MB_OK
	    .endif
		
	
     .if eax==IDC_BTN4
     	shr eax,16
     	.if ax==BN_CLICKED
     		      invoke SendDlgItemMessage,hWin,IDC_LST1,LB_RESETCONTENT,0,0
	    	invoke SetDlgItemText,hWin,IDC_EDT1,addr zero
	    	invoke GetDlgItem,hWin,IDC_BTN1
	    	invoke ShowWindow,eax,FALSE
	    	invoke SetDlgItemText,hWin,IDC_BTN1,addr zero
     	invoke atodw,addr CurrentPage
     		inc eax
     	invoke dwtoa,eax,addr CurrentPage
     		invoke SendMessage,hWin,WM_SETFOCUS,0,0
     	.endif
     .endif
     		;============================================
     		;Previous	=================================
     .if eax==IDC_BTN3
     	shr eax,16
     	.if ax==BN_CLICKED
     		      invoke SendDlgItemMessage,hWin,IDC_LST1,LB_RESETCONTENT,0,0
	    	invoke SetDlgItemText,hWin,IDC_EDT1,addr zero
	    	invoke GetDlgItem,hWin,IDC_BTN1
	    	invoke ShowWindow,eax,FALSE
	    	invoke SetDlgItemText,hWin,IDC_BTN1,addr zero
     	invoke atodw,addr CurrentPage
     	dec eax
     	invoke dwtoa,eax,addr CurrentPage
     			invoke SendMessage,hWin,WM_SETFOCUS,0,0
     	.endif
     .endif
     		;============================================
     		;Command	=================================
     		
     		.if eax==IDC_BTN1
	    	shr eax,16
	    	.if ax==BN_CLICKED
	    lstsel:
     		.if PathBuffer!=0
     			
     		invoke lstrcpy,addr MainBuffer1,addr pathd
			invoke lstrcat,addr MainBuffer1,ADDR CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr paths
		invoke lstrcat,addr MainBuffer,addr CurrentPage
     		invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,ADDR DescriptionBuffer1,SIZEOF page1,addr inipath	
	    		invoke lstrcmp,addr page1,addr DescriptionBuffer1
	    		.if eax==0
	    		invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,ADDR DescriptionBuffer1,SIZEOF DescriptionBuffer1,addr inipath	
	    		;invoke lstrcmp,addr DescriptionBuffer1,addr page1
	    		;invoke lstrcpy,addr DescriptionBuffer1,addr DescriptionBuffer
	    	;	invoke atodw,addr DescriptionBuffer1
	    	;	mov ebx,eax
	    	;	invoke atodw,addr page1
	    	;	xor eax,ebx
	    		invoke OpenFile,addr DescriptionBuffer1,addr ItemBuffer2,NULL
	    		invoke ReadFile,addr ItemBuffer2,addr DescriptionBuffer1,SIZEOF page1,SIZEOF DescriptionBuffer1,NULL
	    		;invoke dwtoa,eax,addr DescriptionBuffer1
	    
	    	;	invoke MessageBox,hWin,ADDR DescriptionBuffer1,ADDR DescriptionBuffer1,MB_OK
	    		
	    		.endif
	    		;invoke MessageBox,hWin,ADDR DescriptionBuffer1,ADDR DescriptionBuffer1,MB_OK
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
     		
     		;Set Command Button Caption=================
     		invoke lstrcpy,addr MainBuffer1,addr bcap
			invoke lstrcat,addr MainBuffer1,ADDR CurrentSelection
     		invoke lstrcpy,addr MainBuffer,addr bcaps
		invoke lstrcat,addr MainBuffer,addr CurrentPage
			invoke GetPrivateProfileString,addr MainBuffer,addr MainBuffer1,NULL,ADDR DescriptionBuffer,SIZEOF DescriptionBuffer,addr inipath
			invoke RtlZeroMemory,ADDR MainBuffer,SIZEOF MainBuffer
			invoke atodw,addr DescriptionBuffer
			.if eax==0
			invoke GetDlgItem,hWin,IDC_BTN1
			invoke ShowWindow,eax,FALSE
			
			.else
			invoke GetDlgItem,hWin,IDC_BTN1
			invoke ShowWindow,eax,TRUE
			
			.endif
			
			invoke SetDlgItemText,hWin,IDC_BTN1,addr DescriptionBuffer
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
     			
     			
     ;END LISTBOX ACTIONS			++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     		
      
	  
	  	
	  	.endif
     .endif   
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






end start
