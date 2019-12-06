// CPU that allows the computer to run programs.
// Better CPUs are obtainable via research and can run more programs on background.

/obj/item/weapon/computer_hardware/processor_unit
	name = "standard processor board"
	desc = "A CPU board used in most computers. It can run up to three programs simultaneously."
	icon_state = "cpuboard"
	hardware_size = 2
	power_usage = 50
	critical = TRUE
	malfunction_probability = 1
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)

	var/max_idle_programs = 2 // 2 idle, + 1 active = 3 as said in description.

/obj/item/weapon/computer_hardware/processor_unit/small
	name = "standard microprocessor"
	desc = "A miniaturised CPU used in most portable devices. It can run up to two programs simultaneously."
	icon_state = "cpu"
	hardware_size = 1
	power_usage = 25
	max_idle_programs = 1
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)



/obj/item/weapon/computer_hardware/processor_unit/super
	name = "photonic processor board"
	desc = "A photonic CPU board prototype. It can run up to five programs simultaneously, but uses a lot of power."
	icon_state = "cpuboard_super"
	hardware_size = 2
	power_usage = 250
	max_idle_programs = 4
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	price_tag = 20

/obj/item/weapon/computer_hardware/processor_unit/super/small
	name = "photonic microprocessor"
	desc = "A photonic CPU prototype for portable devices. It can run up to four programs simultaneously."
	icon_state = "cpu_super"
	hardware_size = 1
	power_usage = 75
	max_idle_programs = 2
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)

/obj/item/weapon/computer_hardware/processor_unit/Destroy()
	if(holder2 && (holder2.processor_unit == src))
		holder2.processor_unit = null
	return ..()