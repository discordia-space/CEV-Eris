/obj/random/techpart
	name = "random techpart"
	icon_state = "tech-orange"

/obj/random/techpart/item_to_spawn()
	return pick(prob(9);/obj/item/weapon/computer_hardware/battery_module,\
				prob(3);/obj/item/weapon/computer_hardware/battery_module/advanced,\
				prob(9);/obj/item/weapon/computer_hardware/card_slot,\
				prob(9);/obj/item/weapon/computer_hardware/hard_drive,\
				prob(3);/obj/item/weapon/computer_hardware/hard_drive/advanced,\
				prob(9);/obj/item/weapon/computer_hardware/network_card,\
				prob(3);/obj/item/weapon/computer_hardware/network_card/advanced,\
				prob(9);/obj/item/weapon/computer_hardware/processor_unit,\
				prob(9);/obj/item/weapon/computer_hardware/processor_unit/small,\
				prob(3);/obj/item/weapon/computer_hardware/processor_unit/photonic,\
				prob(9);/obj/item/weapon/computer_hardware/tesla_link,\
				prob(12);/obj/item/device/assembly/igniter,\
				prob(12);/obj/item/device/assembly/infra,\
				prob(12);/obj/item/device/assembly/prox_sensor,\
				prob(12);/obj/item/device/assembly/signaler,\
				prob(12);/obj/item/device/assembly/timer,\
				prob(9);/obj/item/device/assembly/voice,\
				prob(15);/obj/item/weapon/stock_parts/console_screen,\
				prob(15);/obj/item/weapon/stock_parts/capacitor,\
				prob(3);/obj/item/weapon/stock_parts/capacitor/adv,\
				prob(15);/obj/item/weapon/stock_parts/manipulator,\
				prob(3);/obj/item/weapon/stock_parts/manipulator/nano,\
				prob(24);/obj/item/weapon/stock_parts/matter_bin,\
				prob(6);/obj/item/weapon/stock_parts/matter_bin/adv,\
				prob(15);/obj/item/weapon/stock_parts/micro_laser,\
				prob(3);/obj/item/weapon/stock_parts/micro_laser/high,\
				prob(15);/obj/item/weapon/stock_parts/scanning_module,\
				prob(3);/obj/item/weapon/stock_parts/scanning_module/adv,\
				prob(3);/obj/item/weapon/stock_parts/subspace/amplifier,\
				prob(3);/obj/item/weapon/stock_parts/subspace/analyzer,\
				prob(3);/obj/item/weapon/stock_parts/subspace/ansible,\
				prob(3);/obj/item/weapon/stock_parts/subspace/crystal,\
				prob(3);/obj/item/weapon/stock_parts/subspace/filter,\
				prob(3);/obj/item/weapon/stock_parts/subspace/transmitter,\
				prob(3);/obj/item/weapon/stock_parts/subspace/treatment,\
				prob(3);/obj/item/weapon/disk/autolathe_disk/basic,\
				prob(3);/obj/item/weapon/disk/autolathe_disk/devices,\
				prob(3);/obj/item/weapon/disk/autolathe_disk/toolpack,\
				prob(3);/obj/item/weapon/disk/autolathe_disk/component,\
				prob(2);/obj/item/weapon/disk/autolathe_disk/advtoolpack,\
				prob(2);/obj/item/weapon/disk/autolathe_disk/circuitpack,\
				prob(2);/obj/item/weapon/disk/autolathe_disk/medical,\
				prob(2);/obj/item/weapon/disk/autolathe_disk/fs_cheap_guns,\
				prob(1);/obj/item/weapon/disk/autolathe_disk/fs_kinetic_guns,\
				prob(1);/obj/item/weapon/disk/autolathe_disk/fs_energy_guns,\
				prob(1);/obj/item/weapon/disk/autolathe_disk/nt_old_guns,\
				prob(1);/obj/item/weapon/disk/autolathe_disk/nt_new_guns,\
				prob(3);/obj/item/weapon/disk/autolathe_disk/nonlethal_ammo,\
				prob(2);/obj/item/weapon/disk/autolathe_disk/lethal_ammo)

/obj/random/techpart/low_chance
	name = "low chance random techpart"
	icon_state = "tech-orange-low"
	spawn_nothing_percentage = 60
