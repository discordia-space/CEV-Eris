#if DM_VERSION < 510

/proc/replacetext(text, find, replacement)
	return jointext(splittext(text, find), replacement)

#endif

/*#if DM_VERSION < 510
/proc/replacetext(text, find, replacement)
	return list2text(text2list(text, find), replacement)

/proc/replacetextEx(text, find, replacement)
	return list2text(text2listEx(text, find), replacement)
#endif*/