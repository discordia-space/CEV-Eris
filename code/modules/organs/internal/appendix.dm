/obj/item/organ/internal/appendix
	name = "appendix"
	icon_state = "appendix"
	parent_organ_base = BP_GROIN
	organ_efficiency = list(OP_APPENDIX = 100)
	specific_organ_size = 0
	price_tag = 50
	var/inflamed = 0 //Counter, not boolean

/obj/item/organ/internal/appendix/update_icon()
	..()
	if(inflamed)
		icon_state = "appendixinflamed"
		name = "inflamed appendix"

/obj/item/organ/internal/appendix/Process()
	..()
	if(inflamed && owner)
		inflamed++
		if(prob(5))
			to_chat(owner, SPAN_WARNING("You feel a stinging pain in your abdomen!"))
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
					to_chat(owner, SPAN_DANGER("You gag as you want to throw up, but there's nothing in your stomach!"))
					owner.Weaken(10)
		if(inflamed > 600)
			if(prob(1))
				to_chat(owner, SPAN_DANGER("Your abdomen is a world of pain!"))
				owner.Weaken(10)
				owner.adjustToxLoss(25)
				removed()
				qdel(src)
