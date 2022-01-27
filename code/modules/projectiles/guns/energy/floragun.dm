/obj/item/gun/energy/floragun
	name = "Prototype: floral somatoray"
	desc = "A tool that discharges controlled radiation which induces69utation in plant cells."
	icon = 'icons/obj/guns/energy/flora.dmi'
	icon_state = "floramut100"
	item_state = "floramut"
	fire_sound = 'sound/effects/stealthoff.ogg'
	charge_cost = 100
	projectile_type = /obj/item/projectile/energy/floramut
	origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	modifystate = "floramut"
	self_recharge = 1
	matter = list(MATERIAL_STEEL = 20)
	price_tag = 1000
	spawn_tags = SPAWN_TAG_GUN_ENERGY_BOTANICAL
	init_firemodes = list(
		list(mode_name="induce69utations",69ode_desc="Make your crops weird and wonderful", projectile_type=/obj/item/projectile/energy/floramut,69odifystate="floramut", item_modifystate="mut", icon="kill"),
		list(mode_name="increase yield",69ode_desc="More fruit for your labour", projectile_type=/obj/item/projectile/energy/florayield,69odifystate="florayield", item_modifystate="yield", icon="stun"),
		)

/obj/item/gun/energy/floragun/afterattack(obj/target,69ob/user, adjacent_flag)
	//allow shooting into adjacent hydrotrays regardless of intent
	if(adjacent_flag && istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		user.visible_message(SPAN_DANGER("\The 69user69 fires \the 69src69 into \the 69target69!"))
		Fire(target,user)
		return
	..()
