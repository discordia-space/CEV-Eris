/obj/item/device/assembly
	name = "assembly"
	desc = "A small electronic device that should never exist."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = ""
	flags = CONDUCT
	w_class = 2.0
	matter = list(DEFAULT_WALL_MATERIAL = 100)
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 3
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 1)

	var/secured = TRUE
	var/list/attached_overlays = null
	var/obj/item/device/assembly_holder/holder = null
	var/cooldown = 0 //To prevent spam
	var/wires = WIRE_RECEIVE | WIRE_PULSE

	var/const/WIRE_RECEIVE = 1			//Allows Pulsed(0) to call Activate()
	var/const/WIRE_PULSE = 2				//Allows Pulse(0) to act on the holder
	var/const/WIRE_PULSE_SPECIAL = 4		//Allows Pulse(0) to act on the holders special assembly
	var/const/WIRE_RADIO_RECEIVE = 8		//Allows Pulsed(1) to call Activate()
	var/const/WIRE_RADIO_PULSE = 16		//Allows Pulse(1) to send a radio message


/obj/item/device/assembly/proc/activate()
	if(!secured || (cooldown > 0))
		return FALSE
	cooldown = 2
	spawn(10)
		process_cooldown()
	return TRUE


/obj/item/device/assembly/proc/process_cooldown()
	cooldown--
	if(cooldown <= 0)
		return FALSE
	spawn(10)
		process_cooldown()
	return TRUE


/obj/item/device/assembly/proc/pulsed(var/radio = 0)
	if(holder && wires & WIRE_RECEIVE)
		activate()
	if(radio && wires & WIRE_RADIO_RECEIVE)
		activate()


/obj/item/device/assembly/proc/pulse(var/radio = 0)
	if(holder && (wires & WIRE_PULSE))
		holder.process_activation(src, 1, 0)
	if(holder && (wires & WIRE_PULSE_SPECIAL))
		holder.process_activation(src, 0, 1)
	return 1


/obj/item/device/assembly/proc/toggle_secure()
	secured = !secured
	update_icon()
	return secured


/obj/item/device/assembly/proc/attach_assembly(var/obj/item/device/assembly/A, var/mob/user)
	holder = new/obj/item/device/assembly_holder(get_turf(src))
	if(holder.attach(A, src, user))
		user << "<span class='notice'>You attach \the [A] to \the [src]!</span>"


/obj/item/device/assembly/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(is_assembly(W))
		var/obj/item/device/assembly/A = W
		if((!A.secured) && (!secured))
			attach_assembly(A, user)
			return
	if(isscrewdriver(W))
		if(toggle_secure())
			user << "<span class='notice'>\The [src] is ready!</span>"
		else
			user << "<span class='notice'>\The [src] can now be attached!</span>"
		return
	..()


/obj/item/device/assembly/process()
	processing_objects.Remove(src)


/obj/item/device/assembly/examine(mob/user)
	..(user)
	if(in_range(src, user) || loc == user)
		if(secured)
			user << "<span class='notice'>\The [src] is ready!</span>"
		else
			user << "<span class='notice'>\The [src] can be attached!</span>"


/obj/item/device/assembly/attack_self(mob/user as mob)
	if(!user)
		return 0
	user.set_machine(src)
	interact(user)
	return 1


/obj/item/device/assembly/interact(mob/user as mob)
	return //HTML MENU FOR WIRES GOES HERE

/obj/item/device/assembly/proc/holder_movement()
	return

/obj/item/device/assembly/nano_host()
    if(istype(loc, /obj/item/device/assembly_holder))
        return loc.nano_host()
    return ..()

/obj/item/device/assembly/proc/is_attachable()
	if(secured)
		return FALSE
	return TRUE
