/obj/item/weapon/electronics
	spawn_tags = SPAWN_TAG_ELECTRONICS
	spawn_blacklisted = FALSE
	rarity_value = 10
	spawn_frequency = 10

/obj/spawner/electronics
	name = "random electronics"
	icon_state = "tech-blue"
	tags_to_spawn = list(SPAWN_ELECTRONICS)

/obj/random/circuitboard
	name = "random circuitboard"
	icon_state = "tech-blue"

/obj/random/circuitboard/item_to_spawn()
	return pickweight(list(/obj/random/pack/rare = 1,
				/obj/item/weapon/electronics/circuitboard/autolathe = 8,
				/obj/item/weapon/electronics/circuitboard/aifixer = 1,
				/obj/item/weapon/electronics/circuitboard/air_management = 1,
				/obj/item/weapon/electronics/circuitboard/arcade/battle = 3,
				/obj/item/weapon/electronics/circuitboard/area_atmos = 1,
				/obj/item/weapon/electronics/circuitboard/atmos_alert = 3,
				/obj/item/weapon/electronics/circuitboard/atmoscontrol = 1,
				/obj/item/weapon/electronics/circuitboard/biogenerator = 3,
				/obj/item/weapon/electronics/circuitboard/bluespacerelay = 1,
				/obj/item/weapon/electronics/circuitboard/broken = 4,
				/obj/item/weapon/electronics/circuitboard/circuit_imprinter = 2,
				/obj/item/weapon/electronics/circuitboard/comm_monitor = 1,
				/obj/item/weapon/electronics/circuitboard/comm_server = 1,
				/obj/item/weapon/electronics/circuitboard/communications = 2,
				/obj/item/weapon/electronics/circuitboard/curefab = 1,
				/obj/item/weapon/electronics/circuitboard/destructive_analyzer = 2,
				/obj/item/weapon/electronics/circuitboard/drone_control = 2,
				/obj/item/weapon/electronics/circuitboard/industrial_grinder = 4,
				/obj/item/weapon/electronics/circuitboard/mech_recharger = 2,
				/obj/item/weapon/electronics/circuitboard/mechfab = 2,
				/obj/item/weapon/electronics/circuitboard/med_data = 2,
				/obj/item/weapon/electronics/circuitboard/message_monitor = 1,
				/obj/item/weapon/electronics/circuitboard/neotheology/biocan = 1,
				/obj/item/weapon/electronics/circuitboard/neotheology/cloner = 1,
				/obj/item/weapon/electronics/circuitboard/neotheology/reader = 1,
				/obj/item/weapon/electronics/circuitboard/ntnet_relay = 1,
				/obj/item/weapon/electronics/circuitboard/operating = 2,
				/obj/item/weapon/electronics/circuitboard/ordercomp = 1,
				/obj/item/weapon/electronics/circuitboard/pacman = 4,
				/obj/item/weapon/electronics/circuitboard/powermonitor = 2,
				/obj/item/weapon/electronics/circuitboard/protolathe = 2,
				/obj/item/weapon/electronics/circuitboard/rdconsole = 2,
				/obj/item/weapon/electronics/circuitboard/rdserver = 2,
				/obj/item/weapon/electronics/circuitboard/rdservercontrol = 2,
				/obj/item/weapon/electronics/circuitboard/recharge_station = 2,
				/obj/item/weapon/electronics/circuitboard/repair_station = 2,
				/obj/item/weapon/electronics/circuitboard/robotics = 1,
				/obj/item/weapon/electronics/circuitboard/smes = 2,
				/obj/item/weapon/electronics/circuitboard/solar_control = 1,
				/obj/item/weapon/electronics/circuitboard/splicer = 1,
				/obj/item/weapon/electronics/circuitboard/stationalert = 2,
				/obj/item/weapon/electronics/ai_module/reset = 1,
				/obj/item/weapon/electronics/circuitboard/teleporter = 1,
				/obj/item/weapon/electronics/circuitboard/telecomms/broadcaster = 1,
				/obj/item/weapon/electronics/circuitboard/telecomms/bus = 1,
				/obj/item/weapon/electronics/circuitboard/telecomms/hub = 1,
				/obj/item/weapon/electronics/circuitboard/telecomms/processor = 1,
				/obj/item/weapon/electronics/circuitboard/telecomms/receiver = 1,
				/obj/item/weapon/electronics/circuitboard/telecomms/relay = 1,
				/obj/item/weapon/electronics/circuitboard/telecomms/server = 1,
				/obj/spawner/electronics = 2,))

/obj/random/circuitboard/low_chance
	name = "low chance random circuitboard"
	icon_state = "tech-blue-low"
	spawn_nothing_percentage = 60
