# General

* Pull requests should not contain commented code except TODOs and explanation comments.
* Pull requests should not contain any debug output, variables or procs.
* Pull requests should not contain changes that do not relate with functionality described in commit messages.
* If pull request relates with existing github issue, it should be specified in commit message, for example, "Fix broken floor sprites, close #23" (see https://help.github.com/articles/closing-issues-via-commit-messages/ for additional info).
* If pull request contains map files changes, it should be previously proccessed by mapmerger tool (see /tool/mapmerger/install.txt for additional info). Pull request description should contain screenshots of map changes if it's not obvious from map files diff.
* If pull request contains icon files changes, it should be previously proccessed by icon merger tool (see /tool/dmitool/merging.txt for additional info). Pull request description should contain screenshots of changed icon files.


# Code style

Proc defines should contain full type path.

***Good:***
```
/obj/item/pistol/proc/fire()

/obj/item/pistol/proc/reload()
```
***Bad:***

```
/obj/item/pistol
    proc
	fire()

    proc/reload()
```
***
If, else, for, return, continue and break expressions should not be inline.

***Good:***
```
if(condition)
    foo()
```
```
for(var/object in objects)
    foo(object)
```
***Bad:***
```
if(condition) foo()
```
```
for(var/object in objects) foo(object)
```
***

Spaces are needed between function agruments (declaration and definition). Spaces are needed between the binary operator and arguments. Space is not needed when the operation is unary. Spaces are not needed near brackets. Spaces are needed around assignment operator.

***Good:***
```
/obj/item/pistol/fire(var/user, var/target)
    if(can_fire() && target)
        ammo--
        var/corpse = target
```
***Bad:***
```
/obj/item/pistol/fire(var/user,var/target)
    if ( can_fire()&&target )
        ammo --
        var/corpset=target
```
***

Boolean variables and return values should use TRUE and FALSE constans instead of 1 and 0.

***Good:***
```
/obj/item/pistol/
	var/broken = FALSE

/obj/item/pistol/proc/can_fire()
	return TRUE
```
***Bad:***
```
/obj/item/pistol/
	var/broken = 0

/obj/item/pistol/proc/can_fire()
	return 1
```
***

Using colon operator (:) for object property and procs access is deprecated.

***Good:***
```
var/obj = new obj()
var/count = obj.count
```
***Bad:***
```
var/obj = new obj()
if(hasvar(obj, "count"))
	var/count = obj:count
```
***

Colorized text outputs should use html tags instead of magic color symbols.

***Good:***
```
player << "<span class='notice'>Everything is OK.</span>"
player << "<span class='warning'>There's something wrong...</span>"
player << "<span class='danger'>Everything is fucked up!</span>"
```
***Bad:***
```
player << "\blue Everything is OK."
player << "\red \bold Everything is fucked up!"
```
***

del() usage is deprecated, use qdel() instead.

***Good:***
```
qdel(src)
```
***Bad:***
```
del(src)
```
***

Do not return unused values from functions. Do not use return if there's no any actions in function after it. 

***Good:***
```
proc/mutate_count(var/obj, var/value)
	if(!value)
	    return
    obj.count = value
```
***Bad:***
```
proc/mutate_count(var/obj, var/value)
	obj.count = value
	return 1
```
***

Instance variables should be used with only with source object denotation to avoid namespace conflicts.

***Good:***
```
/obj/item/
	var/name = ""
	
/obj/item/proc/set_name(name)
	src.name = name
```
***Bad:***
```
/obj/item/
	var/name = ""

/obj/item/proc/set_name(name)
	name = name
	# You will probably get a runtime error.
```

# Naming
Avoid short names. No acronyms or abbreviations.

***Good:***
```
/obj/proximity_sensor/update_sprites()
var/count = 0
```
***Bad:***
```
/obj/prox_sensor/upd_sprites()
var/c = 1
```
***
Avoid digits in names.

***Good:***
```
/datum/job/first_officer
```
***Bad:***
```
var/text1 = "text"
```
***
Variables, types and methods should be named in "snake case". Constant values should be named in uppercase. 

***Good:***
```
proc/redraw_icons()
#define SHIP_NAME "Eris"
```
***Bad:***
```
proc/Reload_gun()
var/brigArea
```
***
