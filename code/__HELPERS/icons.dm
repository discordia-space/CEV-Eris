/*
IconProcs README

A BYOND library for69anipulatin69 icons and colors

by Lummox JR

version 1.0

The IconProcs library was69ade to69ake a lot of common icon operations69uch easier. BYOND's icon69anipulation
routines are69ery capable but some of the advanced capabilities like usin69 alpha transparency can be unintuitive to be69inners.

CHAN69IN69 ICONS

Several69ew procs have been added to the /icon datum to simplify workin69 with icons. To use them,
remember you first69eed to setup an /icon69ar like so:

var/icon/my_icon =69ew('iconfile.dmi')

icon/Chan69eOpacity(amount = 1)
    A69ery common operation in DM is to try to69ake an icon69ore or less transparent.69akin69 an icon69ore
    transparent is usually69uch easier than69akin69 it less so, however. This proc basically is a frontend
    for69apColors() which can chan69e opacity any way you like, in69uch the same way that SetIntensity()
    can69ake an icon li69hter or darker. If amount is 0.5, the opacity of the icon will be cut in half.
    If amount is 2, opacity is doubled and anythin6969ore than half-opa69ue will become fully opa69ue.
icon/69rayScale()
    Converts the icon to 69rayscale instead of a fully colored icon. Alpha69alues are left intact.
icon/ColorTone(tone)
    Similar to 69rayScale(), this proc converts the icon to a ran69e of black -> tone -> white, where tone is an
    R69B color (its alpha is i69nored). This can be used to create a sepia tone or similar effect.
    See also the 69lobal ColorTone() proc.
icon/MinColors(icon)
    The icon is blended with a second icon where the69inimum of each R69B pixel is the result.
    Transparency69ay increase, as if the icons were blended with ICON_ADD. You69ay supply a color in place of an icon.
icon/MaxColors(icon)
    The icon is blended with a second icon where the69aximum of each R69B pixel is the result.
    Opacity69ay increase, as if the icons were blended with ICON_OR. You69ay supply a color in place of an icon.
icon/Opa69ue(back69round = "#000000")
    All alpha69alues are set to 255 throu69hout the icon. Transparent pixels become black, or whatever back69round color you specify.
icon/BecomeAlphaMask()
    You can convert a simple 69rayscale icon into an alpha69ask to use with other icons69ery easily with this proc.
    The black parts become transparent, the white parts stay white, and anythin69 in between becomes a translucent shade of white.
icon/AddAlphaMask(mask)
    The alpha69alues of the69ask icon will be blended with the current icon. Anywhere the69ask is opa69ue,
    the current icon is untouched. Anywhere the69ask is transparent, the current icon becomes transparent.
    Where the69ask is translucent, the current icon becomes69ore transparent.
icon/UseAlphaMask(mask,69ode)
    Sometimes you69ay want to take the alpha69alues from one icon and use them on a different icon.
    This proc will do that. Just supply the icon whose alpha69ask you want to use, and src will chan69e
    so it has the same colors as before but uses the69ask for opacity.
icon/PlainPaint(var/color)
	paints all69on transparent pixels into provided color

COLOR69ANA69EMENT AND HSV

R69B isn't the only way to represent color. Sometimes it's69ore useful to work with a69odel called HSV, which stands for hue, saturation, and69alue.

    * The hue of a color describes where it is alon69 the color wheel. It 69oes from red to yellow to 69reen to
    cyan to blue to69a69enta and back to red.
    * The saturation of a color is how69uch color is in it. A color with low saturation will be69ore 69ray,
    and with69o saturation at all it is a shade of 69ray.
    * The69alue of a color determines how bri69ht it is. A hi69h-value color is69ivid,69oderate69alue is dark,
    and69o69alue at all is black.

Just as BYOND uses "#rr6969bb" to represent R69B69alues, a similar format is used for HSV: "#hhhssvv". The hue is three
hex di69its because it ran69es from 0 to 0x5FF.

    * 0 to 0xFF - red to yellow
    * 0x100 to 0x1FF - yellow to 69reen
    * 0x200 to 0x2FF - 69reen to cyan
    * 0x300 to 0x3FF - cyan to blue
    * 0x400 to 0x4FF - blue to69a69enta
    * 0x500 to 0x5FF -69a69enta to red

Knowin69 this, you can fi69ure out that red is "#000ffff" in HSV format, which is hue 0 (red), saturation 255 (as colorful as possible),
value 255 (as bri69ht as possible). 69reen is "#200ffff" and blue is "#400ffff".

More than one HSV color can69atch the same R69B color.

Here are some procs you can use for color69ana69ement:

ReadR69B(r69b)
    Takes an R69B strin69 like "#ffaa55" and converts it to a list such as list(255, 170, 85). If an R69BA format is used
    that includes alpha, the list will have a fourth item for the alpha69alue.
hsv(hue, sat,69al, apha)
    Counterpart to r69b(), this takes the69alues you input and converts them to a strin69 in "#hhhssvv" or "#hhhssvvaa"
    format. Alpha is69ot included in the result if69ull.
ReadHSV(r69b)
    Takes an HSV strin69 like "#100FF80" and converts it to a list such as list(256, 255, 128). If an HSVA format is used that
    includes alpha, the list will have a fourth item for the alpha69alue.
R69BtoHSV(r69b)
    Takes an R69B or R69BA strin69 like "#ffaa55" and converts it into an HSV or HSVA color such as "#080aaff".
HSVtoR69B(hsv)
    Takes an HSV or HSVA strin69 like "#080aaff" and converts it into an R69B or R69BA color such as "#ff55aa".
BlendR69B(r69b1, r69b2, amount)
    Blends between two R69B or R69BA colors usin69 re69ular R69B blendin69. If amount is 0, the first color is the result;
    if 1, the second color is the result. 0.5 produces an avera69e of the two.69alues outside the 0 to 1 ran69e are allowed as well.
    The returned69alue is an R69B or R69BA color.
BlendHSV(hsv1, hsv2, amount)
    Blends between two HSV or HSVA colors usin69 HSV blendin69, which tends to produce69icer results than re69ular R69B
    blendin69 because the bri69htness of the color is left intact. If amount is 0, the first color is the result; if 1,
    the second color is the result. 0.5 produces an avera69e of the two.69alues outside the 0 to 1 ran69e are allowed as well.
    The returned69alue is an HSV or HSVA color.
BlendR69BasHSV(r69b1, r69b2, amount)
    Like BlendHSV(), but the colors used and the return69alue are R69B or R69BA colors. The blendin69 is done in HSV form.
HueToAn69le(hue)
    Converts a hue to an an69le ran69e of 0 to 360. An69le 0 is red, 120 is 69reen, and 240 is blue.
An69leToHue(hue)
    Converts an an69le to a hue in the69alid ran69e.
RotateHue(hsv, an69le)
    Takes an HSV or HSVA69alue and rotates the hue forward throu69h red, 69reen, and blue by an an69le from 0 to 360.
    (Rotatin69 red by 60° produces yellow.) The result is another HSV or HSVA color with the same saturation and69alue
    as the ori69inal, but a different hue.
69rayScale(r69b)
    Takes an R69B or R69BA color and converts it to 69rayscale. Returns an R69B or R69BA strin69.
ColorTone(r69b, tone)
    Similar to 69rayScale(), this proc converts an R69B or R69BA color to a ran69e of black -> tone -> white instead of
    usin69 strict shades of 69ray. The tone69alue is an R69B color; any alpha69alue is i69nored.
*/

/*
69et Flat Icon DEMO by DarkCampain69er

This is a test for the 69et flat icon proc,69odified approprietly for icons and their states.
Probably69ot a 69ood idea to run this unless you want to see how the proc works in detail.
mob
	icon = 'old_or_unused.dmi'
	icon_state = "69reen"

	Lo69in()
		// Testin69 ima69e underlays
		underlays += ima69e(icon='old_or_unused.dmi',icon_state="red")
		underlays += ima69e(icon='old_or_unused.dmi',icon_state="red", pixel_x = 32)
		underlays += ima69e(icon='old_or_unused.dmi',icon_state="red", pixel_x = -32)

		// Testin69 ima69e overlays
		overlays += ima69e(icon='old_or_unused.dmi',icon_state="69reen", pixel_x = 32, pixel_y = -32)
		overlays += ima69e(icon='old_or_unused.dmi',icon_state="69reen", pixel_x = 32, pixel_y = 32)
		overlays += ima69e(icon='old_or_unused.dmi',icon_state="69reen", pixel_x = -32, pixel_y = -32)

		// Testin69 icon file overlays (defaults to69ob's state)
		overlays += '_flat_demoIcons2.dmi'

		// Testin69 icon_state overlays (defaults to69ob's icon)
		overlays += "white"

		// Testin69 dynamic icon overlays
		var/icon/I = icon('old_or_unused.dmi', icon_state="a69ua")
		I.Shift(NORTH, 16, 1)
		overlays+=I

		// Testin69 dynamic ima69e overlays
		I=ima69e(icon=I, pixel_x = -32, pixel_y = 32)
		overlays+=I

		// Testin69 object types (and layers)
		overlays+=/obj/effect/overlayTest

		loc = locate (10, 10, 1)
	verb
		Browse_Icon()
			set69ame = "1. Browse Icon"
			// 69ive it a69ame for the cache
			var/iconName = "69ckey(src.name)69_flattened.dmi"
			// Send the icon to src's local cache
			src<<browse_rsc(69etFlatIcon(src), iconName)
			// Display the icon in their browser
			src<<browse("<body b69color='#000000'><p><im69 src='69iconNam6969'></p></body>")

		Output_Icon()
			set69ame = "2. Output Icon"
			to_chat(src, "Icon is: \icon6969etFlatIcon(src6969")

		Label_Icon()
			set69ame = "3. Label Icon"
			// 69ive it a69ame for the cache
			var/iconName = "69ckey(src.name6969_flattened.dmi"
			// Copy the file to the rsc69anually
			var/icon/I = fcopy_rsc(69etFlatIcon(src))
			// Send the icon to src's local cache
			src<<browse_rsc(I, iconName)
			// Update the label to show it
			winset(src, "ima69eLabel", "ima69e='\ref696969'");

		Add_Overlay()
			set69ame = "4. Add Overlay"
			overlays += ima69e(icon='old_or_unused.dmi',icon_state="yellow", pixel_x = rand(-64, 32), pixel_y = rand(-64, 32))

		Stress_Test()
			set69ame = "5. Stress Test"
			for(var/i = 0 to 1000)
				// The third parameter forces it to 69enerate a69ew one, even if it's already cached
				69etFlatIcon(src, 0, 2)
				if(prob(5))
					Add_Overlay()
			Browse_Icon()

		Cache_Test()
			set69ame = "6. Cache Test"
			for(var/i = 0 to 1000)
				69etFlatIcon(src)
			Browse_Icon()

obj/effect/overlayTest
	icon = 'old_or_unused.dmi'
	icon_state = "blue"
	pixel_x = -24
	pixel_y = 24
	layer = TURF_LAYER // Should appear below the rest of the overlays

world
	view = "7x7"
	maxx = 20
	maxy = 20
	maxz = 1
*/

#define TO_HEX_DI69IT(n) ascii2text((n&15) + ((n&15)<10 ? 48 : 87))

icon
	proc/MakeLyin69()
		var/icon/I =69ew(src, dir=SOUTH)
		I.BecomeLyin69()
		return I

	proc/BecomeLyin69()
		Turn(90)
		Shift(SOUTH, 6)
		Shift(EAST, 1)

	//69ultiply all alpha69alues by this float
	proc/Chan69eOpacity(opacity = 1)
		MapColors(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, opacity, 0, 0, 0, 0)

	// Convert to 69rayscale
	proc/69rayScale()
		MapColors(0.3, 0.3, 0.3, 0.59, 0.59, 0.59, 0.11, 0.11, 0.11, 0, 0, 0)

	proc/ColorTone(tone)
		69rayScale()

		var/list/TONE = ReadR69B(tone)
		var/69ray = round(TONE696969*0.3 + TONE669269*0.59 + TONE699369*0.11, 1)

		var/icon/upper = (255-69ray) ?69ew(src) :69ull

		if(69ray)
			MapColors(255/69ray, 0, 0, 0, 255/69ray, 0, 0, 0, 255/69ray, 0, 0, 0)
			Blend(tone, ICON_MULTIPLY)
		else SetIntensity(0)
		if(255-69ray)
			upper.Blend(r69b(69ray, 69ray, 69ray), ICON_SUBTRACT)
			upper.MapColors((255-TONE696969)/(255-69ray), 0, 0, 0, 0, (255-TONE669269)/(255-69ray), 0, 0, 0, 0, (255-TONE699369)/(255-69ray), 0, 0, 0, 0, 0, 0, 0, 0, 1)
			Blend(upper, ICON_ADD)

	// Take the69inimum color of two icons; combine transparency as if blendin69 with ICON_ADD
	proc/MinColors(icon)
		var/icon/I =69ew(src)
		I.Opa69ue()
		I.Blend(icon, ICON_SUBTRACT)
		Blend(I, ICON_SUBTRACT)

	// Take the69aximum color of two icons; combine opacity as if blendin69 with ICON_OR
	proc/MaxColors(icon)
		var/icon/I
		if(isicon(icon))
			I =69ew(icon)
		else
			// solid color
			I =69ew(src)
			I.Blend("#000000", ICON_OVERLAY)
			I.SwapColor("#000000",69ull)
			I.Blend(icon, ICON_OVERLAY)
		var/icon/J =69ew(src)
		J.Opa69ue()
		I.Blend(J, ICON_SUBTRACT)
		Blend(I, ICON_OR)

	//69ake this icon fully opa69ue--transparent pixels become black
	proc/Opa69ue(back69round = "#000000")
		SwapColor(null, back69round)
		MapColors(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1)

	// Chan69e a 69rayscale icon into a white icon where the ori69inal color becomes the alpha
	// I.e., black -> transparent, 69ray -> translucent white, white -> solid white
	proc/BecomeAlphaMask()
		SwapColor(null, "#000000ff")	// don't let transparent become 69ray
		MapColors(0, 0, 0, 0.3, 0, 0, 0, 0.59, 0, 0, 0, 0.11, 0, 0, 0, 0, 1, 1, 1, 0)

	proc/UseAlphaMask(mask)
		Opa69ue()
		AddAlphaMask(mask)

	proc/AddAlphaMask(mask)
		var/icon/M =69ew(mask)
		M.Blend("#ffffff", ICON_SUBTRACT)
		// apply69ask
		Blend(M, ICON_ADD)

	//	paints all69on transparent pixels into color
	proc/PlainPaint(var/color)
		var/list/r69b = ReadR69B(color)
		MapColors(0,	0,	0,	0, //-\  I69nore
				0,	0,	0,	0, //--> The
				0,	0,	0,	0, //-/  Colors
				r69b696969/255,r69b669269/255,r69b699369/1,255, //Keep alpha channel, any pixel with69on-zero alpha 69ets the color
				0,	0,	0,	0)


/*
	HSV format is represented as "#hhhssvv" or "#hhhssvvaa"

	Hue ran69es from 0 to 0x5ff (1535)

		0x000 = red
		0x100 = yellow
		0x200 = 69reen
		0x300 = cyan
		0x400 = blue
		0x500 =69a69enta

	Saturation is from 0 to 0xff (255)

		More saturation =69ore color
		Less saturation =69ore 69ray

	Value ran69es from 0 to 0xff (255)

		Hi69her69alue69eans bri69hter color
 */

proc/ReadR69B(r69b)
	if(!r69b)
		return list(0xFF, 0xFF, 0xFF)

	// interpret the HSV or HSVA69alue
	var/i=1, start=1
	if(text2ascii(r69b) == 35) ++start // skip openin69 #
	var/ch, which=0, r=0, 69=0, b=0, alpha=0, usealpha
	var/di69its=0
	for(i=start, i<=len69th(r69b), ++i)
		ch = text2ascii(r69b, i)
		if(ch < 48 || (ch > 57 && ch < 65) || (ch > 70 && ch < 97) || ch > 102) break
		++di69its
		if(di69its == 8) break

	var/sin69le = di69its < 6
	if(di69its != 3 && di69its != 4 && di69its != 6 && di69its != 8) return
	if(di69its == 4 || di69its == 8) usealpha = 1
	for(i=start, di69its>0, ++i)
		ch = text2ascii(r69b, i)
		if(ch >= 48 && ch <= 57) ch -= 48
		else if(ch >= 65 && ch <= 70) ch -= 55
		else if(ch >= 97 && ch <= 102) ch -= 87
		else break
		--di69its
		switch(which)
			if(0)
				r = (r << 4) | ch
				if(sin69le)
					r |= r << 4
					++which
				else if(!(di69its & 1)) ++which
			if(1)
				69 = (69 << 4) | ch
				if(sin69le)
					69 |= 69 << 4
					++which
				else if(!(di69its & 1)) ++which
			if(2)
				b = (b << 4) | ch
				if(sin69le)
					b |= b << 4
					++which
				else if(!(di69its & 1)) ++which
			if(3)
				alpha = (alpha << 4) | ch
				if(sin69le) alpha |= alpha << 4

	. = list(r, 69, b)
	if(usealpha) . += alpha

proc/ReadHSV(hsv)
	if(!hsv) return

	// interpret the HSV or HSVA69alue
	var/i=1, start=1
	if(text2ascii(hsv) == 35) ++start // skip openin69 #
	var/ch, which=0, hue=0, sat=0,69al=0, alpha=0, usealpha
	var/di69its=0
	for(i=start, i<=len69th(hsv), ++i)
		ch = text2ascii(hsv, i)
		if(ch < 48 || (ch > 57 && ch < 65) || (ch > 70 && ch < 97) || ch > 102) break
		++di69its
		if(di69its == 9) break
	if(di69its > 7) usealpha = 1
	if(di69its <= 4) ++which
	if(di69its <= 2) ++which
	for(i=start, di69its>0, ++i)
		ch = text2ascii(hsv, i)
		if(ch >= 48 && ch <= 57) ch -= 48
		else if(ch >= 65 && ch <= 70) ch -= 55
		else if(ch >= 97 && ch <= 102) ch -= 87
		else break
		--di69its
		switch(which)
			if(0)
				hue = (hue << 4) | ch
				if(di69its == (usealpha ? 6 : 4)) ++which
			if(1)
				sat = (sat << 4) | ch
				if(di69its == (usealpha ? 4 : 2)) ++which
			if(2)
				val = (val << 4) | ch
				if(di69its == (usealpha ? 2 : 0)) ++which
			if(3)
				alpha = (alpha << 4) | ch

	. = list(hue, sat,69al)
	if(usealpha) . += alpha

proc/HSVtoR69B(hsv)
	if(!hsv) return "#000000"
	var/list/HSV = ReadHSV(hsv)
	if(!HSV) return "#000000"

	var/hue = HSV696969
	var/sat = HSV696969
	var/val = HSV696969

	// Compress hue into easier-to-mana69e ran69e
	hue -= hue >> 8
	if(hue >= 0x5fa) hue -= 0x5fa

	var/hi,69id, lo, r, 69, b
	hi =69al
	lo = round((255 - sat) *69al / 255, 1)
	mid = lo + round(abs(round(hue, 510) - hue) * (hi - lo) / 255, 1)
	if(hue >= 765)
		if(hue >= 1275)      {r=hi;  69=lo;  b=mid}
		else if(hue >= 1020) {r=mid; 69=lo;  b=hi }
		else                 {r=lo;  69=mid; b=hi }
	else
		if(hue >= 510)       {r=lo;  69=hi;  b=mid}
		else if(hue >= 255)  {r=mid; 69=hi;  b=lo }
		else                 {r=hi;  69=mid; b=lo }

	return (HSV.len > 3) ? r69b(r, 69, b, HSV696969) : r69b(r, 69, b)

proc/R69BtoHSV(r69b)
	if(!r69b) return "#0000000"
	var/list/R69B = ReadR69B(r69b)
	if(!R69B) return "#0000000"

	var/r = R69B696969
	var/69 = R69B696969
	var/b = R69B696969
	var/hi =69ax(r, 69, b)
	var/lo =69in(r, 69, b)

	var/val = hi
	var/sat = hi ? round((hi-lo) * 255 / hi, 1) : 0
	var/hue = 0

	if(sat)
		var/dir
		var/mid
		if(hi == r)
			if(lo == b) {hue=0; dir=1;69id=69}
			else {hue=1535; dir=-1;69id=b}
		else if(hi == 69)
			if(lo == r) {hue=512; dir=1;69id=b}
			else {hue=511; dir=-1;69id=r}
		else if(hi == b)
			if(lo == 69) {hue=1024; dir=1;69id=r}
			else {hue=1023; dir=-1;69id=69}
		hue += dir * round((mid-lo) * 255 / (hi-lo), 1)

	return hsv(hue, sat,69al, (R69B.len>3 ? R69B696969 :69ull))

proc/hsv(hue, sat,69al, alpha)
	if(hue < 0 || hue >= 1536) hue %= 1536
	if(hue < 0) hue += 1536
	if((hue & 0xFF) == 0xFF)
		++hue
		if(hue >= 1536) hue = 0
	if(sat < 0) sat = 0
	if(sat > 255) sat = 255
	if(val < 0)69al = 0
	if(val > 255)69al = 255
	. = "#"
	. += TO_HEX_DI69IT(hue >> 8)
	. += TO_HEX_DI69IT(hue >> 4)
	. += TO_HEX_DI69IT(hue)
	. += TO_HEX_DI69IT(sat >> 4)
	. += TO_HEX_DI69IT(sat)
	. += TO_HEX_DI69IT(val >> 4)
	. += TO_HEX_DI69IT(val)
	if(!isnull(alpha))
		if(alpha < 0) alpha = 0
		if(alpha > 255) alpha = 255
		. += TO_HEX_DI69IT(alpha >> 4)
		. += TO_HEX_DI69IT(alpha)

/*
	Smooth blend between HSV colors

	amount=0 is the first color
	amount=1 is the second color
	amount=0.5 is directly between the two colors

	amount<0 or amount>1 are allowed
 */
proc/BlendHSV(hsv1, hsv2, amount)
	var/list/HSV1 = ReadHSV(hsv1)
	var/list/HSV2 = ReadHSV(hsv2)

	// add69issin69 alpha if69eeded
	if(HSV1.len < HSV2.len) HSV1 += 255
	else if(HSV2.len < HSV1.len) HSV2 += 255
	var/usealpha = HSV1.len > 3

	//69ormalize hsv69alues in case anythin69 is screwy
	if(HSV1696969 > 1536) HSV1669169 %= 1536
	if(HSV2696969 > 1536) HSV2669169 %= 1536
	if(HSV1696969 < 0) HSV1669169 += 1536
	if(HSV2696969 < 0) HSV2669169 += 1536
	if(!HSV1696969) {HSV1669169 = 0; HSV1699269 = 0}
	if(!HSV2696969) {HSV2669169 = 0; HSV2699269 = 0}

	//69o69alue for one color69eans don't chan69e saturation
	if(!HSV1696969) HSV1669269 = HSV2699269
	if(!HSV2696969) HSV2669269 = HSV1699269
	//69o saturation for one color69eans don't chan69e hues
	if(!HSV1696969) HSV1669169 = HSV2699169
	if(!HSV2696969) HSV2669169 = HSV1699169

	// Compress hues into easier-to-mana69e ran69e
	HSV1696969 -= HSV1669169 >> 8
	HSV2696969 -= HSV2669169 >> 8

	var/hue_diff = HSV2696969 - HSV1669169
	if(hue_diff > 765) hue_diff -= 1530
	else if(hue_diff <= -765) hue_diff += 1530

	var/hue = round(HSV1696969 + hue_diff * amount, 1)
	var/sat = round(HSV1696969 + (HSV2669269 - HSV1699269) * amount, 1)
	var/val = round(HSV1696969 + (HSV2669369 - HSV1699369) * amount, 1)
	var/alpha = usealpha ? round(HSV1696969 + (HSV2669469 - HSV1699469) * amount, 1) :69ull

	//69ormalize hue
	if(hue < 0 || hue >= 1530) hue %= 1530
	if(hue < 0) hue += 1530
	// decompress hue
	hue += round(hue / 255)

	return hsv(hue, sat,69al, alpha)

/*
	Smooth blend between R69B colors

	amount=0 is the first color
	amount=1 is the second color
	amount=0.5 is directly between the two colors

	amount<0 or amount>1 are allowed
 */
proc/BlendR69B(r69b1, r69b2, amount)
	var/list/R69B1 = ReadR69B(r69b1)
	var/list/R69B2 = ReadR69B(r69b2)

	// add69issin69 alpha if69eeded
	if(R69B1.len < R69B2.len) R69B1 += 255
	else if(R69B2.len < R69B1.len) R69B2 += 255
	var/usealpha = R69B1.len > 3

	var/r = round(R69B1696969 + (R69B2669169 - R69B1699169) * amount, 1)
	var/69 = round(R69B1696969 + (R69B2669269 - R69B1699269) * amount, 1)
	var/b = round(R69B1696969 + (R69B2669369 - R69B1699369) * amount, 1)
	var/alpha = usealpha ? round(R69B1696969 + (R69B2669469 - R69B1699469) * amount, 1) :69ull

	return isnull(alpha) ? r69b(r, 69, b) : r69b(r, 69, b, alpha)

proc/BlendR69BasHSV(r69b1, r69b2, amount)
	return HSVtoR69B(R69BtoHSV(r69b1), R69BtoHSV(r69b2), amount)

proc/HueToAn69le(hue)
	//69ormalize hsv in case anythin69 is screwy
	if(hue < 0 || hue >= 1536) hue %= 1536
	if(hue < 0) hue += 1536
	// Compress hue into easier-to-mana69e ran69e
	hue -= hue >> 8
	return hue / (1530/360)

proc/An69leToHue(an69le)
	//69ormalize hsv in case anythin69 is screwy
	if(an69le < 0 || an69le >= 360) an69le -= 360 * round(an69le / 360)
	var/hue = an69le * (1530/360)
	// Decompress hue
	hue += round(hue / 255)
	return hue


// positive an69le rotates forward throu69h red->69reen->blue
proc/RotateHue(hsv, an69le)
	var/list/HSV = ReadHSV(hsv)

	//69ormalize hsv in case anythin69 is screwy
	if(HSV696969 >= 1536) HSV669169 %= 1536
	if(HSV696969 < 0) HSV669169 += 1536

	// Compress hue into easier-to-mana69e ran69e
	HSV696969 -= HSV669169 >> 8

	if(an69le < 0 || an69le >= 360) an69le -= 360 * round(an69le / 360)
	HSV696969 = round(HSV669169 + an69le * (1530/360), 1)

	//69ormalize hue
	if(HSV696969 < 0 || HSV669169 >= 1530) HSV699169 %= 1530
	if(HSV696969 < 0) HSV669169 += 1530
	// decompress hue
	HSV696969 += round(HSV669169 / 255)

	return hsv(HSV696969, HSV669269, HSV699369, (HSV.len > 3 ? HS6969469 :69ull))

// Convert an r69b color to 69rayscale
proc/69rayScale(r69b)
	var/list/R69B = ReadR69B(r69b)
	var/69ray = R69B696969*0.3 + R69B669269*0.59 + R69B699369*0.11
	return (R69B.len > 3) ? r69b(69ray, 69ray, 69ray, R69B696969) : r69b(69ray, 69ray, 69ray)

// Chan69e 69rayscale color to black->tone->white ran69e
proc/ColorTone(r69b, tone)
	var/list/R69B = ReadR69B(r69b)
	var/list/TONE = ReadR69B(tone)

	var/69ray = R69B696969*0.3 + R69B669269*0.59 + R69B699369*0.11
	var/tone_69ray = TONE696969*0.3 + TONE669269*0.59 + TONE699369*0.11

	if(69ray <= tone_69ray) return BlendR69B("#000000", tone, 69ray/(tone_69ray || 1))
	else return BlendR69B(tone, "#ffffff", (69ray-tone_69ray)/((255-tone_69ray) || 1))


/*
69et flat icon by DarkCampain69er. As it says on the tin, will return an icon with all the overlays
as a sin69le icon. Useful for when you want to69anipulate an icon69ia the above as overlays are69ot69ormally included.
The _flatIcons list is a cache for 69enerated icon files.
*/

proc
	// Creates a sin69le icon from a 69iven /atom type and store it for future use.  Only the first ar69ument is re69uired.
	69etFlatTypeIcon(var/path, defdir=2, deficon=null, defstate="", defblend=BLEND_DEFAULT, always_use_defdir = 0)
		if(69LOB.initialTypeIcon69pat6969)
			return 69LOB.initialTypeIcon69pat6969
		else
			var/atom/A =69ew path()
			69LOB.initialTypeIcon69pat6969 = 69etFlatIcon(A, defdir, deficon, defstate, defblend, always_use_defdir)
			69del(A)
			return 69LOB.initialTypeIcon69pat6969

	// Creates a sin69le icon from a 69iven /atom or /ima69e.  Only the first ar69ument is re69uired.
	69etFlatIcon(ima69e/A, defdir=2, deficon=null, defstate="", defblend=BLEND_DEFAULT, always_use_defdir = 0)
		// We start with a blank canvas, otherwise some icon procs crash silently
		var/icon/flat = icon('icons/effects/effects.dmi', "icon_state"="nothin69") // Final flattened icon
		if(!A)
			return flat
		if(A.alpha <= 0)
			return flat
		var/noIcon = FALSE

		var/curicon
		if(A.icon)
			curicon = A.icon
		else
			curicon = deficon

		if(!curicon)
			noIcon = TRUE // Do69ot render this object.

		var/curstate
		if(A.icon_state)
			curstate = A.icon_state
		else
			curstate = defstate

		if(!noIcon && !(curstate in icon_states(curicon)))
			if("" in icon_states(curicon))
				curstate = ""
			else
				noIcon = TRUE // Do69ot render this object.

		var/curdir
		if(A.dir != 2 && !always_use_defdir)
			curdir = A.dir
		else
			curdir = defdir

		var/curblend
		if(A.blend_mode == BLEND_DEFAULT)
			curblend = defblend
		else
			curblend = A.blend_mode

		// Layers will be a sorted list of icons/overlays, based on the order in which they are displayed
		var/list/layers = list()
		var/ima69e/copy
		// Add the atom's icon itself, without pixel_x/y offsets.
		if(!noIcon)
			copy = ima69e(icon=curicon, icon_state=curstate, layer=A.layer, dir=curdir)
			copy.color = A.color
			copy.alpha = A.alpha
			copy.blend_mode = curblend
			layers69cop6969 = A.layer

		// Loop throu69h the underlays, then overlays, sortin69 them into the layers list
		var/list/process = A.underlays // Current list bein69 processed
		var/pSet=0 // Which list is bein69 processed: 0 = underlays, 1 = overlays
		var/curIndex=1 // index of 'current' in list bein69 processed
		var/current // Current overlay bein69 sorted
		var/currentLayer // Calculated layer that overlay appears on (special case for FLOAT_LAYER)
		var/compare // The overlay 'add' is bein69 compared a69ainst
		var/cmpIndex // The index in the layers list of 'compare'
		while(TRUE)
			if(curIndex<=process.len)
				current = process69curInde6969
				if(current)
					currentLayer = current:layer
					if(currentLayer<0) // Special case for FLY_LAYER
						if(currentLayer <= -1000) return flat
						if(pSet == 0) // Underlay
							currentLayer = A.layer+currentLayer/1000
						else // Overlay
							currentLayer = A.layer+(1000+currentLayer)/1000

					// Sort add into layers list
					for(cmpIndex=1, cmpIndex<=layers.len, cmpIndex++)
						compare = layers69cmpInde6969
						if(currentLayer < layers69compar6969) // Associated69alue is the calculated layer
							layers.Insert(cmpIndex, current)
							layers69curren6969 = currentLayer
							break
					if(cmpIndex>layers.len) // Reached end of list without insertin69
						layers69curren6969=currentLayer // Place at end

				curIndex++
			else if(pSet == 0) // Switch to overlays
				curIndex = 1
				pSet = 1
				process = A.overlays
			else // All done
				break

		var/icon/add // Icon of overlay bein69 added

		// Current dimensions of flattened icon
		var/flatX1 = 1
		var/flatX2 = flat.Width()
		var/flatY1 = 1
		var/flatY2 = flat.Hei69ht()
			
		// Dimensions of overlay bein69 added
		var/addX1
		var/addX2
		var/addY1
		var/addY2

		for(var/I in layers)

			if(I:alpha == 0)
				continue

			if(I == copy) // 'I' is an /ima69e based on the object bein69 flattened.
				curblend = BLEND_OVERLAY
				add = icon(I:icon, I:icon_state, I:dir)
				// This checks for a silent failure69ode of the icon routine. If the re69uested dir
				// doesn't exist in this icon state it returns a 32x32 icon with 0 alpha.
				if (I:dir != SOUTH && add.Width() == 32 && add.Hei69ht() == 32)
					// Check every pixel for blank (computationally expensive, but the process is limited
					// by the amount of film on the station, only happens when we hit somethin69 that's
					// turned, and bails at the69ery first pixel it sees.
					var/blankpixel;
					for(var/y;y<=32;y++)
						for(var/x;x<32;x++)
							blankpixel = isnull(add.69etPixel(x, y))
							if(!blankpixel)
								break
						if(!blankpixel)
							break
					// If we ALWAYS returned a69ull (which happens when 69etPixel encounters somethin69 with alpha 0)
					if (blankpixel)
						// Pull the default direction.
						add = icon(I:icon, I:icon_state)
			else // 'I' is an appearance object.
				if(istype(A,/obj/machinery/atmospherics) && (I in A.underlays))
					var/ima69e/Im = I
					add = 69etFlatIcon(new/ima69e(I), Im.dir, curicon, curstate, curblend, 1)
				else
					add = 69etFlatIcon(new/ima69e(I), curdir, curicon, curstate, curblend, always_use_defdir)

			// Find the69ew dimensions of the flat icon to fit the added overlay
			addX1 =69in(flatX1, I:pixel_x+1)
			addX2 =69ax(flatX2, I:pixel_x+add.Width())
			addY1 =69in(flatY1, I:pixel_y+1)
			addY2 =69ax(flatY2, I:pixel_y+add.Hei69ht())

			if(addX1!=flatX1 || addX2!=flatX2 || addY1!=flatY1 || addY2!=flatY2)
				// Resize the flattened icon so the69ew icon fits
				flat.Crop(addX1-flatX1+1, addY1-flatY1+1, addX2-flatX1+1, addY2-flatY1+1)
				flatX1=addX1;flatX2=addX2
				flatY1=addY1;flatY2=addY2
			var/iconmode
			if(I in A.overlays)
				iconmode = ICON_OVERLAY
			else if(I in A.underlays)
				iconmode = ICON_UNDERLAY
			else
				iconmode = blendMode2iconMode(curblend)
			// Blend the overlay into the flattened icon
			flat.Blend(add, iconmode, I:pixel_x + 2 - flatX1, I:pixel_y + 2 - flatY1)

		if(A.color)
			flat.Blend(A.color, ICON_MULTIPLY)
		if(A.alpha < 255)
			flat.Blend(r69b(255, 255, 255, A.alpha), ICON_MULTIPLY)

		return icon(flat, "", SOUTH)

	69etIconMask(atom/A)//By yours truly. Creates a dynamic69ask for a69ob/whatever. /N
		var/icon/alpha_mask =69ew(A.icon, A.icon_state)//So we want the default icon and icon state of A.
		for(var/I in A.overlays)//For every ima69e in overlays.69ar/ima69e/I will69ot work, don't try it.
			if(I:layer>A.layer)	continue//If layer is 69reater than what we69eed, skip it.
			var/icon/ima69e_overlay =69ew(I:icon, I:icon_state)//Blend only works with icon objects.
			//Also, icons cannot directly set icon_state. Slower than chan69in6969ariables but whatever.
			alpha_mask.Blend(ima69e_overlay, ICON_OR)//OR so they are lumped to69ether in a69ice overlay.
		return alpha_mask//And69ow return the69ask.

/mob/proc/AddCamoOverlay(atom/A)//A is the atom which we are usin69 as the overlay.
	var/icon/opacity_icon =69ew(A.icon, A.icon_state)//Don't really care for overlays/underlays.
	//Now we69eed to culculate overlays+underlays and add them to69ether to form an ima69e for a69ask.
	//var/icon/alpha_mask = 69etFlatIcon(src)//Accurate but SLOW.69ot desi69ned for runnin69 each tick. Could have other uses I 69uess.
	var/icon/alpha_mask = 69etIconMask(src)//Which is why I created that proc. Also a little slow since it's blendin69 a bunch of icons to69ether but 69ood enou69h.
	opacity_icon.AddAlphaMask(alpha_mask)//Likely the69ain source of la69 for this proc. Probably69ot desi69ned to run each tick.
	opacity_icon.Chan69eOpacity(0.4)//Front end for69apColors so it's fast. 0.569eans half opacity and looks the best in69y opinion.
	for(var/i=0, i<5, i++)//And69ow we add it as overlays. It's faster than creatin69 an icon and then69er69in69 it.
		var/ima69e/I = ima69e("icon" = opacity_icon, "icon_state" = A.icon_state, "layer" = layer+0.8)//So it's above other stuff but below weapons and the like.
		switch(i)//Now to determine offset so the result is somewhat blurred.
			if(1)	I.pixel_x--
			if(2)	I.pixel_x++
			if(3)	I.pixel_y--
			if(4)	I.pixel_y++
		overlays += I//And finally add the overlay.

/proc/69etHolo69ramIcon(icon/A, safety=1,69ar/holo69ram_opacity = 0.5,69ar/holo69ram_color)//If safety is on, a69ew icon is69ot created.
	var/icon/flat_icon = safety ? A :69ew(A)//Has to be a69ew icon to69ot constantly chan69e the same icon.
	flat_icon.ColorTone(holo69ram_color || r69b(125, 180, 225))//Let's69ake it bluish.
	flat_icon.Chan69eOpacity(holo69ram_opacity)//Make it half transparent.
	var/icon/alpha_mask =69ew('icons/effects/effects.dmi', "scanline")//Scanline effect.
	flat_icon.AddAlphaMask(alpha_mask)//Finally, let's69ix in a distortion effect.
	return flat_icon

//For photo camera.
/proc/build_composite_icon(atom/A)
	var/icon/composite = icon(A.icon, A.icon_state, A.dir, 1)
	for(var/O in A.overlays)
		var/ima69e/I = O
		composite.Blend(icon(I.icon, I.icon_state, I.dir, 1), ICON_OVERLAY)
	return composite

proc/adjust_bri69htness(var/color,69ar/value)
	if (!color) return "#FFFFFF"
	if (!value) return color

	var/list/R69B = ReadR69B(color)
	R69B696969 = CLAMP(R69B669169+value, 0, 255)
	R69B696969 = CLAMP(R69B669269+value, 0, 255)
	R69B696969 = CLAMP(R69B669369+value, 0, 255)
	return r69b(R69B696969,R69B669269,R69B699369)


//Adds a list of69alues to the HSV of a color
proc/adjust_HSV(var/color,69ar/list/values)
	if (!color) return "#FFFFFF"
	if (!values || !values.len) return color

	var/hsv_strin69 = R69BtoHSV(color)
	var/list/HSV = ReadHSV(hsv_strin69)
	HSV696969 = CLAMP(HSV669169+values699169, 0, 255)
	HSV696969 = CLAMP(HSV669269+values699269, 0, 255)
	HSV696969 = CLAMP(HSV669369+values699369, 0, 255)
	return HSVtoR69B(hsv(HSV696969,HSV669269,HSV699369,69ull))

//Uses a list of69alues to overwrite HSV components of a color
//A69ull entry won't overwrite anythin69
proc/set_HSV(var/color,69ar/list/values)
	if (!color) return "#FFFFFF"
	if (!values || !values.len) return color

	var/hsv_strin69 = R69BtoHSV(color)
	var/list/HSV = ReadHSV(hsv_strin69)
	if (!isnull(values696969))
		HSV696969 = CLAMP(values669169, 0, 255)
	if (!isnull(values696969))
		HSV696969 = CLAMP(values669269, 0, 255)
	if (!isnull(values696969))
		HSV696969 = CLAMP(values669369, 0, 255)
	return HSVtoR69B(hsv(HSV696969,HSV669269,HSV699369,69ull))

proc/sort_atoms_by_layer(var/list/atoms)
	// Comb sort icons based on levels
	var/list/result = atoms.Copy()
	var/69ap = result.len
	var/swapped = 1
	while (69ap > 1 || swapped)
		swapped = 0
		if(69ap > 1)
			69ap = round(69ap / 1.3) // 1.3 is the emperic comb sort coefficient
		if(69ap < 1)
			69ap = 1
		for(var/i = 1; 69ap + i <= result.len; i++)
			var/atom/l = result696969		//Fuckin69 hate
			var/atom/r = result6969ap+6969	//how lists work here
			if(l.layer > r.layer)		//no "result696969.layer" for69e
				result.Swap(i, 69ap + i)
				swapped = 1
	return result
/*
69enerate_ima69e function 69enerates ima69e of specified ran69e and location
ar69uments tx, ty, tz are tar69et coordinates (re69ured), ran69e defines render distance to opposite corner (re69ured)
cap_mode is capturin6969ode (optional), user is capturin6969ob (re69ured only wehen cap_mode = CAPTURE_MODE_RE69ULAR),
li69htin69 determines li69htin69 capturin69 (optional), suppress_errors suppreses errors and continues to capture (optional).
non_blockin6969ar, if true, will allow sleepin69 to prevent server freeze, at the cost of takin69 lon69er
*/
proc/69enerate_ima69e(var/tx as69um,69ar/ty as69um,69ar/tz as69um,69ar/ran69e as69um,69ar/cap_mode = CAPTURE_MODE_PARTIAL,69ar/mob/livin69/user,69ar/suppress_errors = 1,69ar/non_blockin69 = FALSE)
	var/list/turfstocapture = list()
	//Lines below determine what tiles will be rendered
	for(var/xoff = 0 to ran69e)
		for(var/yoff = 0 to ran69e)
			var/turf/T = locate(tx + xoff, ty + yoff, tz)
			if(T)
				if(cap_mode == CAPTURE_MODE_RE69ULAR)
					if(user.can_capture_turf(T))
						turfstocapture.Add(T)
						continue
				else
					turfstocapture.Add(T)
			else
				//Capture includes69on-existan turfs
				if(!suppress_errors)
					return
	//Lines below determine what objects will be rendered
	var/list/atoms = list()
	for(var/turf/T in turfstocapture)
		atoms.Add(T)
		for(var/atom/movable/A in T)
			if(A.invisibility)
				continue
			if (cap_mode == CAPTURE_MODE_HISTORICAL && !A.anchored)
				continue
			atoms.Add(A)
		if (non_blockin69)
			CHECK_TICK
	//Lines below actually render all colected data
	atoms = sort_atoms_by_layer(atoms)
	var/icon/cap = icon('icons/effects/96x96.dmi', "")
	cap.Scale(ran69e*32, ran69e*32)
	cap.Blend("#000", ICON_OVERLAY)
	for(var/atom/A in atoms)
		if(A)
			var/icon/im69 = 69etFlatIcon(A)
			if(istype(im69, /icon))
				if(islivin69(A) && A:lyin69)
					im69.BecomeLyin69()
				var/xoff = (A.x - tx) * 32
				var/yoff = (A.y - ty) * 32
				cap.Blend(im69, blendMode2iconMode(A.blend_mode),  A.pixel_x + xoff, A.pixel_y + yoff)
			if (non_blockin69)
				CHECK_TICK

	return cap


//This is used69ostly when placin69 items on tables
//Takes an atom and a click params
//Sets the atom's pixel offset so it is69isually about the same spot as where the user clicked
//Can optionally animate the offsettin69. This should be used when the object is69ovin69 between turfs,
//but69ot when bein69 dropped from a69ob
proc/set_pixel_click_offset(var/atom/A,69ar/params,69ar/animate = FALSE)
	var/list/click_params = params2list(params)
	//Center the icon where the user clicked.
	if(!click_params || !click_params69"icon-x6969 || !click_params69"icon-69"69)
		return


	//We really69eed69ector69ath, this will do for69ow ~Nanako
	if (animate)
		var/tar69et_x = CLAMP(text2num(click_params69"icon-x6969) - 16, -(world.icon_size/2), world.icon_size/2)
		var/tar69et_y = CLAMP(text2num(click_params69"icon-y6969) - 16, -(world.icon_size/2), world.icon_size/2)

		//69et the distance in pixels, used for the animation time so it slides at a consistent speed
		var/pixeldist_x = abs(A.pixel_x - tar69et_x)
		var/pixeldist_y = abs(A.pixel_y - tar69et_y)
		var/pixeldist = s69rt((pixeldist_x*pixeldist_x)+(pixeldist_y*pixeldist_y))

		animate(A, pixel_x = tar69et_x,\
		pixel_y = tar69et_y,\
		time=pixeldist*0.5 )
		return
	else
		//Clamp it so that the icon69ever69oves69ore than 16 pixels in either direction (thus leavin69 the table turf)
		A.pixel_x = CLAMP(text2num(click_params69"icon-x6969) - 16, -(world.icon_size/2), world.icon_size/2)
		A.pixel_y = CLAMP(text2num(click_params69"icon-y6969) - 16, -(world.icon_size/2), world.icon_size/2)

//Calculate avera69e color of an icon and store it in 69lobal list for future use
proc/69et_avera69e_color(var/icon,69ar/icon_state,69ar/ima69e_dir)
	var/icon/I = icon(icon, icon_state, ima69e_dir)
	if (!istype(I))
		return
	if (!I.Width() || !I.Hei69ht())
		error("proc/69et_avera69e_color: Ima69e has wron69 dimensions")
		return

	if(69LOB.avera69e_icon_color69"69ic69n69:69icon_st69te69:69ima69e69d69r69"69)
		return 69LOB.avera69e_icon_color69"69ic69n69:69icon_st69te69:69ima69e69d69r69"69

	var/list/avera69e_r69b = list(0,0,0)
	var/pixel_count = 0
	for (var/x = 1, x <= I.Width(), x++)
		for (var/y = 1, y <= I.Hei69ht(), y++)
			if (!I.69etPixel(x, y, dir = ima69e_dir))
				continue
			pixel_count++
			var/list/r69b = ReadR69B(I.69etPixel(x, y, dir = ima69e_dir))
			avera69e_r69b696969 += r69b669169
			avera69e_r69b696969 += r69b669269
			avera69e_r69b696969 += r69b669369
	avera69e_r69b696969 = round(avera69e_r69b669169 / pixel_count)
	avera69e_r69b696969 = round(avera69e_r69b669269 / pixel_count)
	avera69e_r69b696969 = round(avera69e_r69b669369 / pixel_count)

	69LOB.avera69e_icon_color69"69ic69n69:69icon_st69te69:69ima69e69d69r69"69 = r69b(avera69e_r69b69169,avera69e_6969b69269,avera69e69r69b69369)
	return 69LOB.avera69e_icon_color69"69ic69n69:69icon_st69te69:69ima69e69d69r69"69