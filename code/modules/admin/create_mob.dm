/var/create_mob_html
/datum/admins/proc/create_mob(var/mob/user)
	if (!create_mob_html)
		var/mobjs
		mobjs = jointext(typesof(/mob), ";")
		create_mob_html = file2text('html/create_object.html')
		create_mob_html = replacetext(create_mob_html, "null /* object types */", "\"69mobjs69\"")

	user << browse(replacetext(create_mob_html, "/* ref src */", "\ref69src69"), "window=create_mob;size=425x475")
