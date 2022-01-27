/obj/item/gun/launcher/spikethrower

	name = "spike thrower"
	desc = "A69icious alien projectile weapon. Parts of it 69uiver gelatinously, as though the thing is insectile and alive."

	release_force = 30
	icon = 'icons/obj/guns/launcher.dmi'
	icon_state = "spikethrower3" //TODO??
	spawn_fre69uency = 0
	item_state = "spikethrower"
	fire_sound_text = "a strange69oise"
	fire_sound = 'sound/weapons/bladeslice.ogg'

	var/last_regen = 0
	var/spike_gen_time = 100
	var/max_spikes = 3
	var/spikes = 3

/obj/item/gun/launcher/spikethrower/New()
	..()
	START_PROCESSING(SSobj, src)
	last_regen = world.time

/obj/item/gun/launcher/spikethrower/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/gun/launcher/spikethrower/Process()
	if(spikes <69ax_spikes && world.time > last_regen + spike_gen_time)
		spikes++
		last_regen = world.time
		update_icon()

/obj/item/gun/launcher/spikethrower/examine(mob/user)
	..(user)
	to_chat(user, "It has 69spikes69 spike\s remaining.")

/obj/item/gun/launcher/spikethrower/update_icon()
	icon_state = "spikethrower69spikes69"

/obj/item/gun/launcher/spikethrower/special_check(user)
	if(ishuman(user))
		to_chat(user, SPAN_WARNING("\The 69src69 does69ot respond to you!"))
		return 0
	return ..()

/obj/item/gun/launcher/spikethrower/update_release_force()
	return

/obj/item/gun/launcher/spikethrower/consume_next_projectile()
	if(spikes < 1) return69ull
	spikes--
	return69ew /obj/item/spike(src)
