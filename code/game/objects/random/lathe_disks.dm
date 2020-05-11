/obj/random/lathe_disk
	name = "random lathe disk"
	icon_state = "tech-green"

/obj/random/lathe_disk/item_to_spawn() // pickweight is calculated from advanced list = / 2 - 1. If lower than 1 - delete from the list;
	return pickweight(list(
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/misc = 20,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/devices = 16,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/tools = 6,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/components = 10,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/adv_tools = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/conveyors = 10,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/circuits = 6,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/medical = 8,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/computer = 8,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/security = 6,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_cheap_guns = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_mk58 = 3,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_colt = 3,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_silenced = 2,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_miller = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_consul = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_deckard = 1,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_doublebarrel = 3,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_kammerer = 3,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_paco = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_straylight = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_molly = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_atreides = 1,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_boltgun = 5,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_counselor = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_spiderrose = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_martin = 3,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_themis = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_lightfall = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_halicon = 3,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/ms_dartgun = 4,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/nonlethal_ammo = 7,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/lethal_ammo = 5,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/ammo_boxes_smallarms = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/ammo_boxes_rifle = 4,))

/obj/random/lathe_disk/low_chance
	name = "low chance random lathe disk"
	icon_state = "tech-green-low"
	spawn_nothing_percentage = 80




/obj/random/lathe_disk/advanced
	name = "random advanced lathe disk"
	icon_state = "tech-green"

/obj/random/lathe_disk/advanced/item_to_spawn()
	return pickweight(list(
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/adv_tools = 4,


				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_consul = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_deckard = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_mateba = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_lamia = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_deagle = 2,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_regulator = 6,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_gladstone = 6,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_pug = 1,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_straylight = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_molly = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_zoric = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_atreides = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/ex_drozd = 2,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_bulldog = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_wintermute = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_sol = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/dallas = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_kalashnikov = 4,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_heavysniper = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_pk = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_protector = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_lenar = 1,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_counselor = 6,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_spiderrose = 4,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_nemesis = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_themis = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_lightfall = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_valkirye = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_halicon = 3,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_dominion = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_purger = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_cassad = 1,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/ms_dartgun = 2,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/nonlethal_ammo = 5,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/lethal_ammo = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/ammo_boxes_smallarms = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/ammo_boxes_rifle = 4,))

/obj/random/lathe_disk/advanced/low_chance
	name = "low chance advanced lathe disk"
	icon_state = "tech-green-low"
	spawn_nothing_percentage = 80
