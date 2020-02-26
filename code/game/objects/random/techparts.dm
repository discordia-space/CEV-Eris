/obj/random/techpart
	name = "random techpart"
	icon_state = "tech-orange"

/obj/random/techpart/item_to_spawn()
	return pickweight(list(/obj/item/weapon/computer_hardware/card_slot = 18,
				/obj/item/weapon/computer_hardware/hard_drive/small = 12,
				/obj/item/weapon/computer_hardware/hard_drive/small/adv = 6,
				/obj/item/weapon/computer_hardware/hard_drive = 8,
				/obj/item/weapon/computer_hardware/hard_drive/advanced = 4,
				/obj/item/weapon/computer_hardware/network_card = 12,
				/obj/item/weapon/computer_hardware/network_card/wired = 4,
				/obj/item/weapon/computer_hardware/network_card/advanced = 6,
				/obj/item/weapon/computer_hardware/processor_unit = 12,
				/obj/item/weapon/computer_hardware/processor_unit/small = 12,
				/obj/item/weapon/computer_hardware/processor_unit/adv = 6,
				/obj/item/weapon/computer_hardware/processor_unit/adv/small = 8,
				/obj/item/weapon/computer_hardware/tesla_link = 18,
				/obj/item/device/assembly/igniter = 24,
				/obj/item/device/assembly/infra = 24,
				/obj/item/device/assembly/prox_sensor = 24,
				/obj/item/device/assembly/signaler = 24,
				/obj/item/device/assembly/timer = 24,
				/obj/item/device/assembly/voice = 18,
				/obj/item/weapon/stock_parts/console_screen = 30,
				/obj/item/weapon/stock_parts/capacitor = 20,
				/obj/item/weapon/stock_parts/capacitor/adv = 6,
				/obj/item/weapon/stock_parts/manipulator = 30,
				/obj/item/weapon/stock_parts/manipulator/nano = 10,
				/obj/item/weapon/stock_parts/matter_bin = 40,
				/obj/item/weapon/stock_parts/matter_bin/adv = 12,
				/obj/item/weapon/stock_parts/micro_laser = 30,
				/obj/item/weapon/stock_parts/micro_laser/high = 10,
				/obj/item/weapon/stock_parts/scanning_module = 30,
				/obj/item/weapon/stock_parts/scanning_module/adv = 10,
				/obj/item/weapon/stock_parts/subspace/amplifier = 6,
				/obj/item/weapon/stock_parts/subspace/analyzer = 6,
				/obj/item/weapon/stock_parts/subspace/ansible = 6,
				/obj/item/weapon/stock_parts/subspace/crystal = 6,
				/obj/item/weapon/stock_parts/subspace/filter = 6,
				/obj/item/weapon/stock_parts/subspace/transmitter = 6,
				/obj/item/weapon/stock_parts/subspace/treatment = 6,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/misc = 6,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/devices = 6,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/tools = 6,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/components = 6,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/adv_tools = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/circuits = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/conveyors = 10,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/robustcells = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/medical = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/computer = 4,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_cheap_guns = 3,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_mk58 = 3,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_colt = 3,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_silenced = 2,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_miller = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_consul = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_deckard = 1,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_doublebarrel = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_kammerer = 3,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_regulator = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_gladstone = 2,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_paco = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_straylight = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_molly = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_zoric = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_atreides = 1,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_bulldog = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_sol = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_boltgun = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_kalashnikov = 1,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_counselor = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_spiderrose = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_martin = 3,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_themis = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_lightfall = 1,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_halicon = 2,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_dominion = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_purger = 2,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_cassad = 1,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/ms_dartgun = 6,

				/obj/item/weapon/computer_hardware/hard_drive/portable/design/nonlethal_ammo = 6,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/lethal_ammo = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/ammo_boxes_smallarms = 4,
				/obj/item/weapon/computer_hardware/hard_drive/portable/design/ammo_boxes_rifle = 4,))

/obj/random/techpart/low_chance
	name = "low chance random techpart"
	icon_state = "tech-orange-low"
	spawn_nothing_percentage = 60
