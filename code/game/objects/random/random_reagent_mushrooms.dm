/*/obj/random/mushrooms
	name = "random mushroom"
	icon_state = "hostilemob-red"
	alpha = 128

/obj/random/mushrooms/item_to_spawn()
	return pick(/obj/item/weapon/reagent_containers/toxic_mushroom)

/obj/random/mushrooms/low_chance
	name = "low chance random spider"
	icon_state = "hostilemob-black-low"
	spawn_nothing_percentage = 70

/obj/random/cluster/mushrooms
	name = "cluster of mushrooms"
	icon_state = "hostilemob-red-cluster"
	alpha = 128
	min_amount = 1
	max_amount = 1//Большого количества на одном тайле не надо
	spread_range = 0

/obj/random/cluster/mushrooms/item_to_spawn()
	return /obj/random/mushrooms

/obj/random/cluster/mushrooms/low_chance
	name = "low chance cluster of mushrooms"
	icon_state = "hostilemob-red-cluster-low"
	spawn_nothing_percentage = 70*/



/obj/item/weapon/reagent_containers/toxic_mushroom
	name = "strange mushroom"
	icon = 'icons/obj/mushrooms.dmi'
	icon_state = "mushrooms_5"
	anchored = 1 //Грибы нельзя сдвинуть
	var/grow_size = 100
	volume = 50 //Вмещаемое количество токсинов
	flags = OPENCONTAINER|NOBLUDGEON
	throwforce = 3
	throw_speed = 2
	throw_range = 10
	unacidable = 1
	var/mushroom_toxin


	New()
		icon_state = "mushrooms_[((grow_size>1)?rand(3,8):rand(1,2))]"
		if(!mushroom_toxin)
			var/reagent_type = pick(subtypesof(/datum/reagent)-typesof(/datum/reagent/ethanol))
			if(prob(30))
				reagent_type = pick(typesof(/datum/reagent/ethanol))
			var/datum/reagent/R = new reagent_type()
			mushroom_toxin = R.id
			reagents.add_reagent(mushroom_toxin, 1)

		spawn()
			Life() //Начало процедуры жизни в параллельном потоке

	proc/Life()
		while(src)
			sleep(100)//Основные действия достаточно просчитывать раз в 10 секунд
			if(reagents.get_free_space())//	  регенерация токсина
				reagents.add_reagent(mushroom_toxin, 1)
			ScanAndAttack()

			if(rand(1,100)<10)
				Grow()



		EndOfLife()

	proc/ScanAndAttack(var/range=2)//Гриб сканирует пространство рядом и при наличии врага стреляет токсином как спрей
		if(istype(src, /obj/item/weapon/reagent_containers/toxic_mushroom/net))  return//Сеть не испускает токсины
		var/mob/M = locate(/mob) in view(range)
		world.log << "1"
		if(M && isliving(M))
			world.log << "2"
			M.visible_message("[src] sprays at [M]!")
			reagents.trans_to_mob(M, 10)
			playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)
		return


	proc/Grow()
		for(var/modx=-1, modx<=1, modx++)	for(var/mody=-1, mody<=1, mody++)
			if(src.x==src.x+modx && src.y==src.y+mody) //Клетка с грибом не рассматриваемся
				continue
			if(src.x+modx==world.maxx || src.y+mody==world.maxy || src.x+modx==1 || src.y+mody==1)
				return //Гриб не растет на краях карты
			var/turf/T = locate(src.x+modx, src.y+mody, src.z)
			if(istype(T, /turf/space) || T.density || (locate(/obj/structure/window) in T.contents))
				continue //Грибы не растут в космосе и на плотных тайлах, и около окон
			if(locate(/obj/item/weapon/reagent_containers/toxic_mushroom) in T.contents)
				continue //Если в найденном месте уже есть грибница или сам гриб, тогда пропуск хода
			var/EndFor
			for(var/atom/A in T.contents)//Проверка на аирлоки и прочее
				if(A.density)
					EndFor = 1
					break
			if(EndFor)	break

			var/obj/item/weapon/reagent_containers/toxic_mushroom/net/Net = new/obj/item/weapon/reagent_containers/toxic_mushroom/net()
			Net.Move(locate(src.x+modx, src.y+mody, src.z))
			Net.mushroom_toxin = mushroom_toxin
			break

		if(istype(src, /obj/item/weapon/reagent_containers/toxic_mushroom/net))
			if(prob(20))	return //Шанс сетки вырасти в полноценный гриб очень мал
			grow_size += rand(1, 20)
			if(grow_size>=100) //Переход на другую стадию при достижении нужного размера
				var/obj/item/weapon/reagent_containers/toxic_mushroom/new_mushroom = new/obj/item/weapon/reagent_containers/toxic_mushroom()
				new_mushroom.Move(locate(src.x, src.y, src.z))
				new_mushroom.mushroom_toxin = mushroom_toxin
				qdel(src)
		sleep(100)


	proc/EndOfLife()
		var/obj/effect/decal/cleanable/ash/A = new /obj/effect/decal/cleanable/ash()
		A.Move(locate(src.x, src.y, src.z))
		view() << "Гриб издал странный вздох и полностью затих."
		qdel(src)

	attackby(obj/item/I, mob/user)
		if(QUALITY_CUTTING in I.tool_qualities)
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_CUTTING, FAILCHANCE_ZERO, required_stat = STAT_BIO))
				user << "You cut the mushroom."
				EndOfLife()
		else
			..()




/obj/item/weapon/reagent_containers/toxic_mushroom/net //Грибница
	name = "strange little mushrooms"
	icon_state = "mushrooms_1"
	grow_size = 1
	volume = 10