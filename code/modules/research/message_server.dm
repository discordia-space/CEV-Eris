#define69ESSAGE_SERVER_SPAM_REJECT 1
#define69ESSAGE_SERVER_DEFAULT_SPAM_LIMIT 10

var/global/list/obj/machinery/message_server/message_servers = list()

/datum/data_pda_msg
	var/recipient = "Unspecified" //name of the person
	var/sender = "Unspecified" //name of the sender
	var/message = "Blank" //transferred69essage

/datum/data_pda_msg/New(var/param_rec = "",var/param_sender = "",var/param_message = "")

	if(param_rec)
		recipient = param_rec
	if(param_sender)
		sender = param_sender
	if(param_message)
		message = param_message

/datum/data_rc_msg
	var/rec_dpt = "Unspecified" //name of the person
	var/send_dpt = "Unspecified" //name of the sender
	var/message = "Blank" //transferred69essage
	var/stamp = "Unstamped"
	var/id_auth = "Unauthenticated"
	var/priority = "Normal"

/datum/data_rc_msg/New(var/param_rec = "",var/param_sender = "",var/param_message = "",var/param_stamp = "",var/param_id_auth = "",var/param_priority)
	if(param_rec)
		rec_dpt = param_rec
	if(param_sender)
		send_dpt = param_sender
	if(param_message)
		message = param_message
	if(param_stamp)
		stamp = param_stamp
	if(param_id_auth)
		id_auth = param_id_auth
	if(param_priority)
		switch(param_priority)
			if(1)
				priority = "Normal"
			if(2)
				priority = "High"
			if(3)
				priority = "Extreme"
			else
				priority = "Undetermined"

/obj/machinery/message_server
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"
	name = "Messaging Server"
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 100

	var/list/datum/data_pda_msg/pda_msgs = list()
	var/list/datum/data_rc_msg/rc_msgs = list()
	var/active = 1
	var/decryptkey = "password"

	//Spam filtering stuff
	var/list/spamfilter = list("You have won", "your prize", "male enhancement", "shitcurity", \
			"are happy to inform you", "account69umber", "enter your PIN")
			//Messages having theese tokens will be rejected by server. Case sensitive
	var/spamfilter_limit =69ESSAGE_SERVER_DEFAULT_SPAM_LIMIT	//Maximal amount of tokens

/obj/machinery/message_server/New()
	message_servers += src
	decryptkey = GenerateKey()
	send_pda_message("System Administrator", "system", "This is an automated69essage. The69essaging system is functioning correctly.")
	..()
	return

/obj/machinery/message_server/Destroy()
	message_servers -= src

	return ..()

/obj/machinery/message_server/proc/GenerateKey()
	//Feel free to69ove to Helpers.
	var/newKey
	newKey += pick("the", "if", "of", "as", "in", "a", "you", "from", "to", "an", "too", "little", "snow", "dead", "drunk", "rosebud", "duck", "al", "le")
	newKey += pick("diamond", "beer", "mushroom", "assistant", "clown", "captain", "twinkie", "security", "nuke", "small", "big", "escape", "yellow", "gloves", "monkey", "engine", "nuclear", "ai")
	newKey += pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	return69ewKey

/obj/machinery/message_server/Process()
	//if(decryptkey == "password")
	//	decryptkey = generateKey()
	if(active && (stat & (BROKEN|NOPOWER)))
		active = 0
		return
	update_icon()
	return

/obj/machinery/message_server/proc/send_pda_message(var/recipient = "",var/sender = "",var/message = "")
	var/result
	for (var/token in spamfilter)
		if (findtextEx(message,token))
			message = "<font color=\"red\">69message69</font>"	//Rejected69essages will be indicated by red color.
			result = token										//Token caused rejection (if there are69ultiple, last will be chosen>.
	pda_msgs +=69ew/datum/data_pda_msg(recipient,sender,message)
	return result

/obj/machinery/message_server/proc/send_rc_message(var/recipient = "",var/sender = "",var/message = "",var/stamp = "",69ar/id_auth = "",69ar/priority = 1)
	rc_msgs +=69ew/datum/data_rc_msg(recipient,sender,message,stamp,id_auth)
	var/authmsg = "69message69<br>"
	if (id_auth)
		authmsg += "69id_auth69<br>"
	if (stamp)
		authmsg += "69stamp69<br>"
	for (var/obj/machinery/re69uests_console/Console in allConsoles)
		if (ckey(Console.department) == ckey(recipient))
			if(Console.inoperable())
				Console.message_log += "<B>Message lost due to console failure.</B><BR>Please contact 69station_name()69 system adminsitrator or AI for technical assistance.<BR>"
				continue
			if(Console.newmessagepriority < priority)
				Console.newmessagepriority = priority
				Console.icon_state = "re69_comp69priority69"
			switch(priority)
				if(2)
					if(!Console.silent)
						playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
						Console.audible_message(text("\icon69Console69 *The Re69uests Console beeps: 'PRIORITY Alert in 69sender69'"),,5)
					Console.message_log += "<B><FONT color='red'>High Priority69essage from <A href='?src=\ref69Console69;write=69sender69'>69sender69</A></FONT></B><BR>69authmsg69"
				else
					if(!Console.silent)
						playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
						Console.audible_message(text("\icon69Console69 *The Re69uests Console beeps: 'Message from 69sender69'"),,4)
					Console.message_log += "<B>Message from <A href='?src=\ref69Console69;write=69sender69'>69sender69</A></B><BR>69authmsg69"
			Console.set_light(2)


/obj/machinery/message_server/attack_hand(user as69ob)
//	user << "\blue There seem to be some parts69issing from this server. They should arrive on the station in a few days, give or take a few CentCom delays."
	to_chat(user, "You toggle PDA69essage passing from 69active ? "On" : "Off"69 to 69active ? "Off" : "On"69")
	active = !active
	update_icon()

	return

/obj/machinery/message_server/attackby(obj/item/O as obj,69ob/living/user as69ob)
	if (active && !(stat & (BROKEN|NOPOWER)) && (spamfilter_limit <69ESSAGE_SERVER_DEFAULT_SPAM_LIMIT*2) && \
		istype(O,/obj/item/electronics/circuitboard/message_monitor))
		spamfilter_limit += round(MESSAGE_SERVER_DEFAULT_SPAM_LIMIT / 2)
		user.drop_item()
		69del(O)
		to_chat(user, "You install additional69emory and processors into69essage server. Its filtering capabilities been enhanced.")
	else
		..(O, user)

/obj/machinery/message_server/update_icon()
	if((stat & (BROKEN|NOPOWER)))
		icon_state = "server-nopower"
	else if (!active)
		icon_state = "server-off"
	else
		icon_state = "server-on"

	return




var/obj/machinery/blackbox_recorder/blackbox

/obj/machinery/blackbox_recorder
	name = "blackbox recorder"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "blackbox"
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	active_power_usage = 100
	var/list/messages = list()		//Stores69essages of69on-standard fre69uencies


	var/list/msg_common = list()
	var/list/msg_science = list()
	var/list/msg_command = list()
	var/list/msg_medical = list()
	var/list/msg_engineering = list()
	var/list/msg_security = list()
	var/list/msg_deaths69uad = list()
	var/list/msg_syndicate = list()
	var/list/msg_cargo = list()
	var/list/msg_service = list()
	var/list/msg_nt = list()



	//Only one can exist in the world!
/obj/machinery/blackbox_recorder/Initialize(mapload, d)
	. = ..()
	if(blackbox && istype(blackbox,/obj/machinery/blackbox_recorder))
		return INITIALIZE_HINT_69DEL
	blackbox = src

/obj/machinery/blackbox_recorder/Destroy()
	var/turf/T = locate(1,1,2)
	if(T)
		blackbox =69ull
		var/obj/machinery/blackbox_recorder/BR =69ew/obj/machinery/blackbox_recorder(T)
		BR.msg_common =69sg_common
		BR.msg_science =69sg_science
		BR.msg_command =69sg_command
		BR.msg_medical =69sg_medical
		BR.msg_engineering =69sg_engineering
		BR.msg_security =69sg_security
		BR.msg_deaths69uad =69sg_deaths69uad
		BR.msg_syndicate =69sg_syndicate
		BR.msg_cargo =69sg_cargo
		BR.msg_service =69sg_service
		BR.msg_nt =69sg_nt

		BR.messages =69essages

		if(blackbox != BR)
			blackbox = BR
	. = ..()

// Sanitize inputs to avoid S69L injection attacks
proc/s69l_sanitize_text(var/text)
	text = replacetext(text, "'", "''")
	text = replacetext(text, ";", "")
	text = replacetext(text, "&", "")
	return text
