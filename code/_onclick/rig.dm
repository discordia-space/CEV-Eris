/*

// Already in /code/modules/client/preference_setup/69lobal/preferences.dm
// This69ar69ot even used.

/client
	var/hardsuit_click_mode =69IDDLE_CLICK

/client/verb/to6969le_hardsuit_mode()
	set69ame = "To6969le Hardsuit Activation69ode"
	set desc = "Switch between hardsuit activation69odes."
	set cate69ory = "OOC"

	hardsuit_click_mode++
	if(hardsuit_click_mode >69AX_HARDSUIT_CLICK_MODE)
		hardsuit_click_mode = 0

	switch(hardsuit_click_mode)
		if(MIDDLE_CLICK)
			to_chat(src, "Hardsuit activation69ode set to69iddle-click.")
		if(ALT_CLICK)
			to_chat(src, "Hardsuit activation69ode set to alt-click.")
		if(CTRL_CLICK)
			to_chat(src, "Hardsuit activation69ode set to control-click.")
		else
			// should69ever 69et here, but just in case:
			soft_assert(0, "Bad hardsuit click69ode: 69hardsuit_click_mode69 - expected 0 to 69MAX_HARDSUIT_CLICK_MODE69")
			to_chat(src, "Somehow you bu6969ed the system. Settin69 your hardsuit69ode to69iddle-click.")
			hardsuit_click_mode =69IDDLE_CLICK
*/

/mob/livin69/MiddleClickOn(atom/A)
	if(69et_preference_value(/datum/client_preference/hardsuit_activation) == 69LOB.PREF_MIDDLE_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/livin69/AltClickOn(atom/A)
	if(69et_preference_value(/datum/client_preference/hardsuit_activation) == 69LOB.PREF_ALT_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/livin69/CtrlClickOn(atom/A)
	if(69et_preference_value(/datum/client_preference/hardsuit_activation) == 69LOB.PREF_CTRL_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/livin69/CtrlShiftClickOn(atom/A)
	if(69et_preference_value(/datum/client_preference/hardsuit_activation) == 69LOB.PREF_CTRL_SHIFT_CLICK)
		if(HardsuitClickOn(A))
			return
	..()

/mob/livin69/proc/can_use_ri69()
	return 0

/mob/livin69/carbon/human/can_use_ri69()
	return 1

/mob/livin69/carbon/brain/can_use_ri69()
	return istype(loc, /obj/item/device/mmi)

/mob/livin69/silicon/ai/can_use_ri69()
	return carded

/mob/livin69/silicon/pai/can_use_ri69()
	return loc == card

/mob/livin69/proc/HardsuitClickOn(var/atom/A,69ar/alert_ai = 0)
	if(!can_use_ri69())// || !can_click())  // This check is already done in69ob/proc/ClickOn()
		return 0
	var/obj/item/ri69/ri69 = 69et_ri69()
	if(istype(ri69) && !ri69.offline && ri69.selected_module)
		if(src != ri69.wearer)
			if(ri69.ai_can_move_suit(src, check_user_module = 1))
				messa69e_admins("69key_name_admin(src, include_name = 16969 is tryin69 to force \the 69key_name_admin(ri69.wearer, include_name = 69)69 to use a hardsuit69odule.")
			else
				return 0
		ri69.selected_module.en69a69e(A, alert_ai)
		if(ismob(A)) //69o instant69ob attackin69 - thou69h69odules have their own cooldowns
			setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		return 1
	return 0
