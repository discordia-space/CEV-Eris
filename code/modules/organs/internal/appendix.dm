/obj/item/organ/internal/appendix
	name = "appendix"
	icon_state = "appendix"
	parent_organ = "groin"
	organ_tag = "appendix"
	var/inflamed = 0

/obj/item/organ/internal/appendix/update_icon()
	..()
	if(inflamed)
		icon_state = "appendixinflamed"
		name = "inflamed appendix"

/obj/item/organ/internal/appendix/process()
	..()
	if(inflamed && owner)
		inflamed++
		if(prob(5))
			owner << "<span class='warning'>You feel a stinging pain in your abdomen!</span>"
			owner.emote("me",1,"winces slightly.")
		if(inflamed > 200)
			if(prob(3))
				take_damage(0.1)
				owner.emote("me",1,"winces painfully.")
				owner.adjustToxLoss(1)
		if(inflamed > 400)
			if(prob(1))
				germ_level += rand(2,6)
				if (owner.nutrition > 100)
					owner.vomit()
				else
					owner << "<span class='danger'>You gag as you want to throw up, but there's nothing in your stomach!</span>"
					owner.Weaken(10)
		if(inflamed > 600)
			if(prob(1))
				owner << "<span class='danger'>Your abdomen is a world of pain!</span>"
				owner.Weaken(10)

				var/datum/wound/W = new /datum/wound/internal_bleeding(20)
				parent.germ_level = max(INFECTION_LEVEL_TWO, parent.germ_level)
				owner.adjustToxLoss(25)
				parent.wounds += W
