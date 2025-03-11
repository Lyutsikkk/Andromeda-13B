/obj/item/wirecutters
	name = "кусачки"
	desc = "Это перерезает провода и не только."
	icon = 'icons/obj/tools.dmi'
	icon_state = "cutters_map"
	item_state = "cutters"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	item_flags = SURGICAL_TOOL
	force = 6
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron=80)
	attack_verb = list("pinched", "nipped")
	hitsound = 'sound/items/wirecutter.ogg'
	usesound = 'sound/items/wirecutter.ogg'
	drop_sound = 'sound/items/handling/wirecutter_drop.ogg'
	pickup_sound = 'sound/items/handling/wirecutter_pickup.ogg'
	tool_behaviour = TOOL_WIRECUTTER
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)
	var/random_color = TRUE
	var/static/list/wirecutter_colors = list(
		"blue" = rgb(24, 97, 213),
		"red" = rgb(255, 0, 0),
		"pink" = rgb(213, 24, 141),
		"brown" = rgb(160, 82, 18),
		"green" = rgb(14, 127, 27),
		"cyan" = rgb(24, 162, 213),
		"yellow" = rgb(255, 165, 0)
	)


/obj/item/wirecutters/Initialize(mapload)
	. = ..()
	if(random_color) //random colors!
		var/our_color = pick(wirecutter_colors)
		add_atom_colour(wirecutter_colors[our_color], FIXED_COLOUR_PRIORITY)
		update_icon()

/obj/item/wirecutters/update_overlays()
	. = ..()
	if(!random_color) //icon override
		return
	var/mutable_appearance/base_overlay = mutable_appearance(icon, "cutters_cutty_thingy")
	base_overlay.appearance_flags = RESET_COLOR
	. += base_overlay

/obj/item/wirecutters/worn_overlays(isinhands = FALSE, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(isinhands && random_color)
		var/mutable_appearance/M = mutable_appearance(icon_file, "cutters_cutty_thingy")
		M.appearance_flags = RESET_COLOR
		. += M

/obj/item/wirecutters/get_belt_overlay()
	if(random_color)
		var/mutable_appearance/body = mutable_appearance('icons/obj/clothing/belt_overlays.dmi', "cutters")
		var/mutable_appearance/head = mutable_appearance('icons/obj/clothing/belt_overlays.dmi', "cutters_cutty_thingy")
		body.color = color
		head.add_overlay(body)
		return head
	else
		return mutable_appearance('icons/obj/clothing/belt_overlays.dmi', icon_state)

/obj/item/wirecutters/attack(mob/living/carbon/C, mob/user)
	if(istype(C) && C.handcuffed && istype(C.handcuffed, /obj/item/restraints/handcuffs/cable))
		user.visible_message("<span class='notice'>[user] cuts [C]'s restraints with [src]!</span>")
		qdel(C.handcuffed)
		return
	else
		..()

/obj/item/wirecutters/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is cutting at [user.ru_ego()] arteries with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(loc, usesound, 50, 1, -1)
	return (BRUTELOSS)

/obj/item/wirecutters/brass
	name = "латунные кусачки"
	desc = "Пара изящных кусачек для проволоки, но сделаны из латуни. Ручка на ощупь очень холодная."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	icon_state = "cutters_clock"
	random_color = FALSE
	toolspeed = 0.5

/obj/item/wirecutters/brass/family
	toolspeed = 1

/obj/item/wirecutters/ashwalker
	name = "костяные кусачки"
	desc = "Примитивные кусачки для проволоки, сделанные из заостренных костей и сухожилий."
	icon = 'icons/obj/mining.dmi'
	icon_state = "cutters_bone"
	toolspeed = 0.75
	random_color = FALSE

/obj/item/wirecutters/bronze
	name = "кусачки с бронзовым покрытием"
	desc = "Просто кусачки, кусаются, но с бронзовым покрытием."
	icon_state = "cutters_brass"
	random_color = FALSE
	toolspeed = 0.95 //Wire cutters have 0 time bars though

/obj/item/wirecutters/abductor
	name = "инопланетные кусачки"
	desc = "Чрезвычайно острые кусачки для проволоки, изготовленные из серебристо-зеленого металла."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cutters"
	toolspeed = 0.1
	random_color = FALSE

/obj/item/wirecutters/cyborg
	name = "кусачки"
	desc = "Это перерезает провода и не только."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "wirecutters_cyborg"
	toolspeed = 0.5
	random_color = FALSE

/obj/item/wirecutters/power
	name = "челюсти жизни"
	desc = "Челюсти жизни - это универсальный инструмент, что может использоваться как лом и как кусачки."
	icon_state = "jaws_cutter"
	item_state = "jawsoflife"
	lefthand_file = 'modular_sand/icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'modular_sand/icons/mob/inhands/equipment/tools_righthand.dmi'
	custom_materials = list(/datum/material/iron=150,/datum/material/silver=50,/datum/material/titanium=25)

	usesound = 'sound/items/jaws_cut.ogg'
	toolspeed = 0.25
	random_color = FALSE

/obj/item/wirecutters/power/syndicate
	name = "синдикатовские челюсти жизни"
	desc = "Карманная модернизированная копия стандартной модели Челюсти жизни от Nanotrasen. Может использоваться для принудительного открытия воздушных шлюзов в конфигурации с ломом."
	icon = 'icons/obj/tools.dmi'
	icon_state = "jaws_syndie_cutter"
	item_state = "jawsoflife"
	toolspeed = 0.20

/obj/item/wirecutters/power/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is wrapping \the [src] around [user.ru_ego()] neck. It looks like [user.ru_who()] trying to rip [user.ru_ego()] head off!</span>")
	playsound(loc, 'sound/items/jaws_cut.ogg', 50, 1, -1)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		var/obj/item/bodypart/BP = C.get_bodypart(BODY_ZONE_HEAD)
		if(BP)
			BP.drop_limb()
			playsound(loc,pick('sound/misc/desceration-01.ogg','sound/misc/desceration-02.ogg','sound/misc/desceration-01.ogg') ,50, 1, -1)
	return (BRUTELOSS)

/obj/item/wirecutters/power/attack_self(mob/user)
	playsound(get_turf(user), 'sound/items/change_jaws.ogg', 50, 1)
	var/obj/item/crowbar/power/pryjaws = new /obj/item/crowbar/power(drop_location())
	pryjaws.name = name
	to_chat(user, "<span class='notice'>You attach the pry jaws to [src].</span>")
	qdel(src)
	user.put_in_active_hand(pryjaws)

/obj/item/wirecutters/power/attack(mob/living/carbon/C, mob/user)
	if(istype(C))
		if(C.handcuffed)
			user.visible_message("<span class='notice'>[user] cuts [C]'s restraints with [src]!</span>")
			qdel(C.handcuffed)
			return
		else if(C.has_status_effect(STATUS_EFFECT_CHOKINGSTRAND))
			var/man = C == user ? "your" : "[C]'\s"
			user.visible_message("<span class='notice'>[user] attempts to remove the durathread strand from around [man] neck.</span>", \
								"<span class='notice'>You attempt to remove the durathread strand from around [man] neck.</span>")
			if(do_after(user, 1.5 SECONDS, C))
				user.visible_message("<span class='notice'>[user] succesfuly removes the durathread strand.</span>",
									"<span class='notice'>You succesfuly remove the durathread strand.</span>")
				C.remove_status_effect(STATUS_EFFECT_CHOKINGSTRAND)
			return
	..()

/obj/item/wirecutters/advanced
	name = "продвинутые кусачки"
	desc = "Набор копий инопланетных кусачек с серебряной ручкой и чрезвычайно острым лезвием."
	icon = 'icons/obj/advancedtools.dmi'
	icon_state = "cutters"
	toolspeed = 0.2
	random_color = FALSE
