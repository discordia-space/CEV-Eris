/obj/effect/flooring_type_spawner
	name = "underplating spawner"
	icon = 'icons/obj/structures.dmi'
	icon_state = "plating_spawner"
	density = 1
	anchored = 1
	var/change_floor_to_path = /turf/floor/plating/under
	var/activated = FALSE

/obj/effect/flooring_type_spawner/concrete
	name = "concrete spawner"
	change_floor_to_path = /turf/floor/rock/manmade/concrete
	icon_state = "concrete_spawner"

//Maints tile fixed flooring
/obj/effect/flooring_type_spawner/concrete_small_fixed
	name = "concrete small fixed spawner"
	change_floor_to_path = /turf/floor/industrial/fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/concrete_bricks_fixed
	name = "concrete bricks fixed spawner"
	change_floor_to_path = /turf/floor/industrial/concrete_bricks_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/bricks_fixed
	name = "bricks fixed spawner"
	change_floor_to_path = /turf/floor/industrial/bricks_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/ornate_fixed
	name = "ornate fixed spawner"
	change_floor_to_path = /turf/floor/industrial/ornate_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/sierra_fixed
	name = "sierra fixed spawner"
	change_floor_to_path = /turf/floor/industrial/sierra_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/ceramic_fixed
	name = "ceramic fixed spawner"
	change_floor_to_path = /turf/floor/industrial/ceramic_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/grey_slates_long_fixed
	name = "blue long slates fixed spawner"
	change_floor_to_path = /turf/floor/industrial/grey_slates_long_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/blue_slates_long_fixed
	name = "blue long slates fixed spawner"
	change_floor_to_path = /turf/floor/industrial/blue_slates_long_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/grey_slates_fixed
	name = "grey slates fixed spawner"
	change_floor_to_path = /turf/floor/industrial/grey_slates_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/blue_slates_fixed
	name = "blue slates fixed spawner"
	change_floor_to_path = /turf/floor/industrial/blue_slates_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/navy_slates_fixed
	name = "navy slates fixed spawner"
	change_floor_to_path = /turf/floor/industrial/navy_slates_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/fancy_slates_fixed
	name = "fancy slate fixed spawner"
	change_floor_to_path = /turf/floor/industrial/fancy_slates_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/navy_large_slates_fixed
	name = "navy large fixed spawner"
	change_floor_to_path = /turf/floor/industrial/navy_large_slates_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/black_large_slates_fixed
	name = "black large fixed spawner"
	change_floor_to_path = /turf/floor/industrial/black_large_slates_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/green_large_slates_fixed
	name = "green large fixed spawner"
	change_floor_to_path = /turf/floor/industrial/green_large_slates_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/white_large_slates_fixed
	name = "white large fixed spawner"
	change_floor_to_path = /turf/floor/industrial/white_large_slates_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/white_large_slates_fixed
	name = "white large fixed spawner"
	change_floor_to_path = /turf/floor/industrial/white_large_slates_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/checker_large_fixed
	name = "checkered large fixed spawner"
	change_floor_to_path = /turf/floor/industrial/checker_large_fixed
	icon_state = "concrete_spawner"

/obj/effect/flooring_type_spawner/cafe_large_fixed
	name = "cafe large fixed spawner"
	change_floor_to_path = /turf/floor/industrial/cafe_large_fixed
	icon_state = "concrete_spawner"

//Wooden walls
/obj/effect/flooring_type_spawner/wood_wall
	name = "plank wood wall"
	change_floor_to_path = /turf/wall/wood
	icon_state = "plank_spawner"

/obj/effect/flooring_type_spawner/wood_wall_old
	name = "aged plank wood wall"
	change_floor_to_path = /turf/wall/wood_old
	icon_state = "old_plank_spawner"

//Mining wall Spawners (Used for SLAB)
/obj/effect/flooring_type_spawner/mining_wall_oreful
	name = "mineral spawner - always give ores"
	change_floor_to_path = /turf/mineral/random
	icon_state = "raise_rocks"

/obj/effect/flooring_type_spawner/mining_wall
	name = "mineral spawner"
	change_floor_to_path = /turf/mineral
	icon_state = "raise_rocks"

/obj/effect/flooring_type_spawner/Initialize()
	. = ..()
	if(!change_floor_to_path)
		return
	if(SSticker.current_state < GAME_STATE_PLAYING)
		if(activated)
			return
		activate()
		return INITIALIZE_HINT_QDEL
	else
		if(activated)
			return
		spawn(10)
			activate()
			qdel(src)

/obj/effect/flooring_type_spawner/proc/handle_flooring_spawn()
	var/turf/Tsrc = get_turf(src)
	if(Tsrc)
		Tsrc.ChangeTurf(change_floor_to_path)
	//Returns are for debugging spawners
		return TRUE
	return FALSE

/obj/effect/flooring_type_spawner/proc/activate()
	handle_flooring_spawn(src)
	activated = TRUE
	return
