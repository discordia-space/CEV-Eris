/obj/random/circuitboard
	name = "random circuitboard"
	icon_state = "tech-blue"

/obj/random/circuitboard/item_to_spawn()
	return pick(prob(8);/obj/item/weapon/circuitboard/autolathe,\
				prob(1);/obj/item/weapon/circuitboard/aifixer,\
				prob(1);/obj/item/weapon/circuitboard/air_management,\
				prob(3);/obj/item/weapon/circuitboard/arcade/battle,\
				prob(1);/obj/item/weapon/circuitboard/area_atmos,\
				prob(3);/obj/item/weapon/circuitboard/atmos_alert,\
				prob(1);/obj/item/weapon/circuitboard/atmoscontrol,\
				prob(3);/obj/item/weapon/circuitboard/biogenerator,\
				prob(1);/obj/item/weapon/circuitboard/bluespacerelay,\
				prob(4);/obj/item/weapon/circuitboard/broken,\
				prob(2);/obj/item/weapon/circuitboard/circuit_imprinter,\
				prob(1);/obj/item/weapon/circuitboard/comm_monitor,\
				prob(1);/obj/item/weapon/circuitboard/comm_server,\
				prob(1);/obj/item/weapon/circuitboard/comm_traffic,\
				prob(2);/obj/item/weapon/circuitboard/communications,\
				prob(2);/obj/item/weapon/circuitboard/crew,\
				prob(1);/obj/item/weapon/circuitboard/curefab,\
				prob(2);/obj/item/weapon/circuitboard/destructive_analyzer,\
				prob(2);/obj/item/weapon/circuitboard/drone_control,\
				prob(2);/obj/item/weapon/circuitboard/mech_recharger,\
				prob(1);/obj/item/weapon/circuitboard/mecha/ripley/main,\
				prob(1);/obj/item/weapon/circuitboard/mecha/ripley/peripherals,\
				prob(2);/obj/item/weapon/circuitboard/mecha_control,\
				prob(2);/obj/item/weapon/circuitboard/mechfab,\
				prob(2);/obj/item/weapon/circuitboard/med_data,\
				prob(1);/obj/item/weapon/circuitboard/message_monitor,\
				prob(1);/obj/item/weapon/circuitboard/neotheology/biocan,\
				prob(1);/obj/item/weapon/circuitboard/neotheology/cloner,\
				prob(1);/obj/item/weapon/circuitboard/neotheology/reader,\
				prob(1);/obj/item/weapon/circuitboard/ntnet_relay,\
				prob(2);/obj/item/weapon/circuitboard/operating,\
				prob(1);/obj/item/weapon/circuitboard/ordercomp,\
				prob(4);/obj/item/weapon/circuitboard/pacman,\
				prob(2);/obj/item/weapon/circuitboard/powermonitor,\
				prob(2);/obj/item/weapon/circuitboard/protolathe,\
				prob(2);/obj/item/weapon/circuitboard/rcon_console,\
				prob(2);/obj/item/weapon/circuitboard/rdconsole,\
				prob(2);/obj/item/weapon/circuitboard/rdserver,\
				prob(2);/obj/item/weapon/circuitboard/rdservercontrol,\
				prob(2);/obj/item/weapon/circuitboard/recharge_station,\
				prob(1);/obj/item/weapon/circuitboard/robotics,\
				prob(3);/obj/item/weapon/circuitboard/security,\
				prob(2);/obj/item/weapon/circuitboard/smes,\
				prob(1);/obj/item/weapon/circuitboard/solar_control,\
				prob(1);/obj/item/weapon/circuitboard/splicer,\
				prob(2);/obj/item/weapon/circuitboard/stationalert,\
				prob(1);/obj/item/weapon/aiModule/reset,\
				prob(1);/obj/item/weapon/circuitboard/teleporter,\
				prob(1);/obj/item/weapon/circuitboard/telecomms/broadcaster,\
				prob(1);/obj/item/weapon/circuitboard/telecomms/bus,\
				prob(1);/obj/item/weapon/circuitboard/telecomms/hub,\
				prob(1);/obj/item/weapon/circuitboard/telecomms/processor,\
				prob(1);/obj/item/weapon/circuitboard/telecomms/receiver,\
				prob(1);/obj/item/weapon/circuitboard/telecomms/relay,\
				prob(1);/obj/item/weapon/circuitboard/telecomms/server,\
				prob(1);/obj/item/weapon/airalarm_electronics,\
				prob(1);/obj/item/weapon/airlock_electronics,)

/obj/random/circuitboard/low_chance
	name = "low chance random circuitboard"
	icon_state = "tech-blue-low"
	spawn_nothing_percentage = 60
