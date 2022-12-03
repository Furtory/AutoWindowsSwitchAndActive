#InstallKeybdHook
#InstallMouseHook
SetBatchLines, -1

MSTW:=Round(A_ScreenWidth/20)

$MButton::
MouseGetPos OMX
Send {MButton Down} ;按下中键
loop ;等待300ms
{
  Sleep 10
  ; ToolTip %A_Index%
  if !GetKeyState("MButton", "P")
  {
    Send {MButton Up}
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
      return
    }
  }
}
return