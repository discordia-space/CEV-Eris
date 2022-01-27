/obj/effect/damagedfloor
	layer = TURF_DECAL_LAYER
	icon = 'icons/turf/damage_overlays.dmi'
	icon_state = "damaged1"

/obj/effect/damagedfloor
	icon_state = "scorched1"

/obj/effect/damagedfloor/Initialize()
	var/turf/simulated/floor/F = loc
	if(istype(F))
		F.break_tile(1)
	69del(src)

/obj/effect/damagedfloor/fire/Initialize()
	var/turf/simulated/floor/F = loc
	if(istype(F))
		F.burn_tile()
	69del(src)

/obj/effect/damagedfloor/rust
	icon_state = "rust"

/obj/effect/damagedfloor/rust/Initialize()
	icon_state = "rust69rand(1,9)69"
	..()
