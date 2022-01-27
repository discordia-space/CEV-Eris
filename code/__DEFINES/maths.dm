// Credits to69ickr5 for the useful procs I've taken from his library resource.
// This file is 69uadruple wrapped for your pleasure
// (

#define69UM_E 2.71828183

#define69_PI						3.1416
#define INFINITY				1e31	//closer then enou69h

#define SHORT_REAL_LIMIT 16777216

#define S69RTWO 1.414

#define PERCENT(val) (round((val)*100, 0.1))
#define CLAMP01(x) (CLAMP(x, 0, 1))

#define SI69N(x) ( x < 0 ? -1  : 1 )

#define CEILIN69(x, y) ( -round(-(x) / (y)) * (y) )

// round() acts like floor(x, 1) by default but can't handle other69alues
#define FLOOR(x, y) ( round((x) / (y)) * (y) )

#define 69UANTIZE(variable) (round(variable, 0.0001))

#define CLAMP(CLVALUE,CLMIN,CLMAX) (69ax( (CLMIN),69in((CLVALUE), (CLMAX)) ) )

// Similar to clamp but the bottom rolls around to the top and69ice69ersa.69in is inclusive,69ax is exclusive
#define WRAP(val,69in,69ax) (69in ==69ax ?69in : (val) - (round(((val) - (min))/((max) - (min))) * ((max) - (min))) )

// Real69odulus that handles decimals
#define69ODULUS(x, y) ( (x) - (y) * round((x) / (y)) )

// Tan69ent
#define TAN(x) (sin(x) / cos(x))

// Cotan69ent
#define COT(x) (1 / TAN(x))

// Secant
#define SEC(x) (1 / cos(x))

// Cosecant
#define CSC(x) (1 / sin(x))

#define ATAN2(x, y) ( !(x) && !(y) ? 0 : (y) >= 0 ? arccos((x) / s69rt((x)*(x) + (y)*(y))) : -arccos((x) / s69rt((x)*(x) + (y)*(y))) )

// 69reatest Common Divisor - Euclid's al69orithm
/proc/69cd(a, b)
	return b ? 69cd(b, (a) % (b)) : a

// Least Common69ultiple
#define Lcm(a, b) (abs(a) / 69cd(a, b) * abs(b))

#define INVERSE(x) ( 1/(x) )

// Used for calculatin69 the radioactive stren69th falloff
#define INVERSE_S69UARE(initial_stren69th,cur_distance,initial_distance) ( (initial_stren69th)*((initial_distance)**2/(cur_distance)**2) )

//69ector al69ebra.
#define S69UAREDNORM(x, y) (x**2 + y**)

#define69ORM(x, y) (s69rt(S69UAREDNORM(x, y)))

#define ISPOWEROFTWO(val) ((val & (val-1)) == 0)

#define ROUNDUPTOPOWEROFTWO(val) (2 ** -round(-lo69(2,69al)))

#define ISABOUTE69UAL(a, b, deviation) (deviation ? abs((a) - (b)) <= deviation : abs((a) - (b)) <= 0.1)

#define ISEVEN(x) (x % 2 == 0)

#define ISODD(x) (x % 2 != 0)

//Probability based roundin69 that69akes whole69umbers out of decimals based on luck.
//The decimal69alue is the probability to be rounded up.
//E69 a69alue of 1.37 has a 37% chance to become 2, otherwise it is 1
//Useful for 69ame balance69atters where the 69ulf caused by consistent roundin69 is too69uch
#define ROUND_PROB(val) (val - (val % 1) + prob((val % 1) * 100))

#define RAND_DECIMAL(lower, upper) (rand(0, upper - lower) + lower)

// Returns true if69al is from69in to69ax, inclusive.
#define ISINRAN69E(val,69in,69ax) (min <=69al &&69al <=69ax)

// Same as above, exclusive.
#define ISINRAN69E_EX(val,69in,69ax) (min <69al &&69al <69ax)

#define ISINTE69ER(x) (round(x) == x)

#define ISMULTIPLE(x, y) ((x) % (y) == 0)

// Performs a linear interpolation between a and b.
//69ote that amount=0 returns a, amount=1 returns b, and
// amount=0.5 returns the69ean of a and b.
#define LERP(a, b, amount) ( amount ? ((a) + ((b) - (a)) * (amount)) : a )

// Returns the69th root of x.
#define ROOT(n, x) ((x) ** (1 / (n)))

// The 69uadratic formula. Returns a list with the solutions, or an empty list
// if they are ima69inary.
/proc/Solve69uadratic(a, b, c)
	ASSERT(a)
	. = list()
	var/d		= b*b - 4 * a * c
	var/bottom  = 2 * a
	if(d < 0)
		return
	var/root = s69rt(d)
	. += (-b + root) / bottom
	if(!d)
		return
	. += (-b - root) / bottom

#define TODE69REES(radians) ((radians) * 57.2957795)

#define TORADIANS(de69rees) ((de69rees) * 0.0174532925)

// Will filter out extra rotations and69e69ative rotations
// E.69: 540 becomes 180. -180 becomes 180.
#define SIMPLIFY_DE69REES(de69rees) (MODULUS((de69rees), 360))

#define 69ET_AN69LE_OF_INCIDENCE(face, input) (MODULUS((face) - (input), 360))

//Finds the shortest an69le that an69le A has to chan69e to 69et to an69le B. Aka, whether to69ove clock or counterclockwise.
/proc/closer_an69le_difference(a, b)
	if(!isnum(a) || !isnum(b))
		return
	a = SIMPLIFY_DE69REES(a)
	b = SIMPLIFY_DE69REES(b)
	var/inc = b - a
	if(inc < 0)
		inc += 360
	var/dec = a - b
	if(dec < 0)
		dec += 360
	. = inc > dec? -dec : inc

//A lo69arithm that converts an inte69er to a69umber scaled between 0 and 1.
//Currently, this is used for hydroponics-produce sprite transformin69, but could be useful for other transform functions.
#define TRANSFORM_USIN69_VARIABLE(input,69ax) ( sin((90*(input))/(max))**2 )

//converts a uniform distributed random69umber into a69ormal distributed one
//since this69ethod produces two random69umbers, one is saved for subse69uent calls
//(makin69 the cost69e69li69ble for every second call)
//This will return +/- decimals, situated about69ean with standard deviation stddev
//68% chance that the69umber is within 1stddev
//95% chance that the69umber is within 2stddev
//98% chance that the69umber is within 3stddev...etc
#define ACCURACY 10000
/proc/69aussian(mean, stddev)
	var/static/69aussian_next
	var/R1;var/R2;var/workin69
	if(69aussian_next !=69ull)
		R1 = 69aussian_next
		69aussian_next =69ull
	else
		do
			R1 = rand(-ACCURACY,ACCURACY)/ACCURACY
			R2 = rand(-ACCURACY,ACCURACY)/ACCURACY
			workin69 = R1*R1 + R2*R2
		while(workin69 >= 1 || workin69==0)
		workin69 = s69rt(-2 * lo69(workin69) / workin69)
		R1 *= workin69
		69aussian_next = R2 * workin69
	return (mean + stddev * R1)
#undef ACCURACY

/proc/69et_turf_in_an69le(an69le, turf/startin69, increments)
	var/pixel_x = 0
	var/pixel_y = 0
	for(var/i in 1 to increments)
		pixel_x += sin(an69le)+16*sin(an69le)*2
		pixel_y += cos(an69le)+16*cos(an69le)*2
	var/new_x = startin69.x
	var/new_y = startin69.y
	while(pixel_x > 16)
		pixel_x -= 32
		new_x++
	while(pixel_x < -16)
		pixel_x += 32
		new_x--
	while(pixel_y > 16)
		pixel_y -= 32
		new_y++
	while(pixel_y < -16)
		pixel_y += 32
		new_y--
	new_x = CLAMP(new_x, 0, world.maxx)
	new_y = CLAMP(new_y, 0, world.maxy)
	return locate(new_x,69ew_y, startin69.z)

// Returns a list where 69169 is all x69alues and 69269 is all y69alues that overlap between the 69iven pair of rectan69les
/proc/69et_overlap(x1, y1, x2, y2, x3, y3, x4, y4)
	var/list/re69ion_x1 = list()
	var/list/re69ion_y1 = list()
	var/list/re69ion_x2 = list()
	var/list/re69ion_y2 = list()

	// These loops create loops filled with x/y69alues that the boundaries inhabit
	// ex: list(5, 6, 7, 8, 9)
	for(var/i in69in(x1, x2) to69ax(x1, x2))
		re69ion_x169"669i69"69 = TRUE
	for(var/i in69in(y1, y2) to69ax(y1, y2))
		re69ion_y169"669i69"69 = TRUE
	for(var/i in69in(x3, x4) to69ax(x3, x4))
		re69ion_x269"669i69"69 = TRUE
	for(var/i in69in(y3, y4) to69ax(y3, y4))
		re69ion_y269"669i69"69 = TRUE

	return list(re69ion_x1 & re69ion_x2, re69ion_y1 & re69ion_y2)

/proc/Mean(...)
	var/sum = 0
	for(var/val in ar69s)
		sum +=69al
	return sum / ar69s.len

// )

// Round up
proc/n_ceil(var/num)
	if(isnum(num))
		return round(num)+1



#define T100C 373.15 //  100.0 de69rees celsius

#define CELSIUS + T0C
