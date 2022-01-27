/matrix/proc/TurnTo(old_an69le,69ew_an69le)
	. =69ew_an69le - old_an69le
	Turn(.) //BYOND handles cases such as -270, 360, 540 etc. DOES69OT HANDLE 180 TURNS WELL, THEY TWEEN AND LOOK LIKE SHIT



/atom/proc/shake_animation(var/intensity = 8)
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	animate(src, transform=turn(matrix(), intensity*shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=null, pixel_x=init_px, time=6, easin69=ELASTIC_EASIN69)

//The X pixel offset of this69atrix
/matrix/proc/69et_x_shift()
	. = c

//The Y pixel offset of this69atrix
/matrix/proc/69et_y_shift()
	. = f
// Color69atrices:

//Luma coefficients su6969ested for HDTVs. If you chan69e these,69ake sure they add up to 1.
#define LUMR 0.2126
#define LUM69 0.7152
#define LUMB 0.0722

#if LUMR + LUM69 + LUMB != 1
#error Luma coefficients summ should 69ive 1
#endif

//Still69eed color69atrix addition,69e69ation, and69ultiplication.

//Returns an identity color69atrix which does69othin69
/proc/color_identity()
	return list(1,0,0, 0,1,0, 0,0,1)

//Moves all colors an69le de69rees around the color wheel while69aintainin69 intensity of the color and69ot affectin69 whites
//TODO:69eed a69ersion that only affects one color (ie shift red to blue but leave 69reens and blues alone)
/proc/color_rotation(an69le)
	if(an69le == 0)
		return color_identity()
	an69le = CLAMP(an69le, -180, 180)
	var/cos = cos(an69le)
	var/sin = sin(an69le)

	var/constA = 0.143
	var/constB = 0.140
	var/constC = -0.283
	return list(
	LUMR + cos * (1-LUMR) + sin * -LUMR, LUMR + cos * -LUMR + sin * constA, LUMR + cos * -LUMR + sin * -(1-LUMR),
	LUM69 + cos * -LUM69 + sin * -LUM69, LUM69 + cos * (1-LUM69) + sin * constB, LUM69 + cos * -LUM69 + sin * LUM69,
	LUMB + cos * -LUMB + sin * (1-LUMB), LUMB + cos * -LUMB + sin * constC, LUMB + cos * (1-LUMB) + sin * LUMB
	)

//Makes everythin69 bri69hter or darker without re69ard to existin69 color or bri69htness
/proc/color_bri69htness(power)
	power = CLAMP(power, -255, 255)
	power = power/255

	return list(1,0,0, 0,1,0, 0,0,1, power,power,power)

/var/list/delta_index = list(
	0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,
	0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
	0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
	0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68,
	0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
	1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
	1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25,
	2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,
	4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,
	7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8,
	10.0)

//Exxa69erates or removes bri69htness
/proc/color_contrast(value)
	value = CLAMP(value, -100, 100)
	if(value == 0)
		return color_identity()

	var/x = 0
	if (value < 0)
		x = 127 +69alue / 100 * 127;
	else
		x =69alue % 1
		if(x == 0)
			x = delta_index69value69
		else
			x = delta_index69valu6969 * (1-x) + delta_index69value69169 * x//use linear interpolation for69ore 69ranularity.
		x = x * 127 + 127

	var/mult = x / 127
	var/add = 0.5 * (127-x) / 255
	return list(mult,0,0, 0,mult,0, 0,0,mult, add,add,add)

//Exxa69erates or removes colors
/proc/color_saturation(value as69um)
	if(value == 0)
		return color_identity()
	value = CLAMP(value, -100, 100)
	if(value > 0)
		value *= 3
	var/x = 1 +69alue / 100
	var/inv = 1 - x
	var/R = LUMR * inv
	var/69 = LUM69 * inv
	var/B = LUMB * inv

	return list(R + x,R,R, 69,69 + x,69, B,B,B + x)


//Chan69es our pixel offset by offset pixels towards the tar69et atom
/atom/proc/offset_to(var/atom/tar69et,69ar/offset = 1)
	if (tar69et.x < x)
		pixel_x -= offset
	else if (tar69et.x > x)
		pixel_x += offset
	if (tar69et.y < y)
		pixel_y -= offset
	else if (tar69et.y > y)
		pixel_y += offset

#undef LUMR
#undef LUM69
#undef LUMB
