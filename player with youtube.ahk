SetBatchLines, -1
SetWinDelay, -1
SetControlDelay, -1
#SingleInstance force
#NoEnv
#WinActivateForce
#UseHook, on
#MaxThreads, 100
FileEncoding, UTF-8
CoordMode,Mouse,Relative
SendMode Input
;Var
version = 1.0.0.0
global GuiWidth, GuiHeight, xposgui, queue, iconcolor, themepurple, themeblue, themegreen, themeblueviolet, themecyan, themewhite, brightness, foundsearch, version, hidden, currentPlaylist2, currentPlaylist, currentplaylisttemp, working, cover2, yposgui, ffmpegpath, textcolor, ResultX, BlurBitmap, listclosedX, progressbar, ImageListID, ImageListID2, cursor, listclosed, counttitle, font0, Youtube, YoutubeID3, ResultY, currentviewold, length, shufflelist, fullscreen, ptoken, currvolume, RowNumberplaylist, fullscreenid, fullscreentext, rownumber3, album, titleoriginal, artistoriginal, likename, liked2, fullalwaysontop, titletext2, MenuID, moving, Filestoadd, liked, titleypos, Playlistnamenew, looptoggle, artistypos, currenttemp, albumypos, titleypos2, PrevControl, CurrControl, artistypos2, albumypos2, currpos, line, currentview, pixelcolor, pixelcolor2, color, title2, colorblur, cursortoggle, characterlen, characterlen2, cover, rownumber, listwidth, exactduration, listheight, current2, media, DataPath, artist, title, Args, coverxpos, config, coverwidth, songs, current, bc, name, ext, allext, CM2, CM, AV, oMI
currentPlaylist2 := 0
DataPath := A_Appdata "\musicplayer\Data"
shufflelist = %DataPath%\shuffle.txt
config = %DataPath%\config.ini
songs = %DataPath%\songs.txt
queue = %DataPath%\queue.txt
allext = mp3.m4a.wav.ogg
cover := A_Appdata "\musicplayer\Data\albumart.png"
cover2 := A_Appdata "\musicplayer\Data\albumarttemp.png"
PlaylistDir = %dataPath%\Playlists
currentview = 2
themepurple := ["0x202020", "0xbc67fc", "0xa852ff"]
themeblue := ["0x151515", "0x9db7ff", "0x3b66ff"]
themecyan := ["0x0c0c0c", "0xb0ffd7", "0x00ffbd"]
themewhite := ["0x0F0F0F", "0xf2ffff", "0xFFFFFF"]
themegreen := ["0x080808", "0xa4ff8b", "0x33ff1e"]
themeblueviolet := ["0x151515", "0x8f6bff", "0x9571ff"]
IfNotExist, %queue%
{
    FileAppend, %empty%, %queue%
}
moving = 0
pToken:=gdip_startup()
IniRead, bc, %config%, bc, 1
IniRead, textcolor, %config%, textcolor, 1
IniRead, iconcolor, %config%, iconcolor, 1
IniRead, brightness, %config%, brightness, 1
if(bc = "" or bc = "ERROR")
    bc = 0x202020
if(textcolor = "" or textcolor = "ERROR")
    textcolor = 0xccb1ff
if(iconcolor = "" or iconcolor = "ERROR")
    iconcolor = 0x8e5aff
if(brightness = "" or brightness = "ERROR")
    brightness := 0.7
SplitRGBColor(bc, red, green, blue)
SplitRGBColor(textcolor, red1, green1, blue1)
SplitRGBColor(iconcolor, red2, green2, blue2)
SetWorkingDir, %DataPath%
IfNotExist, %A_AppData%\musicplayer\
    FileCreateDir, %A_AppData%\musicplayer\
IfNotExist, %A_AppData%\musicplayer\Data\
    FileCreateDir, %A_AppData%\musicplayer\Data
IfNotExist, %A_AppData%\musicplayer\Pic\
    FileCreateDir, %A_AppData%\musicplayer\Pic
IfNotExist, %A_AppData%\musicplayer\Files\
    FileCreateDir, %A_AppData%\musicplayer\Files
dllPath = %A_AppData%\musicplayer\Files\MediaInfo64.dll
IfNotExist, %dllPath%
    FileInstall, MediaInfo64.dll, %dllpath%, 1
ffmpegpath = %A_AppData%\musicplayer\Files\ffmpeg.exe
IfNotExist, %ffmpegpath%
    FileInstall, ffmpeg.exe, %ffmpegpath%, 1
if !oMI := new Mediainfo(dllPath)
    FileInstall, MediaInfo64.dll, %dllpath%, 1
if !oMI := new Mediainfo(dllPath)
{
    FileInstall, MediaInfo64.dll, %A_Desktop%\MediaInfo64.dll, 1
    msgbox, can't install "MediaInfo64.fll" to "%dllpath%".`nPlease install manual from "%A_Deskop%\MediaInfo64.dll" to "%dllpath%" then relaunch the app!
    Clipboard := dllPath
}
fullscreen = 0
Args := A_Args.1
FileDelete, %DataPath%\last.txt
if(Args = "") {
    IniRead, current, %config%, config, last
    if(current = "" or current = "ERROR") {
        current = 0
    }
}
else {
    current := Args
    IniWrite, %current%, %config%, config, last
}
IniRead, looptoggle, %config%, loop, 1
if(looptoggle = "" or looptoggle = "ERROR")
    looptoggle = 0
IniRead, shuffletoggle, %config%, shuffle, 1
if(shuffletoggle = "" or shuffletoggle = "ERROR")
    shuffletoggle = 0
font1 := New CustomFont(A_ScriptDir . "\font.ttf")
;include
#include %A_ScriptDir%\Lib\cursor.ahk
#include %A_ScriptDir%\Lib\Pic.ahk
#include %A_ScriptDir%\Lib\other.ahk
#include %A_ScriptDir%\Lib\tooltip.ahk
#include %A_ScriptDir%\Lib\MediaInfo.ahk
#include %A_ScriptDir%\Lib\icon.ahk
#include %A_ScriptDir%\Lib\Gdip_All.ahk
;settings Gui
Gui, settings:color, %bc%
global settings
Gui, settings: font, s11, Sunny Spells Basic
Gui, settings:+Alwaysontop +ToolWIndow +hwndsettings +E0x02000000 +E0x00080000
Gui, settings:Add, Text, csilver x10 w255 y32 h18 backgroundtrans left -wrap, Background color:
Gui, settings:Add, Progress, backgroundtrans x10 w255 y53 h10 cFF0000 vred range0-255, %red%
Gui, settings:Add, Progress, backgroundtrans x10 w255 y65 h10 c00FF00 vgreen range0-255, %green%
Gui, settings:Add, Progress, backgroundtrans x10 w255 y77 h10 c0000FF vblue range0-255, %blue%
Gui, settings:Add, Text, csilver x10 w255 y132 h18 backgroundtrans left -wrap, Text color:
Gui, settings:Add, Progress, backgroundtrans x10 w255 y153 h10 cFF0000 vred1 range0-255, %red1%
Gui, settings:Add, Progress, backgroundtrans x10 w255 y165 h10 c00FF00 vgreen1 range0-255, %green1%
Gui, settings:Add, Progress, backgroundtrans x10 w255 y177 h10 c0000FF vblue1 range0-255, %blue1%
Gui, settings:Add, Text, csilver x10 w255 y232 h18 backgroundtrans left -wrap, Icon color:
Gui, settings:Add, Progress, backgroundtrans x10 w255 y253 h10 cFF0000 vred2 range0-255, %red2%
Gui, settings:Add, Progress, backgroundtrans x10 w255 y265 h10 c00FF00 vgreen2 range0-255, %green2%
Gui, settings:Add, Progress, backgroundtrans x10 w255 y277 h10 c0000FF vblue2 range0-255, %blue2%
Gui, settings:Add, Text, csilver x10 w255 y332 h18 backgroundtrans left -wrap, background brightness:
Gui, settings:Add, Progress, backgroundtrans x10 w200 y353 h10 cFFFFFF vbrightness range0-200, % brightness * 100
Gui, settings:Add, Text, csilver x215 w255 y347 h18 backgroundtrans left -wrap vbrightnessout, %brightness%
backgroundcolor2 := RGB(red) . RGB(green) .  RGB(blue)
gray := getinvertgrayhex("0x" . backgroundcolor2)
if between(gray, 0, 140)
    Gui, settings:add, Progress, vcolor x10 y90 w255 h25 c%backgroundcolor2% background000000, 100
else
    Gui, settings:add, Progress, vcolor x10 y90 w255 h25 c%backgroundcolor2% backgroundFFFFFF, 100
textcolor2 := RGB(red1) . RGB(green1) .  RGB(blue1)
gray := getinvertgrayhex("0x" . textcolor2)
if between(gray, 0, 140)
    Gui, settings:add, progress, vcolor1 x10 y190 w255 h25 c%textcolor2% background000000, 100
else
    Gui, settings:add, progress, vcolor1 x10 y190 w255 h25 c%textcolor2% backgroundFFFFFF, 100
iconcolor2 := RGB(red2) . RGB(green2) .  RGB(blue2)
gray := getinvertgrayhex("0x" . iconcolor2)
if between(gray, 0, 140)
    Gui, settings:add, progress, vcolor2 x10 y290 w255 h25 c%iconcolor2% background000000, 100
else
    Gui, settings:add, progress, vcolor2 x10 y290 w255 h25 c%iconcolor2% backgroundFFFFFF, 100
Gui, settings:Add, Text, csilver x10 w255 y375 h18 backgroundtrans left -wrap, Themes:
pbitmaptemp := DrawTextCube(81,30,"purple", 0xFF202020, "0xFF" . substr(bc, 3), 0xFFbc67fc, 0xFFCC77FF, 2, 8, 13)
Gui, settings:Add, Pic, x8 y400 w81 h30 backgroundtrans gthemepurple vthemepurple, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pbitmaptemp)
Gdip_DisposeImage(pbitmaptemp)
pbitmaptemp := DrawTextCube(81,30,"Blue-violet", 0xFF202020, "0xFF" . substr(bc, 3), 0xFF8f6bff, 0xFF8866FF, 2, 8, 13)
Gui, settings:Add, Pic, x97 y400 w81 h30 backgroundtrans gthemeblueviolet vthemeblueviolet, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pbitmaptemp)
Gdip_DisposeImage(pbitmaptemp)
pbitmaptemp := DrawTextCube(81,30,"blue", 0xFF151515, "0xFF" . substr(bc, 3), 0xFF9db7ff, 0xFF7799FF, 2, 8, 13)
Gui, settings:Add, Pic, x186 y400 w81 h30 backgroundtrans gthemeblue vthemeblue, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pbitmaptemp)
Gdip_DisposeImage(pbitmaptemp)
pbitmaptemp := DrawTextCube(81,30,"cyan", 0xFF0c0c0c, "0xFF" . substr(bc, 3), 0xFFb0ffd7, 0xFF55DDFF, 2, 8, 13)
Gui, settings:Add, Pic, x8 y435 w81 h30 backgroundtrans gthemecyan vthemecyan, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pbitmaptemp)
Gdip_DisposeImage(pbitmaptemp)
pbitmaptemp := DrawTextCube(81,30,"green", 0xFF080808, "0xFF" . substr(bc, 3), 0xFFb1ffac, 0xFF55FF66, 2, 8, 13)
Gui, settings:Add, Pic, x97 y435 w81 h30 backgroundtrans gthemegreen vthemegreen, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pbitmaptemp)
Gdip_DisposeImage(pbitmaptemp)
pbitmaptemp := DrawTextCube(81,30,"white", 0xFF0F0F0F, "0xFF" . substr(bc, 3), 0xFFFFFFFF, 0xFFC0C0C0, 2, 8, 13)
Gui, settings:Add, Pic, x186 y435 w81 h30 backgroundtrans gthemewhite vthemewhite, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pbitmaptemp)
Gdip_DisposeImage(pbitmaptemp)
;Playlist select Gui
gui, 2:font, c%textcolor% s9, courier new
Gui, 2:color, %bc%
GUi, 2:Default
Gui, 2:+OwnDialogs +ToolWindow +hwndPlaylistselect
Gui, 2:Add, listview, AltSubmit x10 y10 w250 h180 vlist2 -hdr background%bc% c%textcolor% glist2 -multi, name|Date created
LV_ModifyCol(1,130)
LV_ModifyCol(2,114)
Gui, 2:Add, edit, x10 y200 h30 w145 vedit2 c000000, Playlist
Gui, 2:Add, Button, x160 w100 h30 y200 c000000 gcreate, Create
Gui, 2:Add, Button, x10 w250 h30 y240 c000000 vaddto gselect, Add To Playlist
;menu Gui
GUi, Menu:+alwaysontop -caption +hwndMenuID
gui, Menu:font, c%textcolor% s9, courier new
gui, Menu:color, %bc%
GUi, Menu:Add, text, x5 backgroundtrans y5 w200 h15 c%textcolor% left vlikelist glike, Add song to favourites
GUi, Menu:Add, text, x5 backgroundtrans y25 w200 h15 c%textcolor% left vAm gAdd, Add song to Playlist
GUi, Menu:Add, text, x5 backgroundtrans y45 w200 h15 c%textcolor% left gPause2 vpm, Pause
Gui, Menu:Add, Progress, x0 y64 w200 h2 background%textcolor% c%textcolor%, 100
GUi, Menu:Add, text, x5 backgroundtrans y70 w200 h15 c%textcolor% left gHide vHide, Hide MusicPlayer
Gui, Menu:Add, Progress, x0 y89 w200 h2 background%textcolor% c%textcolor%, 100
GUi, Menu:Add, text, x5 backgroundtrans y95 w200 h15 c%textcolor% left gGuiClose vmenuexit, Exit MusicPlayer
;Youtube Gui
gui, Youtube:+hwndYoutube -caption +E0x02000000 +E0x00080000
YoutubeGuiWidth := (128 * 5) + 50
YoutubeGuiHeight := 254
xtemp = 5
ytemp = 40
ytemp2 = 112
gui, Youtube:color, %bc%
loop, 10
{
    if(A_Index = 6) {
        ytemp += 102
        ytemp2 += 102
        xtemp = 5
    }
    Gui, Youtube:Add, Pic, w128 h72 x%xtemp% y%ytemp% vimage%A_Index% gYoutubeimage backgroundtrans,
    Gui, Youtube:Add, Text, w128 h20 x%xtemp% y%ytemp2% vtext%A_Index% gYoutubeimage backgroundtrans c%textcolor% -wrap,
    xtemp += 138
}
;menu
IfNotExist, %DataPath%\musicplayer\Pic\
{
    FileCreateDir, %A_AppData%\musicplayer\Pic
    FileInstall, empty.ico, %A_AppData%\musicplayer\Pic\empty.ico
}
IfNotExist, %A_AppData%\musicplayer\Pic\empty.ico
{
    FileInstall, empty.ico, %A_AppData%\musicplayer\Pic\empty.ico
}
Menu, Tray, Icon, %A_AppData%\musicplayer\Pic\empty.ico
Menu, Tray, NoStandard
menu, cover, add, Save cover as..., getcover
menu, cover, add, Save cover to clipboard, getcover2
menu, cover, add, search cover on Youtube, Youtube
menu, main, add, Add folder to library, addfolder
likename = Add song to liked songs
menu, list, add, Add song to current queue, addtoqueue
menu, list, add, remove from this list, removefromlist
menu, list, add, Add song to liked songs, like2
menu, list, add, Open file location, openlocation
menu, list, add, Add to Playlist, add
menu, list, add, Add folder to library, addfolder
menu, playlist, add, Delete playlist, removeplaylist
menu, playlist, add, create Playlist, createnew
menu, playlist2, add, create Playlist, createnew
;Gui
gui, 1:font, s13, Sunny Spells Basic
;gui, 1:font, Q3 Roboto s8
GuiWidth := 960 ;round(A_ScreenWidth / 2)
GuiHeight := 540 ;round(A_ScreenHeight / 2)
xposgui := (A_ScreenWidth - GuiWidth) / 2
yposgui := (A_ScreenHeight - GuiHeight) / 2
listwidth := GuiWidth - 245
listheight := GuiHeight - 90
coverxpos:= listwidth + 65
coverwidth := GuiWidth - coverxpos - 5
Col1 := floor((listwidth / 10) * 4)
Col3 := floor((listwidth / 10) * 2 - 25)
gui, 1:+hwndmusicPlayer +LastFound -caption +E0x02000000 +E0x00080000
Gui, 2:+Owner%musicPlayer%
Gui, settings:+Owner%musicPlayer%
Gui, 1:color, %bc%
Gui, 1:default
AV := ComObjCreate("WMPlayer.OCX")
;Gui, 1:Add, ActiveX, vAV x0 y0 w0 h0, WMPlayer.OCX
gui, 1:Add, listview, Background%bc% c%textcolor% x60 y35 w%listwidth% h%listheight% vlist AltSubmit -Hdr gmylistview -border hwndlistview +LV0x10000 -E0x200 +LV0x40 0x100000, Artist|Title|duration
LV_ModifyCol(1,Col1)
LV_ModifyCol(2,Col1)
LV_ModifyCol(3,Col3)
GUi, 1:add, text, x60 w6 h20 y15 background%bc% c%bc% vtexttemp,
xtemp := 66
gui, 1:Add, text, Background%bc% c%textcolor% x%xtemp% y15 w%Col1% h20 vartist2, artist:
xtemp := xtemp + Col1
gui, 1:Add, text, Background%bc% c%textcolor% x%xtemp% y15 w%Col1% h20 vtitle2, title:
xtemp := xtemp + Col1
gui, 1:Add, text, Background%bc% c%textcolor% x%xtemp% y15 w%Col3% h20 vduration2, duration:
xtemp := xtemp + Col3
listclosedX := xtemp
pbitmap := Gdip_CreateBitmap(20, 20)
brush := Gdip_BrushCreateSolid("0xFF" . substr(bc, 3))
pen := Gdip_CreatePen("0xFF" . substr(textcolor,3), 2)
G := Gdip_GraphicsFromImage(pbitmap), Gdip_SetSmoothingMode(G3, 4)
Gdip_FillRectangle(G, brush, 0, 0, 20, 20)
Gdip_DrawLine(G, Pen, 3, 3, 17, 17)
Gdip_DrawLine(G, Pen, 17, 3, 3, 17)
hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0xff . bc)
Gui, Add, pic, x%xtemp% y15 w20 h20 background%bc% gcloselist vcloselist, hbitmap: %hbitmap%
Gdip_DisposeImage(pBitmap)
Gdip_DeleteBrush(Brush)
Gdip_DeletePen(Pen)
Gdip_DeleteGraphics(G)
DeleteObject(hbitmap)
ytemp := 20 + coverwidth
titleypos := ytemp
Gui, 1:Add, text, Backgroundtrans c%textcolor% x%coverxpos% y%titleypos% w%coverwidth% h40 vtitle hwndtitletext2 -wrap, title:
ytemp += 40
artistypos := ytemp
Gui, 1:Add, text, Backgroundtrans c%textcolor% x%coverxpos% y%artistypos% vartist w%coverwidth% h40 -wrap gartist, artist:
ytemp += 40
albumypos := ytemp
Gui, 1:Add, text, Backgroundtrans c%textcolor% x%coverxpos% y%albumypos% valbum w%coverwidth% h40 -wrap, album:
gui, 1:Add, Pic, Backgroundtrans x0 y30 w60 h60 vPlaying gPlayview, % "hBitmap:" Playing_png()
gui, 1:Add, Pic, Backgroundtrans x0 y100 w60 h60 valllist glistview, % "hBitmap:" folder_png()
gui, 1:Add, Pic, Backgroundtrans x0 y170 w60 h60 vfav gfav, % "hBitmap:" favourite_png()
gui, 1:Add, Pic, Backgroundtrans x0 y240 w60 h60 vPlaylist gPlaylistview, % "hBitmap:" Playlist_png()
xtemp := listwidth + 62
ytemp := listheight
Gui, 1:Add, Pic, x%xtemp% y%ytemp% w30 h30 backgroundtrans grefresh vrefresh, % "hBitmap:" refresh_png()
ytemp -= 35
Gui, 1:Add, Pic, x%xtemp% y%ytemp% w30 h30 backgroundtrans gsettings vsettings, % "hBitmap:" settings_png()
ytemp += 2
xtemp += 35
Gui, 1:Add, Text, x%xtemp% y%ytemp% h20 w200 backgroundtrans c%textcolor% vtimeneed,
xtemp := (GuiWidth / 2) - 130
ytemp := GuiHeight - 35
gui, 1:add, pic, backgroundtrans x%xtemp% y%ytemp% w30 h30 vlike glike, % "hBitmap:" like_png()
xtemp := (GuiWidth / 2) - 95
if looptoggle
    gui, 1:add, pic, backgroundtrans x%xtemp% y%ytemp% w30 h30 vloop gloop, % "hBitmap:" loop2_png()
else
    gui, 1:add, pic, backgroundtrans x%xtemp% y%ytemp% w30 h30 vloop gloop, % "hBitmap:" loop_png()
xtemp := (GuiWidth / 2) - 55
gui, 1:add, pic, backgroundtrans x%xtemp% y%ytemp% w30 h30 vprev gprev, % "hBitmap:" previous_png()
xtemp += 40
gui, 1:add, pic, backgroundtrans x%xtemp% y%ytemp% w30 h30 vPause gPause, % "hBitmap:" Pause_png()
xtemp += 40
gui, 1:add, pic, backgroundtrans x%xtemp% y%ytemp% w30 h30 vnext gnext, % "hBitmap:" next_png()
xtemp += 40
if shuffletoggle
    gui, 1:add, pic, backgroundtrans x%xtemp% y%ytemp% w30 h30 vshuffle gshuffle, % "hBitmap:" shuffle2_png()
else
    gui, 1:add, pic, backgroundtrans x%xtemp% y%ytemp% w30 h30 vshuffle gshuffle, % "hBitmap:" shuffle_png()
xtemp += 35
gui, 1:add, pic, backgroundtrans x%xtemp% y%ytemp% w30 h30 vadd gadd, % "hBitmap:" Add_png()
gui, 1:add, pic, backgroundtrans x80 y%ytemp% w30 h30 vsearch gsearch, % "hBitmap:" search_png()
gui, 1:add, pic, backgroundtrans x15 y5 w30 h20 vback gloadsongs hidden, % "hBitmap:" back_png()
gui, 1:add, edit, background%bc% c000000 x115 y%ytemp% w80 h30 vedit,
ytemp += 2
ResultX := 200
ResultY := ytemp
Gui, 1:Add, text, backgroundtrans x200 y%ytemp% h20 w100 vresults c%textcolor%, 0 songs
gui, 1:add, text, +0x9 c%textcolor% x10 y%ytemp% w50 h20 vcurrenttime center +backgroundtrans, 00:00
ytemp += 4
xtemp := GuiWidth - 85
gui, 1:add, pic, c%textcolor% x%xtemp% y%ytemp% w14 h14 +backgroundtrans gfullscreen vfull, % "hBitmap:" fullscreen_png()
xtemp := GuiWidth - 195
ytemp += 5
IniRead, currvolume, %config%, volume, 1
if(currvolume = "" or currvolume = "ERROR")
    currVolume = 90
Gui, 1:add, progress, x%xtemp% y%ytemp% w100 h4 background%bc% c%textcolor% vProgressvolume range1-100, %currVolume%
ytemp -= 9
xtemp := GuiWidth - 60
gui, 1:add, text, x%xtemp% y%ytemp% w50 h20 -border backgroundtrans vfulltime center c%textcolor%, 00:00
ytemp -= 15
titleypos2 := ytemp - 130
artistypos2 := ytemp - 90
albumypos2 := ytemp - 50
gui, 1:add, progress, x0 y%ytemp% w%GuiWidth% h5 background%bc% c%textcolor% range0-%GuiWidth% vprogress hwndprogressbar, 0
Gui, 1:Add, picture, vcover x%coverxpos% y15 w%coverwidth% h%coverwidth%,
ytemp := "-"floor((GuiWidth - GuiHeight) / 2)
wtemp := GuiWidth + 600
Gui, 1:Add, Picture, vbackground x0 y0 w%GuiWidth% h%GuiWidth% BackgroundTrans,
;audioInfo
AV.settings.volume := currvolume
if current != 0
    AV.Url := current
else
{
    media = 0
    gosub, pause2
}
length2 := FormatSeconds(length)
GuiControl, 1:, fulltime, %length2%
AV.Settings.setMode("loop" ,false)
settimer, slider, 50
ImageListID2 := IL_Create("","",1)
LV_SetImageList(ImageListID2, 1)
get(current)
GuiControl, 1:, fulltime, % FormatSeconds(exactduration)
cover()
;;;;;;;;;
gui, 1:show, w%GuiWidth% h%GuiHeight% x%xposgui% y%yposgui% , MusicPlayer
font0 := New LOGFONT(titletext2)
FrameShadow(musicPlayer)
SetWindowTheme(musicPlayer)
OnMessage(0x200, "WM_MOUSEMOVE")
OnMessage(0x201, "WM_LBUTTONDOWN")
OnMessage(0x404, "WM_ICONCLICKNOTIFY")
OnMessage(0x100, "WM_KEYDOWN")
LV_SetExplorerTheme(listview)
ImageListID := IL_Create("","",1)
temp := loadsongs(songs)
LV_SetImageList(ImageListID, 1)
ToolTipFont("s7")
ToolTipColor("252525", "%textcolor%")
Return

hide:
if not hidden
{
    Gui, 1:Hide
    Gui, settings:hide
    Gui, 2:Hide
    Gui, Menu:Hide
    Gui, Youtube:Hide
    settimer, removecontextmenu, Off
    restorecursors()
    GuiControl,menu:,hide,Show Musicplayer
    hidden = 1
}
else {
    gui, 1:show, w%GuiWidth% h%GuiHeight% x%xposgui% y%yposgui%, MusicPlayer
    Gui, 1:-0x8000000
    FrameShadow(musicPlayer)
    SetWindowTheme(musicPlayer)
    restorecursors()
    GuiControl,menu:,hide,Hide Musicplayer
    hidden = 0
    Gui, Menu:Hide
    settimer, removecontextmenu, Off
}
return

artist:
if working
{
    tooltip, App is currently loarding, please wait
    settimer, tooltipoff, 800
    return
}
artistnow := artistoriginal
LV_Delete()
FileRead, listfull, %songs%
RegExReplace(artistnow, "\,",, n)
if(n > 0) {
    currentview = 7
    GuiControl, 1:show, back
    LV_Delete()
    foundsearch = 0
    GuiControl, 1:, results, 0 results
    IL_Destroy(ImageListID)
    ImageListID := IL_Create("","", 1)
    loop, parse, artistnow, `,
    {
        artistname := A_LoopField
        if artistname =
            continue
        loop {
            temp := substr(artistname, 1, 1)
            if(temp = " ")
                artistname := substr(artistname, 2)
            else
                break
        }
        pBitmaplist := empty2_png()
        hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmaplist)
        IL_Add(ImageListID, "hbitmap: " hbitmap, foundsearch)
        Gdip_DisposeImage(pBitmaplist)
        LV_Add("icon" foundsearch, A_LoopField)
    }
}
else {
    searchartist(artistnow)
}
return

searchartist(artistnow) {
    GuiControl, 1:show, back
    currentview = 6
    start := A_TickCount
    FileRead, listfull, %songs%
    LV_Delete()
    foundsearch = 0
    GuiControl, 1:, results, 0 results
    IL_Destroy(ImageListID)
    ImageListID := IL_Create("","", 1)
    File := Fileopen(DataPath . "\search.txt", "W")
    loop, parse, listfull, `n
    {
        if(A_LoopField != "")
        {
            var := substr(A_LoopField, instr(A_LoopField, "/", 0, 1, 2) + 1)
            var := substr(var, 1, instr(var, "/") - 1)
            If var contains %artistnow%
            {
                foundsearch += 1
                loop, parse, A_LoopField, /
                {
                    if(A_Index = 1) {
                        oMI.Open(A_LoopField)
                        base64 := oMI.GetInfo("general", "Cover_Data")
                        oMI.close()
                        if !base64
                        {
                            pBitmaplist := empty2_png()
                        }
                        else {
                            pBitmaplist := scaleimagefull(Gdip_BitmapFromBase64(base64),64)
                        }
                        hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmaplist)
                        IL_Add(ImageListID, "hbitmap: " hbitmap, foundsearch)
                        Gdip_DisposeImage(pBitmaplist)
                    }
                    if(A_index = 2)
                        titleload := A_LoopField
                    if(A_index = 3)
                        artistload := A_LoopField
                    if(A_index = 4)
                        durationload := A_LoopField
                }
                length3 := FormatSeconds(durationload)
                LV_Add("icon" foundsearch,artistload,titleload,length3)
                File.write(A_LoopField . "`n")
                GuiControl, 1:, results, %foundsearch% results
                time := (A_TickCount - start) / 1000
                GuiControl,1:,timeneed, % SubStr(time, 1, InStr(time, ".") - 1) . "." . substr(time, instr(time, ".") + 1, 2) . " seconds needed"
            }
        }
    }
    file.Close()
    LV_SetImageList(ImageListID, 1)
    if foundsearch = 0
        GuiControl, 1:, results, %foundsearch% results
    time := (A_TickCount - start) / 1000
    GuiControl,1:,timeneed, % SubStr(time, 1, InStr(time, ".") - 1) . "." . substr(time, instr(time, ".") + 1, 2) . " seconds needed"
    settimer, removetimeneed, 500
    working = 0
    listfull =
}

addtoqueue:
working = 1
if currentview = 2
{
    currentPlaylisttemp := songs
}
else if currentview = 3
{
    currentPlaylisttemp = %dataPath%\fav.txt
}
else if currentview = 5
{
    currentPlaylisttemp := currentPlaylist2
}
else if currentview = 6
{
    currentPlaylisttemp = %dataPath%\search.txt
}
else if(currentview = 8) {
    currentPlaylisttemp := queue
}
index3 = 0
rows := LV_GetCount("Selected")
if rows != 1
    max := rownumber3 + rows - 1
FileRead, listfull, %currentPlaylisttemp%
index = 0
listfull2 =
loop, parse, listfull, `n
{
    index := A_Index
    if(A_LoopField != "")
        index3 += 1
    if index3 between %rownumber3% and %max%
    {
        path := substr(A_LoopField, 1, instr(A_LoopField, "/") - 1)
        listfull2 = %listfull2%%path%`n
    }
    if(index3 > max)
        break
}
sort, listfull2, R `n
loop, parse, listfull2, `n
    addsongtoqueue(A_LoopField)
listfull =
working = 0
return

addsongtoqueue(path2) {
    FileRead, listfull, %queue%
    index3 = 0
    listfull2 =
    loop, parse, listfull, `n
    {
        path := substr(A_LoopField, 1, instr(A_LoopField, "/") - 1)
        if(path = path2)
            continue
        listfull2 = %listfull2%%A_LoopField%`n
        path := substr(A_LoopField, 1, instr(A_LoopField, "/") - 1)
        if path contains %current%
        {
            oMI.Open(path2)
            durationload := floor(oMI.GetInfo("general", "Duration") / 1000)
            if(durationload < 5)
                continue
            foundsearch += 1
            artistload := oMI.GetInfo("general", "Artist")
            if !artistload
            {
                titleload := OutFileName
                IfInString, Titleload, -
                {
                    loop, parse, titleload, -
                    {
                        if A_Index = 1
                        {
                            artistload := A_LoopField
                        }
                        Else if A_Index = 2
                        {
                            titleload := A_LoopField
                        }
                    }
                }
                else {
                    artistload = <unknown>
                }
            }
            else {
                titleload := oMI.GetInfo("general", "Title")
            }
            listfull2 = %listfull2%%path2%/%titleload%/%artistload%/%durationload%`n
        }
    }
    File := FileOpen(queue, "W")
    file.write(listfull2)
    file.Close()
    listfull2 =
    listfull =
}

themepurple:
if working
    return
working = 1
bc := themepurple[1]
textcolor := themepurple[2]
iconcolor := themepurple[3]
redrawprogress()
redrawbackground()
redrawtext()
redrawicons()
savecolors()
working = 0
return
themeblue:
if working
    return
working = 1
bc := themeblue[1]
textcolor := themeblue[2]
iconcolor := themeblue[3]
redrawprogress()
redrawbackground()
redrawtext()
redrawicons()
savecolors()
working = 0
return
themecyan:
if working
    return
working = 1
bc := themecyan[1]
textcolor := themecyan[2]
iconcolor := themecyan[3]
redrawprogress()
redrawbackground()
redrawtext()
redrawicons()
savecolors()
working = 0
return
themewhite:
if working
    return
working = 1
bc := themewhite[1]
textcolor := themewhite[2]
iconcolor := themewhite[3]
redrawprogress()
redrawbackground()
redrawtext()
redrawicons()
savecolors()
working = 0
return
themegreen:
if working
    return
working = 1
bc := themegreen[1]
textcolor := themegreen[2]
iconcolor := themegreen[3]
redrawprogress()
redrawbackground()
redrawtext()
redrawicons()
savecolors()
working = 0
return
themeblueviolet:
if working
    return
working = 1
bc := themeblueviolet[1]
textcolor := themeblueviolet[2]
iconcolor := themeblueviolet[3]
redrawprogress()
redrawbackground()
redrawtext()
redrawicons()
savecolors()
working = 0
return

settings:
WinGetPos, X, Y,,,ahk_id %musicplayer%
if(x != "") {
    x := x + StrReplace((GuiWidth - 275) / 2, "-", "")
    y := y + StrReplace((GuiHeight - 485) / 2, "-", "")
    Gui, settings:show, w275 h485 x%x% y%y%, Settings
}
else {
    Gui, settings:show, w275 h485, Settings
}
restorecursors()
Gui, 1:+0x8000000
return

settingsGuiClose:
Gui, 1:-0x8000000
Gui, settings:Hide
WinActivate, ahk_id %musicplayer%
return

redrawprogress() {
    SplitRGBColor(bc, R, G, B)
    GuiControl, settings:, red, %R%
    GuiControl, settings:, green, %G%
    GuiControl, settings:, blue, %B%
    GuiControl, settings:+c%bc%, color
    gray := getinvertgrayhex(bc)
    if between(gray, 0, 140)
        GuiControl, settings:+background000000, color
    else
        GuiControl, settings:+backgroundFFFFFF, color
    SplitRGBColor(textcolor, R, G, B)
    GuiControl, settings:, red1, %R%
    GuiControl, settings:, green1, %G%
    GuiControl, settings:, blue1, %B%
    GuiControl, settings:+c%textcolor%, color1
    gray := getinvertgrayhex(textcolor)
    if between(gray, 0, 140)
        GuiControl, settings:+background000000, color1
    else
        GuiControl, settings:+backgroundFFFFFF, color1
    SplitRGBColor(iconcolor, R, G, B)
    GuiControl, settings:, red2, %R%
    GuiControl, settings:, green2, %G%
    GuiControl, settings:, blue2, %B%
    GuiControl, settings:+c%iconcolor%, color2
    gray := getinvertgrayhex(iconcolor)
    if between(gray, 0, 140)
        GuiControl, settings:+background000000, color2
    else
        GuiControl, settings:+backgroundFFFFFF, color2
}

savecolors() {
    IniWrite, %bc%, %config%, bc, 1
    IniWrite, %textcolor%, %config%, textcolor, 1
    IniWrite, %iconcolor%, %config%, iconcolor, 1
}

redrawicons() {
    GuiControl,1:,playing, % "hbitmap: " playing_png()
    GuiControl,1:,alllist, % "hbitmap: " folder_png()
    GuiControl,1:,fav, % "hbitmap: " favourite_png()
    GuiControl,1:,playlist, % "hbitmap: " playlist_png()
    if media
        GuiControl,1:,pause, % "hbitmap: " play_png()
    else
        GuiControl,1:,pause, % "hbitmap: " pause_png()
    GuiControl,1:,next, % "hbitmap: " next_png()
    GuiControl,1:,prev, % "hbitmap: " previous_png()
    if liked
        GuiControl,1:,like, % "hbitmap: " like2_png()
    else
        GuiControl,1:,like, % "hbitmap: " like_png()
    GuiControl,1:,shuffle, % "hbitmap: " shuffle_png()
    GuiControl,1:,loop, % "hbitmap: " loop_png()
    GuiControl,1:,full, % "hbitmap: " fullscreen_png()
    GuiControl,1:,add, % "hbitmap: " add_png()
    GuiControl,1:,search, % "hbitmap: " search_png()
    GuiControl,1:,refresh, % "hbitmap: " refresh_png()
    GuiControl,1:,settings, % "hbitmap: " settings_png()
}

redrawtext() {
    controls = list.artist.artist2.title.title2.album.duration2.currenttime.fulltime.timeneed.results.progress.progressvolume
    loop, parse, controls, .
    {
        GuiControl, 1:+c%textcolor%, %A_LoopField%
        GuiControlget, temp, 1:, %A_LoopField%
        GuiControl, 1:, %A_LoopField%, %temp%
    }
    controls = pm.Am.Hide.menuexit.likelist
    loop, parse, controls, .
    {
        GuiControl, Menu:+c%textcolor%, %A_LoopField%
        GuiControlGet, temp, Menu:, %A_LoopField%
        GuiControl, Menu:, %A_LoopField%, %temp%
    }
   ; GuiControlget, temp, 1:, results
    ;GuiControl, 1:, list,
    ;GuiControl, 1:, artist, %artist%
    ;GuiControl, 1:, artist2, artist:
    ;GuiControl, 1:, title, %title%
    ;GuiControl, 1:, title2, title:
    ;GuiControl, 1:, album, %album%
    ;GuiControl, 1:, duration2, duration:
    ;GuiControl, 1:, currenttime, % FormatSeconds(AV.controls.currentPosition)
    ;GuiControl, 1:, fulltime, % FormatSeconds(length)
    ;GuiControl, 1:, timeneed, 
    ;GuiControl, 1:, results, %temp%
    ;GuiControl, 1:, progressvolume, % AV.Settings.volume
    if not listclosed
    {
        pbitmap := Gdip_CreateBitmap(20, 20)
        brush := Gdip_BrushCreateSolid("0xFF" . substr(bc, 3))
        pen := Gdip_CreatePen("0xFF" . substr(textcolor,3), 2)
        G := Gdip_GraphicsFromImage(pbitmap), Gdip_SetSmoothingMode(G3, 4)
        Gdip_FillRectangle(G, brush, 0, 0, 20, 20)
        Gdip_DrawLine(G, Pen, 3, 3, 17, 17)
        Gdip_DrawLine(G, Pen, 17, 3, 3, 17)
        hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0xff . bc)
        GuiControl, 1:move, closelist, x%listclosedX% y15 w20 h20
        GuiControl, 1:, closelist, hbitmap: %hbitmap%
        Gdip_DisposeImage(pBitmap)
        Gdip_DeleteBrush(Brush)
        Gdip_DeletePen(Pen)
        Gdip_DeleteGraphics(G)
        DeleteObject(hbitmap)
    }
    else {
        pbitmap := Gdip_CreateBitmap(20, 20)
        brush := Gdip_BrushCreateSolid("0xFF" . substr(bc, 3))
        pen := Gdip_CreatePen("0xFF" . substr(textcolor,3), 2)
        G := Gdip_GraphicsFromImage(pbitmap), Gdip_SetSmoothingMode(G3, 4)
        Gdip_FillRectangle(G, brush, 0, 0, 20, 20)
        Gdip_DrawRectangle(G, Pen, 3, 3, 14, 14)
        hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0xff . bc)
        GuiControl, 1:move, closelist, x5 y5 w20 h20
        GuiControl, 1:, closelist, hbitmap: %hbitmap%
        Gdip_DisposeImage(pBitmap)
        Gdip_DeleteBrush(Brush)
        Gdip_DeletePen(Pen)
        Gdip_DeleteGraphics(G)
        DeleteObject(hbitmap)
    }
}

redrawbackgroundbrightness() {
    oMI.Open(current)
    base64 := oMI.GetInfo("general", "Cover_Data")
    GDIP_disposeimage(BlurBitmap)
    if !base64
    {
        pBitmap := empty_png()
        Gdip_SaveBitmapToFile(pBitmap, cover, 100)
        Gdip_SaveBitmapToFile(pBitmap, cover2, 100)
    }
    else {
        pBitmap := Gdip_BitmapFromBase64(base64)
    }
    oMI.close()
    BlurBitmap2 := Gdip_BlurBitmap( pBitmap , 100, 2)
    BlurBitmap4 := Gdip_BlurBitmap( BlurBitmap2 , 100, 2)
    BlurBitmap3 := FitFullSize2(BlurBitmap4, GuiWidth * 1.5, GuiHeight * 1.5)
    BlurBitmap := Gdip_CreateBitmap(GuiWidth, GuiHeight)
    G3 := Gdip_GraphicsFromImage(BlurBitmap), Gdip_SetSmoothingMode(G3, 2)
    matrix = %brightness%|0|0|0|0|0|%brightness%|0|0|0|0|0|%brightness%|0|0|0|0|0|1|0|0.01|0.01|0.01|0|1
    GDIP_drawimage(G3, BlurBitmap3,0,0,GuiWidth, GuiHeight,GuiWidth / 4,GuiHeight / 4,GuiWidth,GuiHeight, matrix)
    if currentview != 1
    {
        hbitmap := Gdip_CreateHBITMAPFromBitmap(blurbitmap, "0xFF" . substr(bc, 3))
        gettextcolor(BlurBitmap)
        guiControl,1:,background, % "hbitmap: " hbitmap
    }
    Gdip_DeleteGraphics(G3)
    Gdip_DisposeImage( pBitmap )
    Gdip_DisposeImage(BlurBitmap2)
    Gdip_DisposeImage(BlurBitmap3)
    Gdip_DisposeImage(BlurBitmap4)
    ;Gdip_DisposeImage( BlurBitmap )
    DeleteObject( DispalyBitmapBlur )
}

redrawbackground() {
    start := A_TickCount
    GuiControl, 1:+background%bc%, title2
    GuiControl, 1:+background%bc%, artist2
    GuiControl, 1:+background%bc%, album2
    GuiControl, 1:+background%bc%, texttemp
    GuiControl, 1:+background%bc%, list
    GuiControl, 1:+background%bc%, progress
    GuiControl, 1:+background%bc%, progressvolume
    GuiControl, 1:+background%bc%, edit
    GuiControl, 1:+background%bc%, cover
    pbitmaptemp := DrawTextCube(81,30,"purple", 0xFF202020, "0xFF" . substr(bc, 3), 0xFFbc67fc, 0xFFCC77FF, 2, 8, 13)
    GuiControl, settings:, themepurple, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pbitmaptemp)
    Gdip_DisposeImage(pbitmaptemp)
    pbitmaptemp := DrawTextCube(81,30,"Blue-violet", 0xFF202020, "0xFF" . substr(bc, 3), 0xFF8f6bff, 0xFF8866FF, 2, 8, 13)
    GuiControl, settings:, themeblueviolet, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pbitmaptemp)
    Gdip_DisposeImage(pbitmaptemp)
    pbitmaptemp := DrawTextCube(81,30,"blue", 0xFF151515, "0xFF" . substr(bc, 3), 0xFF9db7ff, 0xFF7799FF, 2, 8, 13)
    GuiControl, settings:, themeblue, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pbitmaptemp)
    Gdip_DisposeImage(pbitmaptemp)
    pbitmaptemp := DrawTextCube(81,30,"cyan", 0xFF0c0c0c, "0xFF" . substr(bc, 3), 0xFFb0ffd7, 0xFF55DDFF, 2, 8, 13)
    GuiControl, settings:, themecyan, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pbitmaptemp)
    Gdip_DisposeImage(pbitmaptemp)
    pbitmaptemp := DrawTextCube(81,30,"green", 0xFF080808, "0xFF" . substr(bc, 3), 0xFFb1ffac, 0xFF55FF66, 2, 8, 13)
    GuiControl, settings:, themegreen, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pbitmaptemp)
    Gdip_DisposeImage(pbitmaptemp)
    pbitmaptemp := DrawTextCube(81,30,"white", 0xFF0F0F0F, "0xFF" . substr(bc, 3), 0xFFFFFFFF, 0xFFC0C0C0, 2, 8, 13)
    GuiControl, settings:, themewhite, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pbitmaptemp)
    Gdip_DisposeImage(pbitmaptemp)
    Gui, 1:color, %bc%
    Gui, 2:color, %bc%
    Gui, menu:color, %bc%
    Gui, Youtube:color, %bc%
    Gui, settings:color, %bc%
    if not listclosed
    {
        pbitmap := Gdip_CreateBitmap(20, 20)
        brush := Gdip_BrushCreateSolid("0xFF" . substr(bc, 3))
        pen := Gdip_CreatePen("0xFF" . substr(textcolor,3), 2)
        G := Gdip_GraphicsFromImage(pbitmap), Gdip_SetSmoothingMode(G3, 4)
        Gdip_FillRectangle(G, brush, 0, 0, 20, 20)
        Gdip_DrawLine(G, Pen, 3, 3, 17, 17)
        Gdip_DrawLine(G, Pen, 17, 3, 3, 17)
        hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0xff . bc)
        GuiControl, 1:move, closelist, x%listclosedX% y15 w20 h20
        GuiControl, 1:, closelist, hbitmap: %hbitmap%
        Gdip_DisposeImage(pBitmap)
        Gdip_DeleteBrush(Brush)
        Gdip_DeletePen(Pen)
        Gdip_DeleteGraphics(G)
        DeleteObject(hbitmap)
    }
    else {
        pbitmap := Gdip_CreateBitmap(20, 20)
        brush := Gdip_BrushCreateSolid("0xFF" . substr(bc, 3))
        pen := Gdip_CreatePen("0xFF" . substr(textcolor,3), 2)
        G := Gdip_GraphicsFromImage(pbitmap), Gdip_SetSmoothingMode(G3, 4)
        Gdip_FillRectangle(G, brush, 0, 0, 20, 20)
        Gdip_DrawRectangle(G, Pen, 3, 3, 14, 14)
        hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0xff . bc)
        GuiControl, 1:move, closelist, x5 y5 w20 h20
        GuiControl, 1:, closelist, hbitmap: %hbitmap%
        Gdip_DisposeImage(pBitmap)
        Gdip_DeleteBrush(Brush)
        Gdip_DeletePen(Pen)
        Gdip_DeleteGraphics(G)
        DeleteObject(hbitmap)
    }
}

closelist:
if not listclosed
{
    working = 1
    GuiControl, 1:hide,artist2
    GuiControl, 1:hide,title2
    GuiControl, 1:hide,duration2
    GuiControl, 1:hide,list
    GuiControl, 1:hide,texttemp
    GuiControl, 1:show,refresh
    GuiControl, 1:show,closelist
    GuiControl, 1:show,closelist
    GuiControl, 1:hide,Playing
    GuiControl, 1:hide,alllist
    GuiControl, 1:hide,fav
    GuiControl, 1:hide,playlist
    GuiControl, 1:hide,timeneed
    GuiControl, 1:hide,results
    GuiControl, 1:hide,refresh
    pbitmap := Gdip_CreateBitmap(20, 20)
    brush := Gdip_BrushCreateSolid("0xFF" . substr(bc, 3))
    pen := Gdip_CreatePen("0xFF" . substr(textcolor,3), 2)
    G := Gdip_GraphicsFromImage(pbitmap), Gdip_SetSmoothingMode(G3, 4)
    Gdip_FillRectangle(G, brush, 0, 0, 20, 20)
    Gdip_DrawRectangle(G, Pen, 3, 3, 14, 14)
    hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0xff . bc)
    GuiControl, 1:move, closelist, x5 y5 w20 h20
    GuiControl, 1:, closelist, hbitmap: %hbitmap%
    Gdip_DisposeImage(pBitmap)
    Gdip_DeleteBrush(Brush)
    Gdip_DeletePen(Pen)
    Gdip_DeleteGraphics(G)
    DeleteObject(hbitmap)
    listclosed = 1
    working = 0
}
else {
    working = 1
    GuiControl, 1:show,artist2
    GuiControl, 1:show,title2
    GuiControl, 1:show,duration2
    GuiControl, 1:show,closelist
    GuiControl, 1:show,list
    GuiControl, 1:show,texttemp
    GuiControl, 1:show,refresh
    GuiControl, 1:show,closelist
    GuiControl, 1:show,Playing
    GuiControl, 1:show,alllist
    GuiControl, 1:show,fav
    GuiControl, 1:show,playlist
    GuiControl, 1:show,timeneed
    GuiControl, 1:show,results
    GuiControl, 1:show,refresh
    pbitmap := Gdip_CreateBitmap(20, 20)
    brush := Gdip_BrushCreateSolid("0xFF" . substr(bc, 3))
    pen := Gdip_CreatePen("0xFF" . substr(textcolor,3), 2)
    G := Gdip_GraphicsFromImage(pbitmap), Gdip_SetSmoothingMode(G3, 4)
    Gdip_FillRectangle(G, brush, 0, 0, 20, 20)
    Gdip_DrawLine(G, Pen, 3, 3, 17, 17)
    Gdip_DrawLine(G, Pen, 17, 3, 3, 17)
    hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap, 0xff . bc)
    GuiControl, 1:move, closelist, x%listclosedX% y15 w20 h20
    GuiControl, 1:, closelist, hbitmap: %hbitmap%
    Gdip_DisposeImage(pBitmap)
    Gdip_DeleteBrush(Brush)
    Gdip_DeletePen(Pen)
    Gdip_DeleteGraphics(G)
    DeleteObject(hbitmap)
    listclosed = 0
    working = 0
}
return


fullscreen:
if not fullscreen
{
    Gui, 1:Default
    Gui, 1:hide
    fullscreen = 1
    GuiWidth := A_ScreenWidth
    GuiHeight := A_ScreenHeight
    xposgui := 0
    yposgui := 0
    listwidth := GuiWidth - 240
    listheight := GuiHeight - 90
    coverxpos:= listwidth + 65
    coverwidth := GuiWidth - coverxpos - 5
    Col1 := floor((listwidth / 10) * 4)
    Col3 := floor((listwidth / 10) * 2 - 25)
    GuiControl, 1:move, list, w%listwidth% h%listheight%
    LV_ModifyCol(1,Col1)
    LV_ModifyCol(2,Col1)
    LV_ModifyCol(3,Col3)
    xtemp := 66
    GuiControl,1:move, artist2, x%xtemp% w%Col1% y15 h20
    xtemp := Col1 + xtemp
    GuiControl,1:move, title2, x%xtemp% y15 w%Col1% h20
    xtemp := xtemp + Col1
    GuiControl,1:move, duration2, x%xtemp% y15 w%Col3% h20
    xtemp := xtemp + Col3
    listclosedX := xtemp
    if not listclosed
        GuiControl,1:move,closelist, x%xtemp% y15 w20 h20
    else
        GuiControl,1:move,closelist, x5 y5 w20 h20
    if currentview != 1
    {
        ytemp := 20 + coverwidth
        titleypos := ytemp
        GuiControl,1:move, title, x%coverxpos% y%titleypos% w%coverwidth% h40
        ytemp += 40
        artistypos := ytemp
        GuiControl,1:move, artist, x%coverxpos% y%artistypos% w%coverwidth% h40
        ytemp += 40
        albumypos := ytemp
        GuiControl,1:move, album, x%coverxpos% y%albumypos% w%coverwidth% h40
    }
    else {
        titleypos3 := GuiHeight - 230
        artistypos3 := GuiHeight - 190
        albumypos3 := GuiHeight - 150
        ytemp := 20 + coverwidth
        titleypos := ytemp
        GuiControl,1:move, title, y%titleypos3% x10 w300 h40
        ytemp += 40
        artistypos := ytemp
        GuiControl,1:move, artist, y%artistypos3% x10 w300 h40
        ytemp += 40
        albumypos := ytemp
        GuiControl,1:move, album, y%albumypos3% x10 w300 h40
    }
    xtemp := listwidth + 62
    ytemp := listheight
    GuiControl,1:move, refresh, x%xtemp% y%ytemp% w30 h30
    ytemp -= 35
    GuiControl,1:move, settings, x%xtemp% y%ytemp% w30 h30
    ytemp += 2
    xtemp += 35
    GuiControl,1:move, timeneed, x%xtemp% y%ytemp% h20 w200
    xtemp := (GuiWidth / 2) - 130
    ytemp := GuiHeight - 35
    GuiControl,1:move,like, x%xtemp% y%ytemp% w30 h30
    xtemp := (GuiWidth / 2) - 95
    if looptoggle
        GuiControl,1:move,loop, x%xtemp% y%ytemp% w30 h30
    else
        GuiControl,1:move,loop, x%xtemp% y%ytemp% w30 h30
    xtemp := (GuiWidth / 2) - 55
    GuiControl,1:move,prev, x%xtemp% y%ytemp% w30 h30
    xtemp += 40
    GuiControl,1:move,pause, x%xtemp% y%ytemp% w30 h30
    xtemp += 40
    GuiControl,1:move,next, x%xtemp% y%ytemp% w30 h30
    xtemp += 40
    if shuffletoggle
        GuiControl,1:move,shuffle, x%xtemp% y%ytemp% w30 h30
    else
        GuiControl,1:move,shuffle, x%xtemp% y%ytemp% w30 h30
    xtemp += 35
    GuiControl,1:move,add, x%xtemp% y%ytemp% w30 h30
    GuiControl,1:move,search, x80 y%ytemp% w30 h30
    GuiControl,1:move,back, x15 y5 w30 h20
    GuiControl,1:move,edit, x115 y%ytemp% w80 h30
    ytemp += 5
    ResultX := 200
    ResultY := ytemp
    GuiControl,1:move,results, x200 y%ytemp% h20 w100
    GuiControl,1:move,currenttime, x10 y%ytemp% w50 h20 
    ytemp += 4
    xtemp := GuiWidth - 85
    GuiControl,1:move,full, x%xtemp% y%ytemp% w14 h14
    xtemp := GuiWidth - 195
    ytemp += 5
    IniRead, currvolume, %config%, volume, 1
    if(currvolume = "" or currvolume = "ERROR")
        currVolume = 90
    GuiControl,1:move,Progressvolume, x%xtemp% y%ytemp% w100 h4
    ytemp -= 9
    xtemp := GuiWidth - 60
    GuiControl,1:move,fulltime, x%xtemp% y%ytemp% w50 h20
    ytemp -= 15
    titleypos2 := ytemp - 130
    artistypos2 := ytemp - 90
    albumypos2 := ytemp - 50
    GuiControl,1:move,progress, x0 y%ytemp% w%GuiWidth% h5
    GuiControl, 1:+range0-%GuiWidth%, progress
    GuiControl,1:move,cover, x%coverxpos% y15 w%coverwidth% h%coverwidth%
    GuiControl,1:move,background, x0 y0 w%GuiWidth% h%GuiWidth%
    WinSet, ExStyle, -0x20000, ahk_id %progressbar%
    GuiControl, 1:,full, % "hbitmap: " fullscreen2_png()
    gui, 1:show, w%GuiWidth% h%GuiHeight% x%xposgui% y%yposgui%, MusicPlayer
    ;LV_SetExplorerTheme(listview)
    DllCall("UxTheme.dll\SetWindowTheme", "Ptr", musicplayer, "WStr", "", "WStr", "")
    cover()
}
else {
    Gui, 1:hide
    fullscreen = 0
    Gui, 1:Default
    fullscreen = 0
    GuiWidth := 960 ;A_ScreenWidth / 2
    GuiHeight := 540 ;A_ScreenHeight / 2
    xposgui := (A_ScreenWidth - GuiWidth) / 2
    yposgui := (A_ScreenHeight - GuiHeight) / 2
    listwidth := GuiWidth - 240
    listheight := GuiHeight - 90
    coverxpos:= listwidth + 65
    coverwidth := GuiWidth - coverxpos - 5
    Col1 := floor((listwidth / 10) * 4)
    Col3 := floor((listwidth / 10) * 2 - 25)
    GuiControl, 1:move, list, w%listwidth% h%listheight%
    LV_ModifyCol(1,Col1)
    LV_ModifyCol(2,Col1)
    LV_ModifyCol(3,Col3)
    xtemp := 66
    GuiControl,1:move, artist2, x%xtemp% w%Col1% y15 h20
    xtemp := Col1 + 66
    GuiControl,1:move, title2, x%xtemp% y15 w%Col1% h20
    xtemp := xtemp + Col1
    GuiControl,1:move, duration2, x%xtemp% y15 w%Col3% h20
    xtemp := xtemp + Col3
    listclosedX := xtemp
    if not listclosed
        GuiControl,1:move,closelist, x%xtemp% y15 w20 h20
    else
        GuiControl,1:move,closelist, x5 y5 w20 h20
    if currentview != 1
    {
        ytemp := 20 + coverwidth
        titleypos := ytemp
        GuiControl,1:move, title, x%coverxpos% y%titleypos% w%coverwidth% h40
        ytemp += 40
        artistypos := ytemp
        GuiControl,1:move, artist, x%coverxpos% y%artistypos% w%coverwidth% h40
        ytemp += 40
        albumypos := ytemp
        GuiControl,1:move, album, x%coverxpos% y%albumypos% w%coverwidth% h40
    }
    else {
        guicontrol, 1:move, album, y%albumypos2% x10 w300
        guicontrol, 1:move, artist, y%artistypos2% x10 w300
        guicontrol, 1:move, title, y%titleypos2% x10 w300
    }
    xtemp := listwidth + 62
    ytemp := listheight
    GuiControl,1:move, refresh, x%xtemp% y%ytemp% w30 h30
    ytemp -= 35
    GuiControl,1:move, settings, x%xtemp% y%ytemp% w30 h30
    ytemp += 2
    xtemp += 35
    GuiControl,1:move, timeneed, x%xtemp% y%ytemp% h20 w200
    xtemp := (GuiWidth / 2) - 130
    ytemp := GuiHeight - 35
    GuiControl,1:move,like, x%xtemp% y%ytemp% w30 h30
    xtemp := (GuiWidth / 2) - 95
    if looptoggle
        GuiControl,1:move,loop, x%xtemp% y%ytemp% w30 h30
    else
        GuiControl,1:move,loop, x%xtemp% y%ytemp% w30 h30
    xtemp := (GuiWidth / 2) - 55
    GuiControl,1:move,prev, x%xtemp% y%ytemp% w30 h30
    xtemp += 40
    GuiControl,1:move,pause, x%xtemp% y%ytemp% w30 h30
    xtemp += 40
    GuiControl,1:move,next, x%xtemp% y%ytemp% w30 h30
    xtemp += 40
    if shuffletoggle
        GuiControl,1:move,shuffle, x%xtemp% y%ytemp% w30 h30
    else
        GuiControl,1:move,shuffle, x%xtemp% y%ytemp% w30 h30
    xtemp += 35
    GuiControl,1:move,add, x%xtemp% y%ytemp% w30 h30
    GuiControl,1:move,search, x80 y%ytemp% w30 h30
    GuiControl,1:move,back, x15 y5 w30 h20
    GuiControl,1:move,edit, x115 y%ytemp% w80 h30
    ytemp += 5
    ResultX := 200
    ResultY := ytemp
    GuiControl,1:move,results, x200 y%ytemp% h20 w100
    GuiControl,1:move,currenttime, x10 y%ytemp% w50 h20 
    ytemp += 4
    xtemp := GuiWidth - 85
    GuiControl,1:move,full, x%xtemp% y%ytemp% w14 h14
    xtemp := GuiWidth - 195
    ytemp += 5
    IniRead, currvolume, %config%, volume, 1
    if(currvolume = "" or currvolume = "ERROR")
        currVolume = 90
    GuiControl,1:move,Progressvolume, x%xtemp% y%ytemp% w100 h4
    ytemp -= 9
    xtemp := GuiWidth - 60
    GuiControl,1:move,fulltime, x%xtemp% y%ytemp% w50 h20
    ytemp -= 15
    titleypos2 := ytemp - 130
    artistypos2 := ytemp - 90
    albumypos2 := ytemp - 50
    GuiControl,1:move,progress, x0 y%ytemp% w%GuiWidth% h5
    GuiControl, 1:+range0-%GuiWidth%, progress
    GuiControl,1:move,cover, x%coverxpos% y15 w%coverwidth% h%coverwidth%
    ytemp := "-"floor((GuiWidth - GuiHeight) / 2)
    wtemp := GuiWidth + 600
    GuiControl,1:move,background, x0 y0 w%GuiWidth% h%GuiWidth%
    WinSet, ExStyle, -0x20000, ahk_id %progressbar%
    GuiControl, 1:,full, % "hbitmap: " fullscreen_png()
    gui, 1:show, w%GuiWidth% h%GuiHeight% x%xposgui% y%yposgui%, MusicPlayer
    FrameShadow(musicPlayer)
    SetWindowTheme(musicPlayer)
    LV_SetExplorerTheme(listview)
    cover()
}
return

YoutubeGuiClose:
if working
{
    tooltip, please wait!
    return
}
Gui, Youtube:hide
Gui, 1:Show
return

YoutubeImage:
if working
    Return
working = 1
image := A_GuiControl
if image contains image
{
    path = %A_ScriptDir%\search\%image%.jpg
    IfExist, %path%
    {
        AV.Close()
        File := FileOpen(YoutubeID3, "R")
        length := file.length
        file.RawRead(out, length)
        file.close
        file := FileOpen(DataPath . "\temp.mp3", "W")
        File.RawWrite(out, length)
        file.Close()
        ;FileDelete, %YoutubeID3%
        ;FileMove, %YoutubeID3%, %DataPath%\temp.mp3, 1
        command = "%ffmpegpath%" -y -i "%DataPath%\temp.mp3" -i "%path%" -map 0:0 -map 1:0 -c copy -id3v2_version 3 -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" "%YoutubeID3%"
        Cli_RunCMD(command, A_ScriptDir)
        loop, 10
        {
            GuiControl, Youtube:, image%A_Index%,
            GuiControl, Youtube:, text%A_Index%,
        }
        if(YoutubeID3 = current) {
            current := YoutubeID3
            get(current)
            cover()
            AV.Url := current
        }
        Gui, Youtube:Hide
        Gui, 1:Show
        WinActivate, ahk_id %musicplayer%
        working = 0
        gosub, refresh
    }
}
working = 0
return

Youtube:
if working
    return
working = 1
YoutubeID3 := current
loop, 10
{
    GuiControl, Youtube:, image%A_Index%,
    GuiControl, Youtube:, text%A_Index%,
    FileDelete, %A_ScriptDir%\search\image%A_index%.jpg
}
Gui, Youtube:Show, w%YoutubeGuiWidth% h%YoutubeGuiHeight%
WinSet, Region, 0-0 w%YoutubeGuiWidth% h%YoutubeGuiHeight% r15-15, ahk_id %Youtube%
Gui, 1:Hide
text = %artistoriginal% - %titleoriginal%
searchQueryEncoded := UrlEncode(text)
searchURL = https://www.youtube.com/results?search_query=%searchQueryEncoded%
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", searchURL, false)
whr.Send()
responseText := whr.ResponseText
search1 = "url":"https://i.ytimg.com/vi/
search2 = /hq720.jpg?
search3 = "title":{"runs":[{"text":"
search4 = "}],"
search5 = "longBylineText":{"runs":[{"text":"
search6 = ","
index = 0
full =
pBitmapoverlay := Youtube_Outline_png()
loop
{
    responseText := SubStr(responseText, InStr(responseText, search1) + strlen(search1))
    link := SubStr(responseText, 1, InStr(responseText, search2) - 1)
    if(StrLen(link) > 17) {
        continue
    }
    index2 := A_Index
    if(A_Index = 30)
        break
    titleYoutube := SubStr(responseText, InStr(responseText, search3) + strlen(search3))
    artistYoutube := SubStr(titleYoutube, InStr(titleYoutube, search5) + strlen(search5))
    titleYoutube := SubStr(titleYoutube, 1, InStr(titleYoutube, search4) - 1)
    artistYoutube := SubStr(artistYoutube, 1, InStr(artistYoutube, search6) - 1)
    responseText := SubStr(responseText, InStr(responseText, search1) + strlen(search1))
    foundYoutube = 0
    loop, parse, text, %A_Space%
    {
        if(A_LoopField = "-" or A_LoopField = "") {
            continue
        }
        else if titleYoutube contains %A_LoopField%
        {
            foundYoutube = 1
            Break
        }
        else if artistYoutube contains %A_LoopField%
        {
            foundYoutube = 1
            Break
        }
    }
    if not foundYoutube
        continue
    index += 1
    URLDownloadtofile, https://i.ytimg.com/vi/%link%/maxresdefault.jpg, %A_ScriptDir%\search\image%index%.jpg
    FileGetSize, size, %A_ScriptDir%\search\image%index%.jpg, B
    if(size = 1097) {
        index -= 1
        continue
    }
    pBitmapYoutube := Gdip_CreateBitmap(128,72)
    GY := Gdip_GraphicsFromImage(pBitmapYoutube)
    pBitmapYoutube2 := Gdip_CreateBitmapFromFile(A_ScriptDir . "\search\image" . index . ".jpg")
    Gdip_DrawImage(GY,pBitmapYoutube2,0,0,128,72)
    Gdip_DrawImage(GY,pBitmapoverlay,0,0,128,72)
    GuiControl, Youtube:,image%index%, % "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pBitmapYoutube)
    GuiControl,Youtube:,text%index%,%artistYoutube% - %titleYoutube%
    Gdip_DisposeImage(pBitmapYoutube)
    Gdip_DisposeImage(pBitmapYoutube2)
    Gdip_DeleteGraphics(GY)
    if(index = 10)
        break
}
working = 0
return

refresh:
if working
{
    tooltip, App is currently loarding, please wait
    settimer, tooltipoff, 800
    return
}
if currentview = 2
{
    currentPlaylist := songs
}
else if currentview = 3
{
    currentPlaylist = %dataPath%\fav.txt
} ;;;;;;;;;;;
else if currentview = 4
{
    IL_Destroy(ImageListID)
    FileGetTime, time, %songs%, C
    ImageListID := IL_Create(1,"", 1)
    IL_Add(ImageListID, "hbitmap: " Gdip_CreateHBITMAPFromBitmap(empty2_png()), 1)
    LV_Add("icon1","all songs in library",timeconvert(time),"")
    FileGetTime, time, %queue%, C
    LV_Add("icon1","current queue",timeconvert(time),"")
    foundsearch = 0
    loop, %PlaylistDir%\*.txt, 0, 0
    {
        FileGetTime, time, %A_loopFileFullPath%, C
        stringtrimright, Playlistnamenew, A_LoopFileName, 4
        LV_Add("icon1",Playlistnamenew,timeconvert(time),"")
        foundsearch += 1
        GuiControl, 1:, results, %foundsearch% playlists
    }
    if foundsearch = 0
        GuiControl, 1:, results, %foundsearch% playlists
    LV_SetImageList(ImageListID, 1)
}
else if currentview = 5
{
    currentPlaylist := currentPlaylist2
}
else if currentview = 6
{
    currentPlaylist = %dataPath%\search.txt
}
else if(currentview = 7) {
    artistnow := artistoriginal
    currentview = 7
    GuiControl, 1:show, back
    LV_Delete()
    foundsearch = 0
    GuiControl, 1:, results, 0 results
    IL_Destroy(ImageListID)
    ImageListID := IL_Create("","", 1)
    loop, parse, artistnow, `,
    {
        artistname := A_LoopField
        if artistname =
            continue
        loop {
            temp := substr(artistname, 1, 1)
            if(temp = " ")
                artistname := substr(artistname, 2)
            else
                break
        }
        pBitmaplist := empty2_png()
        hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmaplist)
        IL_Add(ImageListID, "hbitmap: " hbitmap, foundsearch)
        Gdip_DisposeImage(pBitmaplist)
        LV_Add("icon" foundsearch, A_LoopField)
    }
}
else if(currentview = 8) {
    currentPlaylist := queue
}
workingtemp := working
working = 1
FileRead, listfull, %currentPlaylist%
SetTimer, removetimeneed, Off
start := A_TickCount
IL_Destroy(ImageListID)
LV_Delete()
ImageListID := IL_Create("", "", 1)
LV_SetImageList(ImageListID, 1)
foundsearch = 0
listfull2 =
files = 0
loop, parse, listfull, `n
{
    if A_LoopField !=
        files += 1
}
files2 = 0
extensionsload = mp3.wav.m4a.ogg.flac.avi.webm.mkv
loop, parse, listfull, `n
{
    files2 += 1
    if(A_LoopField = "")
        continue
    path := substr(A_LoopField, 1,instr(A_LoopField, "/") - 1)
    SplitPath, path, OutFileName, OutDir, OutExtension, OutNameNoExt
    if extensionsload contains %OutExtension%
    {
        oMI.Open(path)
        durationload := floor(oMI.GetInfo("general", "Duration") / 1000)
        if(durationload < 5)
            continue
        foundsearch += 1
        artistload := oMI.GetInfo("general", "Artist")
        base64 := oMI.GetInfo("general", "Cover_Data")
        if !base64
            pBitmaplist := empty2_png()
        else
            pBitmaplist := scaleimagefull(Gdip_BitmapFromBase64(base64),64)
        IL_Add(ImageListID, "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pBitmaplist), foundsearch)
        if !artistload
        {
            titleload := OutFileName
            IfInString, Titleload, -
            {
                loop, parse, titleload, -
                {
                    if A_Index = 1
                    {
                        artistload := A_LoopField
                    }
                    Else if A_Index = 2
                    {
                        titleload := A_LoopField
                    }
                }
            }
            else {
                artistload = <unknown>
            }
        }
        else {
            titleload := oMI.GetInfo("general", "Title")
        }
        listfull2 = %listfull2%%path%/%titleload%/%artistload%/%durationload%`n
        oMI.Close()
        LV_Add("icon" A_Index, artistload, titleload, FormatSeconds(durationload))
        Gdip_DisposeImage(pBitmaplist)
        GuiControl, 1:, results, scanned %files2%/%files%
        time := (A_TickCount - start) / 1000
        GuiControl,1:,timeneed, % SubStr(time, 1, InStr(time, ".") - 1) . "." . substr(time, instr(time, ".") + 1, 2) . " seconds needed"
    }
}
file := FileOPen(queue, "W")
file.Write(listfull2)
file.Close()
listfull2 =
FileRead, listfull, %currentPlaylisttemp%
if(listfull = "") {
    FileAppend, `n, %currentPlaylisttemp%
}
listfull =
listfull2 =
GuiControl, 1:, results, %foundsearch% songs
time := (A_TickCount - start) / 1000
GuiControl,1:,timeneed, % SubStr(time, 1, InStr(time, ".") - 1) . "." . substr(time, instr(time, ".") + 1, 2) . " seconds needed"
working = 0
settimer, removetimeneed, 500
return

removetimeneed:
SetTimer, removetimeneed, Off
GuiControl,1:,timeneed,
Return

checkversion:
working = 1
if(getversion() != version)
    msgbox, new version
Else
    msgbox, You are on the newest version#
working = 0
return

addfolder:
foldertoadd := SelectFolderEx("C:\users\" . A_Username . "\music\", "select folder with music files", musicplayer, "Add Files")
loadtoall(foldertoadd)
gosub, refresh
return

getcover:
pathadd = C:\users\%A_UserName%\Pictures\%titleoriginal%.png
if !pathsave := SaveFile(musicplayer, pathadd, {Image: "`n*.png;*.jpg;*.jpeg"},"")
    return
extpic = .BMP.DIB.RLE.JPG.JPEG.JPE.JFIF.GIF.TIF.TIFF.PNG
SplitPath, pathsave, nametemp,,extpic2
if(extpic2 = " ") {
    pathsave = %pathsave%.png
    nametemp = %nametemp%.png
}
else if extpic not contains %extpic2%
{
    pathsave = %pathsave%.png
    nametemp = %nametemp%.png
}
IfExist, %pathsave%
{
    msgbox, 4, continue?, "%nametemp%" already exists.`nDo you still want to continue?
    ifmsgbox, yes
    {
        pBitmap := Gdip_CreateBitmapFromFile(cover)
        Gdip_SaveBitmapToFile(pBitmap, pathsave, 100)
    }
    IfMsgBox, no
    {
        pathsave =
        goto, getcover
    }
}
else {
    pBitmap := Gdip_CreateBitmapFromFile(cover)
    Gdip_SaveBitmapToFile(pBitmap, pathsave, 100)
}
pathsave =
return

getcover2:
pBitmap := Gdip_CreateBitmapFromFile(cover)
Gdip_SetBitmapToClipboard(pBitmap)
return

create:
Gui, 2:Default
GuiControlget, Playlistnamenew, 2:, edit2
IfExist, %PlaylistDir%\%Playlistnamenew%.txt
{
    Gui, 2:hide
    msgbox, 4, already exists, Playlist already exist. would you like to override `"%Playlistnamenew%`"?
    ifmsgbox no
    {
        Gui, 2:show
        return
    }
    ifmsgbox yes
    {
        Gui, 2:show
        loop, % LV_GetCount()
        {
            LV_GetText(text, A_Index)
            if(text = Playlistnamenew)
                LV_Delete(A_Index)
        }
        Gui, 1:default
        loop, % LV_GetCount()
        {
            LV_GetText(text, A_Index)
            if(text = Playlistnamenew)
                LV_Delete(A_Index)
        }
        filedelete, %PlaylistDir%\%Playlistnamenew%.txt
    }
}
GUi, 1:default
if(currentview = 4) {
    LV_Add("", Playlistnamenew, timeconvert(A_Now))
}
Gui, 2:Default
LV_Add("", Playlistnamenew, timeconvert(A_Now))
FileAppend, %asjfhaskjfa%, %PlaylistDir%\%Playlistnamenew%.txt
Return


2GuiClose:
Gui, 1:-0x8000000
Gui, 2:hide
Gui, 1:Default
GuiControl,2:show,addto
return

3GuiClose:
Gui, 1:-0x8000000
Gui, 2:hide
Gui, 1:Default
return

list2:
Gui, 2:Default
RowNumberplaylist := LV_GetNext()
if (RowNumberplaylist = 0) {
   RowNumberplaylist := rownumberold
}
else {
    rownumberold := RowNumberplaylist
}
return

select:
working = 1
Gui, 2:Default
LV_GetText(text, RowNumberplaylist)
Fileread, listfull, %PlaylistDir%\%text%.txt
temp := filestoadd
filestoadd =
loop, parse, temp, `n
{
    if listfull not contains %A_LoopField%
        filestoadd = % filestoadd . StrReplace(A_loopField, "`n", "") . "`n"
}
Fileappend, %Filestoadd%, %PlaylistDir%\%text%.txt
Gui, 2:hide
Gui, 1:-0x8000000
WinActivate, ahk_id %musicPlayer%
Gui, 2:Default
if(currentview = 5 and currentPlaylist2 != 0) {
    vartemp = %PlaylistDir%\%text%.txt
    if(currentplaylist2 = vartemp)
    {
        loop, parse, Filestoadd, /
        {
            if(A_Index = 2) {
                titleload := A_LoopField
            }
            if(A_Index = 3) {
                artistload := A_LoopField
            }
            if(A_Index = 4) {
                length3 := FormatSeconds(A_LoopField)
                break
            }
        }
        LV_Add("", artistload, titleload, length3)
    }
}
working = 0
listfull =
return

add:
if current = 0
{
    tooltip, please play a file first!
    settimer, tooltipoff, 800
    return
}
GuiControl,2:show,addto
Gui, 1:+0x8000000
Gui, 2:Default
LV_Delete()
loop, %PlaylistDir%\*.txt, 0, 0
{
    FileGetTime, time, %A_loopFileFullPath%, C
    stringtrimright, Playlistnamenew, A_LoopFileName, 4
    LV_Add("",Playlistnamenew,timeconvert(time))
}
filestoadd = %current%/%titleoriginal%/%artistoriginal%/%length%`n
Gui, 2:show, center w270 h280
return

createnew:
GuiControl,2:hide,addto
Filestoadd = %current%/%titleoriginal%/%artistoriginal%/%length%`n
Gui, 1:+0x8000000
Gui, 2:Default
LV_Delete()
loop, %PlaylistDir%\*.txt, 0, 0
{
    FileGetTime, time, %A_loopFileFullPath%, C
    stringtrimright, Playlistnamenew, A_LoopFileName, 4
    LV_Add("",Playlistnamenew,timeconvert(time))
}
Gui, 2:show, center w270 h280
return

timeconvert(time) {
    stringtrimleft, hour, time, 8
    stringtrimright, hour, hour, 4
    StringTrimLeft, min, time, 10
    stringtrimright, min, min, 2
    stringtrimleft, month, time, 4
    stringtrimright, month, month, 8
    stringtrimleft, day, time, 6
    stringtrimright, day, day, 6
    return hour ":" min "/" day "." month
}


removeplaylist:
rows := LV_GetCount("Selected")
loop, %rows%
{
    LV_GetText(text, RowNumber3, 1)
    FileDelete, %PlaylistDir%\%text%.txt
    LV_Delete(rownumber3)
}
return

like2:
if(likename = "Add song to liked songs" or likename = "Add songs to liked songs") {
    rows := LV_GetCount("Selected")
    loop, %rows%
    {
        rownumbertemp := (rownumber3 + A_Index) - 1
        like(rownumbertemp)
    }
}
Else {
    rows := LV_GetCount("Selected")
    loop, %rows%
    {
        removelike(rownumber3)
    }
}
return

like(rownumber2) {
    working = 1
    if currentview = 2
    {
        currentPlaylisttemp := songs
    }
    else if currentview = 3
    {
        currentPlaylisttemp = %dataPath%\fav.txt
    }
    else if currentview = 5
    {
        currentPlaylisttemp := currentPlaylist2
    }
    else if currentview = 6
    {
        currentPlaylisttemp = %dataPath%\search.txt
    }
    else if(currentview = 8) {
        currentPlaylisttemp := queue
    }
    FileRead, listfull, %currentPlaylisttemp%
    index3 = 0
    loop, parse, listfull, `n
    {
        if(A_LoopField != "")
            index3 += 1
        if(index3 = rownumber2) {
            FileRead, listfull2, %DataPath%\fav.txt
            if listfull2 contains %A_LoopField%
            {
                Break
            }
            else {
                FileAppend, %A_loopField%`n, %DataPath%\fav.txt
            }
            break
        }
    }
    working = 0
    listfull =
}

removelike(rownumber2) {
    working = 1
    if currentview = 2
    {
        currentPlaylisttemp := songs
    }
    else if currentview = 5
    {
        currentPlaylisttemp := currentPlaylist2
    }
    else if currentview = 6
    {
        currentPlaylisttemp = %dataPath%\search.txt
    }
    else if(currentview = 8) {
        currentPlaylisttemp := queue
    }
    if currentview != 3
    {
        index3 = 0
        FileRead, listfull, %currentPlaylisttemp%
        loop, parse, listfull, `n
        {
            if(A_LoopField != "")
                index3 += 1
            if(index3 = rownumber2) {
                path := substr(A_LoopField, 1, instr(A_LoopField, "/") - 1)
                break
            }
        }
        index3 = 0
        FileRead, listfull, % DataPath . "\fav.txt"
        File := Fileopen(DataPath . "\fav.txt", "W")
        loop, parse, listfull, `n
        {
            index3 += 1
            if A_LoopField not contains %path%
            {
                File.write(A_LoopField . "`n")
            }
        }
    }
    else {
        index3 = 0
        loop, parse, listfull, `n
        {
            if(A_LoopField != "")
                index3 += 1
            if(index3 != rownumber2 and A_LoopField != "") {
                File.write(A_LoopField . "`n")
            }
        }
    }
    if currentview = 3
    {
        LV_Delete(rownumber2)
    }
    File.Close()
    working = 0
    listfull =
}

like:
if current = 0
{
    tooltip, please play a file first!
    settimer, tooltipoff, 800
    return
}
if liked {
    liked = 0
    GuiCOntrol,1:,like, % "hBitmap:" like_png()
    GuiControl, Menu:, likelist, Add song to favourites
    FileRead, listfull, %DataPath%\fav.txt
    File := Fileopen(DataPath . "\fav.txt", "W")
    index3 = 0
    loop, parse, listfull, `n
    {
        if(A_LoopField != "")
            index3 += 1
        else
            continue
        if A_LoopField not contains %current%
        {
            File.write(A_LoopField . "`n")
        }
        else
            indexlike := index3
    }
    if currentview = 3
    {
        LV_Delete(indexlike)
    }
    File.Close()
}
Else {
    liked = 1
    GuiControl, Menu:, likelist, Remove song from favourites
    GuiCOntrol,1:,like, % "hBitmap:" like2_png()
    FileRead, listfull, %DataPath%\fav.txt
    IfNotInString, listfull, %current%
    {
        Fileappend, %current%/%titleoriginal%/%artistoriginal%/%length%`n, %DataPath%\fav.txt
        if currentview = 3
        {
            oMI.Open(current)
            base64 := oMI.GetInfo("general", "Cover_Data")
            oMI.close()
            if !base64
            {
                pBitmaplist := empty2_png()
            }
            else {
                pBitmaplist := scaleimagefull(Gdip_BitmapFromBase64(base64),64)
            }
            foundsearch += 1
            IL_Add(ImageListID, "hbitmap: " Gdip_CreateHBITMAPFromBitmap(pBitmaplist), foundsearch)
            Gdip_DisposeImage(pBitmaplist)
            LV_Add("icon" foundsearch, artistoriginal, titleoriginal, FormatSeconds(length))
        }
    }
}
listfull =
return

fav:
if currentview = 3
    return
if(working = 1 and currentview = 1 and currentviewold = 3) {
    guicontrol, 1:move, album, y%albumypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, artist, y%artistypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, title, y%titleypos% x%coverxpos% w%coverwidth%
    get(current)
    currentview = 2
    GuiControl, 1:show, list
    GuiControl, 1:show, cover
    guicontrol, 1:show, artist2
    guicontrol, 1:show, title2
    guicontrol, 1:show, duration
    GuiControl, 1:show, search
    GuiControl, 1:show, edit
    GuiControl, 1:show, refresh
    GuiControl, 1:show, timeneed
    GuiControl, 1:show, closelist
    GuiControl, 1:show, settings
    GuiControl, 1:show, texttemp
    hbitmap := Gdip_CreateHBITMAPFromBitmap(blurbitmap, "0xFF" . substr(bc, 3))
    gettextcolor(BlurBitmap)
    guiControl,1:,background, % "hbitmap: " hbitmap
    GuiControl, 1:+backgroundtrans, currenttime
    GuiControl, 1:+backgroundtrans, prev
    GuiControl, 1:+backgroundtrans, Pause
    GuiControl, 1:+backgroundtrans, next
    return
}
else if working
{
    tooltip, App is currently loarding, please wait
    settimer, tooltipoff, 800
    return
}
else if currentview = 6
{
    GuiControl, 1:hide, back
}
else if currentview = 4
{
    guicontrol, 1:-redraw, list
    GuiControl, 1:, title2, title:
    GuiControl, 1:, artist2, artist:
    GuiControl, 1:, duration2, duration:
    Col1 := floor((listwidth / 10) * 4)
    Col3 := floor((listwidth / 10) * 2 - 25)
    LV_ModifyCol(1,Col1)
    LV_ModifyCol(2,Col1)
    LV_ModifyCol(3,Col3)
    guicontrol, 1:+redraw, list
}
else if(currentview = 1 and currentviewold = 3) {
    guicontrol, 1:move, album, y%albumypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, artist, y%artistypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, title, y%titleypos% x%coverxpos% w%coverwidth%
    get(current)
    currentview = 3
    GuiControl, 1:show, list
    GuiControl, 1:show, cover
    guicontrol, 1:show, artist2
    guicontrol, 1:show, title2
    guicontrol, 1:show, duration
    GuiControl, 1:show, search
    GuiControl, 1:show, edit
    GuiControl, 1:show, refresh
    GuiControl, 1:show, timeneed
    GuiControl, 1:show, closelist
    GuiControl, 1:show, settings
    GuiControl, 1:show, texttemp
    hbitmap := Gdip_CreateHBITMAPFromBitmap(blurbitmap, "0xFF" . substr(bc, 3))
    gettextcolor(BlurBitmap)
    guiControl,1:,background, % "hbitmap: " hbitmap
    GuiControl, 1:+backgroundtrans, currenttime
    GuiControl, 1:+backgroundtrans, prev
    GuiControl, 1:+backgroundtrans, Pause
    GuiControl, 1:+backgroundtrans, next
    return
}
else if(currentview = 1 and currentviewold != 3) {
    guicontrol, 1:move, album, y%albumypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, artist, y%artistypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, title, y%titleypos% x%coverxpos% w%coverwidth%
    get(current)
    currentview = 3
    LV_Delete()
    GuiControl, 1:show, list
    GuiControl, 1:show, cover
    guicontrol, 1:show, artist2
    guicontrol, 1:show, title2
    guicontrol, 1:show, duration
    GuiControl, 1:show, search
    GuiControl, 1:show, edit
    GuiControl, 1:show, refresh
    GuiControl, 1:show, timeneed
    GuiControl, 1:show, closelist
    GuiControl, 1:show, settings
    GuiControl, 1:show, texttemp
    hbitmap := Gdip_CreateHBITMAPFromBitmap(blurbitmap, "0xFF" . substr(bc, 3))
    gettextcolor(BlurBitmap)
    guiControl,1:,background, % "hbitmap: " hbitmap
    GuiControl, 1:+backgroundtrans, currenttime
    GuiControl, 1:+backgroundtrans, prev
    GuiControl, 1:+backgroundtrans, Pause
    GuiControl, 1:+backgroundtrans, next
}
else {
    GuiControl, 1:hide, back
}
currentviewold = 0
working = 1
currentview = 3
LV_Delete()
FileRead, listfull, %dataPath%\fav.txt
foundsearch = 0
IL_Destroy(ImageListID)
ImageListID := IL_Create("","", 1)
LV_SetImageList(ImageListID, 1)
loop, parse, listfull, `n
{
    if(A_LoopField != "") {
        foundsearch += 1
        loop, parse, A_LoopField, /
        {
            if(A_Index = 1) {
                oMI.Open(A_LoopField)
                base64 := oMI.GetInfo("general", "Cover_Data")
                oMI.close()
                if !base64
                {
                    pBitmaplist := empty2_png()
                }
                else {
                    pBitmaplist := scaleimagefull(Gdip_BitmapFromBase64(base64),64)
                }
                hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmaplist)
                IL_Add(ImageListID, "hbitmap: " hbitmap, foundsearch)
                Gdip_DisposeImage(pBitmaplist)
            }
            if(A_index = 2)
                titleload := A_LoopField
            if(A_index = 3)
                artistload := A_LoopField
            if(A_index = 4)
                durationload := A_LoopField
        }
        length3 := FormatSeconds(durationload)
        LV_Add("icon" foundsearch,artistload,titleload,length3)
        GuiControl, 1:, results, %foundsearch% songs
    }
}
if foundsearch = 0
    GuiControl, 1:, results, %foundsearch% songs
working = 0
listfull =
return

tooltipoff:
tooltip,
return
search:
if working
{
    tooltip, App is currently loarding, please wait
    settimer, tooltipoff, 800
    return
}
if currentview = 4
{
    guicontrol, 1:-redraw, list
    GuiControl, 1:, title2, title:
    GuiControl, 1:, artist2, artist:
    GuiControl, 1:, duration2, duration:
    Col1 := floor((listwidth / 10) * 4)
    Col3 := floor((listwidth / 10) * 2 - 25)
    LV_ModifyCol(1,Col1)
    LV_ModifyCol(2,Col1)
    LV_ModifyCol(3,Col3)
    guicontrol, 1:+redraw, list
}
working = 1
GuiControl, 1:show, back
currentview = 6
GuiControlGet, searchstring2, , edit
if searchstring2 =
    return
start := A_TickCount
FileRead, listfull, %songs%
LV_Delete()
File := Fileopen(DataPath . "\search.txt", "W")
foundsearch = 0
GuiControl, 1:, results, 0 results
IL_Destroy(ImageListID)
ImageListID := IL_Create("","", 1)
loop, parse, listfull, `n
{
    IfInString, A_LoopField, %searchstring2%
    {
        if(A_LoopField != "") {
            foundsearch += 1
            loop, parse, A_LoopField, /
            {
                if(A_Index = 1) {
                    oMI.Open(A_LoopField)
                    base64 := oMI.GetInfo("general", "Cover_Data")
                    oMI.close()
                    if !base64
                    {
                        pBitmaplist := empty2_png()
                    }
                    else {
                        pBitmaplist := scaleimagefull(Gdip_BitmapFromBase64(base64),64)
                    }
                    hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmaplist)
                    IL_Add(ImageListID, "hbitmap: " hbitmap, foundsearch)
                    Gdip_DisposeImage(pBitmaplist)
                }
                if(A_index = 2)
                    titleload := A_LoopField
                if(A_index = 3)
                    artistload := A_LoopField
                if(A_index = 4)
                    durationload := A_LoopField
            }
            length3 := FormatSeconds(durationload)
            LV_Add("icon" foundsearch,artistload,titleload,length3)
            File.write(A_LoopField . "`n")
            GuiControl, 1:, results, %foundsearch% results
            time := (A_TickCount - start) / 1000
            GuiControl,1:,timeneed, % SubStr(time, 1, InStr(time, ".") - 1) . "." . substr(time, instr(time, ".") + 1, 2) . " seconds needed"
        }
    }
}
LV_SetImageList(ImageListID, 1)
if foundsearch = 0
    GuiControl, 1:, results, %foundsearch% results
time := (A_TickCount - start) / 1000
GuiControl,1:,timeneed, % SubStr(time, 1, InStr(time, ".") - 1) . "." . substr(time, instr(time, ".") + 1, 2) . " seconds needed"
settimer, removetimeneed, 500
file.Close()
working = 0
listfull =
Return

loop:
if looptoggle
{
    looptoggle = 0
    IniWrite, 0, %config%, loop, 1
    GuiControl, 1:, loop, % "hBitmap:" loop_png()
    ;AV.Settings.setMode("loop" ,false)
}
Else {
    looptoggle = 1
    IniWrite, 1, %config%, loop, 1
    GuiControl, 1:, loop, % "hBitmap:" loop2_png()
    ;AV.Settings.setMode("loop" ,true)
}
return

shuffle:
if shuffletoggle
{
    shuffletoggle = 0
    IniWrite, 0, %config%, shuffle, 1
    GuiControl, 1:, shuffle, % "hBitmap:" shuffle_png()
    FileRead, listfull, %shufflelist%
    File := Fileopen(queue, "W")
    File.write(listfull)
    file.Close()
}
Else {
    shuffletoggle = 1
    IniWrite, 1, %config%, shuffle, 1
    GuiControl, 1:, shuffle, % "hBitmap:" shuffle2_png()
    FileRead, listfull, %queue%
    File := Fileopen(shufflelist, "W")
    File.write(listfull)
    file.Close()
    Sort, listfull, Random `n
    File := Fileopen(queue, "W")
    File.write(listfull)
    file.Close()
}
listfull =
return

slider:
multislider := exactduration / AV.controls.currentPosition
multislider2 := GuiWidth / multislider
currenttime := floor(AV.controls.currentPosition)
if(currenttime != currenttimeold) {
    currenttimeold := currenttime
    GuiControl, 1:, currenttime, % FormatSeconds(currenttime)
    ;Control, Hide,,,ahk_id %textcurrent%
    ;ControlSetText, , % FormatSeconds(currenttime), ahk_id %textcurrent%
    ;Control, show,,,ahk_id %textcurrent%
}
if(floor(AV.controls.currentPosition) = length) {
    if looptoggle
    {
        AV.controls.currentPosition := 0
        AV.controls.play
    }
    else {
        gosub, next
    }
}
GuiControl,1:,progress, %multislider2%
MouseGetPos,,, MouseOverWindowID
if (MouseOverWindowID != musicPlayer and MouseoverWindowID != fullscreenid and MouseoverWindowID != MenuID) {
    ToolTip,
    if cursor
    {
        restorecursors()
        cursor = 0
    }
    Currcontrol =
    PrevControl =
}
return


Pause:
if not media
{
    media = 1
    guicontrol, 1:, Pause, % "hBitmap:" Play2_png()
    GuiControl, Menu:, pm, Play
    Currvolume := AV.settings.volume
    AV.controls.Pause
}
else {
    if current = 0
    {
        tooltip, please play a file first!
        settimer, tooltipoff, 800
        return
    }
    media = 0
    guicontrol, 1:, Pause, % "hBitmap:" Pause2_png()
    GuiControl, Menu:, pm, Pause
    AV.controls.Play
}
Return

Pause2:
if not media
{
    media = 1
    guicontrol, 1:, Pause, % "hBitmap:" Play_png()
    GuiControl, Menu:, pm, Play
    AV.controls.Pause
}
else {
    media = 0
    guicontrol, 1:, Pause, % "hBitmap:" Pause_png()
    GuiControl, Menu:, pm, Pause
    AV.controls.Play
}
Return

prev:
if(currenttime > 6) {
    AV.controls.currentPosition := 0
    Return
}
FileRead, listfull, %queue%
found2 = 0
currenttemp =
temp = 0
loop, parse, listfull, `n
{
    loop, parse, A_LoopField, /
    {
        if(A_Index = 1) {
            if(A_LoopField = current) {
                if not temp
                {
                    AV.controls.currentPosition := 0
                }
                else {
                    current := temp
                    get(current)
                    GuiControl, 1:, fulltime, % FormatSeconds(exactduration)
                    AV.Url := Current
                    if media
                    {
                        media = 0
                        GuiControl,1:,pause,% "hBitmap:" pause_png()
                    }
                    SplitPath, current, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
                    IniWrite, %current%, %config%, config, last
                    cover()
                }
                break
            }
            temp := A_LoopField
            break
        }
    }
}
listfull =
Return

next:
FileRead, listfull, %queue%
found2 = 0
found = 0
loop, parse, listfull, `n
{
    if found2
        break
    loop, parse, A_LoopField, /
    {
        if found {
            found = 0
            IfExist, %A_LoopField%
            {
                found2 = 1
            }
            else {
                found2 = 0
                break
                goto, next3
            }
            current := A_LoopField
            get(current)
            GuiControl, 1:, fulltime, % FormatSeconds(exactduration)
            AV.Url := Current
            if media
            {
                media = 0
                GuiControl,1:,pause,% "hBitmap:" pause_png()
            }
            SplitPath, current, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
            IniWrite, %current%, %config%, config, last
            get(current)
            cover()
        }
        else if(A_Index = 1) {
            if(A_LoopField = current) {
                found = 1
            }
        }
        break
    }
}
next3:
if !found2
{
    FileRead, listfull, %queue%
    if shuffletoggle
    {
        File := Fileopen(shufflelist, "W")
        File.write(listfull)
        file.Close()
        Sort, listfull, Random `n
        File := Fileopen(queue, "W")
        File.write(listfull)
        file.Close()
    }
    loop, parse, listfull, `n
    {
        if(A_Index = 1) {
            loop, parse, A_LoopField, /
            {
                if(A_Index = 1) {
                    IfnotExist, %A_LoopField%
                    {
                        AV.controls.Stop
                        GuiControl,1:,pause,% "hBitmap:" play_png()
                        media = 1
                        return
                    }
                    current := A_LoopField
                    get(current)
                    GuiControl, 1:, fulltime, % FormatSeconds(exactduration)
                    AV.Url := Current
                    if media
                    {
                        media = 0
                        GuiControl,1:,pause,% "hBitmap:" pause_png()
                    }
                    SplitPath, current, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
                    IniWrite, %current%, %config%, config, last
                    get(current)
                    cover()
                }
                break
            }
        }
        break
    }
}
found2 = 0
listfull =
return

Playview:
if currentview = 1
    return
else if currentview = 6
{
    GuiControl, 1:hide, back
}
if currentview = 4
{
    guicontrol, 1:-redraw, list
    GuiControl, 1:, title2, title:
    GuiControl, 1:, artist2, artist:
    GuiControl, 1:, duration2, duration:
    Col1 := floor((listwidth / 10) * 4)
    Col3 := floor((listwidth / 10) * 2 - 25)
    LV_ModifyCol(1,Col1)
    LV_ModifyCol(2,Col1)
    LV_ModifyCol(3,Col3)
    guicontrol, 1:+redraw, list
}
currentviewold := currentview
currentview = 1
get2(current)
GuiControl, 1:hide, list
GuiControl, 1:hide, cover
if not fullscreen
{
    guicontrol, 1:move, album, y%albumypos2% x10 w300
    guicontrol, 1:move, artist, y%artistypos2% x10 w300
    guicontrol, 1:move, title, y%titleypos2% x10 w300
}
else {
    titleypos3 := GuiHeight - 230
    artistypos3 := GuiHeight - 190
    albumypos3 := GuiHeight - 150
    guicontrol, 1:move, album, y%albumypos3% x10 w300
    guicontrol, 1:move, artist, y%artistypos3% x10 w300
    guicontrol, 1:move, title, y%titleypos3% x10 w300
}
guicontrol, 1:hide, artist2
guicontrol, 1:hide, title2
guicontrol, 1:hide, duration
GuiControl, 1:hide, search
GuiControl, 1:hide, edit
GuiControl, 1:hide, refresh
GuiControl, 1:hide, closelist
GuiControl, 1:hide, settings
GuiControl, 1:hide, texttemp
GuiControl, 1:hide, timeneed
GuiControl,1:,timeneed,
oMI.Open(current)
base64 := oMI.GetInfo("general", "Cover_Data")
oMI.Close()
if !base64
{
    Bitmaptemp2 := FitFullSize(empty_png(), GuiWidth, GuiHeight)
}
else {
    Bitmaptemp2 := FitFullSize(Gdip_BitmapFromBase64(Base64), GuiWidth, GuiHeight)
}
hbitmap := Gdip_CreateHBITMAPFromBitmap(Bitmaptemp2, "0xFF" . substr(bc, 3))
guiControl,1:,background, % "*w%GUiWidth% *h%GuiHeight% hbitmap: " hbitmap
bitmaptemp := GDip_BlurBitmap(Bitmaptemp2, 20)
gettextcolor(bitmaptemp)
Gdip_DisposeImage(Bitmaptemp)
Gdip_DisposeImage(Bitmaptemp2)
GuiControl, 1:+backgroundtrans, currenttime
GuiControl, 1:+backgroundtrans, prev
GuiControl, 1:+backgroundtrans, Pause
GuiControl, 1:+backgroundtrans, next
get(current)
Return

listview:
if(working = 1 and currentview = 1 and currentviewold = 2) {
    guicontrol, 1:move, album, y%albumypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, artist, y%artistypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, title, y%titleypos% x%coverxpos% w%coverwidth%
    get(current)
    currentview = 2
    GuiControl, 1:show, list
    GuiControl, 1:show, cover
    guicontrol, 1:show, artist2
    guicontrol, 1:show, title2
    guicontrol, 1:show, duration
    GuiControl, 1:show, search
    GuiControl, 1:show, edit
    GuiControl, 1:show, refresh
    GuiControl, 1:show, timeneed
    GuiControl, 1:show, closelist
    GuiControl, 1:show, settings
    GuiControl, 1:show, texttemp
    hbitmap := Gdip_CreateHBITMAPFromBitmap(blurbitmap, "0xFF" . substr(bc, 3))
    guiControl, 1:,background, % "hbitmap: " hbitmap
    gettextcolor(BlurBitmap)
    GuiControl, 1:+backgroundtrans, currenttime
    GuiControl, 1:+backgroundtrans, prev
    GuiControl, 1:+backgroundtrans, Pause
    GuiControl, 1:+backgroundtrans, next
    return
}
else if working
{
    tooltip, App is currently loarding, please wait
    settimer, tooltipoff, 800
    return
}
if currentview = 2
    return
else if currentview = 6
{
    GuiControl, 1:hide, back
}
if currentview = 4
{
    guicontrol, 1:-redraw, list
    GuiControl, 1:, title2, title:
    GuiControl, 1:, artist2, artist:
    GuiControl, 1:, duration2, duration:
    Col1 := floor((listwidth / 10) * 4)
    Col3 := floor((listwidth / 10) * 2 - 25)
    LV_ModifyCol(1,Col1)
    LV_ModifyCol(2,Col1)
    LV_ModifyCol(3,Col3)
    guicontrol, 1:+redraw, list
}
if(currentview = 1 and currentviewold = 2) {
    guicontrol, 1:move, album, y%albumypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, artist, y%artistypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, title, y%titleypos% x%coverxpos% w%coverwidth%
    get(current)
    currentview = 2
    GuiControl, 1:show, list
    GuiControl, 1:show, cover
    guicontrol, 1:show, artist2
    guicontrol, 1:show, title2
    guicontrol, 1:show, duration
    GuiControl, 1:show, search
    GuiControl, 1:show, edit
    GuiControl, 1:show, refresh
    GuiControl, 1:show, timeneed
    GuiControl, 1:show, closelist
    GuiControl, 1:show, settings
    GuiControl, 1:show, texttemp
    hbitmap := Gdip_CreateHBITMAPFromBitmap(blurbitmap, "0xFF" . substr(bc, 3))
    guiControl, 1:,background, % "hbitmap: " hbitmap
    gettextcolor(BlurBitmap)
    GuiControl, 1:+backgroundtrans, currenttime
    GuiControl, 1:+backgroundtrans, prev
    GuiControl, 1:+backgroundtrans, Pause
    GuiControl, 1:+backgroundtrans, next
    return
}
else if(currentview = 1) {
    guicontrol, 1:move, album, y%albumypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, artist, y%artistypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, title, y%titleypos% x%coverxpos% w%coverwidth%
    get(current)
    GuiControl, 1:hide, back
    currentview = 2
    LV_Delete()
    GuiControl, 1:show, list
    GuiControl, 1:show, cover
    guicontrol, 1:show, artist2
    guicontrol, 1:show, title2
    guicontrol, 1:show, duration
    GuiControl, 1:show, search
    GuiControl, 1:show, edit
    GuiControl, 1:show, refresh
    GuiControl, 1:show, timeneed
    GuiControl, 1:show, closelist
    GuiControl, 1:show, settings
    GuiControl, 1:show, texttemp
    hbitmap := Gdip_CreateHBITMAPFromBitmap(BlurBitmap, "0xFF" . substr(bc, 3))
    guiControl, 1:,background, % "hbitmap: " hbitmap
    gettextcolor(BlurBitmap)
    GuiControl, 1:+backgroundtrans, currenttime
    GuiControl, 1:+backgroundtrans, prev
    GuiControl, 1:+backgroundtrans, Pause
    GuiControl, 1:+backgroundtrans, next
    loadsongs(songs)
}
else {
    currentview = 2
    loadsongs(songs)
    GuiControl, 1:hide, back
}
currentviewold = 0
return

Playlistview:
if(working = 1 and currentview = 1 and currentviewold = 4) {
    guicontrol, 1:move, album, y%albumypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, artist, y%artistypos% x%coverxpos% w%coverwidth%
    guicontrol, 1:move, title, y%titleypos% x%coverxpos% w%coverwidth%
    get(current)
    currentview = 2
    GuiControl, 1:show, list
    GuiControl, 1:show, cover
    guicontrol, 1:show, artist2
    guicontrol, 1:show, title2
    guicontrol, 1:show, duration
    GuiControl, 1:show, search
    GuiControl, 1:show, edit
    GuiControl, 1:show, refresh
    GuiControl, 1:show, timeneed
    GuiControl, 1:show, closelist
    GuiControl, 1:show, settings
    GuiControl, 1:show, texttemp
    hbitmap := Gdip_CreateHBITMAPFromBitmap(blurbitmap, "0xFF" . substr(bc, 3))
    gettextcolor(BlurBitmap)
    guiControl,1:,background, % "hbitmap: " hbitmap
    GuiControl, 1:+backgroundtrans, currenttime
    GuiControl, 1:+backgroundtrans, prev
    GuiControl, 1:+backgroundtrans, Pause
    GuiControl, 1:+backgroundtrans, next
    return
}
else if working
{
    tooltip, App is currently loarding, please wait
    settimer, tooltipoff, 800
    return
}
if currentview = 4
    return
else if currentview = 6
{
    GuiControl, 1:hide, back
}
if(currentview = 1) {
guicontrol, 1:move, album, y%albumypos% x%coverxpos% w%coverwidth%
guicontrol, 1:move, artist, y%artistypos% x%coverxpos% w%coverwidth%
guicontrol, 1:move, title, y%titleypos% x%coverxpos% w%coverwidth%
get(current)
}
LV_Delete()
currentview = 4
GuiControl, 1:show, list
GuiControl, 1:show, cover
guicontrol, 1:show, artist2
guicontrol, 1:show, title2
guicontrol, 1:show, duration
GuiControl, 1:show, search
GuiControl, 1:show, edit
GuiControl, 1:show, refresh
GuiControl, 1:show, timeneed
GuiControl, 1:show, closelist
GuiControl, 1:show, settings
GuiControl, 1:show, texttemp
hbitmap := Gdip_CreateHBITMAPFromBitmap(blurbitmap, "0xFF" . substr(bc, 3))
gettextcolor(BlurBitmap)
guiControl,1:,background, % "hbitmap: " hbitmap
GuiControl, 1:+backgroundtrans, currenttime
GuiControl, 1:+backgroundtrans, prev
GuiControl, 1:+backgroundtrans, Pause
GuiControl, 1:+backgroundtrans, next
GuiControl, 1:, title2,
GuiControl, 1:, artist2, name:
GuiControl, 1:, duration2, Date created:
guicontrol, 1:-redraw, list
Col1 := floor(((listwidth / 10) * 4) * 2)
Col3 := floor((listwidth / 10) * 2 - 25)
LV_ModifyCol(1,Col1)
LV_ModifyCol(2,Col3)
LV_ModifyCol(3,0)
guicontrol, 1:+redraw, list
IL_Destroy(ImageListID)
FileGetTime, time, %songs%, C
ImageListID := IL_Create(1,"", 1)
IL_Add(ImageListID, "hbitmap: " Gdip_CreateHBITMAPFromBitmap(empty2_png()), 1)
LV_Add("icon1","all songs in library",timeconvert(time),"")
FileGetTime, time, %queue%, C
LV_Add("icon1","current queue",timeconvert(time),"")
foundsearch = 0
loop, %PlaylistDir%\*.txt, 0, 0
{
    FileGetTime, time, %A_loopFileFullPath%, C
    stringtrimright, Playlistnamenew, A_LoopFileName, 4
    LV_Add("icon1",Playlistnamenew,timeconvert(time),"")
    foundsearch += 1
    GuiControl, 1:, results, %foundsearch% playlists
}
if foundsearch = 0
    GuiControl, 1:, results, %foundsearch% playlists
LV_SetImageList(ImageListID, 1)
return

MyListView:
if (A_GuiEvent = "DoubleClick")
{
rownumber := LV_GetNext()
if (rownumber = 0) {
   return
}
if currentview = 2
{
    currentPlaylist := songs
}
else if currentview = 3
{
    currentPlaylist = %dataPath%\fav.txt
} ;;;;;;;;;;;
else if currentview = 4
{
    if(rownumber != 1 and rownumber != 2) {
        LV_GetText(Playlistnamenew, rownumber)
        currentPlaylist2 = %PlaylistDir%\%Playlistnamenew%.txt
        FileRead, listfull, %currentPlaylist2%
        if shuffletoggle
        {
            File := Fileopen(shufflelist, "W")
            File.write(listfull)
            file.Close()
            Sort, listfull, Random `n
        }
        File := Fileopen(queue, "W")
        File.write(listfull)
        file.Close()
        loadqueue()
        return
    }
    else if(rownumber = 1) {
        goto, listview
    }
    else if(rownumber = 2) {
        currentview = 8
        loadqueue()
    }
    return
}
else if currentview = 5
{
    currentPlaylist := currentPlaylist2
}
else if currentview = 6
{
    currentPlaylist = %dataPath%\search.txt
}
else if(currentview = 7) {
    LV_GetText(artistnow, rownumber)
    searchartist(artistnow)
    return
}
else if(currentview = 8) {
    currentPlaylist := queue
}
workingtemp := working
working = 1
FileRead, listfull, %currentPlaylist%
index3 = 0
loop, parse, listfull, `n
{
    if(A_LoopField != "")
        index3 += 1
    if(index3 = rownumber) {
        loop, parse, A_LoopField, /
        {
            if(A_Index = 1) {
                current2 := A_LoopField
                IfnotExist, %current2%
                {
                    msgbox, could not find file`,`ncheck if the file has rare characters in name and remove them.
                    current2 = 0
                    working = 0
                    break
                    return
                }
                else {
                    if(current2 = "") {
                        msgbox, error
                        current2 = 0
                        return
                    }
                    current := current2
                    current2 = 1
                }
            }
            break
        }
        break
    }
}
    if !current2
        return
    get(current)
    GuiControl, 1:, fulltime, % FormatSeconds(exactduration)
    AV.Url := Current
    if media
    {
        media = 0
        GuiControl,1:,pause,% "hBitmap:" pause_png()
    }
    SplitPath, current, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
    IniWrite, %current%, %config%, config, last
    LV_Modify("","-Select")
    cover()
    if(shuffletoggle = 1 and currentview != 8)
    {
        File := Fileopen(shufflelist, "W")
        File.write(listfull)
        file.Close()
        Sort, listfull, Random `n
    }
    File := Fileopen(queue, "W")
    File.write(listfull)
    file.Close()
    working := workingtemp
}
listfull =
return

between(value, low, high) {
    return value >= low && value <= high
}

GuiClose:
settimer, slider, off
Gui, 1:Destroy
Gui, 1:Hide
Gdip_Shutdown(ptoken)
restorecursors()
exitapp

loadqueue() {
    if working
    {
        tooltip, App is currently loarding, please wait
        settimer, tooltipoff, 800
        return
    }
    guicontrol, 1:-redraw, list
    GuiControl, 1:, title2, title:
    GuiControl, 1:, artist2, artist:
    GuiControl, 1:, duration2, duration:
    Col1 := floor((listwidth / 10) * 4)
    Col3 := floor((listwidth / 10) * 2 - 25)
    LV_ModifyCol(1,Col1)
    LV_ModifyCol(2,Col1)
    LV_ModifyCol(3,Col3)
    guicontrol, 1:+redraw, list
    working = 1
    GuiControl, 1:hide, back
    LV_Delete()
    IL_Destroy(ImageListID)
    ImageListID := IL_Create("","", 1)
    FileRead, listfull, %queue%
    start := A_TickCount
    if listfull not contains /
    {
        GuiControl, 1:, results, 0 songs
        working = 0
        return 0
    }
    else {
        searchstring = /
        foundsearch = 0
        full = 0
        loop, parse, listfull, `n
        {
            if(A_LoopField != "") {
                full += 1
            }
        }
        index = 0
        loop, parse, listfull, `n
        {
            if(A_LoopField != "") {
                foundsearch += 1
                loop, parse, A_LoopField, /
                {
                    if(A_index = 1) {
                        if A_LoopField contains ??
                            Continue
                        oMI.Open(A_LoopField)
                        base64 := oMI.GetInfo("general", "Cover_Data")
                        oMI.close()
                        if !base64
                        {
                            pBitmaplist := empty2_png()
                        }
                        else {
                            pBitmaplist := scaleimagefull(Gdip_BitmapFromBase64(base64),64)
                        }
                        hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmaplist)
                        IL_Add(ImageListID, "hbitmap: " hbitmap, foundsearch)
                        Gdip_DisposeImage(pBitmaplist)
                    }
                    if(A_index = 2)
                        titleload := A_LoopField
                    if(A_index = 3)
                        artistload := A_LoopField
                    if(A_index = 4)
                        durationload := A_LoopField
                }
                length3 := FormatSeconds(durationload)
                LV_Add("icon" foundsearch,artistload,titleload,length3)
                GuiControl, 1:, results, %foundsearch% songs
                time := (A_TickCount - start) / 1000
                GuiControl,1:,timeneed, % SubStr(time, 1, InStr(time, ".") - 1) . "." . substr(time, instr(time, ".") + 1, 2) . " seconds needed"
            }
        }
        if foundsearch = 0
            GuiControl, 1:, results, %foundsearch% songs
        LV_SetImageList(ImageListID)
        working = 0
        settimer, removetimeneed, 500
        listfull =
        return foundsearch
    }
    listfull =
}

loadsongs(path) {
    if working
    {
        tooltip, App is currently loarding, please wait
        settimer, tooltipoff, 800
        return
    }
    working = 1
    GuiControl, 1:hide, back
    LV_Delete()
    IL_Destroy(ImageListID)
    ImageListID := IL_Create("","", 1)
    LV_SetImageList(ImageListID)
    FileRead, listfull, %path%
    start := A_TickCount
    if listfull not contains /
    {
        GuiControl, 1:, results, 0 songs
        working = 0
        return 0
    }
    else {
        searchstring = /
        foundsearch = 0
        full = 0
        loop, parse, listfull, `n
        {
            if(A_LoopField != "") {
                full += 1
            }
        }
        index = 0
        loop, parse, listfull, `n
        {
            if(A_LoopField != "") {
                foundsearch += 1
                loop, parse, A_LoopField, /
                {
                    if(A_index = 1) {
                        if A_LoopField contains ??
                            Continue
                        oMI.Open(A_LoopField)
                        base64 := oMI.GetInfo("general", "Cover_Data")
                        oMI.close()
                        if !base64
                        {
                            pBitmaplist := empty2_png()
                        }
                        else {
                            pBitmaplist := scaleimagefull(Gdip_BitmapFromBase64(base64),64)
                        }
                        hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmaplist)
                        IL_Add(ImageListID, "hbitmap: " hbitmap, foundsearch)
                        Gdip_DisposeImage(pBitmaplist)
                    }
                    if(A_index = 2)
                        titleload := A_LoopField
                    if(A_index = 3)
                        artistload := A_LoopField
                    if(A_index = 4)
                        durationload := A_LoopField
                }
                length3 := FormatSeconds(durationload)
                LV_Add("icon" foundsearch,artistload,titleload,length3)
                GuiControl, 1:, results, %foundsearch% songs
                time := (A_TickCount - start) / 1000
                GuiControl,1:,timeneed, % SubStr(time, 1, InStr(time, ".") - 1) . "." . substr(time, instr(time, ".") + 1, 2) . " seconds needed"
            }
        }
        if foundsearch = 0
            GuiControl, 1:, results, %foundsearch% songs
        LV_SetImageList(ImageListID)
        working = 0
        settimer, removetimeneed, 500
        listfull =
        return foundsearch
    }
    listfull =
}

scaleimagefull(pBitmap, wsize) {
    width := Gdip_GetImageWidth(pBitmap)
    height := Gdip_GetImageHeight(pBitmap)
    if(width > height) {
        width := width * (wsize / height)
        height := wsize
        y = 0
        x := "-" (width - height) / 2
        outbitmap := Gdip_CreateBitmap(wsize,wsize)
        G := Gdip_GraphicsFromImage(outbitmap), Gdip_SetSmoothingMode(G3, 4)
        Gdip_DrawImage(G,pBitmap,x,y,width,height)
        Gdip_DisposeImage(pBitmap)
        return outbitmap
    }
    else if(height > width) {
        height := height * (wsize / width)
        width := wsize
        x = 0
        y := "-" (height - width) / 2
        outbitmap := Gdip_CreateBitmap(wsize,wsize)
        G := Gdip_GraphicsFromImage(outbitmap)
        Gdip_DrawImage(G,pBitmap,x,y,width,height)
        Gdip_DisposeImage(pBitmap)
        return outbitmap
    }
    else {
        return pBitmap
    }
}

loadsongs:
if working
{
    tooltip, App is currently loarding, please wait
    settimer, tooltipoff, 800
    return
}
working = 1
GuiControl, 1:hide, back
LV_Delete()
FileRead, listfull, %songs%
foundsearch = 0
currentPlaylist := songs
currentview = 2
loop, parse, listfull, `n
{
    if(A_LoopField != "") {
        foundsearch += 1
        loop, parse, A_LoopField, /
        {
            if(A_index = 1) {
                if A_LoopField contains ??
                    Continue
                oMI.Open(A_LoopField)
                base64 := oMI.GetInfo("general", "Cover_Data")
                oMI.close()
                if !base64
                {
                    pBitmaplist := empty2_png()
                }
                else {
                    pBitmaplist := scaleimagefull(Gdip_BitmapFromBase64(base64),64)
                }
                hbitmap := Gdip_CreateHBITMAPFromBitmap(pBitmaplist)
                IL_Add(ImageListID, "hbitmap: " hbitmap, foundsearch)
                Gdip_DisposeImage(pBitmaplist)
            }
            if(A_index = 2)
                titleload := A_LoopField
            if(A_index = 3)
                artistload := A_LoopField
            if(A_index = 4)
                durationload := A_LoopField
        }
        length3 := FormatSeconds(durationload)
        LV_Add("icon" foundsearch,artistload,titleload,length3)
        GuiControl, 1:, results, %foundsearch% songs
    }
}
if foundsearch = 0
    GuiControl, 1:, results, %foundsearch% songs
LV_SetImageList(ImageListID)
working = 0
listfull =
return

FormatSeconds(sec)
{
sec := floor(sec)
min := sec
min /= 60
min := floor(min)
min2 := (min*60)
sec -= %min2%
sec := floor(sec)
if(sec < 10)
	sec = 0%sec%
out = %min%:%sec%
return out
}

get(path) {
    working = 1
    FileRead, listfull, %DataPath%\fav.txt
    if listfull contains %path%
    {
        GuiControl, 1:, like, % "hBitmap:" like2_png()
        GuiControl, Menu:, likelist, Remove song from favourites
        liked = 1
    }
    else {
        GuiControl, 1:, like, % "hBitmap:" like_png()
        GuiControl, Menu:, likelist, Add song to favourites
        liked = 0
    }
    SplitPath, path, , ,ext, name
    if(ext in allext) {
        oMI.open(path)
        artist := oMI.GetInfo("general", "Artist")
        artistoriginal := artist
        if !artist
        {
            if name contains -
            {
                artistoriginal := substr(name, 1, instr(name, "-") - 1)
                titleoriginal := substr(name, instr(name, "-") + 1)
                artist := "artist: " artist
                title := "title: " title
            }
            else {
                title = title: %name%
                artist = artist: <unknown>
                artistoriginal = <unknown>
                titleoriginal = %name%
            }
        }
        else {
            titleoriginal := oMI.GetInfo("general", "Title")
            title := "title: " . titleoriginal
            artist = artist: %artist%
        }
        album := "album: " oMI.GetInfo("general", "Album")
        if(currentview = 1) {
            if(font0.pixelwidth(title) > 300){
                StringLen, len2, title
                loop, %len2%
                {
                    StringTrimRight, title2, title, %A_Index%
                    len3 := font0.PixelWidth(title2)
                    len4 := 300 - 16
                    if(len3 < len4) {
                        title = %title2%...
                        break
                    }
                }
            }
            if(font0.pixelwidth(album) > 300){
                StringLen, len2, album
                loop, %len2%
                {
                    StringTrimRight, album2, album, %A_Index%
                    len3 := font0.PixelWidth(album2)
                    len4 := 300 - 16
                    if(len3 < len4) {
                        album = %album2%...
                        break
                    }
                }
            }
            if(font0.pixelwidth(artist) > 300){
                StringLen, len2, artist
                loop, %len2%
                {
                    StringTrimRight, artist2, artist, %A_Index%
                    len3 := font0.PixelWidth(artist2)
                    len4 := 300 - 16
                    if(len3 < len4) {
                        artist = %artist2%...
                    break
                    }
                }
            }
        }
        else {
            if(font0.pixelwidth(title) > coverwidth){
                StringLen, len2, title
                loop, %len2%
                {
                    StringTrimRight, title2, title, %A_Index%
                    len3 := font0.PixelWidth(title2)
                    len4 := coverwidth - 16
                    if(len3 < len4) {
                        title = %title2%...
                        break
                    }
                }
            }
            if(font0.pixelwidth(album) > coverwidth){
                StringLen, len2, album
                loop, %len2%
                {
                    StringTrimRight, album2, album, %A_Index%
                    len3 := font0.PixelWidth(album2)
                    len4 := coverwidth - 16
                    if(len3 < len4) {
                        album = %album2%...
                        break
                    }
                }
            }
            if(font0.pixelwidth(artist) > coverwidth){
                StringLen, len2, artist
                loop, %len2%
                {
                    StringTrimRight, artist2, artist, %A_Index%
                    len3 := font0.PixelWidth(artist2)
                    len4 := coverwidth - 16
                    if(len3 < len4) {
                        artist = %artist2%...
                    break
                    }
                }
            }
        }
        length := floor(oMI.GetInfo("general", "Duration") / 1000)
        exactduration := oMI.GetInfo("general", "Duration") / 1000
        settimer, updatetitle, 250
        oMI.close()
    }
    working = 0
    listfull =
}

updatetitle:
if(font0.pixelwidth(titleoriginal) > coverwidth and font0.pixelwidth(title) > 150 and currentview != 1)
{
    if(counttitle < 0 and counttitle != "") {
        counttitle += 1
        return
    }
    pos := instr(titleoriginal, substr(title, 8, instr(title, "...") - 8))
    pos += 1
    newtitle := "title: " . substr(titleoriginal, pos)
    if(font0.pixelwidth(newtitle) > coverwidth){
        StringLen, len2, newtitle
        loop, %len2%
        {
            StringTrimRight, title2, newtitle, %A_Index%
            len3 := font0.PixelWidth(title2)
            len4 := coverwidth
            if(len3 < len4) {
                title = %title2%
                break
            }
        }
        counttitle = 0
    }
    else {
        counttitle += 1
        title := newtitle
    }
    GuiControl, 1:, title, %title%
}
else if(font0.pixelwidth(titleoriginal) > 300 and font0.pixelwidth(title) > 150 and currentview = 1)
{
    if(counttitle < 0 and counttitle != "") {
        counttitle += 1
        return
    }
    pos := instr(titleoriginal, substr(title, 8, instr(title, "...") - 8))
    pos += 1
    newtitle := "title: " . substr(titleoriginal, pos)
    if(font0.pixelwidth(newtitle) > 300){
        StringLen, len2, newtitle
        loop, %len2%
        {
            StringTrimRight, title2, newtitle, %A_Index%
            len3 := font0.PixelWidth(title2)
            len4 := 300
            if(len3 < len4) {
                title = %title2%
                break
            }
        }
        counttitle = 0
    }
    else {
        counttitle += 1
        title := newtitle
    }
    GuiControl, 1:, title, %title%
}
else {
    counttitle += 1 
    if(counttitle > 5) {
        title := "title: " . titleoriginal
        if(currentview != 1) {
            if(font0.pixelwidth(title) > coverwidth){
                StringLen, len2, title
                loop, %len2%
                {
                    StringTrimRight, title2, title, %A_Index%
                    len3 := font0.PixelWidth(title2)
                    len4 := coverwidth
                    if(len3 < len4) {
                        title = %title2%
                        break
                    }
                }
            }
        }
        else {
            if(font0.pixelwidth(title) > 300){
                StringLen, len2, title
                loop, %len2%
                {
                    StringTrimRight, title2, title, %A_Index%
                    len3 := font0.PixelWidth(title2)
                    len4 := 300
                    if(len3 < len4) {
                        title = %title2%
                        break
                    }
                }
            }
        }
        GuiControl, 1:, title, %title%
        counttitle = -5
        return
    }
}
return


get2(path) {
    FileRead, listfull, %DataPath%\fav.txt
    if listfull contains %path%
    {
        GuiControl, 1:, like, % "hBitmap:" like2_png()
        GuiControl, Menu:, likelist, Remove song from favourites
        liked = 1
    }
    else {
        GuiControl, 1:, like, % "hBitmap:" like_png()
        GuiControl, Menu:, likelist, Add song to favourites
        liked = 0
    }
    SplitPath, path, , ,ext, name
    if(ext in allext) {
        oMI.open(path)
        artist := oMI.GetInfo("general", "Artist")
        if !artist
        {
            title2 := name
            IfInString, Title2, -
            {
                loop, parse, title2, -
                {
                    if A_Index = 1
                    {
                        artist := "artist: " A_LoopField
                    }
                    Else if A_Index = 2
                    {
                        title := "title: " A_LoopField
                    }
                }
            }
            else {
                title = title: %title2%
                artist = artist: <unknown>
            }
        }
        else {
            title := "title: " oMI.GetInfo("general", "Title")
            artist = artist: %artist%
        }
        album := "album: " oMI.GetInfo("general", "Album")
        if(font0.pixelwidth(album) > 300){
            StringLen, len2, album
            loop, %len2%
            {
                StringTrimRight, album2, album, %A_Index%
                len3 := font0.PixelWidth(album2)
                if(len3 < 284) {
                    album = %album2%...
                    break
                }
            }
        }
        if(font0.pixelwidth(title) > 300){
            StringLen, len2, title
            loop, %len2%
            {
                StringTrimRight, title2, title, %A_Index%
                len3 := font0.PixelWidth(title2)
                if(len3 < 284) {
                    title = %title2%...
                    break
                }
            }
        }
        if(font0.pixelwidth(artist) > 300){
            StringLen, len2, artist
            loop, %len2%
            {
                StringTrimRight, artist2, artist, %A_Index%
                len3 := font0.PixelWidth(artist2)
                if(len3 < 284) {
                    artist = %artist2%...
                    break
                }
            }
        }
        GuiControl, 1:, title, %title%
        GuiControl, 1:, artist, %artist%
        GuiControl, 1:, album, %album%
        length := floor(oMI.GetInfo("general", "Duration") / 1000)
        exactduration := oMI.GetInfo("general", "Duration") / 1000
    }
    listfull =
}

WM_KEYDOWN(wParam, lParam) {
    if(wParam = 79 and lParam = 1572865 and GetKeystate("LCtrl", "D")) {
        if working
            return
        FileSelectFile, file, , C:\users\%A_Username%\music\*.*, Open audio file, Audio(*.mp3;*.wav;*.m4a;*.ogg;*.flac)
        if !file
            return
        SplitPath, file, filename, , OutExtension
        extensions = *.mp3;*.wav;*.m4a;*.ogg;*.flac
        if extensions not contains %OutExtension%
        {
            msgbox, The file "%FileName%" does not have a supportet file extension.`nplease make sure ur file ends with:`n"%extensions%"
            return
        }
        else {
            current := file
            IniWrite, %songs%, %config%, config, lastplaylist
            get(current)
            GuiControl, 1:, fulltime, % FormatSeconds(exactduration)
            AV.Url := Current
            if media
            {
                media = 0
                GuiControl,1:,pause,% "hBitmap:" pause_png()
            }
            SplitPath, current, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
            IniWrite, %current%, %config%, config, last
            LV_Modify("","-Select")
            cover()
        }
    }
    else if(wParam = 32 and lParam = 3735553) {
        if not media
        {
            media = 1
            guicontrol, 1:, Pause, % "hBitmap:" Play_png()
            GuiControl, Menu:, pm, Play
            Currvolume := AV.settings.volume
            AV.controls.Pause
        }
        else {
            media = 0
            guicontrol, 1:, Pause, % "hBitmap:" Pause_png()
            GuiControl, Menu:, pm, Pause
            AV.controls.Play
        }
    }
}

WM_MOUSEMOVE()
{
    if moving
        return
    CurrControl := A_GuiControl
    If (CurrControl <> PrevControl)
    {

        If (PrevControl="Playlist")
	    {
			restorecursors()
            cursor = 0
		}
        else If (PrevControl="loop")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="closelist")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="refresh")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="settings")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="artist")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="progress")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="progressvolume")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="progressfull")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="Add")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="full")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="fullscreen2")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="fav")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="shuffle")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="search")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="back")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="prev")
    	{
    	    GuiControl,1:,prev, % "hBitmap:" previous_png()
		    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="Pause")
    	{
    	    if not media
    	        GuiControl,1:,Pause, % "hBitmap:" Pause_png()
    	    else
    	        GuiControl,1:,Pause, % "hBitmap:" Play_png()
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="next")
    	{
   	        GuiControl,1:,next, % "hBitmap:" next_png()
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="Playing")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="alllist")
    	{
    	    restorecursors()
            cursor = 0
    	}
        else If (PrevControl="like")
    	{
    	    restorecursors()
            cursor = 0
    	}

    	PrevControl := CurrControl

        if(CurrControl = "") {
            return
        }
    	else If (CurrControl="Playlist")
		{
			SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="Playing")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="progress")
    	{
    	    SetSystemCursor("IDC_SIZEWE")
            cursor = 1
        }
    	else If (CurrControl="progressvolume")
    	{
    	    SetSystemCursor("IDC_SIZEWE")
            cursor = 1
    	}
    	else If (CurrControl="refresh")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
    	else If (CurrControl="settings")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="progressfull")
    	{
    	    SetSystemCursor("IDC_SIZEWE")
            cursor = 1
    	}
        else If (CurrControl="Add")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="closelist")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="fullscreen2")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="full")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="artist")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="loop")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="shuffle")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="fav")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="search")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="back")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="like")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (CurrControl="alllist")
    	{
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (PrevControl="prev")
    	{
    	    GuiControl,1:,prev, % "hBitmap:" previous2_png()
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (PrevControl="Pause")
    	{
    	    if not media
    	        GuiControl,1:,Pause, % "hBitmap:" Pause2_png()
    	    else
    	        GuiControl,1:,Pause, % "hBitmap:" Play2_png()
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}
        else If (PrevControl="next")
    	{
    	    GuiControl,1:,next, % "hBitmap:" next2_png()
    	    SetSystemCursor("IDC_HAND")
            cursor = 1
    	}

    }
    return
}

openlocation:
working = 1
if currentview = 2
{
    currentPlaylisttemp := songs
}
else if currentview = 3
{
    currentPlaylisttemp = %dataPath%\fav.txt
}
else if currentview = 5
{
    currentPlaylisttemp := currentPlaylist2
}
else if currentview = 6
{
    currentPlaylisttemp = %dataPath%\search.txt
}
else if(currentview = 8) {
    currentPlaylisttemp := queue
}
FileRead, listfull, %currentPlaylisttemp%
index3 = 0
loop, parse, listfull, `n
{
    if(A_LoopField != "")
        index3 += 1
    if(index3 = rownumber3) {
        path := substr(A_LoopField, 1, instr(A_LoopField, "/") - 1)
        run, %A_WInDir%\explorer.exe /select`, "%path%"
        break
    }
}
working = 0
listfull =
return

GuiContextMenu:
restorecursors()
if(A_GuiControl = "list") {
    if working
    {
        tooltip, App is currently loarding, please wait
        settimer, tooltipoff, 800
        return
    }
    rownumber3 := LV_GetNext()
    if (rownumber3 = 0) {
        if(currentview = 4) {
            Menu, playlist2, show
            return
        }
        else
            return
    }
    else if(currentview = 4) {
        if(rownumber3 = 1 or rownumber = 2) {
            return
        }
        Menu, playlist, show
        return
    }
    rows := LV_GetCount("selected")
    if(rows = 1) {
        if currentview = 2
        {
            currentPlaylisttemp := songs
        }
        else if currentview = 3
        {
            currentPlaylisttemp = %dataPath%\fav.txt
        }
        else if currentview = 6
        {
            currentPlaylisttemp = %dataPath%\search.txt
        }
        else if currentview = 5
        {
            currentPlaylisttemp := currentplaylist2
        }
        FileRead, listfull, %currentPlaylisttemp%
        searchstring = /
        index3 = 0
        loop, parse, listfull, `n
        {
            if(A_LoopField != "") {
                index3 += 1
            }
            if(index3 = rownumber3) {
                loop, parse, A_Loopfield, /
                {
                    if(A_Index = 1) {
                        file := A_Loopfield
                    }
                    break
                }
                break
            }
        }
        if !getlikestate(file)
        {
            Menu, list, rename, %likename%, Add song to liked songs
            likename = Add song to liked songs
        }
        else {
            Menu, list, rename, %likename%, Remove song from liked songs
            likename = Remove song from liked songs
        }
        Filestoadd = %current%/%titleoriginal%/%artistoriginal%/%length%`n
    }
    else {
        if(currentview = 3) {
            Menu, list, rename, %likename%, Remove songs from liked songs
            likename = Remove songs from liked songs
        }
        else {
            Menu, list, rename, %likename%, Add songs to liked songs
            likename = Add songs to liked songs
        }
        if currentview = 2
        {
            currentPlaylisttemp := songs
        }
        else if currentview = 3
        {
            currentPlaylisttemp = %dataPath%\fav.txt
        }
        else if currentview = 6
        {
            currentPlaylisttemp = %dataPath%\search.txt
        }
        else if currentview = 5
        {
            currentPlaylisttemp := currentplaylist2
        }
        FileRead, Listfull, %currentPlaylisttemp%
        max := rownumber3 + rows
        filestoadd =
        loop, parse, listfull, `n
        {
            SplitPath, A_LoopField, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
            if between(A_Index, rownumber3, max - 1) {
                if(OutExtension in allext) {
                    if(A_LoopField = "")
                        continue
                    filestoadd = %filestoadd%%A_LoopField%`n
                }
            }
            else if(A_Index = (max + 1))
                break
        }
    }
    Menu, list, show
}
else if(A_GuiControl = "cover") {
    if working
    {
        tooltip, App is currently loarding, please wait
        settimer, tooltipoff, 800
        return
    }
    menu, cover, show
}
else {
    if working
    {
        tooltip, App is currently loarding, please wait
        settimer, tooltipoff, 800
        return
    }
    menu, main, show
}
listfull =
return

removefromlist:
    working = 1
    if(currentview = 4) {
        rows := LV_GetCount("Selected")
        if(rownumber3 = 1 or rownumber3 = 2)
            return
        rownumbertemp := rownumber3 - 1
        loop, %rows%
        {
            rownumbertemp += %A_Index%
            LV_GetText(text, rownumbertemp)
            out = %PlaylistDir%\%text%.txt
            FileDelete, %out%
        }
        loop, %rows%
        {
            LV_Delete(rownumber3)
        }
        working = 0
        return
    }
    if currentview = 2
    {
        currentPlaylisttemp := songs
    }
    else if currentview = 3
    {
        currentPlaylisttemp = %dataPath%\fav.txt
    }
    else if currentview = 6
    {
        currentPlaylisttemp = %dataPath%\search.txt
    }
    else if currentview = 5
    {
        currentPlaylisttemp := currentplaylist2
    }
    rows := LV_GetCount("Selected")
    loop, %rows%
    {
        LV_Delete(rownumber3)
    }
    rows := rows + rownumber3 - 1
    FileRead, listfull, %currentPlaylisttemp%
    FileDelete, %currentPlaylisttemp%
    index3 = 0
    listfull2 =
        fav = %DataPath%\fav.txt
        loop, parse, listfull, `n
        {
        index3 += 1
        if !between(index3, rownumber3, rows) {
            listfull2 = %listfull2%`n%A_LoopField%
        }
        else if(currentPlaylisttemp = fav) {
            if A_LoopField contains %current%
            {
                liked = 0
                GuiControl, 1:, like, % "hBitmap:" like_png()
            }
        }
    }
    StringTrimLeft, listfull2, listfull2, 1
    FileAppend, %listfull2%, %currentPlaylisttemp%
    /*

loop, parse, listfull, `n
{
    if(A_LoopField != "") {
        index3 += 1
        if(index3 != rownumber3) {
            if(listfull2 != "")
                listfull2 = %listfull2%`n%A_LoopField%
            Else
                listfull2 = %A_LoopField%
        }
    }
    else {
        continue
    }
}
if(listfull2 != "")
    FileAppend, %listfull2%, %currentPlaylisttemp%
Else
    FileAppend, <empty>, %currentPlaylisttemp%
LV_Delete(rownumber3)
*/
working = 0
listfull =
return


WM_ICONCLICKNOTIFY(wParam,lParam)
{
	if (lParam = 0x205)
	{
        ytemp := A_ScreenHeight - 200
        CoordMode,Mouse,screen
        mousegetpos, menux, menuy
        if(menuy > ytemp) {
            menuy -= 117
        }
        Gui, menu: show, x%menux% y%menuy% w200 h117
        WinSet, Region, 0-0 w200 h117 r6-6, ahk_id %MenuID%
        CoordMode,Mouse,Relative
        WinActivate, ahk_id %Menu%
        settimer, removecontextmenu, 10
	}
	return 0
}

getsongfromnumber(number) {
    FileRead, listfull, %currentPlaylist%
    searchstring = /
    index3 = 0
    loop, parse, listfull, `n
    {
        if(A_LoopField != "")
            index3 += 1
        if(index3 = number) {
            found = 1
            return A_LoopField
        }
    }
    if not found
        return 0
    listfull =
}

getlikestate(path) {
    FileRead, listfull, %DataPath%\fav.txt
    if listfull contains %path%
        return 1
    else
        return 0
    listfull =
}

removecontextmenu:
WinGet, ID, ID, A
if(ID != MenuID) {
    Gui, Menu:hide
}
return

WM_LBUTTONDOWN()
{
    if working
        return
    CurrControl1 := A_GuiControl
    If (CurrControl1="" or CurrControl1="cover") {
        if (A_Gui = "1") {
            PostMessage, 0xA1, 2
        }
    }
    else if(A_Gui = "settings") {
        CurrControl := CurrControl1
        if(CurrControl = "brightness") {
            SetSystemCursor("IDC_SIZEWE")
            moving = 1
            color2 := RGB(green) . RGB(blue)
            CoordMode, mouse, Screen
            while GetKeyState("LButton", "P") {
                MouseGetPos, XPos
                WinGetPos, GuiX, , , , ahk_id %Settings%
                XPos := XPos - GuiX - 13
                if(XPos < 0)
                    xpos := 0
                if(XPos > 200)
                    XPos := 200
                if(XPos = XPosOld) {
                    continue
                }
                else {
                    XPosOld := XPos
                }
                GuiControl,settings:,brightness,%XPos%
                brightness := substr(XPos / 100, 1, instr(XPos / 100, ".") + 2)
                GuiControl,settings:,brightnessout,%brightness%
            }
            brightness := substr(XPos / 100, 1, instr(XPos / 100, ".") + 2)
            IniWrite, %brightness%, %config%, brightness, 1
            moving = 0
            redrawbackgroundbrightness()
            restorecursors()
        }
        else if(CurrControl = "red") {
            SetSystemCursor("IDC_SIZEWE")
            moving = 1
            GuiControlget, green, settings:, green
            GuiControlget, blue, settings:, blue
            color2 := RGB(green) . RGB(blue)
            CoordMode, mouse, Screen
            while GetKeyState("LButton", "P") {
                MouseGetPos, XPos
                WinGetPos, GuiX, , , , ahk_id %Settings%
                XPos := XPos - GuiX - 13
                if(XPos < 0)
                    xpos := 0
                if(XPos > 255)
                    XPos := 255
                if(XPos = XPosOld) {
                    continue
                }
                else {
                    XPosOld := XPos
                }
                GuiControl,settings:,red,%XPos%
                backgroundcolor2 := RGB(XPos) . color2
                GuiControl,settings:+c%backgroundcolor2%,color
                gray := getinvertgrayhex("0x" . backgroundcolor2)
                if between(gray, 0, 140)
                    GuiControl,settings:+background000000,color
                else
                    GuiControl,settings:+backgroundFFFFFF,color
            }
            bc := "0x" . backgroundcolor2
            IniWrite, %bc%, %config%, bc, 1
            moving = 0
            restorecursors()
            redrawbackground()
        }
        else if(CurrControl = "green") {
            SetSystemCursor("IDC_SIZEWE")
            moving = 1
            GuiControlget, red, settings:, red
            GuiControlget, blue, settings:, blue
            CoordMode, mouse, Screen
            while GetKeyState("LButton", "P") {
                MouseGetPos, XPos
                WinGetPos, GuiX, , , , ahk_id %Settings%
                XPos := XPos - GuiX - 13
                if(XPos < 0)
                    xpos := 0
                if(XPos > 255)
                    XPos := 255
                if(XPos = XPosOld) {
                    continue
                }
                else {
                    XPosOld := XPos
                }
                GuiControl,settings:,green,%XPos%
                backgroundcolor2 := RGB(red) . RGB(XPos) . RGB(blue)
                GuiControl,settings:+c%backgroundcolor2%,color
                gray := getinvertgrayhex("0x" . backgroundcolor2)
                if between(gray, 0, 140)
                    GuiControl,settings:+background000000,color
                else
                    GuiControl,settings:+backgroundFFFFFF,color
            }
            bc := "0x" . backgroundcolor2
            IniWrite, %bc%, %config%, bc, 1
            moving = 0
            restorecursors()
            redrawbackground()
        }
        else if(CurrControl = "blue") {
            SetSystemCursor("IDC_SIZEWE")
            moving = 1
            GuiControlget, red, settings:, red
            GuiControlget, green, settings:, green
            CoordMode, mouse, Screen
            while GetKeyState("LButton", "P") {
                MouseGetPos, XPos
                WinGetPos, GuiX, , , , ahk_id %Settings%
                XPos := XPos - GuiX - 13
                if(XPos < 0)
                    xpos := 0
                if(XPos > 255)
                    XPos := 255
                if(XPos = XPosOld) {
                    continue
                }
                else {
                    XPosOld := XPos
                }
                GuiControl,settings:,blue,%XPos%
                backgroundcolor2 := RGB(red) . RGB(green) . RGB(XPos)
                GuiControl,settings:+c%backgroundcolor2%,color
                gray := getinvertgrayhex("0x" . backgroundcolor2)
                if between(gray, 0, 140)
                    GuiControl,settings:+background000000,color
                else
                    GuiControl,settings:+backgroundFFFFFF,color
            }
            bc := "0x" . backgroundcolor2
            IniWrite, %bc%, %config%, bc, 1
            moving = 0
            restorecursors()
            redrawbackground()
        }
        else if(CurrControl = "red1") {
            SetSystemCursor("IDC_SIZEWE")
            moving = 1
            GuiControlget, green, settings:, green1
            GuiControlget, blue, settings:, blue1
            color2 := RGB(green) . RGB(blue)
            CoordMode, mouse, Screen
            while GetKeyState("LButton", "P") {
                MouseGetPos, XPos
                WinGetPos, GuiX, , , , ahk_id %Settings%
                XPos := XPos - GuiX - 13
                if(XPos < 0)
                    xpos := 0
                if(XPos > 255)
                    XPos := 255
                if(XPos = XPosOld) {
                    continue
                }
                else {
                    XPosOld := XPos
                }
                GuiControl,settings:,red1,%XPos%
                textcolor2 := RGB(XPos) . color2
                GuiControl,settings:+c%textcolor2%,color1
                gray := getinvertgrayhex("0x" . textcolor2)
                if between(gray, 0, 140)
                    GuiControl,settings:+background000000,color1
                else
                    GuiControl,settings:+backgroundFFFFFF,color1
            }
            textcolor := "0x" . textcolor2
            IniWrite, %textcolor%, %config%, textcolor, 1
            moving = 0
            restorecursors()
            redrawtext()
        }
        else if(CurrControl = "green1") {
            SetSystemCursor("IDC_SIZEWE")
            moving = 1
            GuiControlget, red, settings:, red1
            GuiControlget, blue, settings:, blue1
            CoordMode, mouse, Screen
            while GetKeyState("LButton", "P") {
                MouseGetPos, XPos
                WinGetPos, GuiX, , , , ahk_id %Settings%
                XPos := XPos - GuiX - 13
                if(XPos < 0)
                    xpos := 0
                if(XPos > 255)
                    XPos := 255
                if(XPos = XPosOld) {
                    continue
                }
                else {
                    XPosOld := XPos
                }
                GuiControl,settings:,green1,%XPos%
                textcolor2 := RGB(red) . RGB(XPos) . RGB(blue)
                GuiControl,settings:+c%textcolor2%,color1
                gray := getinvertgrayhex("0x" . textcolor2)
                if between(gray, 0, 140)
                    GuiControl,settings:+background000000,color1
                else
                    GuiControl,settings:+backgroundFFFFFF,color1
            }
            textcolor := "0x" . textcolor2
            IniWrite, %textcolor%, %config%, textcolor, 1
            moving = 0
            restorecursors()
            redrawtext()
        }
        else if(CurrControl = "blue1") {
            SetSystemCursor("IDC_SIZEWE")
            moving = 1
            GuiControlget, red, settings:, red1
            GuiControlget, green, settings:, green1
            CoordMode, mouse, Screen
            while GetKeyState("LButton", "P") {
                MouseGetPos, XPos
                WinGetPos, GuiX, , , , ahk_id %Settings%
                XPos := XPos - GuiX - 13
                if(XPos < 0)
                    xpos := 0
                if(XPos > 255)
                    XPos := 255
                if(XPos = XPosOld) {
                    continue
                }
                else {
                    XPosOld := XPos
                }
                GuiControl,settings:,blue1,%XPos%
                textcolor2 := RGB(red) . RGB(green) . RGB(XPos)
                GuiControl,settings:+c%textcolor2%,color1
                gray := getinvertgrayhex("0x" . textcolor2)
                if between(gray, 0, 140)
                    GuiControl,settings:+background000000,color1
                else
                    GuiControl,settings:+backgroundFFFFFF,color1
            }
            textcolor := "0x" . textcolor2
            IniWrite, %textcolor%, %config%, textcolor, 1
            moving = 0
            restorecursors()
            redrawtext()
        }
        else if(CurrControl = "red2") {
            SetSystemCursor("IDC_SIZEWE")
            moving = 1
            GuiControlget, green, settings:, green2
            GuiControlget, blue, settings:, blue2
            color2 := RGB(green) . RGB(blue)
            CoordMode, mouse, Screen
            while GetKeyState("LButton", "P") {
                MouseGetPos, XPos
                WinGetPos, GuiX, , , , ahk_id %Settings%
                XPos := XPos - GuiX - 13
                if(XPos < 0)
                    xpos := 0
                if(XPos > 255)
                    XPos := 255
                if(XPos = XPosOld) {
                    continue
                }
                else {
                    XPosOld := XPos
                }
                GuiControl,settings:,red2,%XPos%
                iconcolor2 := RGB(XPos) . color2
                GuiControl,settings:+c%iconcolor2%,color2
                gray := getinvertgrayhex("0x" . iconcolor2)
                if between(gray, 0, 140)
                    GuiControl,settings:+background000000,color2
                else
                    GuiControl,settings:+backgroundFFFFFF,color2
            }
            iconcolor := "0x" . iconcolor2
            IniWrite, %iconcolor%, %config%, iconcolor, 1
            moving = 0
            restorecursors()
            redrawicons()
        }
        else if(CurrControl = "green2") {
            SetSystemCursor("IDC_SIZEWE")
            moving = 1
            GuiControlget, red, settings:, red2
            GuiControlget, blue, settings:, blue2
            CoordMode, mouse, Screen
            while GetKeyState("LButton", "P") {
                MouseGetPos, XPos
                WinGetPos, GuiX, , , , ahk_id %Settings%
                XPos := XPos - GuiX - 13
                if(XPos < 0)
                    xpos := 0
                if(XPos > 255)
                    XPos := 255
                if(XPos = XPosOld) {
                    continue
                }
                else {
                    XPosOld := XPos
                }
                GuiControl,settings:,green2,%XPos%
                iconcolor2 := RGB(red) . RGB(XPos) . RGB(blue)
                GuiControl,settings:+c%iconcolor2%,color2
                gray := getinvertgrayhex("0x" . iconcolor2)
                if between(gray, 0, 140)
                    GuiControl,settings:+background000000,color2
                else
                    GuiControl,settings:+backgroundFFFFFF,color2
            }
            iconcolor := "0x" . iconcolor2
            IniWrite, %iconcolor%, %config%, iconcolor, 1
            moving = 0
            restorecursors()
            redrawicons()
        }
        else if(CurrControl = "blue2") {
            SetSystemCursor("IDC_SIZEWE")
            moving = 1
            GuiControlget, red, settings:, red2
            GuiControlget, green, settings:, green2
            CoordMode, mouse, Screen
            while GetKeyState("LButton", "P") {
                MouseGetPos, XPos
                WinGetPos, GuiX, , , , ahk_id %Settings%
                XPos := XPos - GuiX - 13
                if(XPos < 0)
                    xpos := 0
                if(XPos > 255)
                    XPos := 255
                if(XPos = XPosOld) {
                    continue
                }
                else {
                    XPosOld := XPos
                }
                GuiControl,settings:,blue2,%XPos%
                iconcolor2 := RGB(red) . RGB(green) . RGB(XPos)
                GuiControl,settings:+c%iconcolor2%,color2
                gray := getinvertgrayhex("0x" . iconcolor2)
                if between(gray, 0, 140)
                    GuiControl,settings:+background000000,color2
                else
                    GuiControl,settings:+backgroundFFFFFF,color2
            }
            iconcolor := "0x" . iconcolor2
            IniWrite, %iconcolor%, %config%, iconcolor, 1
            moving = 0
            restorecursors()
            redrawicons()
        }
    }
    else If (CurrControl1="Progress") {
        settimer, slider, off
        SetSystemCursor("IDC_SIZEWE")
        moving = 1
        while getkeystate("LButton", "D") {
            MouseGetPos, xpos
            if(xpos < 0)
                xpos = 0
            if(xpos > GuiWidth)
                xpos := GuiWidth
            GuiControl, 1:, progress, %xpos%
            multislider3 := xpos / GuiWidth
            multislider4 := exactduration * multislider3
            GuiCOntrol, 1:, currenttime, % FormatSeconds(multislider4)
        }
        settimer, slider, 50
        restorecursors()
        cursor = 0
        tooltip,
        MouseGetPos, xpos
        if(xpos < 0)
            xpos = 0
        if(xpos > GuiWidth)
            xpos := GuiWidth
        GuiControl, 1:, progress, %xpos%
        multislider4 := xpos / GuiWidth
        multislider5 := exactduration * multislider4
        AV.controls.currentPosition := multislider5
        moving = 0
    }
    else if(CurrControl1 = "progressvolume") {
        SetSystemCursor("IDC_SIZEWE")
        moving = 1
        xtemp := GuiWidth - 195
        while getkeystate("LButton", "D") {
            MouseGetPos, xpos
            xpos -= %xtemp%
            if(xpos < 0)
                xpos := 0
            if(xpos > 100)
                xpos := 100
            GuiControl, 1:, progressvolume, %xpos%
        }
        restorecursors()
        cursor = 0
        tooltip,
        MouseGetPos, xpos
        xpos -= %xtemp%
        if(xpos < 0)
            xpos := 0
        if(xpos > 100)
            xpos := 100
        GuiControl, 1:, progressvolume, %xpos%
        AV.Settings.volume := xpos
        IniWrite, %xpos%, %config%, volume, 1
        moving = 0
    }
}

cover() {
    working = 1
    filedelete, %cover%
    filedelete, %cover2%
    oMI.Open(current)
    base64 := oMI.GetInfo("general", "Cover_Data")
    GDIP_disposeimage(BlurBitmap)
    if !base64
    {
        pBitmap := empty_png()
        Gdip_SaveBitmapToFile(pBitmap, cover, 100)
        Gdip_SaveBitmapToFile(pBitmap, cover2, 100)
    }
    else {
        pBitmap := Gdip_BitmapFromBase64(base64)
        width := Gdip_GetImageWidth(pbitmap)
        height := Gdip_GetImageHeight(pbitmap)
        if(width > height) {
            width2 := height
            height2 := height
            x2 := (width - height) / 2
            y2 := 0
            pbitmap3 := Gdip_CreateBitmap(coverwidth, coverwidth)
            pbitmap2 := Gdip_CreateBitmap(width2, height2)
            g2 := Gdip_GraphicsFromImage(pbitmap2), Gdip_SetSmoothingMode(G2, 4)
            g3 := Gdip_GraphicsFromImage(pBitmap3), Gdip_SetSmoothingMode(G3, 4)
            Gdip_DrawImage(g2, pbitmap, 0, 0, width2, height2, x2, y2, width2, height2)
            Gdip_DrawImage(g3, pbitmap, 0, 0, coverwidth, coverwidth, x2, y2, width2, height2)
            pBitmaptemp := empty_png()
            Gdip_DrawImage(g3, pBitmaptemp, 0, (coverwidth - 30), 30, 30)
        }
        else if(height > width) {
            width2 := width
            height2 := width
            y2 := ((height - width) / 2)
            x2 := 0
            pbitmap3 := Gdip_CreateBitmap(coverwidth, coverwidth)
            pbitmap2 := Gdip_CreateBitmap(width2, height2)
            g2 := Gdip_GraphicsFromImage(pbitmap2), Gdip_SetSmoothingMode(G2, 4)
            g3 := Gdip_GraphicsFromImage(pBitmap3), Gdip_SetSmoothingMode(G3, 4)
            Gdip_DrawImage(g2, pbitmap, 0, 0, width2, height2, x2, y2, width2, height2)
            Gdip_DrawImage(g3, pbitmap, 0, 0, coverwidth, coverwidth, x2, y2, width2, height2)
            pBitmaptemp := empty_png()
            Gdip_DrawImage(g3, pBitmaptemp, 0, (coverwidth - 30), 30, 30)
        }
        else {
            pbitmap3 := Gdip_CreateBitmap(coverwidth, coverwidth)
            pbitmap2 := Gdip_CreateBitmap(width, height)
            g3 := Gdip_GraphicsFromImage(pBitmap3), Gdip_SetSmoothingMode(G3, 4)
            g2 := Gdip_GraphicsFromImage(pbitmap2), Gdip_SetSmoothingMode(G2, 4)
            Gdip_DrawImage(g2, pbitmap, 0, 0, width, height, 0, 0, width, height)
            Gdip_DrawImage(g3, pbitmap, 0, 0, coverwidth, coverwidth, 0, 0, width, height)
            pBitmaptemp := empty_png()
            Gdip_DrawImage(g3, pBitmaptemp, 0, (coverwidth - 30), 30, 30)
        }
        Gdip_SaveBitmapToFile(pBitmap2, cover, 100)
        Gdip_SaveBitmapToFile(pBitmap3, cover2, 100)
        Gdip_DisposeImage(pBitmaptemp)
        Gdip_DisposeImage(pbitmap3)
        Gdip_DisposeImage(pbitmap2)
        Gdip_DeleteGraphics(g2)
        Gdip_DeleteGraphics(g3)
    }
    oMI.close()
    BlurBitmap2 := Gdip_BlurBitmap( pBitmap , 100, 2)
    BlurBitmap4 := Gdip_BlurBitmap( BlurBitmap2 , 100, 2)
    BlurBitmap3 := FitFullSize2(BlurBitmap4, GuiWidth * 1.5, GuiHeight * 1.5)
    BlurBitmap := Gdip_CreateBitmap(GuiWidth, GuiHeight)
    G3 := Gdip_GraphicsFromImage(BlurBitmap), Gdip_SetSmoothingMode(G3, 2)
    matrix = %brightness%|0|0|0|0|0|%brightness%|0|0|0|0|0|%brightness%|0|0|0|0|0|1|0|0.01|0.01|0.01|0|1
    GDIP_drawimage(G3, BlurBitmap3,0,0,GuiWidth, GuiHeight,GuiWidth / 4,GuiHeight / 4,GuiWidth,GuiHeight, matrix)
    if currentview != 1
    {
        hbitmap := Gdip_CreateHBITMAPFromBitmap(blurbitmap, "0xFF" . substr(bc, 3))
        gettextcolor(BlurBitmap)
        guiControl,1:,background, % "hbitmap: " hbitmap
    }
    else {
        Bitmaptemp2 := FitFullSize(pBitmap, GuiWidth, GuiHeight)
        hbitmap := Gdip_CreateHBITMAPFromBitmap(Bitmaptemp2, "0xFF" . substr(bc, 3))
        guiControl,1:,background, % "*w%GUiWidth% *h%GuiHeight% hbitmap: " hbitmap
    }
    GuiControl, 1:, cover, %cover2%
    GuiControl, 1:, title, %title%
    GuiControl, 1:, artist, %artist%
    GuiControl, 1:, album, %album%
    Gdip_DeleteGraphics(G3)
    Gdip_DisposeImage( pBitmap )
    Gdip_DisposeImage(BlurBitmap2)
    Gdip_DisposeImage(BlurBitmap3)
    Gdip_DisposeImage(BlurBitmap4)
    ;Gdip_DisposeImage( BlurBitmap )
    DeleteObject( DispalyBitmapBlur )
    working = 0
}

getinvertgray(ARGB) {
    trans := Format("{:i}", "0x" substr(color, 1, 2))
    color := "0x" . substr(ARGB, 3)
    SplitRGBColor(color, R, G, B)
    gray := (0.299 * R) + (0.587 * G) + (0.114 * B)
    gray := gray - (trans * (gray / 255))
    gray := substr(gray - 255, 2)
    return gray
}

getinvertgrayhex(hex) {
    SplitRGBColor(hex, R, G, B)
    gray := (0.299 * R) + (0.587 * G) + (0.114 * B)
    gray := substr(gray - 255, 2)
    return gray
}

getTextColor(pBitmap) {
    color := Format("{1:x}", Gdip_GetPixel(pBitmap,ResultX + 50, ResultY + 10), 195948557, 0)
    if not color
        out = %textcolor%
    else {
        gray := getinvertgray(color)
        if between(gray, 140, 255)
            out = %textcolor%
        else if between(gray, 0, 140)
            out = 0x000000
    }
    GuiControl,1:+c%out%,results
    color := Format("{1:x}", Gdip_GetPixel(pBitmap,50, ResultY + 10), 195948557, 0)
    if not color
        out = %textcolor%
    else {
        gray := getinvertgray(color)
        if between(gray, 140, 255)
            out = %textcolor%
        else if between(gray, 0, 140)
            out = 0x000000
    }
    GuiControl,1:+c%out%,currenttime
    color := Format("{1:x}", Gdip_GetPixel(pBitmap,GuiWidth - 30, ResultY + 10), 195948557, 0)
    if not color
        out = %textcolor%
    else {
        gray := getinvertgray(color)
        if between(gray, 140, 255)
            out = %textcolor%
        else if between(gray, 0, 140)
            out = 0x000000
    }
    GuiControl,1:+c%out%,fulltime
    ;
    x := listwidth + 97
    y := listheight + 5
    color := Format("{1:x}", Gdip_GetPixel(pBitmap,x, y), 195948557, 0)
    if not color
        out = %textcolor%
    else {
        gray := getinvertgray(color)
        if between(gray, 140, 255)
            out = %textcolor%
        else if between(gray, 0, 140)
            out = 0x000000
    }
    GuiControl,1:+c%out%,timeneed
    return
}


getversion() {
    api_dev_key := "rxkjcbgzFHCQvxDLH9OjeJMTPjE0gGv5"
    api_user_name := "Align_coding"
    api_user_password := "WPG1LOL.durvi"
    api_user_name := urlencode(api_user_name)
    api_user_password := urlencode(api_user_password)
    url := "https://pastebin.com/api/api_login.php"
    ch := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    ch.Open("POST", url, false)
    ch.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    ch.Send("api_dev_key=" api_dev_key "&api_user_name=" api_user_name "&api_user_password=" api_user_password)
    api_user_key := ch.ResponseText
    api_results_limit := "100"
    url := "https://pastebin.com/api/api_post.php"
    ch.Open("POST", url, false)
    ch.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    ch.Send("api_option=list&api_user_key=" . api_user_key . "&api_dev_key=" . api_dev_key . "&api_results_limit=" . api_results_limit)
    response := ch.ResponseText
    api_paste_key := 0
    loop, parse, response, `n
    {
        if A_LoopField contains <paste_key>
        {
            Version_key2 := A_LoopField
            stringtrimleft, Version_key2, Version_key2, 12
            stringtrimright, Version_key2, Version_key2, 12
        }
        if A_LoopField contains <paste_title>
        {
            RegExMatch(A_LoopField, "<paste_title>\K.*(?=</paste_title>)", TEST)
            if(Test = "Version") {
                api_paste_key := Version_key2
            }
        }
    }
    if(api_paste_key != 0) {
        api_option := "show_paste"
        url := "https://pastebin.com/api/api_post.php"
        ch.Open("POST", url, false)
        ch.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
        ch.Send("api_dev_key=" api_dev_key "&api_user_key=" api_user_key "&api_option=" api_option "&api_paste_key=" api_paste_key)
        Version := ch.ResponseText
    }
    Else
        Version = 0
    return Version
}

loadtoall(path) {
    working = 1
    files = 0
    extensionsload = mp3.wav.m4a.ogg.flac.avi.webm.mkv
    FileRead, listfull, %songs%
    loop, %path%\*.*, 0, 1
    {
        if listfull contains %A_LoopFileFullPath%
            continue
        if listfull contains %A_LoopFileFullPath%
            continue
        if extensionsload contains %A_LoopFileExt%
        {
            files += 1
        }
    }
    listfull2 := ""
    loop, %path%\*.*, 0, 1
    {
        if extensionsload contains %A_LoopFileExt%
        {
            if listfull contains %A_LoopFileFullPath%
                continue
            files2 += 1
            GuiControl,1:,timeneed, scanned %files2%/%files%
            oMI.Open(A_LoopFileFullPath)
            durationload := floor(oMI.GetInfo("general", "Duration") / 1000)
            if(durationload < 5)
                continue
            artistload := oMI.GetInfo("general", "Artist")
            if !artistload
            {
                titleload := A_LoopFileName
                IfInString, Titleload, -
                {
                    loop, parse, titleload, -
                    {
                        if A_Index = 1
                        {
                            artistload := A_LoopField
                        }
                        Else if A_Index = 2
                        {
                            titleload := A_LoopField
                        }
                    }
                }
                else {
                    artistload = <unknown>
                }
            }
            else {
                titleload := oMI.GetInfo("general", "Title")
            }
            listfull2 = %listfull2%%A_LoopFileFullPath%/%titleload%/%artistload%/%durationload%`n
        }
    }
    Fileappend, %listfull2%, %songs%
    tooltip, 
    working = 0
    listfull =
}