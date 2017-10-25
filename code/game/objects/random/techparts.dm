/obj/random/techpart
	name = "random techpart"
	icon_state = "tech-orange"

/obj/random/techpart/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/computer_hardware/battery_module,\
				prob(1);/obj/item/weapon/computer_hardware/battery_module/advanced,\
				prob(3);/obj/item/weapon/computer_hardware/card_slot,\
				prob(3);/obj/item/weapon/computer_hardware/hard_drive,\
				prob(1);/obj/item/weapon/computer_hardware/hard_drive/advanced,\
				prob(3);/obj/item/weapon/computer_hardware/network_card,\
				prob(1);/obj/item/weapon/computer_hardware/network_card/advanced,\
				prob(3);/obj/item/weapon/computer_hardware/processor_unit,\
				prob(3);/obj/item/weapon/computer_hardware/processor_unit/small,\
				prob(1);/obj/item/weapon/computer_hardware/processor_unit/photonic,\
				prob(3);/obj/item/weapon/computer_hardware/tesla_link,\
				prob(5);/obj/item/weapon/stock_parts/console_screen,\
				prob(5);/obj/item/weapon/stock_parts/capacitor,\
				prob(1);/obj/item/weapon/stock_parts/capacitor/adv,\
				prob(5);/obj/item/weapon/stock_parts/manipulator,\
				prob(1);/obj/item/weapon/stock_parts/manipulator/nano,\
				prob(8);/obj/item/weapon/stock_parts/matter_bin,\
				prob(2);/obj/item/weapon/stock_parts/matter_bin/adv,\
				prob(5);/obj/item/weapon/stock_parts/micro_laser,\
				prob(1);/obj/item/weapon/stock_parts/micro_laser/high,\
				prob(5);/obj/item/weapon/stock_parts/scanning_module,\
				prob(1);/obj/item/weapon/stock_parts/scanning_module/adv,\
				prob(1);/obj/item/weapon/stock_parts/subspace/amplifier,\
				prob(1);/obj/item/weapon/stock_parts/subspace/analyzer,\
				prob(1);/obj/item/weapon/stock_parts/subspace/ansible,\
				prob(1);/obj/item/weapon/stock_parts/subspace/crystal,\
				prob(1);/obj/item/weapon/stock_parts/subspace/filter,\
				prob(1);/obj/item/weapon/stock_parts/subspace/transmitter,\
				prob(1);/obj/item/weapon/stock_parts/subspace/treatment)

/obj/random/techpart/low_chance
	name = "low chance random techpart"
	icon_state = "tech-orange-low"
	spawn_nothing_percentage = 60
