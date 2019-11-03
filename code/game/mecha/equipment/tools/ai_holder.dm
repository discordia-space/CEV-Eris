/obj/item/mecha_parts/mecha_equipment/tool/ai_holder
	name = "AI holder"
	desc = "AI holder - allowed AI control exo-suits."
	icon_state = "ai_holder"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_STEEL = 20, MATERIAL_GLASS = 3)
	energy_drain = 2
	equip_cooldown = 20
	salvageable = 0
	var/obj/machinery/camera/Cam = null
	var/mob/living/silicon/ai/occupant = null
	var/mob/living/prev_occupant = null

/obj/item/mecha_parts/mecha_equipment/tool/ai_holder/proc/go_out()
	chassis.occupant = null
	chassis.update_icon()
	occupant.remove_mecha_verbs()
	occupant.set_mecha(null)
	if(occupant.eyeobj)
		occupant.eyeobj.setLoc(chassis)
	else
		var/mob/living/silicon/ai/AI = occupant
		AI.create_eyeobj(get_turf(src))

	occupant = null
	if(prev_occupant)
		chassis.occupant = prev_occupant
		prev_occupant.forceMove(chassis)


/obj/item/mecha_parts/mecha_equipment/tool/ai_holder/proc/occupied(var/mob/living/silicon/ai/AI)
	if(chassis.occupant && !isAI(chassis.occupant))
		prev_occupant = chassis.occupant
		prev_occupant.forceMove(src)
	AI.set_mecha(chassis)
	occupant = AI
	chassis.occupant = occupant
	chassis.update_icon()
	AI.add_mecha_verbs()

/obj/item/mecha_parts/mecha_equipment/tool/ai_holder/interact(var/mob/living/silicon/ai/user)
	//Enter
	if(!chassis)
		//No chasis
		return
	if(occupant)
		//OC exist
		if(occupant == user)
			go_out()
		else
			to_chat(user, "Controller is already occupied!")
	else
		//No OC
		if(isAI(user))
			//user is AI
			occupied(user)
			//"Exit"

/obj/item/mecha_parts/mecha_equipment/tool/ai_holder/attach()
	..()
	Cam = new
	Cam.c_tag = chassis.name

/obj/item/mecha_parts/mecha_equipment/tool/ai_holder/detach()
	if(occupant)
		go_out()
	qdel(Cam)


/obj/mecha/attack_ai(var/mob/living/user)
	var/obj/item/mecha_parts/mecha_equipment/tool/ai_holder/AH = locate() in src
	if(AH)
		AH.interact(user)

/mob/living/silicon/ai/proc/set_mecha(var/obj/mecha/M)
	if(M)
		if(controlled_mech == M)
			return
		if(controlled_mech)
			controlled_mech.go_out()
		destroy_eyeobj(M)
	controlled_mech = M
