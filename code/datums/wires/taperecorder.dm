/datum/wires/taperecorder
	holder_type = /obj/item/device/taperecorder
	wire_count = 4
	descriptions = list(
		new /datum/wire_description(TAPE_WIRE_STOP, "Stop"),
		new /datum/wire_description(TAPE_WIRE_PLAY, "Play"),
		new /datum/wire_description(TAPE_WIRE_RECORD, "Record"),
		new /datum/wire_description(TAPE_WIRE_WIPE, "Wipe"),
	)

var/const/TAPE_WIRE_STOP = 1
var/const/TAPE_WIRE_PLAY = 2
var/const/TAPE_WIRE_RECORD = 4
var/const/TAPE_WIRE_WIPE = 8

/datum/wires/taperecorder/UpdatePulsed(var/index)
	var/obj/item/device/taperecorder/T = holder
	switch(index)
		if(TAPE_WIRE_STOP)
			T.stop(0)
		if(TAPE_WIRE_PLAY)
			T.playback_memory(0)
		if(TAPE_WIRE_RECORD)
			T.record(0)
		if(TAPE_WIRE_WIPE)
			T.clear_memory(0)
	SSnano.update_uis(holder)