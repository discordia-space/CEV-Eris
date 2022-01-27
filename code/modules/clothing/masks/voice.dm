/obj/item/voice_changer
	name = "voice changer"
	desc = "A69oice scrambling69odule. If you can see this, report it as a bug on the tracker."
	var/voice //If set and item is present in69ask/suit, this name will be used for the wearer's speech.
	var/active

/obj/item/clothing/mask/gas/voice
	name = "gas69ask"
	desc = "A face-covering69ask that can be connected to an air supply. It seems to house some odd electronics."
	var/obj/item/voice_changer/changer
	origin_tech = list(TECH_COVERT = 4)

/obj/item/clothing/mask/gas/voice/verb/Toggle_Voice_Changer()
	set category = "Object"
	set src in usr

	changer.active = !changer.active
	to_chat(usr, "<span class='notice'>You 69changer.active ? "enable" : "disable"69 the69oice-changing69odule in \the 69src69.</span>")

/obj/item/clothing/mask/gas/voice/verb/Set_Voice(name as text)
	set category = "Object"
	set src in usr

	var/voice = sanitize(name,69AX_NAME_LEN)
	if(!voice || !length(voice)) return
	changer.voice =69oice
	to_chat(usr, SPAN_NOTICE("You are now69imicking <B>69changer.voice69</B>."))

/obj/item/clothing/mask/gas/voice/New()
	..()
	changer = new(src)
