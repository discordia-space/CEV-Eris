// Jukebox
#define WIRE_MAIN_POWER1 1
#define WIRE_POWER 2
#define WIRE_JUKEBOX_HACK 4
#define WIRE_SPEEDUP 8
#define WIRE_SPEEDDOWN 16
#define WIRE_REVERSE 32
#define WIRE_START 64
#define WIRE_STOP 128
#define WIRE_PREV 256
#define WIRE_NEXT 512

/datum/wires/jukebox
	random = TRUE
	holder_type = /obj/machinery/media/jukebox
	wire_count = 11

/datum/wires/jukebox/CanUse(mob/user)
	var/obj/machinery/media/jukebox/A = holder
	if(A.panel_open)
		return TRUE
	return FALSE

// Show the status of lights as a hint to the current state
/datum/wires/jukebox/GetInteractWindow()
	var/obj/machinery/media/jukebox/A = holder
	. = ..()
	. += "<br>\n The power light is [A.stat & (BROKEN|NOPOWER) ? "off." : "on."]"
	. += "<br>\n The parental guidance light is [A.hacked ? "off." : "on."]"
	. += "<br>\n The data light is [IsIndexCut(WIRE_REVERSE) ? "hauntingly dark." : "glowing softly."]"

// Give a hint as to what each wire does
/datum/wires/jukebox/UpdatePulsed(wire)
	var/obj/machinery/media/jukebox/A = holder
	switch(wire)
		if(WIRE_MAIN_POWER1)
			holder.visible_message("<span class='notice'>The power light flickers.</span>")
			A.shock(usr, 90)
		if(WIRE_JUKEBOX_HACK)
			holder.visible_message("<span class='notice'>The parental guidance light flickers.</span>")
		if(WIRE_REVERSE)
			holder.visible_message("<span class='notice'>The data light blinks ominously.</span>")
		if(WIRE_SPEEDUP)
			holder.visible_message("<span class='notice'>The speakers squeaks.</span>")
		if(WIRE_SPEEDDOWN)
			holder.visible_message("<span class='notice'>The speakers rumble.</span>")
		if(WIRE_START)
			A.StartPlaying()
		if(WIRE_STOP)
			A.StopPlaying()
		if(WIRE_PREV)
			A.PrevTrack()
		if(WIRE_NEXT)
			A.NextTrack()
		else
			A.shock(usr, 10) // The nothing wires give a chance to shock just for fun

/datum/wires/jukebox/UpdateCut(wire, mend)
	var/obj/machinery/media/jukebox/A = holder

	switch(wire)
		if(WIRE_MAIN_POWER1)
			// TODO - Actually make machine electrified or something.
			A.shock(usr, 90)

		if(WIRE_JUKEBOX_HACK)
			A.set_hacked(!mend)

		if(WIRE_SPEEDUP, WIRE_SPEEDDOWN, WIRE_REVERSE)
			var/newfreq = IsIndexCut(WIRE_REVERSE) ? -1 : 1;
			if(IsIndexCut(WIRE_SPEEDUP))
				newfreq *= 2
			if(IsIndexCut(WIRE_SPEEDDOWN))
				newfreq *= 0.5
			A.freq = newfreq

