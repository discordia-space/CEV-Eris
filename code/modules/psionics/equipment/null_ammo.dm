/obj/item/projectile/bullet/magnum/nullglass
	name = ".40 nullglass bullet"
	damage_types = list(BRUTE = 15, HALLOSS = 6)
//TODO: uncomment	var/shrapnel_type = /obj/item/material/shard/nullglass
	embed = FALSE

/obj/item/projectile/bullet/magnum/nullglass/disrupts_psionics()
	return src

/obj/item/projectile/bullet/magnum/on_hit(mob/living/target, def_zone = BP_CHEST)
 //   if(istype(target))
 //TODO: uncomment       var/obj/item/material/shard/nullglass/N = new(null)
 //       target.embed(N, def_zone)

/obj/item/ammo_casing/magnum/nullglass
	desc = "A revolver bullet casing with a nullglass coating."
	projectile_type = /obj/item/projectile/bullet/magnum/nullglass

/obj/item/ammo_casing/magnum/nullglass/disrupts_psionics()
	return src

/obj/item/ammo_magazine/speedloader/magnum/nullglass
	ammo_type = /obj/item/ammo_casing/magnum/nullglass
