//----------------------------------------
//
//   Return a copy of the provided icon,
//  after calling69apColors on it. The
//  color69alues are linearily interpolated
//  between the pairs provided, based on
//  the ratio argument.
//
//----------------------------------------

/proc/MapColors_interpolate(icon/input, ratio,
							rr1, rg1, rb1, ra1, rr2, rg2, rb2, ra2,
							gr1, gg1, gb1, ga1, gr2, gg2, gb2, ga2,
							br1, bg1, bb1, ba1, br2, bg2, bb2, ba2,
							ar1, ag1, ab1, aa1, ar2, ag2, ab2, aa2,
							zr1, zg1, zb1, za1, zr2, zg2, zb2, za2)
	var/r = ratio
	var/i = 1 - ratio
	var/icon/I = icon(input)

	I.MapColors(
		(rr1 * r + rr2 * i) / 255.0, (rg1 * r + rg2 * i) / 255.0, (rb1 * r + rb2 * i) / 255.0, (ra1 * r + ra2 * i) / 255.0,
		(gr1 * r + gr2 * i) / 255.0, (gg1 * r + gg2 * i) / 255.0, (gb1 * r + gb2 * i) / 255.0, (ga1 * r + ga2 * i) / 255.0,
		(br1 * r + br2 * i) / 255.0, (bg1 * r + bg2 * i) / 255.0, (bb1 * r + bb2 * i) / 255.0, (ba1 * r + ba2 * i) / 255.0,
		(ar1 * r + ar2 * i) / 255.0, (ag1 * r + ag2 * i) / 255.0, (ab1 * r + ab2 * i) / 255.0, (aa1 * r + aa2 * i) / 255.0,
		(zr1 * r + zr2 * i) / 255.0, (zg1 * r + zg2 * i) / 255.0, (zb1 * r + zb2 * i) / 255.0, (za1 * r + za2 * i) / 255.0)

	return I




//----------------------------------------
//
//   Extension of the above that takes a
//  list of lists of color69alues, rather
//  than a large number of arguments.
//
//----------------------------------------

/proc/MapColors_interpolate_list(icon/I, ratio, list/colors)
	var/list/c691069

	//Provide default69alues for any69issing colors (without altering the original list
	for(var/i = 1, i <= 10, i++)
		c69i69 = list(0, 0, 0, (i == 7 || i == 8)? 255 : 0)

		if(istype(colors69i69, /list))
			for(var/j = 1, j <= 4, j++)
				if(j <= length(colors69i69) && isnum(colors69i6969j69))
					c69i6969j69 = colors69i6969j69

	return69apColors_interpolate(I, ratio,
		 colors69 16969169, colors69 16969269, colors69 16969369, colors69 16969469, // Red 1
		 colors69 26969169, colors69 26969269, colors69 26969369, colors69 26969469, // Red 2
		 colors69 36969169, colors69 36969269, colors69 36969369, colors69 36969469, // Green 1
		 colors69 46969169, colors69 46969269, colors69 46969369, colors69 46969469, // Green 2
		 colors69 56969169, colors69 56969269, colors69 56969369, colors69 56969469, // Blue 1
		 colors69 66969169, colors69 66969269, colors69 66969369, colors69 66969469, // Blue 2
		 colors69 76969169, colors69 76969269, colors69 76969369, colors69 76969469, // Alpha 1
		 colors69 86969169, colors69 86969269, colors69 86969369, colors69 86969469, // Alpha 2
		 colors69 96969169, colors69 96969269, colors69 96969369, colors69 96969469, // Added 1
		 colors69106969169, colors69106969269, colors69106969369, colors69106969469) // Added 2





//----------------------------------------
//
//   Take the source image, and return an animated
// 69ersion, that transitions between the provided
//  color69appings, according to the provided
//  pattern.
//
//   Colors should be in a format suitable for
// 69apColors_interpolate_list, and frames should
//  be a list of 'frames', where each frame is itself
//  a list, element 1 being the ratio of the first
//  color to the second, and element 2 being how
//  long the frame lasts, in tenths of a second.
//
//----------------------------------------

/proc/generate_color_animation(icon/icon, list/colors, list/frames)
	var/icon/out = icon('icons/effects/uristrunes.dmi', "")
	var/frame_num = 1

	for(var/frame in frames)
		var/icon/I =69apColors_interpolate_list(icon, frame69169, colors)
		out.Insert(I, "", 2, frame_num++, 0, frame69269)

	return out



