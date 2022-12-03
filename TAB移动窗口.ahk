/*
@Require AutoHotkey V2.0+
@Version 0.2
@Description 按住`， 可在窗口的任意位置用鼠标左键拖动窗口，用滚轮调整窗口大小
*/

#NoTrayIcon

Tab & LButton:: {
    DllCall("GetCursorPos", "int64*", &cursorPt := 0)
    childHwnd := DllCall("WindowFromPoint", "int64", cursorPt, "ptr")
    if 0 == topHwnd := DllCall("GetAncestor", "ptr", childHwnd, "uint", 2, "ptr")
        return
    DllCall("ShowWindowAsync", "ptr", topHwnd, "int", 1)
    WinActivate(topHwnd)
    WinGetPos(&topWndX, &topWndY, , , topHwnd)
    offsetX := (cursorPt & 0xffffffff) - topWndX
    offsetY := (cursorPt >> 32) - topWndY
    pLowLevelKeyboardProc := CallbackCreate(LowLevelKeyboardProc, "F")
    hook := DllCall("SetWindowsHookEx", "int", 14, "ptr", pLowLevelKeyboardProc, "ptr", 0, "uint", 0, "ptr")
    LowLevelKeyboardProc(nCode, wParam, lParam) {
        Critical
        if 0 == nCode {
            if 0x0200 == wParam
                DllCall("SetWindowPos", "ptr", topHwnd, "ptr", 0, "int", NumGet(lParam, "int") - offsetX, "int", NumGet(lParam, 4, "int") - offsetY, "int", 0, "int", 0, "uint", 1)
            else if 0x0202 == wParam {
                DllCall("UnhookWindowsHookEx", "ptr", hook)
                CallbackFree(pLowLevelKeyboardProc)
            }
        }
        return DllCall("CallNextHookEx", "ptr", 0, "int", nCode, "ptr", wParam, "ptr", lParam)
    }
}

Tab & WheelUp:: {
    divisor := 15
    DllCall("GetCursorPos", "int64*", &cursorPt := 0)
    childHwnd := DllCall("WindowFromPoint", "int64", cursorPt, "ptr")
    if 0 == topHwnd := DllCall("GetAncestor", "ptr", childHwnd, "uint", 2, "ptr")
        return
    DllCall("SetForegroundWindow", "ptr", topHwnd)
    WinGetPos(&topWndX, &topWndY, &topWndW, &topWndH, topHwnd)
    rateX := ((cursorPt & 0xffffffff) - topWndX) / topWndW
    rateY := ((cursorPt >> 32) - topWndY) / topWndH
    addendW := A_ScreenWidth / divisor
    addendH := A_ScreenWidth * (topWndH / topWndW) / divisor
    topWndX -= addendW * rateX
    topWndY -= addendH * rateY
    topWndW += addendW
    topWndH += addendH
    DllCall("SetWindowPos", "ptr", topHwnd, "ptr", 0, "int", topWndX, "int", topWndY, "int", topWndW, "int", topWndH, "uint", 0)
}

Tab & WheelDown:: {
    divisor := 15
    DllCall("GetCursorPos", "int64*", &cursorPt := 0)
    childHwnd := DllCall("WindowFromPoint", "int64", cursorPt, "ptr")
    if 0 == topHwnd := DllCall("GetAncestor", "ptr", childHwnd, "uint", 2, "ptr")
        return
    DllCall("SetForegroundWindow", "ptr", topHwnd)
    WinGetPos(&topWndX, &topWndY, &topWndW, &topWndH, topHwnd)
    rateX := ((cursorPt & 0xffffffff) - topWndX) / topWndW
    rateY := ((cursorPt >> 32) - topWndY) / topWndH
    addendW := A_ScreenWidth / divisor
    addendH := A_ScreenWidth * (topWndH / topWndW) / divisor
    topWndX += addendW * rateX
    topWndY += addendH * rateY
    topWndW -= addendW
    topWndH -= addendH
    DllCall("SetWindowPos", "ptr", topHwnd, "ptr", 0, "int", topWndX, "int", topWndY, "int", topWndW, "int", topWndH, "uint", 0)
}