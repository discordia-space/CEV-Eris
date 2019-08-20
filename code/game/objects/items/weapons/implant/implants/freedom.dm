#define INSTALL_HANDS 0
#define INSTALL_FOOTS 1

/obj/item/weapon/implant/freedom
	name = "freedom implant"
	desc = "Use this to escape from those evil Red Shirts."
	implant_color = "r"
	var/activation_emote = "chuckle"
	var/uses = 1.0
	var/install_organ = INSTALL_HANDS
	is_legal = FALSE
	origin_tech = list(TECH_COMBAT=5, TECH_MAGNET=3, TECH_BIO=4, TECH_ILLEGAL=2)
	allowed_organs = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)

/obj/item/weapon/implant/freedom/New()
	activation_emote = pick("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	uses = rand(1, 5)

/obj/item/weapon/implant/freedom/trigger(emote, mob/living/carbon/source)
	if (src.uses < 1)
		return
	if (emote == src.activation_emote)
		src.uses--
		to_chat(source, "You feel a faint click.")
		if (source.handcuffed && install_organ == INSTALL_HANDS)
			var/obj/item/weapon/W = source.handcuffed
			source.handcuffed = null
			if(source.buckled && source.buckled.buckle_require_restraints)
				source.buckled.unbuckle_mob()
			source.update_inv_handcuffed()
			if (source.client)
				source.client.screen -= W
			if (W)
				W.loc = source.loc
				dropped(source)
				if (W)
					W.layer = initial(W.layer)
		if (source.legcuffed && install_organ == INSTALL_FOOTS)
			var/obj/item/weapon/W = source.legcuffed
			source.legcuffed = null
			source.update_inv_legcuffed()
			if (source.client)
				source.client.screen -= W
			if (W)
				W.loc = source.loc
				dropped(source)
				if (W)
					W.layer = initial(W.layer)

/obj/item/weapon/implant/freedom/on_install(mob/living/carbon/source, obj/item/organ/O)
	if(O.organ_tag in list(BP_L_LEG, BP_R_LEG))
		install_organ = INSTALL_FOOTS
		source.mind.store_memory("Freedom implant can be activated by using the [activation_emote] emote, <B>say *[activation_emote]</B> to attempt to activate.", 0, 0)
		to_chat(source, "The implanted freedom implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")

/obj/item/weapon/implant/freedom/get_data()
	var/data = {"
		<b>Implant Specifications:</b><BR>
		<b>Name:</b> Freedom Beacon<BR>
		<b>Life:</b> optimum 5 uses<BR>
		<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
		<HR>
		<b>Implant Details:</b> <BR>
		<b>Function:</b> Transmits a specialized cluster of signals to override handcuff locking
		mechanisms<BR>
		<b>Special Features:</b><BR>
		<i>Neuro-Scan</i>- Analyzes certain shadow signals in the nervous system<BR>
		<b>Integrity:</b> The battery is extremely weak and commonly after injection its
		life can drive down to only 1 use.<HR>
		No Implant Specifics"}
	return data

/obj/item/weapon/implantcase/freedom
	name = "glass case - 'freedom'"
	desc = "A case containing a freedom implant."
	implant = /obj/item/weapon/implant/freedom

/obj/item/weapon/implanter/freedom
	name = "implanter (freedom)"
	implant = /obj/item/weapon/implant/freedom
