/obj/structure/reagent_dispensers/coolanttank
	name = "coolant tank"
	desc = "A tank of industrial coolant"
	icon = 'icons/obj/objects.dmi'
	icon_state = "coolanttank"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/coolanttank/Initialize(mapload, ...)
	. = ..()
	reagents.add_reagent("coolant",1000)

/obj/structure/reagent_dispensers/coolanttank/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		explode()

/obj/structure/reagent_dispensers/coolanttank/ex_act(severity)
	if(severity < 4)
		explode()

/obj/structure/reagent_dispensers/coolanttank/explode()
	var/datum/effect/effect/system/smoke_spread/S = new /datum/effect/effect/system/smoke_spread
	//S.attach(src)
	S.set_up(5, 0, src.loc)

	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	spawn(0)
		S.start()

	var/datum/gas_mixture/env = src.loc.return_air()
	if(env)
		env.add_thermal_energy(reagents.total_volume * -5000)

	sleep(10)
	if(src)
		qdel(src)
