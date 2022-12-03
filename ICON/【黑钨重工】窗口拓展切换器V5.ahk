#InstallKeybdHook
#InstallMouseHook
SetBatchLines, -1

/*
【黑钨重工】制作
所有软件教程开源且免费 严禁商用 下载交流群：763625227
*/

Critical, On
WIDL:=0
WIDR:=0
WIDH:=0
TABMOVE:=1
SLHR:=1
SleepTime:=-1
TTL:=A_ScreenWidth/10
TTR:=A_ScreenWidth-A_ScreenWidth/10
MSTW:=Round(A_ScreenWidth/20)
autostartLnk:=A_StartupCommon . "\FurtoryWindowsSwitchAndPro.lnk"

Menu, Tray, Icon, %A_ScriptDir%\ICON\F1.ico
Menu, Tray, NoStandard
Menu, Tray, Add, 设置参数, 设置参数
Menu, Tray, Add, 更新日志, 更新日志
Menu, Tray, Add, 使用教程, 使用教程
Menu, Tray, Add, 图标释义, 图标释义
Menu, Tray, Add, 开机自启, 开机自启
Menu, Tray, Add, 退出软件, 退出所有脚本

Run, %A_ScriptDir%\TAB移动窗口.exe, , ,TABID

IfExist, %A_ScriptDir%\Settings.ini ;如果配置文件存在则读取
{
  IniRead, WXL, Settings.ini, Settings, 激活窗口左右判断宽度
  IniRead, WYU, Settings.ini, Settings, 设置拓展窗口上方判断宽度
  IniRead, WaitTime, Settings.ini, Settings, 切换窗口等待确定防误触发时间
  IniRead, autostart, Settings.ini, Settings, 开机自启
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
  IniWrite, %autostart%, Settings.ini, Settings, 开机自启
}

if (autostart=0)
{
  Menu, Tray, UnCheck, 开机自启
}
else
{
  Menu, Tray, Check, 开机自启
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

使用帮助:
Critical, On
FileEncoding, UTF-8
FileRead, HELP, %A_ScriptDir%\使用教程.txt
MsgBox, , 使用帮助, %HELP%
Critical, Off
return

更新日志:
Critical, On
FileEncoding, UTF-8
FileRead, HELP, %A_ScriptDir%\更新日志.txt
MsgBox, , 使用帮助, %HELP%
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

开机自启:
Critical, On
if (autostart=1)
{
  autostart:=0
  Menu, Tray, UnCheck, 开机自启
  IniWrite, %autostart%, Settings.ini, Settings, 开机自启
}
else
{
  autostart:=1
  Menu, Tray, Check, 开机自启
  IniWrite, %autostart%, Settings.ini, Settings, 开机自启
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
Critical, On
loop ; 等待300ms
{
  Sleep 10
  ; ToolTip %A_Index%
  if !GetKeyState("F2", "P")
  {
    WIDL:=0
    WIDR:=0
    WIDH:=0
    return
  }
}
until (A_Index>30)
IniRead, WIDL, Settings.ini, Settings, 左侧拓展窗口句柄
IniRead, WIDR, Settings.ini, Settings, 右侧拓展窗口句柄
IniRead, WIDH, Settings.ini, Settings, 主窗口句柄
Critical, Off
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
; ToolTip %SLHR% %OSLHR% %WID% %WIDH%

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
    WinMaximize, ahk_id %WIDL%
    IniWrite, %WIDL%, Settings.ini, Settings, 左侧拓展窗口句柄
    loop
    {
      MouseGetPos, WX
      Sleep 50
    }
    until (WX>WXL)and(WX<WXR)
    Critical, Off
    SetTimer, 切换窗口, 30
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
    SetTimer, 切换窗口, 30
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
  ToolTip
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

; 以下为函数五合一，实际想用哪个函数就复制哪个函数
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=76881

; 右下角弹出通知框示例，C0为标题居中 内容左对齐，C00为标题和内容都居左
; OSDTIP_Pop("通知", "消息内容", -3000, "CW2A2A2A CTF0F0F0")

; 右下角实时显示时间 示例
; Loop
;     OSDTIP_Pop("C L O C K", A_Hour . ":" . A_Min . ":" . A_Sec, 0, "CW101010 CTF0F0F0 FM12 FS36")

; OSDTIP_Pop("通知", "消息内容", 0, "zh7 w160 CW101010 CTD3D3D3 U1 U2",,,0x00FFFF, 0x808080, 100) ; 最后一个参数是进度条滚动时间

; 中央弹窗提示【点击可关闭】
; OSDTIP_Alert("MainText", "SubText",, "V0")

; 桌面右下角壁纸贴片
; OSDTIP_Desktop("MainText", "SubText")

; 桌面右下角壁纸实时时间贴片【可用SetTimer刷新显示实时时间】
; Loop
;     OSDTIP_Desktop(A_UserName,  A_Hour . ":" . A_Min . ":" . A_Sec)

; 音量调节Gui
; Volume_Mute:: OSDTIP_Volume("+1",   "", -2000)
; Volume_Up::   OSDTIP_Volume(  "", "+5", -2000)
; Volume_Down:: OSDTIP_Volume(  "", "-5", -2000)

; 大小写等状态指示Gui
; CapsLock::   OSDTIP_KBLeds("CapsLock",,  -2000)
; ScrollLock:: OSDTIP_KBLeds("ScrollLock",,-2000)
; NumLock::    OSDTIP_KBLeds("NumLock",,   -2000)  


OSDTIP_Pop(P*) {                            ; OSDTIP_Pop v0.55 by SKAN on D361/D36E @ tiny.cc/osdtip 
Local
Static FN:="", ID:=0, PM:="", PS:="" 

  If !IsObject(FN)
    FN := Func(A_ThisFunc).Bind(A_ThisFunc) 

  If (P.Count()=0 || P[1]==A_ThisFunc) {
    OnMessage(0x202, FN, 0),  OnMessage(0x010, FN, 0)                   ; WM_LBUTTONUP, WM_CLOSE 
    SetTimer, %FN%, OFF
    DllCall("AnimateWindow", "Ptr",ID, "Int",200, "Int",0x50004)        ; AW_VER_POSITIVE | AW_SLIDE
    Progress, 10:OFF                                                    ; | AW_HIDE
    Return ID:=0
  }

  MT:=P[1], ST:=P[2], TMR:=P[3], OP:=P[4], FONT:=P[5] ? P[5] : "Segoe UI"
  Title := (TMR=0 ? "0x0" : A_ScriptHwnd) . ":" . A_ThisFunc

  If (ID) {
    Progress, 10:, % (ST=PS ? "" : PS:=ST), % (MT=PM ? "" : PM:=MT), %Title%
    OnMessage(0x202, FN, TMR=0 ? 0 : -1)
    SetTimer, %FN%, % Round(TMR)<0 ? TMR : "OFF" 
    Return ID
  }

  If ( InStr(OP,"U2",1) && FileExist(WAV:=A_WinDir . "\Media\Windows Notify.wav") )
    DllCall("winmm\PlaySoundW", "WStr",WAV, "Ptr",0, "Int",0x220013)    ; SND_FILENAME | SND_ASYNC   
                                                                        ; | SND_NODEFAULT   
  DetectHiddenWindows, % ("On", DHW:=A_DetectHiddenWindows)         ; | SND_NOSTOP | SND_SYSTEM
  SetWinDelay, % (-1, SWD:=A_WinDelay)
  DllCall("uxtheme\SetThemeAppProperties", "Int",0)
  Progress, 10:C12 ZH1 FM9 FS11 CWF0F0F0 CT101010 %OP% B1 M HIDE,% PS:=ST, % PM:=MT, %Title%, %FONT%
  WinSet, Transparent, 150, %Title%      ; 窗口透明度
  DllCall("uxtheme\SetThemeAppProperties", "Int",7)                     ; STAP_ALLOW_NONCLIENT
                                                                        ; | STAP_ALLOW_CONTROLS
  WinWait, %Title% ahk_class AutoHotkey2                                ; | STAP_ALLOW_WEBCONTENT
  WinGetPos, X, Y, W, H
  SysGet, M, MonitorWorkArea
  WinMove,% "ahk_id" . WinExist(),,% (MRight-W)-8*A_ScreenDPI/96,% (MBottom-(H:=InStr(OP,"U1",1) ? H : Max(H,100)))-8*A_ScreenDPI/96, W, H
  If ( TRN:=Round(P[6]) & 255 )
    WinSet, Transparent, %TRN% 
    ControlGetPos,,,,H, msctls_progress321                
    If (H>2) {  
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

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

OSDTIP_Alert(P*) {                        ; OSDTIP_Alert v0.54 by SKAN on D37P/D383 @ tiny.cc/osdtip
Local
Static FN:="", ID:=0, PS:="", PM:="", P8:=(A_PtrSize=8 ? "Ptr" : "")
  If !IsObject(FN)
    FN := Func(A_ThisFunc).Bind(A_ThisFunc) 

  If (P.Count()=0 || P[1]==A_ThisFunc) {
    If (P[4]=0x201) ;            WM_NCLBUTTONDOWN=0xA1, HTCAPTION=2       ; WM_LBUTTONDOWN=0x201
    Return DllCall("SendMessage", "Ptr",ID, "Int",0xA1,"Ptr",2, "Ptr",0)  ;   
    OnMessage(0x201, FN, 0),  OnMessage(0x010, FN, 0)                     ; WM_LBUTTONDOWN, WM_CLOSE 
    SetTimer, %FN%, OFF
    Progress, 6:OFF                       
    Return ID:=0                                                              
  }                                         

  MT:=P[1], ST:=P[2], OP := P[4] . A_Space, TMR:=P[3], FONT:=P[5] ? P[5] : "Segoe UI",  
  TRN :=Round(P[6]) ? P[6] & 255 : 255, Title := (TMR=0 ? "0x0" : A_ScriptHwnd) . ":" . A_ThisFunc
  OP.= InStr(OP,"V1") ? "CWFFFFE2 CT856442 CBEBB800" : InStr(OP,"V2") ? "CWF0F8FF CT1A4482 CB3399FF" 
    :  InStr(OP,"V3") ? "CWF0FFE9 CT155724 CB429300" : InStr(OP,"V4") ? "CWFFEEED CT721C24 CBE40000" 
    :  InStr(OP,"V0") ? "CW3F3F3F CTDADADA CB797979" : ""
  PBG := (F := InStr(OP,"CB",1)) ? SubStr(OP, F+2, 6) : "797979"
  PBG := Format("0x{5:}{6:}{3:}{4:}{1:}{2:}", StrSplit(PBG)*)

  WinClose, ahk_id %ID%
  DetectHiddenWindows, % ("On", DHW:=A_DetectHiddenWindows)
  SetWinDelay, % (-1, SWD:=A_WinDelay)  
  SetControlDelay, % (0, SCD:=A_WinDelay)

  DllCall("uxtheme\SetThemeAppProperties", "Int",0)
  Progress, 6: ZX6 ZY4 ZH16 FS10 FM11 WS400 WM800 C00 CT222222 %OP% B1 M Hide
          , %ST%, %MT%, %Title%, %FONT%
  DllCall("uxtheme\SetThemeAppProperties", "Int",7)
  WinWait, %Title% ahk_class AutoHotkey2
  ControlGetPos,,,,         PBS, msctls_progress321
  ControlGetPos, X1,,,, Static1
  ControlGetPos, X2,,,, Static2
  NM := X1+Round(PBS//2)
  Progress, 6: ZY4 ZH16 FS10 FM11 WS400 WM800 C00 CT222222 CB797979 %OP% ZX%NM% B1 M Hide
          , %ST%, %MT%, %Title%, %FONT%
  WinWait, %Title% ahk_class AutoHotkey2          

  WinSet, Transparent, %TRN%, % "ahk_id" . (ID:=WinExist())
  WinGetPos, WX, WY, WW, WH
  ControlGetPos,,,,         PBS, msctls_progress321
  ControlGetPos,, Y1, W1, H1, Static1
  ControlGetPos,, Y2, W2, H2, Static2  
  WH := Y1 + H1 + Round(H2) + 2

  SysGet, M, MonitorWorkArea, % Round(P[9])
  mX := mLeft, mY := mTop, mW := mRight-mLeft, mH := mBottom-mTop 
  WX := mX + ( P[7]="" ? (mW//2)-(WW//2) : P[7]<0 ? mW-WW+P[7]+1 : P[7] )
  WY := mY + ( P[8]="" ? (mH//2)-(WH//2) : P[8]<0 ? mH-WH+P[8]+1 : P[8] )    
  WinMove,,, % WX , % WY , % WW, % WH

  ControlMove, Static1, % X1+PBS, % Y1,      % W1, % H1
  ControlMove, Static2, % X2+PBS, % Y1+H1+2, % W2, % H2
  Control, ExStyle, -0x20000,    msctls_progress321                      ; WS_EX_STATICEDGE, removed
  SendMessage, 0x2001, 1, % PBG, msctls_progress321                      ; PBM_SETBACKCOLOR
  ControlMove, msctls_progress321, 0, 0, % PBS, % WH  

  SetControlDelay, %SCD%
  SetWinDelay, %SWD%
  DetectHiddenWindows, %DHW%
  SC := DllCall("GetClassLong" . P8, "Ptr",ID, "Int",-26, "UInt")        ; GCL_STYLE
  DllCall("SetClassLong" . P8, "Ptr",ID, "Int",-26, "Ptr",SC|0x20000)    ; GCL_STYLE, CS_DROPSHADOW    
  Progress, 6:SHOW                                                     
  DllCall("SetClassLong" . P8, "Ptr",ID, "Int",-26, "Ptr",SC)            ; GCL_STYLE

  If (Round(TMR)<0)
    SetTimer, %FN%, %TMR%
  OnMessage(0x202, FN, TMR=0 ? 0 : -1),  OnMessage(0x010, FN)            ; WM_LBUTTONUP,  WM_CLOSE
Return ID := WinExist()
}

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

OSDTIP_Desktop(P*) {                    ; OSDTIP_Desktop v0.50 by SKAN on D35P/D36E @ tiny.cc/osdtip
Local
Static FN:="", ID:=0, PS:="", PM:="", P8:=(A_PtrSize=8 ? "Ptr" : "")

  If !IsObject(FN)
    FN := Func(A_ThisFunc).Bind(A_ThisFunc) 

  If (P.Count()=0 || P[1]==A_ThisFunc) {
    If (P[4]=0x201) ;            WM_NCLBUTTONDOWN=0xA1, HTCAPTION=2      ; WM_LBUTTONDOWN=0x201
    Return DllCall("SendMessage", "Ptr",ID, "Int",0xA1,"Ptr",2, "Ptr",0) ;   
    OnMessage(0x201, FN, 0),  OnMessage(0x010, FN, 0)                    ; WM_LBUTTONDOWN, WM_CLOSE 
    SetTimer, %FN%, OFF
    Progress, 7:OFF                       
    Return ID:=0                                                              
  }
 
  MT:=P[1], ST:=P[2], TMR:=P[3], OP:=P[4], FONT:=P[5] ? P[5] : "Segoe UI"
  TRN:=P[6] ? P[6] : "A0A0A0 127", Title := (TMR=0 ? "0x0" : A_ScriptHwnd) . ":" . A_ThisFunc
  
  If (ID) {                           
    Progress, 7:, % (ST=PS ? "" : PS:=ST), % (MT=PM ? "" : PM:=MT), %Title%        
    SetTimer, %FN%, % Round(TMR)<0 ? TMR : "OFF"
    OnMessage(0x201, FN, TMR=0 ? 0 : -1)                                 ; WM_LBUTTONDOWN 
    Return ID
  }                                                                                                        

  DetectHiddenWindows, % ("Off", DHW:=A_DetectHiddenWindows)
  If !hSDV:=DllCall("GetWindow", "Ptr",WinExist("ahk_class Progman"), "UInt",5, "Ptr")  ; GW_CHILD=5
      hSDV:=DllCall("GetWindow", "Ptr",WinExist("ahk_class WorkerW"), "UInt",5, "Ptr")  ; GW_CHILD=5
  DetectHiddenWindows, On     
  SetWinDelay, % (-1, SWD:=A_WinDelay)

  DllCall("uxtheme\SetThemeAppProperties", "Int",0)
  Progress, 7: ZX0 ZY0 ZH1 w200 FS14 FM28 CWA0A0A0 CTFEFEFE B %OP% M HIDE
          , %ST%, %MT%, %Title%, %FONT%
  DllCall("uxtheme\SetThemeAppProperties", "Int",7)
  WinWait %Title% ahk_class AutoHotkey2

  Control, Style,   0x50000000,  msctls_progress321                      ; WS_VISIBLE | WS_CHILD
  Control, ExStyle,-0x20000,     msctls_progress321                      ; WS_EX_STATICEDGE 
  If !InStr(OP,"U4") {
    Control, Style,  0x50000002, Static1                                 ; WS_VISIBLE | WS_CHILD
    Control, Style,  0x50000002, Static2                                 ; | SS_RIGHT
    }
  SendMessage, 0x2001, 0, P[9]!="" ? P[9] : 0xFFFFFF, msctls_progress321 ; PBM_SETBACKCOLOR=0x2001
  WinSet, TransColor, %TRN%
  WinGetPos, X, Y, W, H
  SysGet, M, MonitorWorkArea
  If !InStr(OP,"U5") 
    X:=MRight-W-14, Y:=MBottom-H-14
  Else 
    X := P[7]="" ? (MRight/2) -(W/2) : P[7]<0 ? MRight -W+P[7] : P[7]
  , Y := P[8]="" ? (MBottom/2)-(H/2) : P[8]<0 ? MBottom-H+P[8] : P[8]    
  ID:=WinExist()               ; SetWindowPos HWND_BOTTOM=1, SWP_SHOWWINDOW=0x40 SWP_NOACTIVATE=0x10
  DllCall("SetWindowPos", "Ptr",ID, "Ptr",1, "Int",X, "Int",Y, "Int",W+2, "Int",H, "UInt",0x40|0x10)
  DllCall("SetWindowPos", "Ptr",ID, "Ptr",1, "Int",X, "Int",Y, "Int",W+0, "Int",H, "UInt",0x40|0x10)
  DllCall("SetWindowLong" . P8, "Ptr",ID, "Int",-8, "Ptr",hSDV)          ; GWL_HWNDPARENT
  SetWinDelay, %SWD%
  DetectHiddenWindows, %DHW%
  Progress, 7:SHOW  
  If (Round(TMR)<0) 
    SetTimer, %FN%, %TMR%
  OnMessage(0x201, FN, TMR=0 ? 0 : -1),  OnMessage(0x010, FN)            ; WM_LBUTTONDOWN,  WM_CLOSE
Return ID
}

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

OSDTIP_Volume(P*) {                      ; OSDTIP_Volume v0.50 by SKAN on D35P/D369 @ tiny.cc/osdtip
Local
Static FN:="", ID:=0, PV:=0, P8:=(A_PtrSize=8 ? "Ptr" : "") 

  If !IsObject(FN)
    FN := Func(A_ThisFunc).Bind(A_ThisFunc) 

  If (P.Count()=0 || P[1]==A_ThisFunc) {
    OnMessage(0x202, FN, 0),  OnMessage(0x010, FN, 0)                   ; WM_LBUTTONUP, WM_CLOSE 
    SetTimer, %FN%, OFF
    Progress, 8:OFF                       
    Return ID:=0                                                              
  }
  
  M:=P[1], V:=P[2], VSigned:=InStr("+-",SubStr(V,1,1)), TMR:=P[3]
  OP:=P[4], FONT:=P[5] ? P[5] : "Trebuchet MS",  TRN:=Round(P[6]) ? P[6] & 255 : 222
  Title := (TMR=0 ? "0x0" : A_ScriptHwnd) . ":" . A_ThisFunc
  
  If (M!="") 
    SoundSet, %M%,, MUTE
  SoundGet, M,, MUTE
  If ( V!="" && !VSigned)
    SoundSet, %V%  
  SoundGet, VOL
  VOL:=Round(VOL)

  If WinExist("ahk_id" . ID) 
    {
      If (V && VSigned)
        SoundSet, % VOL:=(VOL:=V ? Round((VOL+V)/V)*V : VOL)>100 ? 100 : VOL<0 ? 0 : Round(VOL)
      SendMessage, 0x0409, 1, % (M="On" ? 0x0030FF:0x00FFAA), msctls_progress321 ; PBM_SETBARCOLOR
      SendMessage, 0x2001, 0, % (M="On" ? 0x00175A:0x00402E), msctls_progress321 ; PBM_SETBACKCOLOR
      Progress, 8:%VOL%, % PV!=VOL ? PV:=VOL : "",, %Title% 
      SetTimer, %FN%, % Round(TMR)<0 ? TMR : "OFF"
      Return ID
    }  

  DetectHiddenWindows, % ("On", DHW:=A_DetectHiddenWindows)
  SetWinDelay, % (-1, SWD:=A_WinDelay)  
  DllCall("uxtheme\SetThemeAppProperties", "Int",0)
  Progress, 8:C11 w318 ZH24 ZX28 ZY4 WM400 WS600 FM16 FS22 CT111111 CWF0F0F0 %OP% B1 HIDE
          , % PV:=VOL, V O L U M E, %Title%, %FONT%
  DllCall("uxtheme\SetThemeAppProperties", "Int",7)
  WinWait, %Title% ahk_class AutoHotkey2

  WinSet, Transparent, %TRN%, % "ahk_id" . (ID:=WinExist())
  SendMessage, 0x0409, 1, % (M="On" ? 0x0030FF:0x00FFAA), msctls_progress321 ; PBM_SETBARCOLOR
  SendMessage, 0x2001, 0, % (M="On" ? 0x00175A:0x00402E), msctls_progress321 ; PBM_SETBACKCOLOR
  Control, ExStyle, -0x20000, msctls_progress321
  DetectHiddenWindows, %DHW%
  Progress, 8:%VOL% 
  SC := DllCall("GetClassLong" . P8, "Ptr",ID, "Int",-26, "UInt")       ; GCL_STYLE
  DllCall("SetClassLong" . P8, "Ptr",ID, "Int",-26, "Ptr",SC|0x20000)   ; GCL_STYLE, CS_DROPSHADOW    
  Progress, 8:SHOW
  DllCall("SetClassLong" . P8, "Ptr",ID, "Int",-26, "Ptr",SC)           ; GCL_STYLE
  If (Round(TMR)<0) 
    SetTimer, %FN%, %TMR%
  OnMessage(0x202, FN, TMR=0 ? 0 : -1),  OnMessage(0x010, FN)           ; WM_LBUTTONUP,  WM_CLOSE
Return ID := WinExist()
}

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

OSDTIP_KBLeds(P*) {                      ; OSDTIP_KBLeds v0.50 by SKAN on D361/D367 @ tiny.cc/osdtip 
Local
Static FN:="", ID:=0 

  If !IsObject(FN)
    FN := Func(A_ThisFunc).Bind(A_ThisFunc) 

  If (P.Count()=0 || P[1]==A_ThisFunc) {
    OnMessage(0x202, FN, 0),  OnMessage(0x010, FN, 0)                   ; WM_LBUTTONUP, WM_CLOSE 
    SetTimer, %FN%, OFF
    Progress, 9:OFF                       
    Return ID:=0                                                              
  }

  Key := P[1], ST:=P[2], TMR:=P[3], OP:=P[4], FONT:=P[5] ? P[5] : "Trebuchet MS"
  Title := (TMR=0 ? "0x0" : A_ScriptHwnd) . ":" . A_ThisFunc, TRN:=Round(P[6]) ? P[6] & 255 : 222
     
  If WinExist("ahk_id" . ID) {                                          
    ST.=InStr(ST,"off") || InStr(ST,"on") ? "" :  GetKeyState(Key,"T") ? "Off" : "On"
    Switch (Key) {
      Case "CapsLock"   : SetCapsLockState,   %ST%
      Case "ScrollLock" : SetScrollLockState, %ST%
      Case "NumLock"    : SetNumLockState,    %ST%
    }
    C:=GetKeyState("CapsLock","T"), S:=GetKeyState("ScrollLock","T"), N:=GetKeyState("NumLock","T")
    SendMessage, 0x2001, 1,% C ? 0x00FFAA:0x808080, msctls_progress321 ; PBM_SETBACKCOLOR
    SendMessage, 0x2001, 1,% S ? 0x00AAFF:0x808080, msctls_progress322 ; PBM_SETBACKCOLOR  
    SendMessage, 0x2001, 1,% N ? 0x00FFAA:0x808080, msctls_progress323 ; PBM_SETBACKCOLOR

    If (Key="CapsLock" && C=1) || (Key="NumLock" && N=0)
    If ( InStr(OP,"U2",1) && FileExist(WAV:=A_WinDir . "\Media\Windows Default.wav") )
      DllCall("winmm\PlaySoundW", "WStr",WAV, "Ptr",0, "Int",0x220013)  ; SND_FILENAME | SND_ASYNC   

    SetTimer, %FN%, % Round(TMR)<0 ? TMR : "OFF" 
    Progress, 9:,,,%Title%
    Return ID
  }
                                                                                            
  DetectHiddenWindows, % ("On", DHW:=A_DetectHiddenWindows)
  SetWinDelay, % (-1, SWD:=A_WinDelay)
  SetControlDelay, % (0, SCD:=A_ControlDelay)                  
  DllCall("uxtheme\SetThemeAppProperties", "Int",0)
  Progress, 9:ZX32 ZY6 ZH32 W172 WM600 WS400 FM16 FS16 CT101010 CWF0F0F0 %OP% C00 B1 HIDE
          , ScrollLock, CapsLock, %Title%, %FONT%
  WinWait %Title% ahk_class AutoHotkey2                                  

  WinGetPos, WX, WY, WW, WH, % "ahk_id" . (ID:=WinExist())
  Loop, Parse, % "msctls_progress32|msctls_progress32|Static", | 
  DllCall("CreateWindowEx", "Int",0, "Str",A_LoopField, "Str","NumLock" ; WS_VISIBLE | WS_CHILD
       ,"Int",0x50000000, "Int",0, "Int",0, "Int",10, "Int",10, "Ptr",ID, "Ptr",0, "Ptr",0, "Ptr",0)
  DllCall("uxtheme\SetThemeAppProperties", "Int",7)                     
  SendMessage, 0x31, 0, 0,            Static1                           ; WM_GETFONT
  SendMessage, 0x30, %ErrorLevel%, 1, Static3                           ; WM_SETFONT
  ControlGetPos, CX, CY, CW, CH, Static1
  YM:=CY-1, NX:=CX+CH+24, WW:=WW+CH+24, WH:=(CH*3)+(YM*4)+2, PH:=Round(CH/2), PY:=CY+(PH/2) 
  WX:=(A_ScreenWidth/2)-(WW/2), WY := (A_ScreenHeight/2)-(WH/2)
  WinMove,% "ahk_id" WinExist(),,% WX,% WY,% WW, % WH
  ControlMove, Static1,            % NX, % CY,             % CW, % CH
  ControlMove, Static2,            % NX, % CY+CH+YM,       % CW, % CH
  ControlMove, Static3,            % NX, % CY+CH+YM+CH+YM, % CW, % CH
  ControlMove, msctls_progress321, % CX, % PY,             % CH, % PH
  ControlMove, msctls_progress322, % CX, % PY+CH+YM,       % CH, % PH
  ControlMove, msctls_progress323, % CX, % PY+CH+YM+CH+YM, % CH, % PH
  Loop 3
  Control, Style, +0x202, Static%A_Index%                               ; SS_RIGHT | SS_CENTERIMAGE
  WinSet, Transparent, %TRN%
  SetControlDelay, %SCD%
  SetWinDelay, %SWD%
  DetectHiddenWindows, %DHW%

  P8 := (A_PtrSize=8 ? "Ptr":"")
  SC := DllCall("GetClassLong" . P8, "Ptr",ID, "Int",-26, "UInt")       ; GCL_STYLE
  DllCall("SetClassLong" . P8, "Ptr",ID, "Int",-26, "Ptr",SC|0x20000)   ; GCL_STYLE, CS_DROPSHADOW    
  Progress, 9:SHOW
  DllCall("SetClassLong" . P8, "Ptr",ID, "Int",-26, "Ptr",SC)           ; GCL_STYLE

  P[3]:=0, n:=%A_ThisFunc%(P*)
  If (Round(TMR)<0) 
    SetTimer, %FN%, %TMR%
  OnMessage(0x202, FN, TMR=0 ? 0 : -1),  OnMessage(0x010, FN)           ; WM_LBUTTONUP,  WM_CLOSE
Return ID  
}

;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

OSDTIP(hWnd:="") {
Local OSDTIP 
  If (hWnd="")
     Return A_ScriptHwnd . ":OSDTIP_" . "ahk_class AutoHotkey2"
  If !WinExist("ahk_id" . hWnd)  
     Return 0  
  WinGetTitle, OSDTIP
  OSDTIP := StrSplit(OSDTIP,":")
  If ( OSDTIP[1] = A_ScriptHwnd ) 
       OSDTIP[2]()
}