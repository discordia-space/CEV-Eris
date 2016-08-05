/obj/effect/damagedfloor
	layer = 2.01
	icon = 'icons/turf/damage_overlays.dmi'
	icon_state = "damaged1"

/obj/effect/damagedfloor
	icon_state = "scorched1"

/obj/effect/damagedfloor/fire/New(loc)
	var/turf/simulated/floor/F = loc
	if(istype(F))
		F.burn_tile()
	qdel(src)

/obj/effect/damagedfloor/rust
	icon_state = "rust"

/obj/effect/damagedfloor/New(loc)
	var/turf/simulated/floor/F = loc
	if(istype(F))
		F.break_tile(1)
	qdel(src)