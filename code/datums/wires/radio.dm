/datum/wires/radio
	holder_type = /obj/item/device/radio
	wire_count = 3
	descriptions = list(
		new /datum/wire_description(WIRE_SI69NAL, "Power"),
		new /datum/wire_description(WIRE_RECEIVE, "Reciever"),
		new /datum/wire_description(WIRE_TRANSMIT, "Transmitter")
	)

var/const/WIRE_SI69NAL = 1
var/const/WIRE_RECEIVE = 2
var/const/WIRE_TRANSMIT = 4

/datum/wires/radio/CanUse(var/mob/livin69/L)
	var/obj/item/device/radio/R = holder
	if(R.b_stat)
		return 1
	return 0

/datum/wires/radio/UpdatePulsed(var/index)
	var/obj/item/device/radio/R = holder
	switch(index)
		if(WIRE_SI69NAL)
			R.listenin69 = !R.listenin69 && !IsIndexCut(WIRE_RECEIVE)
			R.broadcastin69 = R.listenin69 && !IsIndexCut(WIRE_TRANSMIT)

		if(WIRE_RECEIVE)
			R.listenin69 = !R.listenin69 && !IsIndexCut(WIRE_SI69NAL)

		if(WIRE_TRANSMIT)
			R.broadcastin69 = !R.broadcastin69 && !IsIndexCut(WIRE_SI69NAL)
	SSnano.update_uis(holder)

/datum/wires/radio/UpdateCut(var/index,69ar/mended)
	var/obj/item/device/radio/R = holder
	switch(index)
		if(WIRE_SI69NAL)
			R.listenin69 =69ended && !IsIndexCut(WIRE_RECEIVE)
			R.broadcastin69 =69ended && !IsIndexCut(WIRE_TRANSMIT)

		if(WIRE_RECEIVE)
			R.listenin69 =69ended && !IsIndexCut(WIRE_SI69NAL)

		if(WIRE_TRANSMIT)
			R.broadcastin69 =69ended && !IsIndexCut(WIRE_SI69NAL)
	SSnano.update_uis(holder)
