; BuffsForHugs
; A Hug-powered, Buff-dispensing bot for Dark Age of Camelot
; Written by Tamlan Tenderheart
;
; Usage:
; Automatically buff people that hug the bot character in-game
; There are a few modes of operation supported:
;
; F1 > Buffs the currently selected toon in-game
; F2 > Thanks the currently selected toon in-game and then buffs them
; F3 > First click sets the top-left point of the capture box; second click sets the bottom-right point of the capture box
; F4 > Uses capture to detect all toons that have hugged you in the on-screen capture box, thanks each one, and buffs them
; F5 > (toggle) Starts / stops autonomous mode that performs a F4 operation every second until stopped

#SingleInstance, force
#MaxThreadsPerHotkey 2

StringCaseSense, On

; variables

global version := "0.1.12"      ; simple version string
global bestowedBuffs := []      ; associative array with Player:tickCount recorded of last buff
global IsRunning := false       ; autonomous running flag
global IsFirstPoint := true     ; toggle for recording first or second point to determine screen capture box
global Window := 0              ; HWND of the DAOC Window
global sessionCount := 0        ; counter of number of buffs given in the current session
global lifetimeCount := 0       ; counter of number of buffs given since script start
global x1 := 895                ; x location for point 1 (given value is predetermined but modifyable during execution)
global y1 := 1043               ; y location for point 1 (given value is predetermined but modifyable during execution)
global x2 := 1890               ; x location for point 2 (given value is predetermined but modifyable during execution)
global y2 := 1214               ; y location for point 2 (given value is predetermined but modifyable during execution)
global Messages := ["/s Thank you for your warm hug, <player>{!} Please accept these buffs as a token of my gratitude{!} <3{Enter}"
  ,"/s Such a wonderful hug, <player>{!} Please take these buffs to assist you in the battle{!} <3{Enter}"
  ,"/s Your hugs are the best, <player>{!} I hope these buffs serve you well on the field{!} <3{Enter}"
  ,"/s I never tire of your sweet hugs, <player>{!} Let me empower you for your coming battle{!} <3{Enter}"
  ,"/s You are so sweet, <player>{!} Allow me to bestow these buffs to aid you on the battlefield{!} <3{Enter}"
  ,"/s It is dangerous to go without buffs, <player>{!} Please take these with my thanks{!} <3{Enter}"
  ,"/s You are such a tenderheart, <player>{!} These buffs are for you{!} <3{Enter}"
  ,"/s Your hugs make me happy, <player>{!} I hope my buffs make you happy{!} <3{Enter}"
  ,"/s I feel empowered by your hug, <player>{!} Allow me to return the favor{!} <3{Enter}"
  ,"/s Allow me to repay your kindness with these buffs, <player>{!} Godspeed{!} <3{Enter}"
  ,"/s Your hugs warm my heart, <player>{!} Let my buffs warm yours{!} <3{Enter}"
  ,"/s Your hugs brighten my day, <player>{!} Let these buffs darken the day for your foes{!} <3{Enter}"
  ,"/s I could melt into your hugs, <player>{!} Take my buffs and go and melt your foes{!} <3{Enter}"]

TargetPlayer(Name)
{
    Send, /target %Name%{Enter}
    Return
}

SendBuffsToTarget(IsMetered, IsAsync)
{
    ; harcoded sequence (8=DA buff, 9=Swing Speed Buff, 7=Bladeturn buff)
    Sleep, 200
    Send 8
    Sleep, 200
    Send 9
    Sleep, 3000 ; need this pause to allow the first buff to finish casting so the second isn't clobbered by the third
    Send 7
    if( IsAsync ) Sleep, 7500 
    if( IsMetered )
    {
        sessionCount += 1
        lifetimeCount += 1
        buffs[player] := A_TickCount ; record the time that we buffed this player
    }
    Return
}

ClearSelectedTarget()
{
    Send {Ctrl Down}
    Sleep, 200
    Send {Tab} ; Select nearest friendly, which ensures that there is a target selected
    Sleep, 200
    Send {Ctrl Up}
    Sleep, 200
    Send {Esc} ; Clear the targeted friendly, which ensures no target is selected
    Sleep, 200
    Return
}

SessionStart()
{
    Window := WinExist("A")
    if( Window )
    {
        WinGetTitle, Title, ahk_id %Window%
        If( ! InStr(Title, "Dark Age of Camelot"))
            Window := 0
        Else Send /s Hugbot version %version%, written by Tamlan Tenderheart, session starting...{Enter}       
    }
    sessionCount := 0
}

SessionEnd()
{
    if( ActivateDaocWindowIfPossible() )
    {
        Send /s Hugbot session ending. I buffed %sessionCount% player(s) this session, and %lifetimeCount% players(s) since script start{Enter}
    }
    Window := 0
}

ActivateDaocWindowIfPossible()
{
    If( Window )
    {
        WinActivate, ahk_id %Window%    
        return true
    }
    return false
}

ProcessScreenLog()
{
    RunWait, C:/apps/Capture2Text/Capture2Text_CLI --screen-rect "%x1% %y1% %x2% %y2%" --clipboard,,Hide
    while pos := RegExMatch(Clipboard, "O)(\w+)(?=\shugs\syou)", m, m ? m.Pos + m.Len : 1)
    Loop, % m.Count()
    {
        player := FixI(m.Value(A_Index))
        If IsPlayerEligible(player)
        {
            ActivateDaocWindowIfPossible()
            TargetPlayer(player)
            ThankPlayer(player)
            SendBuffsToTarget(true, true)
            ClearSelectedTarget()            
        }
    }
    Return
}

ThankPlayer(Player)
{   
    Send % StrReplace(Messages[random(1, Messages.MaxIndex())], "<player>", Player)
    Return    
}

IsPlayerEligible(Player)
{
    If( bestowedBuffs.HasKey(player) )
        return ( ( A_TickCount - bestowedBuffs[player] ) > 30000 )  ; rebuff window is 30s 
    Else return true
}

FixI(name)
{
    If(InStr(name, "l")=1) ; My UI uses a font where the lowercase L looks like the uppercase I.
    {
        return StrReplace(name, "l", "I",,1)    
    }
    return name
}

random( x, y )
{
   Random, var, %x%, %y%
   Return var
}

;#IfWinActive ahk_exe game.dll

F1::
    ; Send buffs to targeted toon in-game
    SendBuffsToTarget(false, false)
    Return

F2::
    ; Send buffs to targeted toon in-game with thanks message
    ThankPlayer("%t")
    SendBuffsToTarget(false, false)
    Return

F3::
    ; First click records the top left of the capture box, second click collects the bottom right, this defines the cap box    
    CoordMode, Mouse, Screen
    if( IsFirstPoint )
    {
        MouseGetPos, x1, y1
        TrayTip,BuffsForHugs,Point 1 is [X%x1% Y%y1%]
    }
    Else
    {
        MouseGetPos, x2, y2
        TrayTip,BuffsForHugs,Point 2 is [X%x2% Y%y2%]
    }
    IsFirstPoint := !IsFirstPoint
    Return

F4::
    ; Send buffs to everyone that hugged me in current screen log (not looping)
    ProcessScreenLog()
    Return

F5::
    ; Begin autonomous operation
    IsRunning := ! IsRunning
    If( IsRunning )
    {
        SessionStart()
        While( IsRunning )
        {
            ProcessScreenLog()
            Sleep, 1000 ; 1 second poll interval, then check flag
        }
        SessionEnd()
    }
    Return
