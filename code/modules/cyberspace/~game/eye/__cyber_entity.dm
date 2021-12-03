/mob/observer/cyber_entity
	icon = 'icons/obj/cyberspace/ices/wild.dmi'

	invisibility = INVISIBILITY_MAXIMUM
	alpha = 200

	var/maxHP = 100
	var/HP
	var/Might = 5
	var/attack_range = 1

	var/movement_delay = 6

	movement_handlers = list(/datum/movement_handler/mob/incorporeal/cyberspace)

	var/hacking_limit = 3
	var/tmp/list/HackingInProgress = list()

	var/Hacked = FALSE

	var/DeleteTime = 5 MINUTES
	var/tmp/delete_timer

	var/list/init_subroutines = list()

	Initialize()
		. = ..()
		SetHP()
		CollectSubroutines()

	incapacitated() // Fuck it, we will right our own incapaciation
		return 0

/mob/observer/cyber_entity/proc/CollectSubroutines()
	if(istype(CyberAvatar.Subroutines))
		var/list/L = list()
		for(var/i in init_subroutines)
			L += new i()
		CyberAvatar.Subroutines.AddSubroutines(
			L,
			CyberAvatar.Subroutines.Attack
		)

/mob/observer/cyber_entity/proc/ChangeHP(percents = 0.05, amount = FALSE) //Returns successful delta
	if(!amount)
		amount = maxHP * percents
	. = HP
	SetHP(clamp(HP + amount, 0, maxHP))
	. = HP - .

/mob/observer/cyber_entity/proc/SetHP(value = maxHP)
	HP = value
	update_hud()
	update_health()

/mob/observer/cyber_entity/proc/update_health()
	if(HP <= 0)
		Death()
	update_icon()

/mob/observer/cyber_entity/proc/Death()
	delete_timer = QDEL_IN(src, DeleteTime)
