/* Stack type objects!
 * Contains:
 * 		Stacks
 * 		Recipe datum
 * 		Recipe list datum
 */

/*
 * Stacks
 */

/obj/item/stack
	icon = 'icons/obj/stack/items.dmi'
	gender = PLURAL
	origin_tech = list(TECH_MATERIAL = 1)
	bad_type = /obj/item/stack
	var/list/datum/stack_recipe/recipes
	var/singular_name
	var/amount = 1
	var/max_amount //also see stack recipes initialisation, param "max_res_amount" must be equal to this max_amount
	var/stacktype //determines whether different stack types can merge
	var/build_type //used when directly applied to a turf
	var/uses_charge = 0
	var/list/charge_costs
	var/list/datum/matter_synth/synths
	var/consumable = TRUE	// Will the stack disappear entirely once the amount is used up?
	var/splittable = TRUE	// Is the stack capable of being splitted?
	var/novariants = TRUE //Determines whether the item should update it's sprites based on amount.

	//If either of these two are set to nonzero values, the stack will have randomised quantity on spawn
	//Used for the /random subtypes of material stacks. any stack works
	var/rand_min = 0
	var/rand_max = 0




/obj/item/stack/New(var/loc, var/amount=null)
	.=..()
	if (amount)
		src.amount = amount

/obj/item/stack/Initialize()
	.=..()
	if (!stacktype)
		stacktype = type

	if (rand_min || rand_max)
		amount = rand(rand_min, rand_max)
		amount = round(amount, 1) //Just in case
	update_icon()

/obj/item/stack/on_update_icon()
	if(novariants)
		return ..()
	if(amount <= (max_amount * (1/3)))
		icon_state = initial(icon_state)
	else if (amount <= (max_amount * (2/3)))
		icon_state = "[initial(icon_state)]_2"
	else
		icon_state = "[initial(icon_state)]_3"
	..()

/obj/item/stack/Destroy()
	if (synths)
		synths.Cut() //Preventing runtimes
	//if(uses_charge)
		//return 1
	if (src && usr && usr.machine == src)
		usr << browse(null, "window=stack")


	return ..()

/obj/item/stack/examine(mob/user)
	if(..(user, 1))
		if(!uses_charge)
			to_chat(user, "There [src.amount == 1 ? "is" : "are"] [src.amount] [src.singular_name]\s in the stack.")
		else
			to_chat(user, "There is enough charge for [get_amount()].")

/obj/item/stack/attack_self(mob/user as mob)
	list_recipes(user)

/obj/item/stack/proc/list_recipes(mob/user as mob, recipes_sublist)
	if (!recipes)
		return
	if (!src || get_amount() <= 0)
		user << browse(null, "window=stack")
	user.set_machine(src) //for correct work of onclose
	var/list/recipe_list = recipes
	if (recipes_sublist && recipe_list[recipes_sublist] && istype(recipe_list[recipes_sublist], /datum/stack_recipe_list))
		var/datum/stack_recipe_list/srl = recipe_list[recipes_sublist]
		recipe_list = srl.recipes
	var/t1 = text("<HTML><HEAD><title>Constructions from []</title></HEAD><body><TT>Amount Left: []<br>", src, src.get_amount())
	for(var/i=1;i<=recipe_list.len,i++)
		var/E = recipe_list[i]
		if (isnull(E))
			t1 += "<hr>"
			continue

		if (i>1 && !isnull(recipe_list[i-1]))
			t1+="<br>"

		if (istype(E, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/srl = E
			t1 += "<a href='?src=\ref[src];sublist=[i]'>[srl.title]</a>"

		if (istype(E, /datum/stack_recipe))
			var/datum/stack_recipe/R = E
			var/max_multiplier = round(src.get_amount() / R.req_amount)
			var/title
			var/can_build = 1
			can_build = can_build && (max_multiplier>0)
			if (R.res_amount>1)
				title+= "[R.res_amount]x [R.title]\s"
			else
				title+= "[R.title]"
			title+= " ([R.req_amount] [src.singular_name]\s)"
			if (can_build)
				t1 += text("<A href='?src=\ref[src];sublist=[recipes_sublist];make=[i];multiplier=1'>[title]</A>  ")
			else
				t1 += text("[]", title)
				continue
			if (R.max_res_amount>1 && max_multiplier>1)
				max_multiplier = min(max_multiplier, round(R.max_res_amount/R.res_amount))
				t1 += " |"
				var/list/multipliers = list(5,10,25)
				for (var/n in multipliers)
					if (max_multiplier>=n)
						t1 += " <A href='?src=\ref[src];make=[i];multiplier=[n]'>[n*R.res_amount]x</A>"
				if (!(max_multiplier in multipliers))
					t1 += " <A href='?src=\ref[src];make=[i];multiplier=[max_multiplier]'>[max_multiplier*R.res_amount]x</A>"

	t1 += "</TT></body></HTML>"
	user << browse(t1, "window=stack")
	onclose(user, "stack")
	return

/obj/item/stack/proc/produce_recipe(datum/stack_recipe/recipe, var/quantity, mob/user)
	var/required = quantity*recipe.req_amount
	var/produced = min(quantity*recipe.res_amount, recipe.max_res_amount)

	if (!can_use(required))
		if (produced>1)
			to_chat(user, SPAN_WARNING("You haven't got enough [src] to build \the [produced] [recipe.title]\s!"))
		else
			to_chat(user, SPAN_WARNING("You haven't got enough [src] to build \the [recipe.title]!"))
		return

	if (recipe.one_per_turf && (locate(recipe.result_type) in user.loc))
		to_chat(user, SPAN_WARNING("There is another [recipe.title] here!"))
		return

	if (recipe.on_floor && !isfloor(user.loc))
		to_chat(user, SPAN_WARNING("\The [recipe.title] must be constructed on the floor!"))
		return

	if (recipe.time)
		to_chat(user, SPAN_NOTICE("Building [recipe.title] ..."))
		if (!do_after(user, recipe.time, user))
			return

	if (use(required))
		var/atom/O
		if(recipe.use_material)
			O = new recipe.result_type(user.loc, recipe.use_material)
		else
			O = new recipe.result_type(user.loc)
		O.set_dir(user.dir)
		O.add_fingerprint(user)

		if (istype(O, /obj/item/stack))
			var/obj/item/stack/S = O
			S.amount = produced
			S.add_to_stacks(user)

		if (istype(O, /obj/item/storage)) //BubbleWrap - so newly formed boxes are empty
			for (var/obj/item/I in O)
				qdel(I)

/obj/item/stack/Topic(href, href_list)
	..()
	if ((usr.restrained() || usr.stat || usr.get_active_hand() != src))
		return

	if (href_list["sublist"] && !href_list["make"])
		list_recipes(usr, text2num(href_list["sublist"]))

	if (href_list["make"])
		if (src.get_amount() < 1) qdel(src) //Never should happen

		var/list/recipes_list = recipes
		if (href_list["sublist"])
			var/datum/stack_recipe_list/srl = recipes_list[text2num(href_list["sublist"])]
			recipes_list = srl.recipes

		var/datum/stack_recipe/R = recipes_list[text2num(href_list["make"])]
		var/multiplier = text2num(href_list["multiplier"])
		if (!multiplier || (multiplier <= 0)) //href exploit protection
			return

		src.produce_recipe(R, multiplier, usr)

	if (src && usr.machine==src) //do not reopen closed window
		spawn( 0 )
			src.interact(usr)
			return
	return

//Return 1 if an immediate subsequent call to use() would succeed.
//Ensures that code dealing with stacks uses the same logic
/obj/item/stack/proc/can_use(var/used)
	if (get_amount() < used)
		return 0
	return 1

/obj/item/stack/proc/use(var/used)
	if (!can_use(used))
		return 0
	if(!uses_charge)
		amount -= used
		if (amount <= 0 && consumable)	// Only proceed with deletion if the item is supposed to disappear entirely after being used up
			if(usr)
				usr.remove_from_mob(src)
			qdel(src) //should be safe to qdel immediately since if someone is still using this stack it will persist for a little while longer
		update_icon()
		return 1
	else
		if(get_amount() < used)
			return 0
		for(var/i = 1 to charge_costs.len)
			var/datum/matter_synth/S = synths[i]
			S.use_charge(charge_costs[i] * used) // Doesn't need to be deleted
		return 1

/obj/item/stack/proc/add(var/extra)
	if(!uses_charge)
		if(amount + extra > get_max_amount())
			return 0
		else
			amount += extra
		update_icon()
		return 1
	else if(!synths || synths.len < uses_charge)
		return 0
	else
		for(var/i = 1 to uses_charge)
			var/datum/matter_synth/S = synths[i]
			S.add_charge(charge_costs[i] * extra)

/*
	The transfer and split procs work differently than use() and add().
	Whereas those procs take no action if the desired amount cannot be added or removed these procs will try to transfer whatever they can.
	They also remove an equal amount from the source stack.
*/

//attempts to transfer amount to S, and returns the amount actually transferred
/obj/item/stack/proc/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	if (!get_amount())
		return 0
	if ((stacktype != S.stacktype) && !type_verified)
		return 0
	if (isnull(tamount))
		tamount = src.get_amount()

	var/transfer = max(min(tamount, src.get_amount(), (S.get_max_amount() - S.get_amount())), 0)

	var/orig_amount = src.get_amount()
	if (transfer && src.use(transfer))
		S.add(transfer)
		if (prob(transfer/orig_amount * 100))
			transfer_fingerprints_to(S)
			if(blood_DNA)
				S.blood_DNA |= blood_DNA
		return transfer
	return 0

//creates a new stack with the specified amount
/obj/item/stack/proc/split(var/tamount)
	if (!splittable)
		return null
	if (!amount)
		return null
	if(uses_charge)
		return null

	var/transfer = max(min(tamount, src.amount, initial(max_amount)), 0)

	var/orig_amount = src.amount
	if (transfer && src.use(transfer))
		var/obj/item/stack/newstack = new src.type(loc, transfer)
		newstack.color = color
		if (prob(transfer/orig_amount * 100))
			transfer_fingerprints_to(newstack)
			if(blood_DNA)
				newstack.blood_DNA |= blood_DNA
		return newstack
	return null

/obj/item/stack/proc/get_amount()
	if(uses_charge)
		if(!synths || synths.len < uses_charge)
			return 0
		var/datum/matter_synth/S = synths[1]
		. = round(S.get_charge() / charge_costs[1])
		if(charge_costs.len > 1)
			for(var/i = 2 to charge_costs.len)
				S = synths[i]
				. = min(., round(S.get_charge() / charge_costs[i]))
		return
	return amount

/obj/item/stack/proc/get_max_amount()
	if(uses_charge)
		if(!synths || synths.len < uses_charge)
			return 0
		var/datum/matter_synth/S = synths[1]
		. = round(S.max_energy / charge_costs[1])
		if(uses_charge > 1)
			for(var/i = 2 to uses_charge)
				S = synths[i]
				. = min(., round(S.max_energy / charge_costs[i]))
		return
	return max_amount

/obj/item/stack/proc/add_to_stacks(mob/user as mob)
	for (var/obj/item/stack/item in user.loc)
		if (item==src)
			continue
		var/transfer = src.transfer_to(item)
		if (transfer)
			to_chat(user, SPAN_NOTICE("You add a new [item.singular_name] to the stack. It now contains [item.amount] [item.singular_name]\s."))
		if(!amount)
			break

/obj/item/stack/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/obj/item/stack/F = src.split(1)
		if (F)
			user.put_in_hands(F)
			src.add_fingerprint(user)
			F.add_fingerprint(user)
			spawn(0)
				if (src && usr.machine==src)
					src.interact(usr)
	else
		..()
	return

/obj/item/stack/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/S = W
		if (user.get_inactive_hand()==src)
			src.transfer_to(S, 1)
		else
			src.transfer_to(S)

		spawn(0) //give the stacks a chance to delete themselves if necessary
			if (S && usr.machine==S)
				S.interact(usr)
			if (src && usr.machine==src)
				src.interact(usr)
	else
		return ..()

//Verb to split stacks
/obj/item/stack/verb/split_verb()
	set src in view(1)
	set name = "Split"
	set category = "Object"

	if (!usr.IsAdvancedToolUser())
		return



	var/quantity = input(usr,
	"This stack contains [amount]/[max_amount]. How many would you like to split off into a new stack?\n\
	The new stack will be put into your hands if possible", "Split Stack", round(amount * 0.5)) as null|num

	if (!Adjacent(usr))
		to_chat(usr, SPAN_WARNING("You need to be in arm's reach for that!"))
		return

	if (usr.incapacitated())
		return

	if (!isnum(quantity) || quantity < 1)
		return

	var/obj/item/stack/S = split(round(quantity, 1))
	if (istype(S))
		//Try to put the new stack into the user's hands
		if (!(usr.put_in_hands(S)))
			//If that fails, leave it beside the original stack
			S.forceMove(get_turf(src))


/*
 * Recipe datum
 */
/datum/stack_recipe
	var/title = "ERROR"
	var/result_type
	var/req_amount = 1 //amount of material needed for this recipe
	var/res_amount = 1 //amount of stuff that is produced in one batch (e.g. 4 for floor tiles)
	var/max_res_amount = 1
	var/time = 0
	var/one_per_turf = 0
	var/on_floor = 0
	var/use_material

	New(title, result_type, req_amount = 1, res_amount = 1, max_res_amount = 1, time = 0, one_per_turf = 0, on_floor = 0, supplied_material = null)
		src.title = title
		src.result_type = result_type
		src.req_amount = req_amount
		src.res_amount = res_amount
		src.max_res_amount = max_res_amount
		src.time = time
		src.one_per_turf = one_per_turf
		src.on_floor = on_floor
		src.use_material = supplied_material

/*
 * Recipe list datum
 */
/datum/stack_recipe_list
	var/title = "ERROR"
	var/list/recipes = null
	New(title, recipes)
		src.title = title
		src.recipes = recipes



