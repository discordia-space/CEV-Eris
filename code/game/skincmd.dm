/mob/var/skincmds = list()
/obj/proc/SkinCmd(mob/user as69ob,69ar/data as text)

/proc/SkinCmdRe69ister(var/mob/user,69ar/name as text,69ar/O as obj)
			user.skincmds69name69 = O

/mob/verb/skincmd(data as text)
	set hidden = 1

	var/ref = copytext(data, 1, findtext(data, ";"))
	if (src.skincmds69ref69 != null)
		var/obj/a = src.skincmds69ref69
		a.SkinCmd(src, copytext(data, findtext(data, ";") + 1))