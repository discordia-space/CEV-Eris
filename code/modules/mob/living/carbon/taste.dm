/* what this does:
copies what reagents will be taken out of the holder.
catalogue the 'taste strength' of each one
calculate text size per text.
*/
/mob/living/carbon/proc/ingest(var/datum/reagents/from,69ar/datum/reagents/target,69ar/amount = 1,69ar/multiplier = 1,69ar/copy = 0) //we kind of 'sneak' a proc in here for ingesting stuff so we can play with it.
	var/datum/reagents/temp =69ew() //temporary holder used to analyse what gets transfered.
	var/list/tastes = list() //descriptor = strength
	from.trans_to_holder(temp, amount,69ultiplier, 1)
	var/list/out = list()
	var/minimum_percent = 15
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/taste_level = H.species.taste_sensitivity
		if(H.stats.getPerk(PERK_OBORIN_SYNDROME))
			taste_level = TASTE_NUMB
		minimum_percent = round(15/taste_level)
	if(minimum_percent < 100)
		var/total_taste = 0
		for(var/datum/reagent/R in temp.reagent_list)
			var/desc
			if(!R.taste_mult)
				continue
			if(R.id == "nutriment")
				var/list/t = R.get_data()
				for(var/i in 1 to t.len)
					var/A = t69i69
					if(!(A in tastes))
						tastes.Add(A)
						tastes69A69 = 0
					tastes69A69 += t69A69
					total_taste += t69A69
				continue
			else
				desc = R.taste_description
			if(!(desc in tastes))
				tastes.Add(desc)
				tastes69desc69 = 0
			tastes69desc69 += temp.get_reagent_amount(R.id) * R.taste_mult
			total_taste += temp.get_reagent_amount(R.id) * R.taste_mult
		if(tastes.len)
			for(var/i in 1 to tastes.len)
				var/size = "a hint of "
				var/percent = tastes69tastes69i6969/total_taste * 100
				if(percent == 100) //completely 1 thing, dont69eed to do anything to it.
					size = ""
				else if(percent >69inimum_percent * 3)
					size = "the strong flavor of "
				else if(percent >69inimum_percent * 2)
					size = ""
				else if(percent <=69inimum_percent)
					continue
				out.Add("69size6969tastes69i6969")
	to_chat(src, "<span class='notice'>You can taste 69english_list(out,"something indescribable")69</span>" ) //no taste69eans there are too69any tastes and69ot enough flavor.
	from.trans_to_holder(target,amount,multiplier,copy) //complete transfer
