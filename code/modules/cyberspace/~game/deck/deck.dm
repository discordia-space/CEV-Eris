/obj/item/weapon/computer_hardware/deck
	name = "cyberspace deck"
	desc = "A strange device with port for data jacks."
	
	icon = 'icons/obj/cyberspace/deck.dmi'
	icon_state = "common"
	hardware_size = 1
	power_usage = 100
	origin_tech = list(TECH_BLUESPACE = 2, TECH_DATA = 4)
	price_tag = 100

	var/connection = FALSE
	var/power_usage_idle = 100
	var/power_usage_using = 2 KILOWATTS


	var/memory = 4 // Memory slots for programs, can be extended by hardware or by default
	var/list/programs = list() // Installed programs, icebreakers and etc.

	var/mob/observer/cyberspace_eye/projected_mind = /mob/observer/cyberspace_eye/hacker

	var/obj/item/mind_cable/cable

	Initialize()
		. = ..()
		if(ispath(projected_mind))
			projected_mind = new projected_mind(src)
	attackby(obj/item/W, mob/living/user)
		. = ..()
		if(istype(W, /obj/item/mind_cable))
			SetCable(W)
			playsound(get_turf(src), 'sound/weapons/guns/interact/pistol_magin.ogg', 75, 1)

/obj/item/weapon/computer_hardware/deck/proc
	update_power_usage()
		if(!connection)
			power_usage = power_usage_idle
		else
			power_usage = power_usage_using
	SetCable(obj/item/mind_cable/_cable)
		if(cable != _cable && istype(cable))
			cable.DisconnectFromDeck()
		if(istype(_cable))
			cable = src
			cable.ConnectToDeck(src)

	get_user()
		if(istype(cable) && istype(cable.owner))
			var/obj/item/organ/internal/data_jack/data_jack = cable.owner
			return data_jack.owner

	DisconnectCable()
		dropInto(get_turf(src))
		cable = null

	BeginCyberspaceConnection()
		var/mob/living/carbon/human/owner = get_user()
		if(istype(owner) && owner.stat == CONSCIOUS && owner.mind)
			projected_mind.dropInto(get_turf(src))
			return owner.PutInAnotherMob(projected_mind)

	CancelCyberspaceConnection()
		if(istype(projected_mind))
			projected_mind.PutInAnotherMob(get_user())
			projected_mind.forceMove(src)
