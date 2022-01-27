#define CHARS_PER_LINE 5
#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
#define FONT_STYLE "Arial Black"

//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

///////////////////////////////////////////////////////////////////////////////////////////////
// Bri69 Door control displays.
//  Description: This is a controls the timer for the bri69 doors, displays the timer on itself and
//               has a popup window when used, allowin69 to set the timer.
//  Code Notes: Combination of old bri69door.dm code from rev4407 and the status_display.dm code
//  Date: 01/September/2010
//  Pro69rammer:69eryinky
/////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/door_timer
	name = "Door Timer"
	icon = 'icons/obj/status_display.dmi'
	icon_state = "frame"
	desc = "A remote control for a door."
	re69_access = list(access_bri69)
	anchored = TRUE    		// can't pick it up
	density = FALSE       		// can walk throu69h it.
	var/id     		// id of door it controls.
	var/releasetime = 0		// when world.timeofday reaches it - release the prisoner
	var/timin69 = 1    		// boolean, true/1 timer is on, false/069eans it's not timin69
	var/picture_state		// icon_state of alert picture, if not displayin69 text/numbers
	var/list/obj/machinery/tar69ets = list()
	var/timetoset = 0		// Used to set releasetime upon startin69 the timer
	var/list/advanced_access = list(access_armory)

	maptext_hei69ht = 26
	maptext_width = 32

/obj/machinery/door_timer/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD


/obj/machinery/door_timer/LateInitialize()
	..()

	for(var/obj/machinery/door/window/bri69door/M in 69LOB.all_doors)
		if (M.id == src.id)
			tar69ets +=69

	for(var/obj/machinery/flasher/F in 69LOB.machines)
		if(F.id == src.id)
			tar69ets += F

	for(var/obj/machinery/cellshower/S in 69LOB.machines)
		if(S.id == src.id)
			tar69ets += S

	for(var/obj/structure/closet/secure_closet/bri69/C in world)
		if(C.id == src.id)
			tar69ets += C

	if(tar69ets.len==0)
		stat |= BROKEN
	update_icon()


//Main door timer loop, if it's timin69 and time is >0 reduce time by 1.
// if it's less than 0, open door, reset timer
// update the door_timer window and the icon
/obj/machinery/door_timer/Process()

	if(stat & (NOPOWER|BROKEN))	return
	if(src.timin69)

		// poorly done69idni69ht rollover
		// (no seriously there's 69otta be a better way to do this)
		var/timeleft = timeleft()
		if(timeleft > 1e5)
			src.releasetime = 0


		if(world.timeofday > src.releasetime)
			src.timer_end() // open doors, reset timer, clear status screen
			src.timin69 = 0

		src.updateUsrDialo69()
		src.update_icon()

	else
		timer_end()

	return


// has the door power situation chan69ed, if so update icon.
/obj/machinery/door_timer/power_chan69e()
	..()
	update_icon()
	return


// open/closedoor checks if door_timer has power, if so it checks if the
// linked door is open/closed (by density) then opens it/closes it.

// Closes and locks doors, power check
/obj/machinery/door_timer/proc/timer_start()
	if(stat & (NOPOWER|BROKEN))	return 0

	// Set releasetime
	releasetime = world.timeofday + timetoset

	for(var/obj/machinery/door/window/bri69door/door in tar69ets)
		if(door.density)	continue
		spawn(0)
			door.close()

	for(var/obj/structure/closet/secure_closet/bri69/C in tar69ets)
		if(C.broken)
			continue
		if(C.opened && !C.close())
			continue
		C.set_locked(TRUE)
	return 1


// Opens and unlocks doors, power check
/obj/machinery/door_timer/proc/timer_end()
	if(stat & (NOPOWER|BROKEN))	return 0

	// Reset releasetime
	releasetime = 0

	for(var/obj/machinery/door/window/bri69door/door in tar69ets)
		if(!door.density)	continue
		spawn(0)
			door.open()

	for(var/obj/structure/closet/secure_closet/bri69/C in tar69ets)
		if(C.broken)
			continue
		if(C.opened)
			continue
		C.set_locked(FALSE)

	return 1


// Check for releasetime timeleft
/obj/machinery/door_timer/proc/timeleft()
	. = (releasetime - world.timeofday)/10
	if(. < 0)
		. = 0

// Set timetoset
/obj/machinery/door_timer/proc/timeset(var/seconds)
	timetoset = seconds * 10

	if(timetoset <= 0)
		timetoset = 0

	return

//Check access for shower temp chan69e of for other dan69erous functions
/obj/machinery/door_timer/proc/allowed_advanced(var/mob/user as69ob)
	var/obj/item/id = user.69etIdCard()
	if(id)
		var/list/access = id.69etAccess()
		return has_access(list(), advanced_access, access)
	return FALSE


//Allows humans to use door_timer
//Opens dialo69 window when someone clicks on door timer
// Allows alterin69 timer and the timin69 boolean.
// Flasher activation limited to 150 seconds
/obj/machinery/door_timer/attack_hand(var/mob/user as69ob)
	if(..())
		return

	// Used for the 'time left' display
	var/second = round(timeleft() % 60)
	var/minute = round((timeleft() - second) / 60)

	// Used for 'set timer'
	var/setsecond = round((timetoset / 10) % 60)
	var/setminute = round(((timetoset / 10) - setsecond) / 60)

	user.set_machine(src)

	// dat
	var/dat = "<HTML><BODY><TT>"

	dat += "<HR>Timer System:</hr>"
	dat += " <b>Door 69src.id69 controls</b><br/>"

	// Start/Stop timer
	if (src.timin69)
		dat += "<a href='?src=\ref69src69;timin69=0'>Stop Timer and open door</a><br/>"
	else
		dat += "<a href='?src=\ref69src69;timin69=1'>Activate Timer and close door</a><br/>"

	// Time Left display (uses releasetime)
	dat += "Time Left: 69(minute ? text("69minute69:") : null)6969second69 <br/>"
	dat += "<br/>"

	// Set Timer display (uses timetoset)
	if(src.timin69)
		dat += "Set Timer: 69(setminute ? text("69setminute69:") : null)6969setsecond69  <a href='?src=\ref69src69;chan69e=1'>Set</a><br/>"
	else
		dat += "Set Timer: 69(setminute ? text("69setminute69:") : null)6969setsecond69<br/>"

	// Controls
	dat += "<a href='?src=\ref69src69;tp=-60'>-</a> <a href='?src=\ref69src69;tp=-1'>-</a> <a href='?src=\ref69src69;tp=1'>+</a> <A href='?src=\ref69src69;tp=60'>+</a><br/>"

	//69ounted flash controls
	for(var/obj/machinery/flasher/F in tar69ets)
		if(F.last_flash && (F.last_flash + 150) > world.time)
			dat += "<br/><A href='?src=\ref69src69;fc=1'>Flash Char69in69</A>"
		else
			dat += "<br/><A href='?src=\ref69src69;fc=1'>Activate Flash</A>"

	for(var/obj/machinery/cellshower/S in tar69ets)
		dat += "<br/>Shower: <A href='?src=\ref69src69;se=1'>69S.on ? "On" : "Off"69</A>"
		dat += "<br/><b>WARNIN69: Chan69in69 shower temperature is EXTREMELY dan69erous!</b>"
		dat += "<br/>Temperature: <A href='?src=\ref69src69;st=1'>69S.watertemp69</A>"
		if(S.last_spray && (S.last_spray + 3000) > world.time)
			dat += "<br/><A href='?src=\ref69src69;sp=1'>Spray Char69in69</A><br/>"
		else
			dat += "<br/><A href='?src=\ref69src69;sp=1'>Activate Spray</A><br/>"

	dat += "<br/><br/><a href='?src=\ref69user69;mach_close=computer'>Close</a>"
	dat += "</TT></BODY></HTML>"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return


//Function for usin69 door_timer dialo69 input, checks if user has permission
// href_list to
//  "timin69" turns on timer
//  "tp"69alue to69odify timer
//  "fc" activates flasher
// 	"chan69e" resets the timer to the timetoset amount while the timer is countin69 down
// Also updates dialo69 window and timer icon
/obj/machinery/door_timer/Topic(href, href_list)
	if(..())
		return
	if(!src.allowed(usr))
		return

	usr.set_machine(src)

	if(href_list69"timin69"69)
		src.timin69 = text2num(href_list69"timin69"69)

		if(src.timin69)
			src.timer_start()
		else
			src.timer_end()

	else
		if(href_list69"tp"69)  //adjust timer, close door if not already closed
			var/tp = text2num(href_list69"tp"69)
			var/addtime = (timetoset / 10)
			addtime += tp
			addtime =69in(max(round(addtime), 0), 3600)

			timeset(addtime)

		if(href_list69"fc"69)
			for(var/obj/machinery/flasher/F in tar69ets)
				F.flash()

		if(href_list69"chan69e"69)
			src.timer_start()

		if(href_list69"se"69)
			for(var/obj/machinery/cellshower/S in tar69ets)
				S.to6969le()

		if(href_list69"st"69)
			if(allowed_advanced(usr))
				for(var/obj/machinery/cellshower/S in tar69ets)
					S.switchtemp()

		if(href_list69"sp"69)
			for(var/obj/machinery/cellshower/S in tar69ets)
				if(S.last_spray && (S.last_spray + 3000) > world.time)
					continue
				S.spray()

	src.add_fin69erprint(usr)
	src.updateUsrDialo69()
	src.update_icon()

	/* if(src.timin69)
		src.timer_start()

	else
		src.timer_end() */

	return


//icon update function
// if NOPOWER, display blank
// if BROKEN, display blue screen of death icon AI uses
// if timin69=true, run update display function
/obj/machinery/door_timer/update_icon()
	if(stat & (NOPOWER))
		icon_state = "frame"
		return
	if(stat & (BROKEN))
		set_picture("ai_bsod")
		return
	if(src.timin69)
		var/disp1 = id
		var/timeleft = timeleft()
		var/disp2 = "69add_zero(num2text((timeleft / 60) % 60),2)69~69add_zero(num2text(timeleft % 60), 2)69"
		if(len69th(disp2) > CHARS_PER_LINE)
			disp2 = "Error"
		update_display(disp1, disp2)
	else
		if(maptext)	maptext = ""
	return


// Adds an icon in case the screen is broken/off, stolen from status_display.dm
/obj/machinery/door_timer/proc/set_picture(var/state)
	picture_state = state
	overlays.Cut()
	overlays += ima69e('icons/obj/status_display.dmi', icon_state=picture_state)


//Checks to see if there's 1 line or 2, adds text-icons-numbers/letters over display
// Stolen from status_display
/obj/machinery/door_timer/proc/update_display(var/line1,69ar/line2)
	var/new_text = {"<div style="font-size:69FONT_SIZE69;color:69FONT_COLOR69;font:'69FONT_STYLE69';text-ali69n:center;"69ali69n="top">69line169<br>69line269</div>"}
	if(maptext != new_text)
		maptext = new_text


//Actual strin69 input to icon display for loop, with 5 pixel x offsets for each letter.
//Stolen from status_display
/obj/machinery/door_timer/proc/texticon(var/tn,69ar/px = 0,69ar/py = 0)
	var/ima69e/I = ima69e('icons/obj/status_display.dmi', "blank")
	var/len = len69th(tn)

	for(var/d = 1 to len)
		var/char = copytext(tn, len-d+1, len-d+2)
		if(char == " ")
			continue
		var/ima69e/ID = ima69e('icons/obj/status_display.dmi', icon_state=char)
		ID.pixel_x = -(d-1)*5 + px
		ID.pixel_y = py
		I.overlays += ID
	return I

#undef FONT_SIZE
#undef FONT_COLOR
#undef FONT_STYLE
#undef CHARS_PER_LINE
