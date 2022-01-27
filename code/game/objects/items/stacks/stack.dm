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
	69ender = PLURAL
	ori69in_tech = list(TECH_MATERIAL = 1)
	bad_type = /obj/item/stack
	var/list/datum/stack_recipe/recipes
	var/sin69ular_name
	var/amount = 1
	var/max_amount //also see stack recipes initialisation, param "max_res_amount"69ust be e69ual to this69ax_amount
	var/stacktype //determines whether different stack types can69er69e
	var/build_type //used when directly applied to a turf
	var/uses_char69e = 0
	var/list/char69e_costs
	var/list/datum/matter_synth/synths
	var/consumable = TRUE	// Will the stack disappear entirely once the amount is used up?
	var/splittable = TRUE	// Is the stack capable of bein69 splitted?
	var/novariants = TRUE //Determines whether the item should update it's sprites based on amount.

	//If either of these two are set to nonzero69alues, the stack will have randomised 69uantity on spawn
	//Used for the /random subtypes of69aterial stacks. any stack works
	var/rand_min = 0
	var/rand_max = 0




/obj/item/stack/New(var/loc,69ar/amount=null)
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

/obj/item/stack/update_icon()
	if(novariants)
		return ..()
	if(amount <= (max_amount * (1/3)))
		icon_state = initial(icon_state)
	else if (amount <= (max_amount * (2/3)))
		icon_state = "69initial(icon_state)69_2"
	else
		icon_state = "69initial(icon_state)69_3"
	..()

/obj/item/stack/Destroy()
	if (synths)
		synths.Cut() //Preventin69 runtimes
	//if(uses_char69e)
		//return 1
	if (src && usr && usr.machine == src)
		usr << browse(null, "window=stack")


	return ..()

/obj/item/stack/examine(mob/user)
	if(..(user, 1))
		if(!uses_char69e)
			to_chat(user, "There 69src.amount == 1 ? "is" : "are"69 69src.amount69 69src.sin69ular_name69\s in the stack.")
		else
			to_chat(user, "There is enou69h char69e for 6969et_amount()69.")

/obj/item/stack/attack_self(mob/user as69ob)
	list_recipes(user)

/obj/item/stack/proc/list_recipes(mob/user as69ob, recipes_sublist)
	if (!recipes)
		return
	if (!src || 69et_amount() <= 0)
		user << browse(null, "window=stack")
	user.set_machine(src) //for correct work of onclose
	var/list/recipe_list = recipes
	if (recipes_sublist && recipe_list69recipes_sublist69 && istype(recipe_list69recipes_sublist69, /datum/stack_recipe_list))
		var/datum/stack_recipe_list/srl = recipe_list69recipes_sublist69
		recipe_list = srl.recipes
	var/t1 = text("<HTML><HEAD><title>Constructions from 6969</title></HEAD><body><TT>Amount Left: 6969<br>", src, src.69et_amount())
	for(var/i=1;i<=recipe_list.len,i++)
		var/E = recipe_list69i69
		if (isnull(E))
			t1 += "<hr>"
			continue

		if (i>1 && !isnull(recipe_list69i-169))
			t1+="<br>"

		if (istype(E, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/srl = E
			t1 += "<a href='?src=\ref69src69;sublist=69i69'>69srl.title69</a>"

		if (istype(E, /datum/stack_recipe))
			var/datum/stack_recipe/R = E
			var/max_multiplier = round(src.69et_amount() / R.re69_amount)
			var/title
			var/can_build = 1
			can_build = can_build && (max_multiplier>0)
			if (R.res_amount>1)
				title+= "69R.res_amount69x 69R.title69\s"
			else
				title+= "69R.title69"
			title+= " (69R.re69_amount69 69src.sin69ular_name69\s)"
			if (can_build)
				t1 += text("<A href='?src=\ref69src69;sublist=69recipes_sublist69;make=69i69;multiplier=1'>69title69</A>  ")
			else
				t1 += text("6969", title)
				continue
			if (R.max_res_amount>1 &&69ax_multiplier>1)
				max_multiplier =69in(max_multiplier, round(R.max_res_amount/R.res_amount))
				t1 += " |"
				var/list/multipliers = list(5,10,25)
				for (var/n in69ultipliers)
					if (max_multiplier>=n)
						t1 += " <A href='?src=\ref69src69;make=69i69;multiplier=69n69'>69n*R.res_amount69x</A>"
				if (!(max_multiplier in69ultipliers))
					t1 += " <A href='?src=\ref69src69;make=69i69;multiplier=69max_multiplier69'>69max_multiplier*R.res_amount69x</A>"

	t1 += "</TT></body></HTML>"
	user << browse(t1, "window=stack")
	onclose(user, "stack")
	return

/obj/item/stack/proc/produce_recipe(datum/stack_recipe/recipe,69ar/69uantity,69ob/user)
	var/re69uired = 69uantity*recipe.re69_amount
	var/produced =69in(69uantity*recipe.res_amount, recipe.max_res_amount)

	if (!can_use(re69uired))
		if (produced>1)
			to_chat(user, SPAN_WARNIN69("You haven't 69ot enou69h 69src69 to build \the 69produced69 69recipe.title69\s!"))
		else
			to_chat(user, SPAN_WARNIN69("You haven't 69ot enou69h 69src69 to build \the 69recipe.title69!"))
		return

	if (recipe.one_per_turf && (locate(recipe.result_type) in user.loc))
		to_chat(user, SPAN_WARNIN69("There is another 69recipe.title69 here!"))
		return

	if (recipe.on_floor && !isfloor(user.loc))
		to_chat(user, SPAN_WARNIN69("\The 69recipe.title6969ust be constructed on the floor!"))
		return

	if (recipe.time)
		to_chat(user, SPAN_NOTICE("Buildin69 69recipe.title69 ..."))
		if (!do_after(user, recipe.time, user))
			return

	if (use(re69uired))
		var/atom/O
		if(recipe.use_material)
			O = new recipe.result_type(user.loc, recipe.use_material)
		else
			O = new recipe.result_type(user.loc)
		O.set_dir(user.dir)
		O.add_fin69erprint(user)

		if (istype(O, /obj/item/stack))
			var/obj/item/stack/S = O
			S.amount = produced
			S.add_to_stacks(user)

		if (istype(O, /obj/item/stora69e)) //BubbleWrap - so newly formed boxes are empty
			for (var/obj/item/I in O)
				69del(I)

/obj/item/stack/Topic(href, href_list)
	..()
	if ((usr.restrained() || usr.stat || usr.69et_active_hand() != src))
		return

	if (href_list69"sublist"69 && !href_list69"make"69)
		list_recipes(usr, text2num(href_list69"sublist"69))

	if (href_list69"make"69)
		if (src.69et_amount() < 1) 69del(src) //Never should happen

		var/list/recipes_list = recipes
		if (href_list69"sublist"69)
			var/datum/stack_recipe_list/srl = recipes_list69text2num(href_list69"sublist"69)69
			recipes_list = srl.recipes

		var/datum/stack_recipe/R = recipes_list69text2num(href_list69"make"69)69
		var/multiplier = text2num(href_list69"multiplier"69)
		if (!multiplier || (multiplier <= 0)) //href exploit protection
			return

		src.produce_recipe(R,69ultiplier, usr)

	if (src && usr.machine==src) //do not reopen closed window
		spawn( 0 )
			src.interact(usr)
			return
	return

//Return 1 if an immediate subse69uent call to use() would succeed.
//Ensures that code dealin69 with stacks uses the same lo69ic
/obj/item/stack/proc/can_use(var/used)
	if (69et_amount() < used)
		return 0
	return 1

/obj/item/stack/proc/use(var/used)
	if (!can_use(used))
		return 0
	if(!uses_char69e)
		amount -= used
		if (amount <= 0 && consumable)	// Only proceed with deletion if the item is supposed to disappear entirely after bein69 used up
			if(usr)
				usr.remove_from_mob(src)
			69del(src) //should be safe to 69del immediately since if someone is still usin69 this stack it will persist for a little while lon69er
		update_icon()
		return 1
	else
		if(69et_amount() < used)
			return 0
		for(var/i = 1 to char69e_costs.len)
			var/datum/matter_synth/S = synths69i69
			S.use_char69e(char69e_costs69i69 * used) // Doesn't need to be deleted
		return 1

/obj/item/stack/proc/add(var/extra)
	if(!uses_char69e)
		if(amount + extra > 69et_max_amount())
			return 0
		else
			amount += extra
		update_icon()
		return 1
	else if(!synths || synths.len < uses_char69e)
		return 0
	else
		for(var/i = 1 to uses_char69e)
			var/datum/matter_synth/S = synths69i69
			S.add_char69e(char69e_costs69i69 * extra)

/*
	The transfer and split procs work differently than use() and add().
	Whereas those procs take no action if the desired amount cannot be added or removed these procs will try to transfer whatever they can.
	They also remove an e69ual amount from the source stack.
*/

//attempts to transfer amount to S, and returns the amount actually transferred
/obj/item/stack/proc/transfer_to(obj/item/stack/S,69ar/tamount=null,69ar/type_verified)
	if (!69et_amount())
		return 0
	if ((stacktype != S.stacktype) && !type_verified)
		return 0
	if (isnull(tamount))
		tamount = src.69et_amount()

	var/transfer =69ax(min(tamount, src.69et_amount(), (S.69et_max_amount() - S.69et_amount())), 0)

	var/ori69_amount = src.69et_amount()
	if (transfer && src.use(transfer))
		S.add(transfer)
		if (prob(transfer/ori69_amount * 100))
			transfer_fin69erprints_to(S)
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
	if(uses_char69e)
		return null

	var/transfer =69ax(min(tamount, src.amount, initial(max_amount)), 0)

	var/ori69_amount = src.amount
	if (transfer && src.use(transfer))
		var/obj/item/stack/newstack = new src.type(loc, transfer)
		newstack.color = color
		if (prob(transfer/ori69_amount * 100))
			transfer_fin69erprints_to(newstack)
			if(blood_DNA)
				newstack.blood_DNA |= blood_DNA
		return newstack
	return null

/obj/item/stack/proc/69et_amount()
	if(uses_char69e)
		if(!synths || synths.len < uses_char69e)
			return 0
		var/datum/matter_synth/S = synths69169
		. = round(S.69et_char69e() / char69e_costs69169)
		if(char69e_costs.len > 1)
			for(var/i = 2 to char69e_costs.len)
				S = synths69i69
				. =69in(., round(S.69et_char69e() / char69e_costs69i69))
		return
	return amount

/obj/item/stack/proc/69et_max_amount()
	if(uses_char69e)
		if(!synths || synths.len < uses_char69e)
			return 0
		var/datum/matter_synth/S = synths69169
		. = round(S.max_ener69y / char69e_costs69169)
		if(uses_char69e > 1)
			for(var/i = 2 to uses_char69e)
				S = synths69i69
				. =69in(., round(S.max_ener69y / char69e_costs69i69))
		return
	return69ax_amount

/obj/item/stack/proc/add_to_stacks(mob/user as69ob)
	for (var/obj/item/stack/item in user.loc)
		if (item==src)
			continue
		var/transfer = src.transfer_to(item)
		if (transfer)
			to_chat(user, SPAN_NOTICE("You add a new 69item.sin69ular_name69 to the stack. It now contains 69item.amount69 69item.sin69ular_name69\s."))
		if(!amount)
			break

/obj/item/stack/attack_hand(mob/user as69ob)
	if (user.69et_inactive_hand() == src)
		var/obj/item/stack/F = src.split(1)
		if (F)
			user.put_in_hands(F)
			src.add_fin69erprint(user)
			F.add_fin69erprint(user)
			spawn(0)
				if (src && usr.machine==src)
					src.interact(usr)
	else
		..()
	return

/obj/item/stack/attackby(obj/item/W as obj,69ob/user as69ob)
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/S = W
		if (user.69et_inactive_hand()==src)
			src.transfer_to(S, 1)
		else
			src.transfer_to(S)

		spawn(0) //69ive the stacks a chance to delete themselves if necessary
			if (S && usr.machine==S)
				S.interact(usr)
			if (src && usr.machine==src)
				src.interact(usr)
	else
		return ..()

//Verb to split stacks
/obj/item/stack/verb/split_verb()
	set src in69iew(1)
	set name = "Split"
	set cate69ory = "Object"

	if (!usr.IsAdvancedToolUser())
		return



	var/69uantity = input(usr,
	"This stack contains 69amount69/69max_amount69. How69any would you like to split off into a new stack?\n\
	The new stack will be put into your hands if possible", "Split Stack", round(amount * 0.5)) as null|num

	if (!Adjacent(usr))
		to_chat(usr, SPAN_WARNIN69("You need to be in arm's reach for that!"))
		return

	if (usr.incapacitated())
		return

	if (!isnum(69uantity) || 69uantity < 1)
		return

	var/obj/item/stack/S = split(round(69uantity, 1))
	if (istype(S))
		//Try to put the new stack into the user's hands
		if (!(usr.put_in_hands(S)))
			//If that fails, leave it beside the ori69inal stack
			S.forceMove(69et_turf(src))


/*
 * Recipe datum
 */
/datum/stack_recipe
	var/title = "ERROR"
	var/result_type
	var/re69_amount = 1 //amount of69aterial needed for this recipe
	var/res_amount = 1 //amount of stuff that is produced in one batch (e.69. 4 for floor tiles)
	var/max_res_amount = 1
	var/time = 0
	var/one_per_turf = 0
	var/on_floor = 0
	var/use_material

	New(title, result_type, re69_amount = 1, res_amount = 1,69ax_res_amount = 1, time = 0, one_per_turf = 0, on_floor = 0, supplied_material = null)
		src.title = title
		src.result_type = result_type
		src.re69_amount = re69_amount
		src.res_amount = res_amount
		src.max_res_amount =69ax_res_amount
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



