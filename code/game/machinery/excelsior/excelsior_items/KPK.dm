/obj/item/centor_kpk
	name = "\improper Excelsior KOMPAK"
	desc = "Comrade's second best friend, besides their first best friend."
	icon = 'icons/obj/modular_tablet.dmi' 				//get new
	icon_state = "tabletsol" 							//get new
	opacity = 0
	density = FALSE
	anchored = FALSE
	w_class = ITEM_SIZE_NORMAL

/obj/item/centor_kpk/attack_self(mob/user)
	. = ..()
	nano_ui_interact(user)

/obj/item/centor_kpk/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	//var/list/data = nano_ui_data()
	var/list/data = list()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "excelsior_kpk.tmpl", name, 450, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/item/centor_kpk/Topic(href, href_list)
	if(href_list["give_candy"])
		give_candy(usr)

	add_fingerprint(usr)
	return TOPIC_HANDLED // update UIs attached to this object

/obj/item/centor_kpk/proc/give_candy(mob/living/user)
	var/obj/item/reagent_containers/food/snacks/candy_corn = new /obj/item/reagent_containers/food/snacks/candy_corn()
	user.put_in_inactive_hand(candy_corn)
