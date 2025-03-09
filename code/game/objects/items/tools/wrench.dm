/obj/item/wrench
	name = "гаечный ключ"
	desc = "Гаечный ключ общего назначения. Его можно найти в вашей руке."
	icon = 'icons/obj/tools.dmi'
	icon_state = "wrench"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	item_flags = SURGICAL_TOOL
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL
	usesound = 'sound/items/ratchet.ogg'
	custom_materials = list(/datum/material/iron=150)
	drop_sound = 'sound/items/handling/wrench_drop.ogg'
	pickup_sound = 'sound/items/handling/wrench_pickup.ogg'

	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	tool_behaviour = TOOL_WRENCH
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)

	wound_bonus = 5
	bare_wound_bonus = 6

/obj/item/wrench/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is beating themself to death with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(loc, 'sound/weapons/genhit.ogg', 50, 1, -1)
	return (BRUTELOSS)

/obj/item/wrench/cyborg
	name = "автоматический гаечный ключ"
	desc = "Усовершенствованный роботизированный гаечный ключ. Его можно найти в разделе строительные киборги."
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "wrench_cyborg"
	toolspeed = 0.5

/obj/item/wrench/combat
	name = "боевой гаечный ключ"
	desc = "Он похож на обычный гаечный ключ, но более острый. Его можно найти на поле боя."
	icon = 'icons/obj/tools.dmi'
	icon_state = "wrench_combat"
	item_state = "wrench_combat"
	attack_verb_continuous = list("devastates", "brutalizes", "commits a war crime against", "obliterates", "humiliates")
	attack_verb_simple = list("devastate", "brutalize", "commit a war crime against", "obliterate", "humiliate")
	tool_behaviour = null
	toolspeed = null

/obj/item/wrench/combat/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = 10, \
		throwforce_on = 15, \
		hitsound_on = hitsound, \
		w_class_on = WEIGHT_CLASS_NORMAL, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Gives it wrench behaviors when active.
 */
/obj/item/wrench/combat/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(active)
		tool_behaviour = TOOL_WRENCH
		toolspeed = 1
	else
		tool_behaviour = initial(tool_behaviour)
		toolspeed = initial(toolspeed)

	balloon_alert(user, "[name] [active ? "active, woe!":"restrained"]")
	playsound(user ? user : src, active ? 'sound/weapons/saberon.ogg' : 'sound/weapons/saberoff.ogg', 5, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE


/obj/item/wrench/brass
	name = "латунный гаечный ключ"
	desc = "Латунный гаечный ключ. Он слегка теплый на ощупь."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	icon_state = "wrench_clock"
	toolspeed = 0.5

/obj/item/wrench/brass/family
	toolspeed = 1

/obj/item/wrench/ashwalker
	name = "костный гаечный ключ"
	desc = "Дрянной гаечный ключ, сделанный из согнутых костей и сухожилий."
	icon = 'icons/obj/mining.dmi'
	icon_state = "wrench_bone"
	toolspeed = 0.75

/obj/item/wrench/bronze
	name = "гаечный ключ с бронзовым покрытием"
	desc = "Просто ключ, гаечный ключ, но имеет бронзовое покрытие."
	icon_state = "wrench_brass"
	toolspeed = 0.95

/obj/item/wrench/abductor
	name = "инопланетный гаечный ключ"
	desc = "Гаечный ключ с поляризацией. Он поворачивает все, что находится между зажимами."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "wrench"
	usesound = 'sound/effects/empulse.ogg'
	toolspeed = 0.1

/obj/item/wrench/power
	name = "ручная дрель"
	desc = "Универсальная дрель, что может закручивать болты, а так же откручивать винты."
	icon_state = "drill_bolt"
	item_state = "drill"
	lefthand_file = 'modular_sand/icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'modular_sand/icons/mob/inhands/equipment/tools_righthand.dmi'
	usesound = 'sound/items/drill_use.ogg'
	custom_materials = list(/datum/material/iron=150,/datum/material/silver=50,/datum/material/titanium=25)
 //done for balance reasons, making them high value for research, but harder to get
	force = 8 //might or might not be too high, subject to change
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 8
	attack_verb = list("drilled", "screwed", "jabbed")
	toolspeed = 0.25

/obj/item/wrench/power/attack_self(mob/user)
	playsound(get_turf(user),'sound/items/change_drill.ogg',50,1)
	var/obj/item/wirecutters/power/s_drill = new /obj/item/screwdriver/power(drop_location())
	to_chat(user, "<span class='notice'>You attach the screw driver bit to [src].</span>")
	qdel(src)
	user.put_in_active_hand(s_drill)

/obj/item/wrench/power/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is pressing [src] against [user.ru_ego()] head! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (BRUTELOSS)

/obj/item/wrench/medical
	name = "медицинский гаечный ключ"
	desc = "Медицинский гаечный ключ для обычного (медицинского?) использования. Его можно найти в вашей руке."
	icon_state = "wrench_medical"
	force = 2 //MEDICAL
	throwforce = 4

	attack_verb = list("wrenched", "medicaled", "tapped", "jabbed", "whacked")

/obj/item/wrench/medical/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] is praying to the medical wrench to take [user.ru_ego()] soul. It looks like [user.p_theyre()] trying to commit suicide!</span>")
	// TODO Make them glow with the power of the M E D I C A L W R E N C H
	// during their ascension

	// Stun stops them from wandering off
	user.Stun(100, ignore_canstun = TRUE)
	playsound(loc, 'sound/effects/pray.ogg', 50, 1, -1)

	// Let the sound effect finish playing
	sleep(20)

	if(!user)
		return

	for(var/obj/item/W in user)
		user.dropItemToGround(W)

	var/obj/item/wrench/medical/W = new /obj/item/wrench/medical(loc)
	W.add_fingerprint(user)
	W.desc += " For some reason, it reminds you of [user.name]."

	if(!user)
		return

	user.dust()

	return OXYLOSS

/obj/item/wrench/advanced
	name = "усовершенствованный гаечный ключ"
	desc = "Гаечный ключ, в котором используется та же магнитная технология, что и в инструментах для похищения, но несколько более неэффективно."
	icon = 'icons/obj/advancedtools.dmi'
	icon_state = "wrench"
	usesound = 'sound/effects/empulse.ogg'
	toolspeed = 0.2
