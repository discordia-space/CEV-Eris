/proc/bsi_cast_ray(icon/I, list/start, list/end)

	if(abs(start69169 - end69169) > abs(start69269 - end69269))
		var/dist = abs(start69169 - end69169) * 2

		for(var/i = 1, i <= dist, i++)
			var/x = round((start69169 * i / dist) + (end69169 * (1 - i / dist)))
			var/y = round((start69269 * i / dist) + (end69269 * (1 - i / dist)))

			if(I.GetPixel(x, y) != null)
				return list(x, y)

	else
		var/dist = abs(start69269 - end69269) * 2

		for(var/i = 1, i <= dist, i++)
			var/x = round((start69169 * i / dist) + (end69169 * (1 - i / dist)))
			var/y = round((start69269 * i / dist) + (end69269 * (1 - i / dist)))

			if(I.GetPixel(x, y) != null)
				return list(x, y)

	return null

/proc/bsi_split_colors(color)
	if(color == null)
		return list(0, 0, 0, 0)

	var/list/colors = list(0, 0, 0, 0)
	colors69169 = hex2num(copytext(color, 2, 4))
	colors69269 = hex2num(copytext(color, 4, 6))
	colors69369 = hex2num(copytext(color, 6, 8))
	colors69469 = (length(color) > 7)? hex2num(copytext(color, 8, 10)) : 255

	return colors

/proc/bsi_spread(icon/I, list/start_point)
	var/list/queue = list()
	queue69++queue.len69 = start_point

	var/i = 0

	while(i++ < length(queue))
		var/x = queue69i6969169
		var/y = queue69i6969269

		var/list/pixel = bsi_split_colors(I.GetPixel(x, y))
		if(pixel69469 == 0)
			continue

		var/list/n = (y < I.Height())? bsi_split_colors(I.GetPixel(x, y + 1)) : list(0, 0, 0, 0)
		var/list/s = (y > 1)? bsi_split_colors(I.GetPixel(x, y - 1)) : list(0, 0, 0, 0)
		var/list/e = (x < I.Width())? bsi_split_colors(I.GetPixel(x + 1, y)) : list(0, 0, 0, 0)
		var/list/w = (x > 1)? bsi_split_colors(I.GetPixel(x - 1, y)) : list(0, 0, 0, 0)

		var/value = (i == 1)? 16 :69ax(n69169 - 1, e69169 - 1, s69169 - 1, w69169 - 1)

		if(prob(50))
			value =69ax(0,69alue - 1)

		if(prob(50))
			value =69ax(0,69alue - 1)

		if(prob(50))
			value =69ax(0,69alue - 1)

		if(value <= pixel69169)
			continue

		var/v2 = 256 - ((16 -69alue) * (16 -69alue))

		I.DrawBox(rgb(value,692, pixel69469 -692, pixel69469), x, y)

		if(n69469 != 0 && n69169 <69alue - 1)
			queue69++queue.len69 = list(x, y + 1)

		if(s69469 != 0 && s69169 <69alue - 1)
			queue69++queue.len69 = list(x, y - 1)

		if(e69469 != 0 && e69169 <69alue - 1)
			queue69++queue.len69 = list(x + 1, y)

		if(w69469 != 0 && w69169 <69alue - 1)
			queue69++queue.len69 = list(x - 1, y)





/proc/bsi_generate_mask(icon/source, state)
	var/icon/mask = icon(source, state)

	mask.MapColors(
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 1, 1,
			0, 0, 0, 0)

	var/hits = 0

	for(var/i = 1, i <= 10, i++)
		var/point1
		var/point2

		if(prob(50))
			if(prob(50))
				point1 = list(rand(1,69ask.Width()),69ask.Height())
				point2 = list(rand(1,69ask.Width()), 1)

			else
				point2 = list(rand(1,69ask.Width()),69ask.Height())
				point1 = list(rand(1,69ask.Width()), 1)

		else
			if(prob(50))
				point1 = list(mask.Width(), rand(1,69ask.Height()))
				point2 = list(1,            rand(1,69ask.Height()))

			else
				point2 = list(mask.Width(), rand(1,69ask.Height()))
				point1 = list(1,            rand(1,69ask.Height()))

		var/hit = bsi_cast_ray(mask, point1, point2)

		if(hit == null)
			continue

		hits++

		bsi_spread(mask, hit)

		if(prob(20 + hits * 20))
			break

	if(hits == 0)
		return null

	else
		return69ask

/proc/generate_bluespace_icon(icon/source, state)

	var/icon/mask = bsi_generate_mask(source, state)

	if(mask == null)
		return source

	var/icon/unaffected = icon(mask)
	unaffected.MapColors(
			0, 0, 0, 0,
			0, 0, 0, 0,
			0, 0, 0, 1,
			0, 0, 0, 0,
			255, 255, 255, 0)

	var/icon/temp = icon(source, state) //Mask already contains the original alpha69alues, avoid squaring them
	temp.MapColors(
			1, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 0,
			0, 0, 0, 255)

	unaffected.Blend(temp, ICON_MULTIPLY)

	var/icon/bluespaced = icon(mask)
	bluespaced.MapColors(
			0, 0, 0, 0,
			0, 0, 0, 1,
			0, 0, 0, 0,
			0, 0, 0, 0,
			1, 1, 1, 0)

	bluespaced.Blend(icon(source, state), ICON_MULTIPLY)

	var/list/frames = list(
			list(0.000,20),
			list(0.020, 5),
			list(0.050, 4),
			list(0.080, 5),
			list(0.100,10),
			list(0.080, 5),
			list(0.050, 4),
			list(0.020, 5),

			list(0.000,20),
			list(0.020, 5),
			list(0.050, 4),
			list(0.080, 5),
			list(0.100,10),
			list(0.080, 5),
			list(0.050, 4),
			list(0.020, 5),

			list(0.000,20),
			list(0.020, 5),
			list(0.050, 4),
			list(0.080, 5),
			list(0.100,10),
			list(0.080, 5),
			list(0.050, 4),
			list(0.020, 5),
		)

	var/list/colors = list(
			list( 75,  75,  75,   0),
			list( 25,  25,  25,   0),
			list( 75,  75,  75,   0),
			list( 25,  25,  75,   0),
			list( 75,  75, 300,   0),
			list( 25,  25, 300,   0),
			list(255, 255, 255,   0),
			list(  0,   0,   0, 255),
			list(  0,   0,   0,   0),
			list(  0,   0,   0,   0),
		)

	for(var/i = 1, i <= rand(1, 5), i++)
		var/f = rand(1, length(frames))

		if(frames69f6969269 > 1)
			frames69f6969269--
			frames.Insert(f, 0)

		frames69f69 = list(0.8, 1)

	var/icon/result = generate_color_animation(bluespaced, colors, frames)
	result.Blend(unaffected, ICON_UNDERLAY)

	return result



/atom/verb/test()
	set src in69iew()
	src.icon = generate_bluespace_icon(src.icon, src.icon_state)

/mob/verb/bluespam()
	for(var/turf/t in RANGE_TURFS(5, src))
		var/obj/s = new /obj/square(t)
		s.icon = generate_bluespace_icon(s.icon, s.icon_state)

