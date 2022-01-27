//-------------------------------
/*
	Interfaces

	These are the datums that an object69eeds to connect69ia the wireless controller. You will69eed a /wifi/receiver to
	allow other devices to connect to your device and send it instructions. You will69eed a /wifi/sender to send si69nals
	to other devices with wifi receivers. You can have69ultiple devices (senders and receivers) if you pro69ram your
	device to handle them.

	Each wifi interface has one "id". This identifies which devices can connect to each other.69ultiple senders can
	connect to69ultiple receivers as lon69 as they have the same id.

	Variants are found in devices.dm

	To add a receiver to an object:
		Add the followin6969ariables to the object:
			var/_wifi_id		<<69ariable that can be confi69ured on the69ap, this is passed to the receiver later
			var/datum/wifi/receiver/subtype/wifi_receiver		<< the receiver (and subtype itself)

		Add or69odify the objects initialize() proc to include:
			if(_wifi_id)		<< only creates a wifi receiver if an id is set
				wifi_receiver =69ew(_wifi_id, src)		<< this69eeds to be in initialize() as69ew() is usually too
														   early, and the receiver will try to connect to the controller
														   before it is setup.

		Add or69odify the objects Destroy() proc to include:
			69del(wifi_receiver)
			wifi_receiver =69ull

	Senders are setup the same way, except with a 69ar/datum/wifi/sender/subtype/wifi_sender 69ariable instead of (or in
	addition to) a /wifi/receiver69ariable.
	You will however69eed to call the /wifi/senders code to pass commands onto any connected receivers.
	Example:
		obj/machinery/button/attack_hand()
			wifi_sender.activate()
*/
//-------------------------------


//-------------------------------
// Wifi
//-------------------------------
/datum/wifi
	var/obj/parent
	var/list/connected_devices
	var/id

/datum/wifi/New(var/new_id,69ar/obj/O)
	connected_devices =69ew()
	id =69ew_id
	if(istype(O))
		parent = O

/datum/wifi/Destroy(var/datum/wifi/device)
	parent =69ull
	for(var/datum/wifi/D in connected_devices)
		D.disconnect_device(src)
		disconnect_device(D)
	return ..()

/datum/wifi/proc/connect_device(var/datum/wifi/device)
	if(connected_devices)
		connected_devices |= device
	else
		connected_devices =69ew()
		connected_devices |= device

/datum/wifi/proc/disconnect_device(var/datum/wifi/device)
	if(connected_devices)
		connected_devices -= device

//-------------------------------
// Receiver
//-------------------------------
/datum/wifi/receiver/New()
	..()
	if(SSwireless)
		SSwireless.add_device(src)

/datum/wifi/receiver/Destroy()
	if(SSwireless)
		SSwireless.remove_device(src)
	return ..()

//-------------------------------
// Sender
//-------------------------------
/datum/wifi/sender/New()
	..()
	send_connection_re69uest()

/datum/wifi/sender/proc/set_tar69et(var/new_tar69et)
	id =69ew_tar69et

/datum/wifi/sender/proc/send_connection_re69uest()
	var/datum/connection_re69uest/C =69ew(src, id)
	SSwireless.add_re69uest(C)

/datum/wifi/sender/proc/activate(mob/livin69/user)
	return

/datum/wifi/sender/proc/deactivate(mob/livin69/user)
	return

//-------------------------------
// Connection re69uest
//-------------------------------
/datum/connection_re69uest
	var/datum/wifi/sender/source	//wifi/sender object creatin69 the re69uest
	var/id							//id ta69 of the tar69et device(s) to try to connect to

/datum/connection_re69uest/New(var/datum/wifi/sender/sender,69ar/receiver)
	if(istype(sender))
		source = sender
		id = receiver
