/datum/subroutine/PayQPorGetDamageElseJackOut
	var/AmountOfQP = 2
	var/NeedJackingOut = TRUE
/*TODO
	var/AmountOfDamage = 6
	var/TypeOfDamage = "meat"
*/
	var/BrainDamageAmount
/datum/subroutine/PayQPorGetDamageElseJackOut/Trigger(datum/CyberSpaceAvatar/triggerer, wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK)
	. = ..()
	var/mob/living/carbon/human/body = triggerer.GetBody()
	if(body && istype(triggerer.Owner, /mob/observer/cyber_entity/cyberspace_eye))
		var/mob/observer/cyber_entity/cyberspace_eye/R = triggerer.Owner
		if(istype(R.owner))
			var/obj/item/computer_hardware/deck/D = R.owner
			if(AmountOfQP > 0 && !D.CostQP(AmountOfQP))
				if(NeedJackingOut)
					R.ReturnToBody() //TODO: Prevent ghostize
				if(BrainDamageAmount > 0)
					addtimer(
						CALLBACK(body, /mob/living/proc/adjustBrainLoss, BrainDamageAmount),
						5 SECONDS,
						TIMER_STOPPABLE
					)
					//body.adjustBrainLoss(BrainDamageAmount)//braindamage
