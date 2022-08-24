
// insta-wield , can one-wield double wielded weapons, no recoil , no pain effects , +30 damage with fists, 75% chance to block incoming hits , automatically counters agressive grabs, can snap necks with an aggro-grab aimed at the head.

/datum/perk/chem/deathwish
	name = "Deathwish"
	desc = "Your sense of self conversation is lost.Your shots are extremly accurate, your sense of pain is nullified, you are unmatched in CQC, can fire twohanded guns with only one hand and you can do neck-snaps."
	gain_text = "You feel the full power of menace kick in.You are now an absolute unit."

/datum/perk/chem/deathwish/assign(mob/living/carbon/human/H)
	..()
	H.shock_resist += 2
	H.heal_overall_damage(25, 25)
	H.setHalLoss(0)
	H.pulling_punches = FALSE
	H.a_intent = I_HURT

/datum/perk/chem/deathwish/remove()
	holder.shock_resist -= 2
	holder.setHalLoss(50)
	holder.a_intent = I_HELP
	..()

/datum/perk/chem/atomictouch
	name = "Atomic touch"
	desc = "You see the universe in formulas and numbers. Everything is now clear as day. Color doesn't exist. Time is reversable.You hack faster , do genetics faster, tool faster , and can use basic AI remote control shortcuts for doors , APC's and atmos alarm."
	gain_text = "You feel like the control of all machinery is at your fingertips.."

/datum/perk/chem/atomictouch/assign(mob/living/carbon/human/H)
	. = ..()
	H.AddComponent(/datum/component/ai_like_control)

/datum/perk/chem/atomictouch/remove()
	var/datum/component/comp = holder.GetComponent(/datum/component/ai_like_control)
	if(comp)
		comp.RemoveComponent()
	..()





