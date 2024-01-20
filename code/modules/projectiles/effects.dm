/obj/effect/projectile
	icon = 'icons/effects/projectiles.dmi'
	icon_state = "bolt"
	layer = ABOVE_MOB_LAYER
	var/lifetime = 3
	mouse_opacity = 0

/obj/effect/projectile/New(var/turf/location)
	init_plane()
	if(istype(location))
		forceMove(location)
	update_plane()

/obj/effect/projectile/proc/set_transform(var/matrix/M)
	if(istype(M))
		transform = M

/obj/effect/projectile/proc/activate(var/kill_delay = lifetime)
	spawn(kill_delay)
		qdel(src)	//see effect_system.dm - sets loc to null and lets GC handle removing these effects

//----------------------------
// Laser beam
//----------------------------
/obj/effect/projectile/laser/tracer
	icon_state = "beam"

/obj/effect/projectile/laser/muzzle
	icon_state = "muzzle_laser"

/obj/effect/projectile/laser/impact
	icon_state = "impact_laser"

//----------------------------
// Blue laser beam
//----------------------------
/obj/effect/projectile/laser_blue/tracer
	icon_state = "beam_blue"

/obj/effect/projectile/laser_blue/muzzle
	icon_state = "muzzle_blue"

/obj/effect/projectile/laser_blue/impact
	icon_state = "impact_blue"

//----------------------------
// Omni laser beam
//----------------------------
/obj/effect/projectile/laser_omni/tracer
	icon_state = "beam_omni"

/obj/effect/projectile/laser_omni/muzzle
	icon_state = "muzzle_omni"

/obj/effect/projectile/laser_omni/impact
	icon_state = "impact_omni"

//----------------------------
// Xray laser beam
//----------------------------
/obj/effect/projectile/xray/tracer
	icon_state = "xray"

/obj/effect/projectile/xray/muzzle
	icon_state = "muzzle_xray"

/obj/effect/projectile/xray/impact
	icon_state = "impact_xray"

//----------------------------
// Heavy laser beam
//----------------------------
/obj/effect/projectile/laser_heavy/tracer
	icon_state = "beam_heavy"

/obj/effect/projectile/laser_heavy/muzzle
	icon_state = "muzzle_beam_heavy"

/obj/effect/projectile/laser_heavy/impact
	icon_state = "impact_beam_heavy"

//----------------------------
// Psychic heavy laser beam
//----------------------------
/obj/effect/projectile/psychic_laser_heavy/tracer
	icon_state = "psychic_beam_heavy"

/obj/effect/projectile/psychic_laser_heavy/muzzle
	icon_state = "psychic_muzzle_beam_heavy"

/obj/effect/projectile/psychic_laser_heavy/impact
	icon_state = "psychic_impact_beam_heavy"

//----------------------------
// Pulse laser beam
//----------------------------
/obj/effect/projectile/laser_pulse/tracer
	icon_state = "u_laser"

/obj/effect/projectile/laser_pulse/muzzle
	icon_state = "muzzle_u_laser"

/obj/effect/projectile/laser_pulse/impact
	icon_state = "impact_u_laser"

//----------------------------
// Pulse muzzle effect only
//----------------------------
/obj/effect/projectile/pulse/muzzle
	icon_state = "muzzle_pulse"

//----------------------------
// Emitter beam
//----------------------------
/obj/effect/projectile/emitter/tracer
	icon_state = "emitter"

/obj/effect/projectile/emitter/muzzle
	icon_state = "muzzle_emitter"

/obj/effect/projectile/emitter/impact
	icon_state = "impact_emitter"

//----------------------------
// Stun beam
//----------------------------
/obj/effect/projectile/stun/tracer
	icon_state = "stun"

/obj/effect/projectile/stun/muzzle
	icon_state = "muzzle_stun"

/obj/effect/projectile/stun/impact
	icon_state = "impact_stun"

//----------------------------
// Bullet
//----------------------------
/obj/effect/projectile/bullet/muzzle
	icon_state = "muzzle_bullet"

//----------------------------
// Plasma
//----------------------------
/obj/effect/projectile/plasma/muzzle
	icon_state = "muzzle_plasma"

/obj/effect/projectile/plasma/muzzle/light
	icon_state = "muzzle_plasma_pink" //Hue shift of 168

/obj/effect/projectile/plasma/muzzle/heavy
	icon_state = "muzzle_plasma_blue" //Hue shift of 84

/obj/effect/projectile/plasma/tracer

/obj/effect/projectile/plasma/impact
	icon_state = "impact_plasma"
	lifetime = 7.5

/obj/effect/projectile/plasma/impact/light
	icon_state = "impact_plasma_pink"

/obj/effect/projectile/plasma/impact/heavy
	icon_state = "impact_plasma_blue"

//----------------------------
// Cutter
//----------------------------
/obj/effect/projectile/laser/plasmacutter/tracer
	icon_state = "plasmacutter"

/obj/effect/projectile/laser/plasmacutter/impact
	icon_state = "impact_plasmacutter"

/obj/effect/projectile/laser/plasmacutter/muzzle
	icon_state = "muzzle_plasmacutter"

