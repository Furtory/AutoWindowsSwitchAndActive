;去掉下面的 /* 和 */ 让软件以管理员运行
/*
Loop, %0%
{
  param := %A_Index%
  params .= A_Space . param
}
ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
 
if not A_IsAdmin
{
  If A_IsCompiled
    DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
  Else
    DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
  Exit
}
*/

Process, Priority, , Realtime
#MenuMaskKey vkE8
#WinActivateForce
#InstallKeybdHook
#InstallMouseHook
#Persistent
#SingleInstance Force
#MaxHotkeysPerInterval 2000
SendMode Input
SetBatchLines, -1
FileEncoding, UTF-8

/*
【黑钨重工】制作
所有软件教程开源且免费 严禁商用 下载交流群：763625227
*/

Menu, Tray, Icon, %A_ScriptDir%\ICON\F1.ico
Menu, Tray, NoStandard
Menu, Tray, Add, 设置参数, 设置参数
Menu, Tray, Add, 更新日志, 更新日志
Menu, Tray, Add, 使用教程, 使用教程
Menu, Tray, Add, 图标释义, 图标释义
Menu, Tray, Add, 开机自启, 开机自启
Menu, Tray, Add, 重启软件, 重启脚本
Menu, Tray, Add, 退出软件, 退出所有脚本

Critical, On
WIDL:=0
WIDR:=0
WIDH:=0
TapType:=0
TABMOVE:=1
SLHR:=1
SleepTime:=-1
TTL:=A_ScreenWidth/10
TTR:=A_ScreenWidth-A_ScreenWidth/10
MSTW:=Round(A_ScreenWidth/20)

FileRead, 文件内容, %A_ScriptDir%\使用教程.txt
StringReplace, 文件内容, 文件内容, `n, `n, UseErrorLevel
使用教程行数:=ErrorLevel + 3, text:=""
FileRead, 文件内容, %A_ScriptDir%\更新日志.txt
StringReplace, 文件内容, 文件内容, `n, `n, UseErrorLevel 
更新日志行数:=ErrorLevel + 3, text:=""

autostartLnk:=A_StartupCommon . "\FurtoryWindowsSwitchAndActive.lnk"
IfExist, % autostartLnk
{
  autostart:=1
}
else
{
  autostart:=0
}

if (autostart=0)
{
  Menu, Tray, UnCheck, 开机自启
}
else
{
  Menu, Tray, Check, 开机自启
}

Run, %A_ScriptDir%\TAB移动窗口.exe, , ,TABID

IfExist, %A_ScriptDir%\Settings.ini ;如果配置文件存在则读取
{
  IniRead, WXL, Settings.ini, Settings, 激活窗口左右判断宽度
  IniRead, WYU, Settings.ini, Settings, 设置拓展窗口上方判断宽度
  IniRead, WaitTime, Settings.ini, Settings, 切换窗口等待确定防误触发时间
}
IfNotExist, %A_ScriptDir%\Settings.ini ;如果配置文件不存在则新建
{
  WXL:=5
  WYU:=10
  WaitTime:=5
  autostart:=0
  IniWrite, %WXL%, Settings.ini, Settings, 激活窗口左右判断宽度
  IniWrite, %WYU%, Settings.ini, Settings, 设置拓展窗口上方判断宽度
  IniWrite, %WaitTime%, Settings.ini, Settings, 切换窗口等待确定防误触发时间
}

WXR:=A_ScreenWidth-WXL
WYU:=Round(A_ScreenHeight*(WYU/100))

Critical, Off
return

设置参数:
Critical, On
run %A_ScriptDir%\Settings.ini
loop
	{
		Sleep 100
		IfWinActive, ahk_class Notepad
		{
			loop
			{
				ToolTip ,修改保存后关闭记事本会自动读取并应用设置, 7, -25, 3
				Sleep 50
				IfWinNotActive, ahk_class Notepad
				{
					ToolTip
          IniRead, WXL, Settings.ini, Settings, 激活窗口左右判断宽度
          IniRead, WYU, Settings.ini, Settings, 设置拓展窗口上方判断宽度
          IniRead, WaitTime, Settings.ini, Settings, 切换窗口等待确定防误触发时间
          Critical, Off
          return
				}
			}
		}
		if (A_Index > 30)
		{
			MsgBox 0, 警告, 无法打开配置文件,请手动打开配置文件!修改后请退出并重启软件才会应用!, 3
			Run %A_ScriptDir%
      Critical, Off
			return
		}
	}

使用教程:
Critical, On
Gui, HELP:New, , 使用教程
FileRead, FileContents1, %A_ScriptDir%\使用教程.txt
Gui, Font,s12 cFFFFFF Bold, Microsoft YaHei
Gui, Add, Text,w600 r%使用教程行数% x100 y40 vMyEdit1
GuiControl,, MyEdit1, %FileContents1%
Gui, Color, 101010
Gui -MinimizeBox -MaximizeBox
Gui Show, , 使用教程
Critical, Off
return

更新日志:
Critical, On
Gui, THELOG:New, , 更新日志
FileRead, FileContents2, %A_ScriptDir%\更新日志.txt
Gui, Font,s12 cFFFFFF Bold, Microsoft YaHei
Gui, Add, Text,w600 r%更新日志行数% x100 y40 vMyEdit2
GuiControl,, MyEdit2, %FileContents2%
Gui, Color, 101010
Gui -MinimizeBox -MaximizeBox
Gui Show, , 更新日志
Critical, Off
return

图标释义:
Critical, On
Gui, PNGTT:New, , 图标释义
Gui, Add, Picture, , %A_ScriptDir%\状态栏图标释义.png
Gui, Color, 191919
Gui -MinimizeBox -MaximizeBox
Gui Show, , 图标释义
Critical, Off
return

重启脚本:
ToolTip, 正在重启
Process, Close, %TABID%
Process, WaitClose, %TABID%
Reload

GuiEscape:
GuiClose:
Gui, Destroy
return
开机自启:
Critical, On
if (autostart=1)
{
  autostart:=0
  Menu, Tray, UnCheck, 开机自启
}
else
{
  autostart:=1
  Menu, Tray, Check, 开机自启
}

if(autostart=1) ;开启开机自启动
{
  IfExist, % autostartLnk
  {
    FileGetShortcut, %autostartLnk%, lnkTarget
    if(lnkTarget!=A_ScriptFullPath)
    FileCreateShortcut, %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir%
  }
  else
  {
    FileCreateShortcut, %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir%
  }
}
else
{
  IfExist, % autostartLnk
  {
    FileDelete, %autostartLnk%
  }
}
Critical, Off
return

退出所有脚本:
Critical, On
ToolTip, 正在退出
Process, Close, %TABID%
Process, WaitClose, %TABID%
Critical, Off
ExitApp

F2:: ; 短按清除所有窗口设置 长按读取之前的窗口设置
loop 10 ; 等待300ms
{
  if !GetKeyState("F2", "P")
  {
    break
  }
  Sleep 30
  TapType:=TapType+1
}

if (TapType>=10)
{
  OSDTIP_Pop("窗口切换拓展器", "已经读取之前窗口设置", -3000, "CW2A2A2A CTF0F0F0")
  IniRead, WIDL, Settings.ini, Settings, 左侧拓展窗口句柄
  IniRead, WIDR, Settings.ini, Settings, 右侧拓展窗口句柄
  IniRead, WIDH, Settings.ini, Settings, 主窗口句柄
}
else
{
  OSDTIP_Pop("窗口切换拓展器", "已经删除所有窗口设置", -3000, "CW2A2A2A CTF0F0F0")
  WIDL:=0
  WIDR:=0
  WIDH:=0
  if (TABMOVE=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\F1.ico
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\F0.ico
  }
}

WinGet, WID, ID, A
if (TABMOVE=1)
{
  if (WIDL=WID)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1L.ico
  }
  else if (WIDR=WID)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1R.ico
  }
  else if (WIDH=WID)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1H.ico
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\O1.ico
  }
}
else
{
  if (WIDL=WID)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0L.ico
  }
  else if (WIDR=WID)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0R.ico
  }
  else if (WIDH=WID)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0H.ico
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\O0.ico
  }
}

loop
{
  Sleep 10
  if !GetKeyState("F2", "P")
  {
    TapType:=0
    break
  }
}

SetTimer, 切换窗口, 50
return

#z::
Critical, On
SetTimer, UnSuspend, -1, 1
OSDTIP_Pop("窗口切换拓展器", "主窗口和拓展窗口已禁用", -3000, "CW2A2A2A CTF0F0F0")
if (TABMOVE=1)
{
  Menu, Tray, Icon, %A_ScriptDir%\ICON\S1.ico, , 1
}
else
{
  Menu, Tray, Icon, %A_ScriptDir%\ICON\S0.ico, , 1
}
Critical, Off
Suspend, On
return

UnSuspend:
Critical, On
Suspend, Permit
KeyWait, LWin
loop
{
  Sleep 10
  ToolTip 1
  if GetKeyState("LWin", "P")
  {
    Suspend, Toggle
    send {Shift}
    OSDTIP_Pop("窗口切换拓展器", "主窗口和拓展窗口已开启", -3000, "CW2A2A2A CTF0F0F0")
    if (TABMOVE=0)
    {
      if (SLHR=1)
      {
        Menu, Tray, Icon, %A_ScriptDir%\ICON\F0.ico
      }
      else if (SLHR=4)
      {
        Menu, Tray, Icon, %A_ScriptDir%\ICON\0L.ico
      }
      else if (SLHR=5)
      {
        Menu, Tray, Icon, %A_ScriptDir%\ICON\0H.ico
      }
      else if (SLHR=6)
      {
        Menu, Tray, Icon, %A_ScriptDir%\ICON\0R.ico
      }
      else if (SLHR=0)
      {
        Menu, Tray, Icon, %A_ScriptDir%\ICON\O0.ico
      }
    }
    else
    {
      if (SLHR=1)
      {
        Menu, Tray, Icon, %A_ScriptDir%\ICON\F1.ico
      }
      else if (SLHR=4)
      {
        Menu, Tray, Icon, %A_ScriptDir%\ICON\1L.ico
      }
      else if (SLHR=5)
      {
        Menu, Tray, Icon, %A_ScriptDir%\ICON\1H.ico
      }
      else if (SLHR=6)
      {
        Menu, Tray, Icon, %A_ScriptDir%\ICON\1R.ico
      }
      else if (SLHR=0)
      {
        Menu, Tray, Icon, %A_ScriptDir%\ICON\O1.ico
      }
    }
    Critical, Off
    return
  }
}

#q::
; Suspend, Off
Critical, On
Process, Wait, %TABID%
if (TABMOVE=1)
{
  TABMOVE:=0
  OSDTIP_Pop("窗口切换拓展器", "TAB移动窗口功能已关闭", -3000, "CW2A2A2A CTF0F0F0")
  if (SLHR=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\F0.ico
  }
  else if (SLHR=4)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0L.ico
  }
  else if (SLHR=5)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0H.ico
  }
  else if (SLHR=6)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0R.ico
  }
  else if (SLHR=0)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\O0.ico
  }
}
else
{
  TABMOVE:=1
  OSDTIP_Pop("窗口切换拓展器", "TAB移动窗口功能已打开", -3000, "CW2A2A2A CTF0F0F0")
  if (SLHR=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\F1.ico
  }
  else if (SLHR=4)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1L.ico
  }
  else if (SLHR=5)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1H.ico
  }
  else if (SLHR=6)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1R.ico
  }
  else if (SLHR=0)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\O1.ico
  }
}
DetectHiddenWindows, On
WM_COMMAND := 0x0111
ID_FILE_SUSPEND := 65404 
PostMessage, WM_COMMAND, ID_FILE_SUSPEND,,, %A_ScriptDir%\TAB移动窗口.exe ahk_class AutoHotkey
Critical, Off
return

~LButton::
Critical, On
CoordMode, Mouse, Window
MouseGetPos, WX, WY
WinGet, WID, ID, A
ToolTip 当前窗口的ID是%WID%
if (WIDH=0)and(WIDL=0)and(WIDR=0)
{
  if (TABMOVE=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\F1.ico
    SLHR:=1
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\F0.ico
    SLHR:=1
  }
}
else if (WID=WIDH)
{
  if (TABMOVE=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1H.ico
    SLHR:=5
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0H.ico
    SLHR:=5
  }
}
else if (WID=WIDL)
{
  if (TABMOVE=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1L.ico
    SLHR:=4
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0L.ico
    SLHR:=4
  }
}
else if (WID=WIDR)
{
  if (TABMOVE=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1R.ico
    SLHR:=6
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0R.ico
    SLHR:=6
  }
}
else 
{
  if (TABMOVE=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\O1.ico
    SLHR:=0
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\O0.ico
    SLHR:=0
  }
}
OSLHR:=SLHR

if (WY<WYU)and(WX>WXL)and(WX<WXR) ; 判断鼠标是否按在了标题栏附近
{
  KeyWait, LButton
  CoordMode, Mouse, Screen
  MouseGetPos, WX
  if (WX<WXL) ; 鼠标移动到了左侧
  {
    NRTS:=1
    SLHR:=4
    if (TABMOVE=1)
    {
      Menu, Tray, Icon, %A_ScriptDir%\ICON\1L.ico
    }
    else
    {
      Menu, Tray, Icon, %A_ScriptDir%\ICON\0L.ico
    }
    WIDL:=WID
    ToolTip 设为左边拓展窗口%WIDL%
    OSDTIP_Pop("窗口切换拓展器", "已设置左边拓展窗口", -3000, "CW2A2A2A CTF0F0F0")
    WinMaximize, ahk_id %WIDL%
    IniWrite, %WIDL%, Settings.ini, Settings, 左侧拓展窗口句柄
    loop
    {
      MouseGetPos, WX
      Sleep 50
    }
    until (WX>WXL)and(WX<WXR)
    Critical, Off
    SetTimer, 切换窗口, 50
    return
  }
  else if (WX>WXR) ; 鼠标移动到了右侧
  {
    NRTS:=1
    SLHR:=6
    if (TABMOVE=1)
    {
      Menu, Tray, Icon, %A_ScriptDir%\ICON\1R.ico
    }
    else
    {
      Menu, Tray, Icon, %A_ScriptDir%\ICON\0R.ico
    }
    WIDR:=WID
    OSDTIP_Pop("窗口切换拓展器", "已设置右边拓展窗口", -3000, "CW2A2A2A CTF0F0F0")
    ToolTip 设为右边拓展窗口%WIDR%
    IniWrite, %WIDR%, Settings.ini, Settings, 右侧拓展窗口句柄
    WinMaximize, ahk_id %WIDR%
    loop
    {
      MouseGetPos, WX
      Sleep 50
    }
    until (WX>WXL)and(WX<WXR)
    Critical, Off
    SetTimer, 切换窗口, 50
    return
  }
}
else ;没有移到两侧不执行任何设置
{
  KeyWait, LButton
  ToolTip
  Critical, Off
  return
}

切换窗口:
CoordMode, Mouse, Screen
MouseGetPos, WX
if (NRTS=1)and(WX<TTL)
{
  ToolTip 左边拓展窗口设置完成!
  return
}
else if (NRTS=1)and(WX>TTR)
{
  ToolTip 右边拓展窗口设置完成!
  return
}
else
{
  NRTS:=0
}

if (WIDL<>0)and(WIDR<>0) ; 设置了两个拓展窗口
{
  if (WX<WXL)and(WIDL<>0) ; 移动到左侧激活左边拓展窗口
  {
    if (SleepTime=-1)
    {
      SleepTime:=0
    }
    SleepTime:=SleepTime+1
    SLHR:=4
    if (TABMOVE=1)
    {
      Menu, Tray, Icon, %A_ScriptDir%\ICON\1L.ico
    }
    else
    {
      Menu, Tray, Icon, %A_ScriptDir%\ICON\0L.ico
    }
    ToolTip 激活左边拓展窗口%WIDL% %SleepTime%
    WinActivate, ahk_id %WIDL%
  }
  else if (WX>WXR)and(WIDR<>0) ; 移动到右侧激活右边拓展窗口
  {
    if (SleepTime=-1)
    {
      SleepTime:=0
    }
    SleepTime:=SleepTime+1
    SLHR:=6
    if (TABMOVE=1)
    {
      Menu, Tray, Icon, %A_ScriptDir%\ICON\1R.ico
    }
    else
    {
      Menu, Tray, Icon, %A_ScriptDir%\ICON\0R.ico
    }
    ToolTip 激活右边拓展窗口%WIDR% %SleepTime%
    WinActivate, ahk_id %WIDR%
  }
  else ; 在中间
  {
    if (SleepTime=-1)or(SleepTime>WaitTime) ;时间足切换窗口
    {
      SleepTime:=-1
    }
    else if (SleepTime<=WaitTime)and(SleepTime>=0) ;时间不足不切换窗口
    {
      if (SLHR=4)
      {
        WinMinimize, ahk_id %WIDL%
        SleepTime:=-1
      }
      else if (SLHR=6)
      {
        WinMinimize, ahk_id %WIDR%
        SleepTime:=-1
      }
      
      if (TABMOVE=0) ; 图标显示
      {
        if (OSLHR=4)
        {
          SLHR:=4
          Menu, Tray, Icon, %A_ScriptDir%\ICON\0L.ico
        }
        else if (OSLHR=5)
        {
          SLHR:=5
          Menu, Tray, Icon, %A_ScriptDir%\ICON\0H.ico
        }
        else if (OSLHR=6)
        {
          SLHR:=5
          Menu, Tray, Icon, %A_ScriptDir%\ICON\0R.ico
        }
        else if (OSLHR=0)
        {
          SLHR:=0
          Menu, Tray, Icon, %A_ScriptDir%\ICON\O0.ico
        }
        else if (OSLHR=1)
        {
          SLHR:=1
          Menu, Tray, Icon, %A_ScriptDir%\ICON\F0.ico
        }
      }
      else
      {
        if (OSLHR=4)
        {
          SLHR:=4
          Menu, Tray, Icon, %A_ScriptDir%\ICON\1L.ico
        }
        else if (OSLHR=5)
        {
          SLHR:=5
          Menu, Tray, Icon, %A_ScriptDir%\ICON\1H.ico
        }
        else if (OSLHR=6)
        {
          SLHR:=6
          Menu, Tray, Icon, %A_ScriptDir%\ICON\1R.ico
        }
        else if (OSLHR=0)
        {
          SLHR:=0
          Menu, Tray, Icon, %A_ScriptDir%\ICON\O1.ico
        }
        else if (OSLHR=1)
        {
          SLHR:=1
          Menu, Tray, Icon, %A_ScriptDir%\ICON\F1.ico
        }
      }
    }
    ToolTip
  }
}
else ; 如果设置了任意一个拓展窗口
{
  if (WIDL=0)and(WIDR<>0)and(WX<TTL) ; 若左侧拓展窗口没有设置，则在鼠标移到左侧判定区域内时提示
  {
    ToolTip %WIDR% 您还未设置左边拓展窗口
  }
  else if (WIDL<>0)and(WIDR=0)and(WX>TTR)  ; 若右侧拓展窗口没有设置，则在鼠标移到右侧判定区域内时提示
  {
    ToolTip %WIDL% 您还未设置右边拓展窗口
  }
  else if (WX<WXL)and(WIDL<>0) ; 移动到左侧激活左边拓展窗口
  {
    if (SleepTime=-1)
    {
      SleepTime:=0
    }
    SleepTime:=SleepTime+1
    SLHR:=4
    if (TABMOVE=1)
    {
      Menu, Tray, Icon, %A_ScriptDir%\ICON\1L.ico
    }
    else
    {
      Menu, Tray, Icon, %A_ScriptDir%\ICON\0L.ico
    }
    ToolTip 激活左边拓展窗口%WIDL% %SleepTime%
    WinActivate, ahk_id %WIDL%
  }
  else if (WX>WXR)and(WIDR<>0) ; 移动到右侧激活右边拓展窗口
  {
    if (SleepTime=-1)
    {
      SleepTime:=0
    }
    SleepTime:=SleepTime+1
    SLHR:=6
    if (TABMOVE=1)
    {
      Menu, Tray, Icon, %A_ScriptDir%\ICON\1R.ico
    }
    else
    {
      Menu, Tray, Icon, %A_ScriptDir%\ICON\0R.ico
    }
    ToolTip 激活右边拓展窗口%WIDR% %SleepTime%
    WinActivate, ahk_id %WIDR%
  }
  else ; 在中间
  {
    if (SleepTime=-1)or(SleepTime>WaitTime) ;时间足切换窗口
    {
      SleepTime:=-1
    }
    else if (SleepTime<=WaitTime)and(SleepTime>=0) ;时间不足不切换窗口
    {
      if (SLHR=4)
      {
        WinMinimize, ahk_id %WIDL%
        SleepTime:=-1
      }
      else if (SLHR=6)
      {
        WinMinimize, ahk_id %WIDR%
        SleepTime:=-1
      }
      
      if (TABMOVE=0) ; 图标显示
      {
        if (OSLHR=4)
        {
          SLHR:=4
          Menu, Tray, Icon, %A_ScriptDir%\ICON\0L.ico
        }
        else if (OSLHR=5)
        {
          SLHR:=5
          Menu, Tray, Icon, %A_ScriptDir%\ICON\0H.ico
        }
        else if (OSLHR=6)
        {
          SLHR:=6
          Menu, Tray, Icon, %A_ScriptDir%\ICON\0R.ico
        }
        else if (OSLHR=0)
        {
          SLHR:=0
          Menu, Tray, Icon, %A_ScriptDir%\ICON\O0.ico
        }
        else if (OSLHR=1)
        {
          SLHR:=1
          Menu, Tray, Icon, %A_ScriptDir%\ICON\F0.ico
        }
      }
      else
      {
        if (OSLHR=4)
        {
          SLHR:=4
          Menu, Tray, Icon, %A_ScriptDir%\ICON\1L.ico
        }
        else if (OSLHR=5)
        {
          SLHR:=5
          Menu, Tray, Icon, %A_ScriptDir%\ICON\1H.ico
        }
        else if (OSLHR=6)
        {
          SLHR:=6
          Menu, Tray, Icon, %A_ScriptDir%\ICON\1R.ico
        }
        else if (OSLHR=0)
        {
          SLHR:=0
          Menu, Tray, Icon, %A_ScriptDir%\ICON\O1.ico
        }
        else if (OSLHR=1)
        {
          SLHR:=1
          Menu, Tray, Icon, %A_ScriptDir%\ICON\F1.ico
        }
      }
    }
    ToolTip
  }
}
return

CapsLock::
Critical, On
WinGet, WID, ID, A
if (WIDL=WID)and(WIDR<>0) ; 如果当前显示的是左边的拓展窗口 则激活右边的拓展窗口
{
  SLHR:=6
  if (TABMOVE=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1R.ico
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0R.ico
  }
  WinActivate, ahk_id %WIDR%
  ToolTip 当前窗口的ID是%WID% 切换至%WIDR%
  Sleep 300
  ToolTip
  Critical, Off
  return
}
else if (WIDL<>0)and(WIDR=WID) ; 如果当前显示的是右边的拓展窗口 则激活左边的拓展窗口
{
  SLHR:=4
  if (TABMOVE=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1L.ico
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0L.ico
  }
  WinActivate, ahk_id %WIDL%
  ToolTip 当前窗口的ID是%WID% 切换至%WIDL%
  Sleep 300
  ToolTip
  Critical, Off
  return
}
else if (WIDL=WID) ; 如果当前只设置了左边的拓展窗口 则激活左边的拓展窗口
{
  SLHR:=4
  if (TABMOVE=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1L.ico
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0L.ico
  }
  WinActivate, ahk_id %WIDL%
  ToolTip 当前窗口的ID是%WID% 切换至%WIDL%
  Sleep 300
  ToolTip
  Critical, Off
  return
}
else if (WIDR=WID) ; 如果当前只设置了右边的拓展窗口 则激活右边的拓展窗口
{
  SLHR:=6
  if (TABMOVE=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1R.ico
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0R.ico
  }
  WinActivate, ahk_id %WIDR%
  ToolTip 当前窗口的ID是%WID% 切换至%WIDR%
  Sleep 300
  ToolTip
  Critical, Off
  return
}
else ; 如果没有设置任何拓展窗口 不执行任何操作
{
  ToolTip 您还未设置任何拓展窗口
  Sleep 300
  ToolTip
  Critical, Off
  return
}

$MButton::
Critical, On
MouseGetPos OMX
Send {MButton Down} ;按下中键
loop ;等待300ms
{
  Sleep 10
  ; ToolTip %A_Index%
  if !GetKeyState("MButton", "P")
  {
    Send {MButton Up}
    Critical, Off
    return
  }
}
until (A_Index>30)
MouseGetPos, NMX
STABL:=OMX-MSTW*2
STABR:=OMX+MSTW*2
if (NMX<STABL)or(NMX>STABR) ;如果左右移动则切换窗口
{
  OMX:=NMX
  Send {MButton Up}
  MouseGetPos, OMX
  Send {Alt Down}
  Send {Tab}
  loop
  {
    Sleep 10
    MouseGetPos, NMX
    STAB:=(NMX-OMX)/MSTW
    ; ToolTip %STAB%
    if (STAB>=1)
    {
      Send {Right}
      OMX:=NMX
    }
    else if (STAB<=-1)
    {
      Send {Left}
      OMX:=NMX
    }
    
    if !GetKeyState("MButton", "P")
    {
      Send {LButton}
      Send {Alt Up}
      Critical, Off
      return
    }
  }
}
else ;没移动则等待物理抬起中键
{
  loop
  {
    Sleep 10
    if !GetKeyState("MButton", "P")
    {
      Send {MButton Up}
      Critical, Off
      return
    }
  }
}

$space::
Critical, On
SLHR:=5
OSLHR:=5
WinGet, WID, ID, A
if (WIDH=0) ;若没有设置主窗口 按下空格设置主窗口
{
  if (WID=WIDL)
  {
    WIDL:=0
  }
  if (WID=WIDR)
  {
    WIDR:=0
  }
  
  if (TABMOVE=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1H.ico
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0H.ico
  }
  WIDH:=WID
  OSDTIP_Pop("窗口切换拓展器", "已设置主窗口", -3000, "CW2A2A2A CTF0F0F0")
  ToolTip 当前窗口%WIDH%设置为主窗口
  IniWrite, %WIDH%, Settings.ini, Settings, 主窗口句柄
  Sleep 300
  ToolTip
  Critical, Off
  return
}
else if(WID<>WIDH) ;若不在主窗口 切换至主窗口
{
  if (TABMOVE=1)
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\1H.ico
  }
  else
  {
    Menu, Tray, Icon, %A_ScriptDir%\ICON\0H.ico
  }
  WinActivate, ahk_id %WIDH%
  ToolTip 切换至主窗口%WIDH%
  Sleep 300
  ToolTip
  Critical, Off
  return
}
else ;若在主窗口或其他窗口 输入空格
{
  Send {space Down}
  loop
  {
    if !GetKeyState("space", "P")
    {
      send {space Up}
      break
    }
  }
  return
  Critical, Off
}

+space:: ;设置新的主窗口
Critical, On
WinGet, WIDH, ID, A
OSDTIP_Pop("窗口切换拓展器", "已设置主窗口", -3000, "CW2A2A2A CTF0F0F0")
ToolTip 当前窗口%WIDH%设置为主窗口
if (TABMOVE=1)
{
  Menu, Tray, Icon, %A_ScriptDir%\ICON\1H.ico
}
else
{
  Menu, Tray, Icon, %A_ScriptDir%\ICON\0H.ico
}
if (WID=WIDL)
{
  WIDL:=0
}
if (WID=WIDR)
{
  WIDR:=0
}
SLHR:=5
OSLHR:=5
IniWrite, %WIDH%, Settings.ini, Settings, 主窗口句柄
Sleep 300 
ToolTip
Critical, Off
return

$^space:: ;输入空格
Critical, On
Send {space Down}
loop
{
  if !GetKeyState("space", "P")
  {
    send {space Up}
    break
  }
  Critical, Off
  return
}

; OSDTIP_Pop v0.55 by SKAN on D361/D36E @ tiny.cc/osdtip 
; 以下函数来自：
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=76881

OSDTIP_Pop(P*) 
{
Local
Static FN:="", ID:=0, PM:="", PS:="" 

  If !IsObject(FN)
    FN := Func(A_ThisFunc).Bind(A_ThisFunc) 

  If (P.Count()=0 || P[1]==A_ThisFunc) 
  {
    OnMessage(0x202, FN, 0),  OnMessage(0x010, FN, 0)                   ; WM_LBUTTONUP, WM_CLOSE 
    SetTimer, %FN%, OFF
    DllCall("AnimateWindow", "Ptr",ID, "Int",200, "Int",0x50004)        ; AW_VER_POSITIVE | AW_SLIDE
    Progress, 10:OFF                                                    ; AW_HIDE
    Return ID:=0
  }

  MT:=P[1], ST:=P[2], TMR:=P[3], OP:=P[4], FONT:=P[5] ? P[5] : "Segoe UI"
  Title := (TMR=0 ? "0x0" : A_ScriptHwnd) . ":" . A_ThisFunc

  If (ID) 
  {
    Progress, 10:, % (ST=PS ? "" : PS:=ST), % (MT=PM ? "" : PM:=MT), %Title%
    OnMessage(0x202, FN, TMR=0 ? 0 : -1)
    SetTimer, %FN%, % Round(TMR)<0 ? TMR : "OFF" 
    Return ID
  }

  If ( InStr(OP,"U2",1) && FileExist(WAV:=A_WinDir . "\Media\Windows Notify.wav") )
    DllCall("winmm\PlaySoundW", "WStr",WAV, "Ptr",0, "Int",0x220013)    ; SND_FILENAME | SND_ASYNC
  DetectHiddenWindows, % ("On", DHW:=A_DetectHiddenWindows)             ; SND_NOSTOP | SND_SYSTEMq
  SetWinDelay, % (-1, SWD:=A_WinDelay)
  DllCall("uxtheme\SetThemeAppProperties", "Int",0)
  Progress, 10:C12 ZH1 FM9 FS11 CWF0F0F0 CT101010 %OP% B1 M HIDE,% PS:=ST, % PM:=MT, %Title%, %FONT%
  WinSet, Transparent, 200, %Title%      ; 窗口透明度
  DllCall("uxtheme\SetThemeAppProperties", "Int",7)                     ; STAP_ALLOW_NONCLIENT
  WinWait, %Title% ahk_class AutoHotkey2                                ; STAP_ALLOW_WEBCONTENT
  WinGetPos, X, Y, W, H
  SysGet, M, MonitorWorkArea
  WinMove,% "ahk_id" . WinExist(),,% (MRight-W)-8*A_ScreenDPI/96,% (MBottom-(H:=InStr(OP,"U1",1) ? H : Max(H,100)))-8*A_ScreenDPI/96, W, H
  If ( TRN:=Round(P[6]) & 255 )
    WinSet, Transparent, %TRN% 
  ControlGetPos,,,,H, msctls_progress321                
  If (H>2)
  {  
    ColorMQ:=Round(P[7]),  ColorBG:=P[8]!="" ? Round(P[8]) : 0xF0F0F0,  SpeedMQ:=Round(P[9])
    Control, ExStyle, -0x20000,        msctls_progress321               ; v0.55 WS_EX_STATICEDGE
    Control, Style, +0x8,              msctls_progress321               ; PBS_MARQUEE
    SendMessage, 0x040A, 1, %SpeedMQ%, msctls_progress321               ; PBM_SETMARQUEE
    SendMessage, 0x0409, 1, %ColorMQ%, msctls_progress321               ; PBM_SETBARCOLOR
    SendMessage, 0x2001, 1, %ColorBG%, msctls_progress321               ; PBM_SETBACKCOLOR
  }  
  DllCall("AnimateWindow", "Ptr",WinExist(), "Int",200, "Int",0x40008)  ; AW_VER_NEGATIVE | AW_SLIDE
  SetWinDelay, %SWD%
  DetectHiddenWindows, %DHW%
  If (Round(TMR)<0)
    SetTimer, %FN%, %TMR%
  OnMessage(0x202, FN, TMR=0 ? 0 : -1),  OnMessage(0x010, FN)           ; WM_LBUTTONUP,  WM_CLOSE
Return ID:=WinExist()
}