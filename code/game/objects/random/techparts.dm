/obj/random/techpart
	name = "random techpart"
	icon_state = "tech-orange"

/obj/random/techpart/item_to_spawn()
	return pickweight(list(
				/obj/item/weapon/computer_hardware/card_slot = 9,\
				/obj/item/weapon/computer_hardware/hard_drive = 9,\
				/obj/item/weapon/computer_hardware/hard_drive/advanced = 3,\
				/obj/item/weapon/computer_hardware/network_card = 9,\
				/obj/item/weapon/computer_hardware/network_card/advanced = 3,\
				/obj/item/weapon/computer_hardware/processor_unit = 9,\
				/obj/item/weapon/computer_hardware/processor_unit/small = 9,\
				/obj/item/weapon/computer_hardware/processor_unit/photonic = 3,\
				/obj/item/weapon/computer_hardware/tesla_link = 9,\
				/obj/item/device/assembly/igniter = 12,\
				/obj/item/device/assembly/infra = 12,\
				/obj/item/device/assembly/prox_sensor = 12,\
				/obj/item/device/assembly/signaler = 12,\
				/obj/item/device/assembly/timer = 12,\
				/obj/item/device/assembly/voice = 9,\
				/obj/item/weapon/stock_parts/console_screen = 15,\
				/obj/item/weapon/stock_parts/capacitor = 15,\
				/obj/item/weapon/stock_parts/capacitor/adv = 3,\
				/obj/item/weapon/stock_parts/manipulator = 15,\
				/obj/item/weapon/stock_parts/manipulator/nano = 3,\
				/obj/item/weapon/stock_parts/matter_bin = 24,\
				/obj/item/weapon/stock_parts/matter_bin/adv = 6,\
				/obj/item/weapon/stock_parts/micro_laser = 15,\
				/obj/item/weapon/stock_parts/micro_laser/high = 3,\
				/obj/item/weapon/stock_parts/scanning_module = 15,\
				/obj/item/weapon/stock_parts/scanning_module/adv = 3,\
				/obj/item/weapon/stock_parts/subspace/amplifier = 3,\
				/obj/item/weapon/stock_parts/subspace/analyzer = 3,\
				/obj/item/weapon/stock_parts/subspace/ansible = 3,\
				/obj/item/weapon/stock_parts/subspace/crystal = 3,\
				/obj/item/weapon/stock_parts/subspace/filter = 3,\
				/obj/item/weapon/stock_parts/subspace/transmitter = 3,\
				/obj/item/weapon/stock_parts/subspace/treatment = 3,\
				/obj/item/weapon/disk/autolathe_disk/basic = 3,\
				/obj/item/weapon/disk/autolathe_disk/devices = 3,\
				/obj/item/weapon/disk/autolathe_disk/toolpack = 3,\
				/obj/item/weapon/disk/autolathe_disk/component = 3,\
				/obj/item/weapon/disk/autolathe_disk/advtoolpack = 2,\
				/obj/item/weapon/disk/autolathe_disk/circuitpack = 2,\
				/obj/item/weapon/disk/autolathe_disk/robustcells = 2,\
				/obj/item/weapon/disk/autolathe_disk/medical = 2,\
				/obj/item/weapon/disk/autolathe_disk/computer = 2,\
				/obj/item/weapon/disk/autolathe_disk/fs_cheap_guns = 2,\
				/obj/item/weapon/disk/autolathe_disk/fs_kinetic_guns = 1,\
				/obj/item/weapon/disk/autolathe_disk/fs_energy_guns = 1,\
				/obj/item/weapon/disk/autolathe_disk/nt_old_guns = 1,\
				/obj/item/weapon/disk/autolathe_disk/nt_new_guns = 1,\
				/obj/item/weapon/disk/autolathe_disk/nonlethal_ammo = 3,\
				/obj/item/weapon/disk/autolathe_disk/lethal_ammo = 2))

/obj/random/techpart/low_chance
	name = "low chance random techpart"
	icon_state = "tech-orange-low"
	spawn_nothing_percentage = 60
