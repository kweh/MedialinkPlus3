﻿DetectHiddenWindows, On
SetTitleMatchMode, 2
DetectHiddenText, On
#SingleInstance force

#include paths.ahk
#include secure.ahk
#include menu_names.ahk

version = 309

SplashImage = %dir_img%\splash.png
SplashImageGUI(SplashImage, "Center", "Center", 3000, true)
sleep, 2000

#include update.ahk

;Timer för filecheck
from_fc := false
SetTimer, fc_go, 60000


IniRead, RMenuColor, %mlpSettings%, Theme, RMenuColor
	if (RMenuColor = "ERROR")
	{
		RMenuColor = FFFFFF
	}

; count := zen_get_ticket_count()
;
; IniRead, zenNote, %mlpDir%\settings.ini, ZenNotes, aktiv
; 	if (zenNote = 1)
; 	{
; 		SetTimer, zen_notify, 60000
; 	}

menu, tray, add, Starta om Medialink Plus, reload


gosub, updateStart

~RButton::
	Start = %A_TickCount%
	if (mlActive())
	{
		activeDone := A_TickCount - Start
		if (menu)
		{
			menu, mlp, DeleteAll ; Initialisera
			menu, filecheck, DeleteAll ; Initialisera
			menu = False
		}


		Click, right
		Send, {Esc}
		MouseGetPos, , , id, control
		gosub, getList
		listDone := A_TickCount - Start
		gosub, note
		noteDone := A_TickCount - Start


		;Hitta print-knappen
		menu, mlp, add, %m_findprint%, pdf-preview
		menu, mlp, Icon, %m_findprint%, %dir_icons%\inteprint.ico
		menu, mlp, disable, %m_findprint%
		print := printCheck(mlOrdernummer, "-01")
		printDone := A_TickCount - Start
		if (print = "print" || print = "bild") ; Kollar om det finns en print
		{
			menu, mlp, Icon, %m_findprint%, %dir_icons%\print.ico
			menu, mlp, enable, %m_findprint%
		}

		menu, mlp, add, %m_copy%, kundOrder
		menu, mlp, Icon, %m_copy%, %dir_icons%\kopiera.ico
		

		menu, mlp, add
		menu, mlp, add, Tilldela och Bearbeta, status_tilldela
		menu, mlp, Icon, Tilldela och Bearbeta, %dir_icons%\tilldelabearbeta.ico
		; Skapa annons
		menu, mlp, add, %m_createPS%, photoshop
		menu, mlp, Icon, %m_createPS%, %dir_icons%\photoshop.ico
		menu, mlp, add, %m_createFL%, flash
		menu, mlp, Icon, %m_createFL%, %dir_icons%\flash.ico
		menu, mlp, add, %m_dir%, oppna
		menu, mlp, Icon, %m_dir%, %dir_icons%\oppnacxense.ico
		menu, mlp, add

		; Cxense
		menu, cx, add, Boka kampanj, multiCxStart
		menu, cx, Icon, Boka kampanj, %dir_icons%\bokacxense.ico
		menu, cx, add, Öppna kampanj i cxense, multiCxOpen
		menu, cx, Icon, Öppna kampanj i cxense, %dir_icons%\oppnakampanjcxense.ico
		menu, cx, add, Öppna kund i cxense, openCustomerCx
		menu, cx, Icon, Öppna kund i cxense, %dir_icons%\oppnakundcxense.ico
		menu, mlp, add, %m_cx%, :cx
		menu, mlp, Icon, %m_cx%, %dir_icons%\cxense.ico

		; rapportverktyget
		menu, rapport, add, Öppna kampanj i rapportverktyget, openCampaignRapportMulti
		menu, rapport, Icon, Öppna kampanj i rapportverktyget, %dir_icons%\oppnakampanjcxense.ico
		menu, rapport, add, Öppna kund i rapportverktyget, openCustomerRapportMulti
		menu, rapport, Icon, Öppna kund i rapportverktyget, %dir_icons%\oppnakundcxense.ico
		menu, mlp, add, %m_report%, :rapport
		menu, mlp, Icon, %m_report%, %dir_icons%\rapport.ico
		menu, mlp, add

		; Status
		menu, status, add, Ny, status_ny
		menu, status, icon, Ny, %dir_icons%\status\ny.ico

		menu, status, add, Bokad, status_bokad
		menu, status, icon, Bokad, %dir_icons%\status\ny.ico

		menu, status, add, Vilande, status_vilande
		menu, status, icon, vilande, %dir_icons%\status\vilande.ico

		menu, status, add, Manus på mail, status_manusmail
		menu, status, icon, Manus på mail, %dir_icons%\status\vilande.ico

		menu, status, add, Bearbetas, status_Bearbetas
		menu, status, icon, Bearbetas, %dir_icons%\status\Bearbetas.ico

		menu, status, add, Repetition, status_Repetition
		menu, status, icon, Repetition, %dir_icons%\status\Repetition.ico

		menu, status, add, Korrektur skickat, status_korrekturskickat
		menu, status, icon, Korrektur skickat, %dir_icons%\status\korrektur.ico

		menu, status, add, Korrektur klart, status_korrekturklart
		menu, status, icon, Korrektur klart, %dir_icons%\status\korrektur.ico

		menu, status, add, Lev. Färdig, status_levfardig
		menu, status, icon, Lev. Färdig, %dir_icons%\status\levfardig.ico

		menu, status, add, Undersöks, status_undersoks
		menu, status, icon, Undersöks, %dir_icons%\status\undersoks.ico
	
		menu, status, add, Sent bokad, status_sentbokad
		menu, status, icon, Sent bokad, %dir_icons%\status\sentbokad.ico

		menu, status, add, Obekräftad, status_obekraftad
		menu, status, icon, Obekräftad, %dir_icons%\status\Klar.ico

		menu, status, add, Klar, status_Klar
		menu, status, icon, Klar, %dir_icons%\status\Klar.ico

		menu, status, add, Annan..., status_annan

		menu, mlp, add, %m_status%, :status
		menu, mlp, Icon, %m_status%, %dir_icons%\status.ico



		; Tilldela
		menu, assign, add, ...mig, assign_me
		menu, assign, add, ...annan, assign_other
		menu, assign, add, ...ingen, assign_none
		menu, mlp, add, %m_assign%, :assign
		menu, mlp, Icon, %m_assign%, %dir_icons%\tilldela.ico
		; Mail
		menu, mlp, add, %m_mail%, mailGeneral
		menu, mlp, Icon, %m_mail%, %dir_icons%\fraga.ico
		menu, mlp, add, %m_korr%, mailKorr
		menu, mlp, Icon, %m_korr%, %dir_icons%\mailakorr.ico
		menu, mlp, add

		; Kommentera
		menu, mlp, add, %m_comment%, comment
		menu, mlp, Icon, %m_comment%, %dir_icons%\kommentera.ico


		menu, mlp, add, %m_search%, sokOrder
		menu, mlp, Icon, %m_search%, %dir_icons%\sok.ico

		; Filövervakning
		fc_antal := 0
		Loop, read, %mlp_filechecklist% ; räknar antal övervakade filer
		{
			fc_antal++
		}

		menu, filecheck, add, Lägg till i lista, fc_check
		menu, filecheck, Icon, Lägg till i lista, %dir_icons%\plus.ico
		FileRead, fc_list, %mlp_filechecklist%
		if (fc_list != "")
		{
			menu, filecheck, add
			Loop, read, %mlp_filechecklist%
			{
				menu, filecheck, add, %A_LoopReadLine%, fc_select
			}
			menu, filecheck, add
			menu, filecheck, add, Rensa övervakningslista, fc_clear
			menu, filecheck, Icon, Rensa övervakningslista, %dir_icons%\trash.ico
		}
		menu, mlp, add, Filövervakning, :filecheck
		menu, mlp, Icon, Filövervakning, %dir_icons%\filecheck.ico
		fileDone := A_TickCount - Start

		; Traffic
		menu, traffic, add, Uppdatera lagerverktyget, lager
		menu, traffic, add, Räkna markerade annonser, rakna
		menu, traffic, add, Räkna exponeringar, raknaExp
		menu, traffic, add, Kopiera rader, copyCampaigns
		menu, mlp, add, %m_traffic%, :traffic
		menu, mlp, Icon, %m_traffic%, %dir_icons%\traffic.ico

		menu, mlp, add, %m_settings%, mlpSettings
		menu, mlp, Icon, %m_settings%, %dir_icons%\settings.ico

		; Felsökning
		IniRead, dev, %mlpSettings%, Misc, Dev
			if (dev = 1)
				{
					menu, dev, add, Vad är detta?, whatsthis
					menu, dev, add, Produktinfo CX (cpc), cxprod_cpc
					menu, dev, add, Produktinfo CX (ros), cxprod_ros
					menu, dev, add, Produktinfo CX (riktad), cxprod_riktad
					menu, dev, add, Skriv fil till \cxense\, testWrite
					menu, dev, add, Öppna \cxense\, opencxpath
					menu, dev, add, Kolla tid för att ladda meny, menutime
					menu, mlp, add, %m_dev%, :dev
				}
		
		
		menu, mlp, Color, %RMenuColor%

		menu = true
		menu, mlp, show

	}

~LButton::
	CoordMode, Mouse, Screen
	MouseGetPos,mX ,mY , id, control
	; ifWinActive, Atex MediaLink
	; {
	; 	gosub, getList
	; 	gosub, note
	; }

	IfWinActive, NewsCycle MediaLink
	{
		gosub, getList
		gosub, note
	}
return

~Delete::
if (mlActive())
	{
	status("Klar")
	sleep, 100
	Send, {Shift down}{F5}{Shift up}
	}
return

GuiClose:
	Gui, Destroy
return

prodInfo:
	getFormat(mlEnhet)
	cxProduct(format, "riktad") ; returnerar productId, siteTargetingId och keywordsId
return

fleraPrint:
	data := checkPrints(mlOrdernummer)
return

testWrite:
	FileAppend, test, %dir_cxense%\test.txt
return


mailGeneral:
	mail := mlSaljare
	subject := "Ang. " mlKundnamn " (" mlOrdernummer ")"
	body := ""
	mail(mail, subject, body)
return

mailKorr:
	mail := mlSaljare
	subject := "Korrektur: " mlKundnamn " (" mlOrdernummer ")"
	gosub, getKorr
	body =
(


----

{CTRL down}f{CTRL up}Länk för rapport:{CTRL down}f{CTRL up}
%rapportUrl%

Spara denna länk{Shift down}1{Shift up}
På denna länk finns information om hur ordern är inbokad. Kontrollera så att start/stoppdatum stämmer och att antal exponeringar är korrekt. Om vi inte får något svar startar kampanjen på startdatumet. Denna länk fungerar även som statusrapport för denna kampanj. Här kan du se exakt hur många exponeringar/klick som levererats hittills i kampanjen. Om du någon gång under kampanjens gång upplever att något inte står rätt till, kontakta digital.support@ntm.eu.

----

{CTRL down}{Home}{CTRL up}
)
	if (campaignID = "")
	{
		body = 
	}
	status("korrektur skickat")
	mail(mail, subject, body)
return

^#r::
reload
return



~+<:: ; Låter Shift+< agera som Shift+F5
	if (mlActive())
	{
		Send, {Shift Down}{F5}{Shift Up}
	}
return

~^a:: ; Gör att ctrl+a fungerar i MediaLink
	if (mlActive())
	{
		Send, {Home}
		Send, {Shift Down}
		Send, {End}
		Send, {Shift Up}
	}
return

; ~LButton UP::
; 	MouseGetPos, , , id, control
; 	IfInString, control, Edit3
; 		{
; 			IfWinActive, Atex MediaLink
; 			{
; 				temp_clip := Clipboard
; 				Send, ^c
; 				regex := "0{0,3}(\d{7}-\d{2})"
; 				RegExMatch(Clipboard, regex, match)
; 				if (match1 = "")
; 				{
; 					Clipboard := temp_clip
; 				} 
; 				else {
; 					line2 := Clipboard
; 					Clipboard := temp_clip
; 					from_fc := true
; 					menu, context_ordernr, add, Kontrollera print, context_print
; 					menu, context_ordernr, add, Sök på ordernummer, sokOrder
; 					menu, context_ordernr, show
; 				}
; 				Clipboard := temp_clip
; 			}
; 		}
; return

context_print:
	StringSplit, nummer, line2, -
	data := printCheck(line2, nummer2)
	if(data != "")
	{
		IfNotInString, line2, 000
		{
			line2 := "000"line2
		}
		gosub, pdf-preview
	}
Return

nothing:
return

;
;	INCLUDES
;__________________________________________________________

#include func.ahk
#include cxense.ahk
#include subs.ahk
#include pdf_preview.ahk
#include settings.ahk
#include httpreq.ahk
#include json.ahk
; #include zendesk.ahk
#include note.ahk
#include dev.ahk
#include mlFileCheck.ahk