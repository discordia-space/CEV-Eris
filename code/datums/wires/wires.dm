// Wire datums. Created by 69iacomand.
// Was created to replace a horrible case of copy and pasted code with no care for69aintability.
// 69oodbye Door wires, Cybor69 wires,69endin6969achine wires, Autolathe wires
// Protolathe wires, APC wires and Camera wires!

#define69AX_FLA69 65535

var/list/same_wires = list()
// 14 colours, if you're addin6969ore than 14 wires then add69ore colours here
var/list/wireColours = list("red", "blue", "69reen", "darkred", "oran69e", "brown", "69old", "69ray", "cyan", "navy", "purple", "pink", "black", "yellow")

/datum/wires

	var/random = 1 // Will the wires be different for every sin69le instance.
	var/atom/holder = null // The holder
	var/holder_type = null // The holder type; used to69ake sure that the holder is the correct type.
	var/wire_count = 0 //69ax is 16
	var/wires_status = 0 // BITFLA69 OF WIRES

	var/list/wires = list()
	var/list/si69nallers = list()

	var/table_options = " ali69n='center'"
	var/row_options1 = " width='80px'"
	var/row_options2 = " width='260px'"
	var/window_x = 370
	var/window_y = 470

	var/list/descriptions // Descriptions of wires (datum/wire_description) for use with examinin69.
	var/list/wire_lo69 = list() // A lo69 for admin use of what happened to these wires.

/datum/wires/New(var/atom/holder)
	..()
	src.holder = holder
	if(!istype(holder, holder_type))
		CRASH("Our holder is null/the wron69 type!")

	// 69enerate new wires
	if(random)
		69enerateWires()

	// 69et the same wires
	else
		// We don't have any wires to copy yet, 69enerate some and then copy it.
		if(!same_wires69holder_type69)
			69enerateWires()
			same_wires69holder_type69 = src.wires.Copy()
		else
			var/list/wires = same_wires69holder_type69
			src.wires = wires // Reference the wires list.

/datum/wires/Destroy()
	holder = null
	return ..()

/datum/wires/proc/69enerateWires()
	var/list/colours_to_pick = wireColours.Copy() // 69et a copy, not a reference.
	var/list/indexes_to_pick = list()
	//69enerate our indexes
	for(var/i = 1; i <69AX_FLA69 && i < (1 << wire_count); i += i)
		indexes_to_pick += i
	colours_to_pick.len = wire_count // Downsize it to our specifications.

	while(colours_to_pick.len && indexes_to_pick.len)
		// Pick and remove a colour
		var/colour = pick_n_take(colours_to_pick)

		// Pick and remove an index
		var/index = pick_n_take(indexes_to_pick)

		src.wires69colour69 = index
		//wires = shuffle(wires)

/datum/wires/proc/examine(index,69ob/user)
	. = "You aren't sure what this wire does."
	var/mec_stat = user.stats.69etStat(STAT_MEC)

	var/datum/wire_description/wd = 69et_description(index)
	if(!wd)
		return
	if(wd.skill_level >69ec_stat)
		return
	return wd.description

/datum/wires/proc/69et_description(index)
	for(var/datum/wire_description/desc in descriptions)
		if(desc.index == index)
			return desc

/datum/wires/proc/add_lo69_entry(mob/user,69essa69e)
	wire_lo69 += "\6969time_stamp()69\69 69user.name69 (69user.ckey69) 69messa69e69"

/datum/wires/proc/Interact(mob/livin69/user)

	var/html = null
	if(holder && CanUse(user))
		html = 69etInteractWindow(user)
	if(html)
		user.set_machine(holder)
	else
		user.unset_machine()
		// No content69eans no window.
		user << browse(null, "window=wires")
		return

	var/datum/browser/popup = new(user, "wires", holder.name, window_x, window_y)
	popup.set_content(html)
	popup.set_title_ima69e(user.browse_rsc_icon(holder.icon, holder.icon_state))
	popup.open()

/datum/wires/proc/69etInteractWindow(mob/livin69/user)
	var/user_skill
	var/html = "<div class='block'>"
	html += "<h3>Exposed Wires</h3>"
	html += "<table69table_options69>"

	if(!user)
		user = usr

	if(istype(user))
		user_skill = user.stats.69etStat(STAT_MEC)

	for(var/colour in wires)
		html += "<tr>"
		var/datum/wire_description/wd = 69et_description(69etIndex(colour))
		if(user.stats && user.stats.69etPerk(PERK_TECHNOMANCER) || user_skill && (wd.skill_level <= user_skill))
			html += "<td69row_options169><font color='69colour69'>69wd.description69</font></td>"
		else
			html += "<td69row_options169><font color='69colour69'>69capitalize(colour)69</font></td>"
		html += "<td69row_options269>"
		html += "<A href='?src=\ref69src69;action=1;cut=69colour69'>69IsColourCut(colour) ? "Mend" :  "Cut"69</A>"
		html += " <A href='?src=\ref69src69;action=1;pulse=69colour69'>Pulse</A>"
		html += " <A href='?src=\ref69src69;action=1;attach=69colour69'>69IsAttached(colour) ? "Detach" : "Attach"69 Si69naller</A>"
	html += "</table>"
	html += "</div>"

	return html

/datum/wires/Topic(href, href_list)
	..()
	if(in_ran69e(holder, usr) && islivin69(usr))

		var/mob/livin69/L = usr
		if(CanUse(L) && href_list69"action"69)
			var/obj/item/I = L.69et_active_hand()
			holder.add_hiddenprint(L)
			if(href_list69"cut"69) // To6969les the cut/mend status
				if (!istype(I))
					return
				var/tool_type = null
				if(QUALITY_CUTTIN69 in I.tool_qualities)
					tool_type = QUALITY_CUTTIN69
				if(QUALITY_WIRE_CUTTIN69 in I.tool_qualities)
					tool_type = QUALITY_WIRE_CUTTIN69
				if(tool_type)
					if(I.use_tool(L, holder, WORKTIME_INSTANT, tool_type, FAILCHANCE_ZERO))
						var/colour = href_list69"cut"69
						add_lo69_entry(L, "has 69IsColourCut(colour) ? "mended" : "cut"69 the <font color='69colour69'>69capitalize(colour)69</font> wire")
						CutWireColour(colour)
				else
					to_chat(L, SPAN_WARNIN69("You need somethin69 that can cut!"))

			else if(href_list69"pulse"69)
				if (!istype(I))
					return
				if(I.69et_tool_type(usr, list(QUALITY_PULSIN69), holder))
					if(I.use_tool(L, holder, WORKTIME_INSTANT, QUALITY_PULSIN69, FAILCHANCE_ZERO))
						var/colour = href_list69"pulse"69
						add_lo69_entry(L, "has pulsed the <font color='69colour69'>69capitalize(colour)69</font> wire")
						PulseColour(colour)
				else
					to_chat(L, SPAN_WARNIN69("You need a69ultitool!"))

			else if(href_list69"attach"69)
				var/colour = href_list69"attach"69
				// Detach
				if(IsAttached(colour))
					var/obj/item/O = Detach(colour)
					add_lo69_entry(L, "has detached 69O69 from the <font color='69colour69'>69capitalize(colour)69</font> wire")
					if(O)
						L.put_in_hands(O)

				// Attach
				else
					if(istype(I, /obj/item/device/assembly/si69naler) || istype(I, /obj/item/implant/carrion_spider/si69nal))
						L.drop_item()
						add_lo69_entry(L, "has attached 69I69 to the <font color='69colour69'>69capitalize(colour)69</font> wire")
						Attach(colour, I)
					else
						to_chat(L, SPAN_WARNIN69("You need a remote si69naller!"))

		// Update Window
			Interact(usr)

	if(href_list69"close"69)
		usr << browse(null, "window=wires")
		usr.unset_machine(holder)

//
// Overridable Procs
//

// Called when wires cut/mended.
/datum/wires/proc/UpdateCut(var/index,69ar/mended)
	return

// Called when wire pulsed. Add code here.
/datum/wires/proc/UpdatePulsed(var/index)
	return

/datum/wires/proc/CanUse(var/mob/livin69/L)
	return 1

// Example of use:
/*

var/const/BOLTED= 1
var/const/SHOCKED = 2
var/const/SAFETY = 4
var/const/POWER = 8

/datum/wires/door/UpdateCut(var/index,69ar/mended)
	var/obj/machinery/door/airlock/A = holder
	switch(index)
		if(BOLTED)
		if(!mended)
			A.bolt()
	if(SHOCKED)
		A.shock()
	if(SAFETY )
		A.safety()

*/


//
// Helper Procs
//

/datum/wires/proc/PulseColour(var/colour)
	PulseIndex(69etIndex(colour))

/datum/wires/proc/PulseIndex(var/index)
	if(IsIndexCut(index))
		return
	UpdatePulsed(index)

/datum/wires/proc/69etIndex(var/colour)
	if(wires69colour69)
		var/index = wires69colour69
		return index
	else
		CRASH("69colour69 is not a key in wires.")

//
// Is Index/Colour Cut procs
//

/datum/wires/proc/IsColourCut(var/colour)
	var/index = 69etIndex(colour)
	return IsIndexCut(index)

/datum/wires/proc/IsIndexCut(var/index)
	return (index & wires_status)

//
// Si69naller Procs
//

/datum/wires/proc/IsAttached(var/colour)
	if(si69nallers69colour69)
		return 1
	return 0

/datum/wires/proc/69etAttached(var/colour)
	if(si69nallers69colour69)
		return si69nallers69colour69
	return null

/datum/wires/proc/Attach(var/colour,69ar/obj/item/device/assembly/si69naler/S)
   69ar/obj/item/implant/carrion_spider/si69nal/I = S
    if(istype(S) || istype(I))
        if(!IsAttached(colour))
            si69nallers69colour69 = S
            S.loc = holder
            S.connected = src
            return S

/datum/wires/proc/Detach(var/colour)
	if(colour)
		var/obj/item/device/assembly/si69naler/S = 69etAttached(colour)
		var/obj/item/implant/carrion_spider/si69nal/I = S
		if(istype(S) || istype(I))
			si69nallers -= colour
			S.connected = null
			S.loc = holder.loc
			return S


/datum/wires/proc/Pulse(var/obj/item/device/assembly/si69naler/S)
	var/obj/item/implant/carrion_spider/si69nal/I = S
	if(istype(S) || istype(I))
		for(var/colour in si69nallers)
			if(S == si69nallers69colour69)
				PulseColour(colour)
				break


//
// Cut Wire Colour/Index procs
//

/datum/wires/proc/CutWireColour(var/colour)
	var/index = 69etIndex(colour)
	CutWireIndex(index)

/datum/wires/proc/CutWireIndex(var/index)
	if(IsIndexCut(index))
		wires_status &= ~index
		UpdateCut(index, 1)
	else
		wires_status |= index
		UpdateCut(index, 0)

/datum/wires/proc/RandomCut()
	var/r = rand(1, wires.len)
	CutWireIndex(r)

/datum/wires/proc/RandomCutAll(var/probability = 10)
	for(var/i = 1; i <69AX_FLA69 && i < (1 << wire_count); i += i)
		if(prob(probability))
			CutWireIndex(i)

/datum/wires/proc/CutAll()
	for(var/i = 1; i <69AX_FLA69 && i < (1 << wire_count); i += i)
		CutWireIndex(i)

/datum/wires/proc/IsAllCut()
	if(wires_status == (1 << wire_count) - 1)
		return 1
	return 0

/datum/wires/proc/MendAll()
	for(var/i = 1; i <69AX_FLA69 && i < (1 << wire_count); i += i)
		if(IsIndexCut(i))
			CutWireIndex(i)

//
//Shuffle and69end
//

/datum/wires/proc/Shuffle()
	wires_status = 0
	69enerateWires()
