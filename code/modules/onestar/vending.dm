/obj/machinery/vending/one_star
	name = "One Star Vendor"
	desc = "A vendor of the One Star variety."
	icon = 'icons/obj/machines/one_star/vending.dmi'
	icon_state = "vendor_guns"
	icon_vend = "vendor_printing"
	spawn_tags = SPAWN_TAG_OS_VENDOR
	spawn_blacklisted = TRUE
	bad_type = /obj/machinery/vending/one_star
	//product_slogans = "Usually no carcinogens!;Best sports!;Become the strongest!"
	//product_ads = "Strength!;Cheap!;There are contraindications, it is recommended to consult a medical specialist."
	vendor_department = DEPARTMENT_OFFSHIP
	alt_currency_path = /obj/item/stack/os_cash

/obj/machinery/vending/one_star/Initialize()
	. = ..()
	set_light(1.4, 1, COLOR_LIGHTING_CYAN_BRIGHT)
	earnings_account = department_accounts[DEPARTMENT_OFFSHIP]

/obj/machinery/vending/one_star/guns
	desc = "A vendor of the One Star variety. This one sells firearms of the One Star variety."
	icon_state = "vendor_guns"

	products = list(
		/obj/item/gun/projectile/type_62 = 5,
		/obj/item/gun/projectile/type_90 = 5,
		/obj/item/gun/projectile/shotgun/type_21 = 5,
		/obj/item/gun/projectile/automatic/type_17 = 5,
		/obj/item/gun/projectile/type_47 = 5
		)

	prices = list(
		/obj/item/gun/projectile/type_62 = 270,
		/obj/item/gun/projectile/type_90 = 390,
		/obj/item/gun/projectile/shotgun/type_21 = 330,
		/obj/item/gun/projectile/automatic/type_17 = 380,
		/obj/item/gun/projectile/type_47 = 290
		)

/obj/machinery/vending/one_star/food
	desc = "A vendor of the One Star variety. This one sells food of the One Star variety."
	icon_state = "vendor_food"

/obj/machinery/vending/one_star/health
	desc = "A vendor of the One Star variety. This one sells medical paraphernalia of the One Star variety."
	icon_state = "vendor_health"
