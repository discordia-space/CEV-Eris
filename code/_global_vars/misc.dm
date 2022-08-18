GLOBAL_LIST_EMPTY(all_observable_events)

//see proc/get_average_color()
GLOBAL_LIST_EMPTY(average_icon_color)

//see getFlatTypeIcon()
GLOBAL_LIST_EMPTY(initialTypeIcon)

GLOBAL_DATUM(lobbyScreen, /datum/lobbyscreen)

// WORLD TOPIC CACHING //
GLOBAL_VAR(topic_status_lastcache)
GLOBAL_LIST(topic_status_cache)

GLOBAL_LIST_INIT(custom_kits, list(
	"Example OneStar bag of holding" = list(
		/obj/item/storage/backpack/holding,
		/obj/item/clothing/under/onestar,
		/obj/item/clothing/suit/storage/greatcoat/onestar,
		/obj/item/clothing/head/onestar,
		/obj/item/tank/onestar_regenerator,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/glasses/powered/thermal/onestar,
		/obj/item/gun/projectile/type_47,
		/obj/item/ammo_magazine/ihclrifle,
		/obj/item/ammo_magazine/ihclrifle,
		/obj/item/ammo_magazine/ihclrifle)))

// LOGGING  MOVE ME //
GLOBAL_VAR(log_directory)
GLOBAL_PROTECT(log_directory)
