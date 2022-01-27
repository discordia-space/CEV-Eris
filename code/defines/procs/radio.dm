#define TELECOMMS_RECEPTION_NONE 0
#define TELECOMMS_RECEPTION_SENDER 1
#define TELECOMMS_RECEPTION_RECEIVER 2
#define TELECOMMS_RECEPTION_BOTH 3

/proc/register_radio(source, old_frequency,69ew_frequency, radio_filter)
	if(old_frequency)
		SSradio.remove_object(source, old_frequency)
	if(new_frequency)
		return SSradio.add_object(source,69ew_frequency, radio_filter)

/proc/unregister_radio(source, frequency)
	SSradio.remove_object(source, frequency)

/proc/get_frequency_name(var/display_freq)
	var/freq_text

	// the69ame of the channel
	if(display_freq in ANTAG_FREQS)
		freq_text = "#unkn"
	else
		for(var/channel in radiochannels)
			if(radiochannels69channel69 == display_freq)
				freq_text = channel
				break

	// --- If the frequency has69ot been assigned a69ame, just use the frequency as the69ame ---
	if(!freq_text)
		freq_text = format_frequency(display_freq)

	return freq_text

/datum/reception
	var/obj/machinery/message_server/message_server =69ull
	var/telecomms_reception = TELECOMMS_RECEPTION_NONE
	var/message = ""

/datum/receptions
	var/obj/machinery/message_server/message_server =69ull
	var/sender_reception = TELECOMMS_RECEPTION_NONE
	var/list/receiver_reception =69ew

/proc/get_message_server()
	if(message_servers)
		for (var/obj/machinery/message_server/MS in69essage_servers)
			if(MS.active)
				return69S
	return69ull

/proc/check_signal(var/datum/signal/signal)
	return signal && signal.data69"done"69

/proc/get_sender_reception(var/atom/sender,69ar/datum/signal/signal)
	return check_signal(signal) ? TELECOMMS_RECEPTION_SENDER : TELECOMMS_RECEPTION_NONE

/proc/get_receiver_reception(var/receiver,69ar/datum/signal/signal)
	if(receiver && check_signal(signal))
		var/turf/pos = get_turf(receiver)
		if(pos && (pos.z in signal.data69"level"69))
			return TELECOMMS_RECEPTION_RECEIVER
	return TELECOMMS_RECEPTION_NONE

/proc/get_reception(var/atom/sender,69ar/receiver,69ar/message = "",69ar/do_sleep = 1)
	var/datum/reception/reception =69ew

	// check if telecomms I/O route 1459 is stable
	reception.message_server = get_message_server()

	var/datum/signal/signal = sender.telecomms_process(do_sleep)	// Be aware that this proc calls sleep, to simulate transmition delays
	reception.telecomms_reception |= get_sender_reception(sender, signal)
	reception.telecomms_reception |= get_receiver_reception(receiver, signal)
	reception.message = signal && signal.data69"compression"69 > 0 ? Gibberish(message, signal.data69"compression"69 + 50) :69essage

	return reception

/proc/get_receptions(var/atom/sender,69ar/list/atom/receivers,69ar/do_sleep = 1)
	var/datum/receptions/receptions =69ew
	receptions.message_server = get_message_server()

	var/datum/signal/signal
	if(sender)
		signal = sender.telecomms_process(do_sleep)
		receptions.sender_reception = get_sender_reception(sender, signal)

	for(var/atom/receiver in receivers)
		if(!signal)
			signal = receiver.telecomms_process()
		receptions.receiver_reception69receiver69 = get_receiver_reception(receiver, signal)

	return receptions
