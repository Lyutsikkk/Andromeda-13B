/**
  * # Energy Katana
  *
  * The space ninja's katana.
  *
  * The katana that only space ninja spawns with.  Comes with 30 force and throwforce, along with a signature special jaunting system.
  * Upon clicking on a tile with the dash on, the user will teleport to that tile, assuming their target was not dense.
  * The katana has 3 dashes stored at maximum, and upon using the dash, it will return 20 seconds after it was used.
  * It also has a special feature where if it is tossed at a space ninja who owns it (determined by the ninja suit), the ninja will catch the katana instead of being hit by it.
  *
  */
/obj/item/energy_katana
	name = "energy katana"
	desc = "A katana infused with strong energy."
	icon_state = "energy_katana"
	item_state = "energy_katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 25
	throwforce = 25
	block_chance = 45
	armour_penetration = 25
	wound_bonus = 6
	bare_wound_bonus = 12
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	slot_flags = ITEM_SLOT_BELT
	sharpness = SHARP_EDGED
	obj_flags = UNIQUE_RENAME // here is a shitpost and i cannot wait for ninjas naming their sword very rude things
	max_integrity = 200
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/datum/effect_system/spark_spread/spark_system
	var/datum/action/innate/dash/ninja/jaunt
	var/dash_toggled = TRUE

/obj/item/energy_katana/Initialize(mapload)
	. = ..()
	jaunt = new(src)
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/energy_katana/attack_self(mob/user)
	dash_toggled = !dash_toggled
	to_chat(user, "<span class='notice'>You [dash_toggled ? "enable" : "disable"] the dash function on [src].</span>")

/obj/item/energy_katana/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/clothing/suit/space/space_ninja/ninja_suit = H.wear_suit
	if(!istype(ninja_suit))// do you actually have a ninja suit on
		to_chat(user, "<span class='warning'><b>ERROR</b>: garments incompatible with carbon material jaunt. Please suit up in compatible garments.</span>")
		return
	if(!dash_toggled || Adjacent(target) || target.density)// is where you are going not a wall
		return
	if(!ninja_suit.s_coold == 0)// are you not currently on the ability cooldown
		to_chat(user, "<span class='warning'><b>ERROR</b>: suit is on cooldown.</span>")
		return
	jaunt.Teleport(user, target)// okay you can now go my good sir

/obj/item/energy_katana/pickup(mob/living/user)
	. = ..()
	jaunt.Grant(user, src)
	user.update_icons()
	playsound(src, 'sound/items/unsheath3.ogg', 25, 1)

/obj/item/energy_katana/dropped(mob/user)
	. = ..()
	jaunt.Remove(user)
	user.update_icons()

//If we hit the Ninja who owns this Katana, they catch it.
//Works for if the Ninja throws it or it throws itself or someone tries
//To throw it at the ninja
/obj/item/energy_katana/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(ishuman(hit_atom))
		var/mob/living/carbon/human/hit_human = hit_atom
		if(istype(hit_human.wear_suit, /obj/item/clothing/suit/space/space_ninja))
			var/obj/item/clothing/suit/space/space_ninja/ninja_suit = hit_human.wear_suit
			if(ninja_suit.energyKatana == src)
				returnToOwner(hit_human, 0, 1)
				return

	..()

/obj/item/energy_katana/Destroy()
	QDEL_NULL(spark_system)
	QDEL_NULL(jaunt)
	return ..()

/**
  * Proc called when the katana is recalled to its space ninja.
  *
  * Proc called when space ninja is hit with its suit's katana or the recall ability is used.
  * Arguments:
  * * user - To whom the katana is returning to.
  * * doSpark - whether or not the katana will spark when it returns.
  * * caught - boolean for whether or not the katana was caught or was teleported back.
  */
/obj/item/energy_katana/proc/returnToOwner(mob/living/carbon/human/user, doSpark = TRUE, caught = FALSE)
	if(!istype(user))
		return
	forceMove(get_turf(user))

	if(doSpark)
		spark_system.start()
		playsound(get_turf(src), "sparks", 50, 1)

	var/msg = ""

	if(user.put_in_hands(src))
		msg = "Your Energy Katana teleports into your hand!"
	else if(user.equip_to_slot_if_possible(src, ITEM_SLOT_BELT, 0, 1, 1))
		msg = "Your Energy Katana teleports back to you, sheathing itself as it does so!</span>"
	else
		msg = "Your Energy Katana teleports to your location!"

	if(caught)
		if(loc == user)
			msg = "You catch your Energy Katana!"
		else
			msg = "Your Energy Katana lands at your feet!"

	if(msg)
		to_chat(user, "<span class='notice'>[msg]</span>")

/obj/item/energy_katana/attack(mob/living/target, mob/living/carbon/human/user)
	if(user.mind && !(user.mind.has_antag_datum(/datum/antagonist/ninja)))
		user.DefaultCombatKnockdown(100)
		user.dropItemToGround(src, TRUE)
		to_chat(user, "<span class='danger'><B>fÄTaL ÈÈRRoR</B>: 382200-*#00CÖDE <B>RED</B>\nUNAUHORIZED USÈ DETÈCeD\nCoMMÈNCING SUB-R0UIN3 13...\nTÈRMInATING U-U-USÈR...</span>")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2,force))
	..()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/item/energy_naginata
	name = "energy naginata"
	desc = "A weapon resembling naginata infused with strong energy."
	icon_state = "energy_naginata"
	item_state = "energy_naginata1"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 40
	throwforce = 15
	block_chance = 55
	armour_penetration = 39
	wound_bonus = 7
	bare_wound_bonus = 14
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/bladeslice2.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	slot_flags = ITEM_SLOT_BELT
	sharpness = SHARP_EDGED
	obj_flags = UNIQUE_RENAME
	max_integrity = 200
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	block_parry_data = /datum/block_parry_data/dual_esword
	var/datum/effect_system/spark_spread/spark_system
	var/datum/action/innate/dash/ninja/ronin/jaunt_ronin
	var/dash_toggled = TRUE

/obj/item/energy_naginata/check_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	block_return[BLOCK_RETURN_REFLECT_PROJECTILE_CHANCE] = 100
	return ..()

/obj/item/energy_naginata/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if((is_energy_reflectable_projectile(object) ||  !is_energy_reflectable_projectile(object)) && (attack_type & ATTACK_TYPE_PROJECTILE) && prob(75))
		block_return[BLOCK_RETURN_REDIRECT_METHOD] = REDIRECT_METHOD_RETURN_TO_SENDER			//no you
		owner.visible_message("<span class='danger'>Ranged attacks just make [owner] angrier!</span>")
		playsound(src, pick('sound/weapons/bulletflyby.ogg', 'sound/weapons/bulletflyby2.ogg', 'sound/weapons/bulletflyby3.ogg'), 75, 1)
		return BLOCK_SHOULD_REDIRECT | BLOCK_SUCCESS | BLOCK_REDIRECTED
	return ..()

/obj/item/energy_naginata/Initialize(mapload)
	. = ..()
	jaunt_ronin = new(src)
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/energy_naginata/attack_self(mob/user)
	dash_toggled = !dash_toggled
	to_chat(user, "<span class='notice'>You [dash_toggled ? "enable" : "disable"] the dash function on [src].</span>")

/obj/item/energy_naginata/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/clothing/suit/space/space_ninja/ronin/ninja_suit = H.wear_suit
	if(!istype(ninja_suit))// do you actually have a ninja suit on
		to_chat(user, "<span class='warning'><b>ERROR</b>: garments incompatible with carbon material jaunt. Please suit up in compatible garments.</span>")
		return
	if(!dash_toggled || Adjacent(target) || target.density)// is where you are going not a wall
		return
	if(!ninja_suit.s_coold == 0)// are you not currently on the ability cooldown
		to_chat(user, "<span class='warning'><b>ERROR</b>: suit is on cooldown.</span>")
		return
	jaunt_ronin.Teleport(user, target)// okay you can now go my good sir

/obj/item/energy_naginata/pickup(mob/living/user)
	. = ..()
	jaunt_ronin.Grant(user, src)
	user.update_icons()
	playsound(src, 'sound/items/unsheath2.ogg', 25, 1)

/obj/item/energy_naginata/dropped(mob/user)
	. = ..()
	jaunt_ronin.Remove(user)
	user.update_icons()

/obj/item/energy_naginata/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(ishuman(hit_atom))
		var/mob/living/carbon/human/hit_human = hit_atom
		if(istype(hit_human.wear_suit, /obj/item/clothing/suit/space/space_ninja/ronin))
			var/obj/item/clothing/suit/space/space_ninja/ninja_suit = hit_human.wear_suit
			if(ninja_suit.energyNaginata == src)
				returnToOwner(hit_human, 0, 1)
				return

	..()

/obj/item/energy_naginata/Destroy()
	QDEL_NULL(spark_system)
	QDEL_NULL(jaunt_ronin)
	return ..()

/obj/item/energy_naginata/proc/returnToOwner(mob/living/carbon/human/user, doSpark = TRUE, caught = FALSE)
	if(!istype(user))
		return
	forceMove(get_turf(user))

	if(doSpark)
		spark_system.start()
		playsound(get_turf(src), "sparks", 50, 1)

	var/msg = ""

	if(user.put_in_hands(src))
		msg = "Your Energy Naginata teleports into your hand!"
	else if(user.equip_to_slot_if_possible(src, ITEM_SLOT_BELT, 0, 1, 1))
		msg = "Your Energy Naginata teleports back to you, sheathing itself as it does so!</span>"
	else
		msg = "Your Energy Naginata teleports to your location!"

	if(caught)
		if(loc == user)
			msg = "You catch your Energy Naginata!"
		else
			msg = "Your Energy Naginata lands at your feet!"

	if(msg)
		to_chat(user, "<span class='notice'>[msg]</span>")

/obj/item/energy_naginata/attack(mob/living/target, mob/living/carbon/human/user)
	if(user.mind && !(user.mind.has_antag_datum(/datum/antagonist/ninja)))
		user.DefaultCombatKnockdown(100)
		user.dropItemToGround(src, TRUE)
		to_chat(user, "<span class='danger'><B>fÄTaL ÈÈRRoR</B>: 382200-*#00CÖDE <B>RED</B>\nUNAUHORIZED USÈ DETÈCeD\nCoMMÈNCING SUB-R0UIN3 13...\nTÈRMInATING U-U-USÈR...</span>")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2,force))
	..()

/obj/item/energy_naginata/proc/explode()
	do_sparks(3, 1, src)
	explosion(src.loc,0,1,1,1)
	qdel(src)


///////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/action/innate/dash/ninja
	current_charges = 3
	max_charges = 3
	charge_rate = 200
	recharge_sound = null

/datum/action/innate/dash/ninja/ronin
	current_charges = 2
	max_charges = 2
	//charge_rate = 150
	beam_effect = "blood_beam"
	phasein = /obj/effect/temp_visual/dir_setting/cult/phase
	phaseout = /obj/effect/temp_visual/dir_setting/cult/phase/out


