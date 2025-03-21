/obj/item/stack/tile
	name = "broken tile"
	singular_name = "broken tile"
	desc = "A broken tile. This should not exist."
	icon = 'icons/obj/tiles.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 1
	throwforce = 1
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	novariants = TRUE									//sandstorm change - tile floofing
	/// What type of turf does this tile produce.		//included - tile floofing
	var/turf_type = null
	/// Determines certain welder interactions.			//included - tile floofing
	var/mineralType = null
	var/human_maxHealth = 100

/obj/item/stack/tile/Initialize(mapload, amount)
	. = ..()
	if(tile_reskin_types)
		tile_reskin_types = tile_reskin_list(tile_reskin_types)
	pixel_x = rand(-3, 3)
	pixel_y = rand(-3, 3) //randomize a little
	air_update_turf(TRUE) // Почему.

/obj/item/stack/tile/examine(mob/user)
	. = ..()
	if(throwforce && !is_cyborg) //do not want to divide by zero or show the message to borgs who can't throw
		var/verb
		switch(CEILING(human_maxHealth / throwforce, 1)) //throws to crit a human
			if(1 to 3)
				verb = "superb"
			if(4 to 6)
				verb = "great"
			if(7 to 9)
				verb = "good"
			if(10 to 12)
				verb = "fairly decent"
			if(13 to 15)
				verb = "mediocre"
		if(!verb)
			return
		. += "<span class='notice'>Those could work as a [verb] throwing weapon.</span>"

/obj/item/stack/tile/attackby(obj/item/W, mob/user, params)

	if(W.tool_behaviour == TOOL_WELDER)
		if(get_amount() < 4)
			to_chat(user, "<span class='warning'>You need at least four tiles to do this!</span>")
			return

		if(!mineralType)
			to_chat(user, "<span class='warning'>You can not reform this!</span>")
			return

		if(W.use_tool(src, user, 0, volume=40))
			if(mineralType == "plasma")
				atmos_spawn_air("plasma=5;TEMP=1000")
				user.visible_message("<span class='warning'>[user.name] sets the plasma tiles on fire!</span>", \
									"<span class='warning'>You set the plasma tiles on fire!</span>")
				qdel(src)
				return

			if (mineralType == "metal")
				var/obj/item/stack/sheet/metal/new_item = new(user.loc)
				user.visible_message("[user.name] shaped [src] into metal with the welding tool.", \
							 "<span class='notice'>You shaped [src] into metal with the welding tool.</span>", \
							 "<span class='italics'>You hear welding.</span>")
				var/obj/item/stack/rods/R = src
				src = null
				var/replace = (user.get_inactive_held_item()==R)
				R.use(4)
				if (!R && replace)
					user.put_in_hands(new_item)

			else
				var/sheet_type = text2path("/obj/item/stack/sheet/mineral/[mineralType]")
				var/obj/item/stack/sheet/mineral/new_item = new sheet_type(user.loc)
				user.visible_message("[user.name] shaped [src] into a sheet with the welding tool.", \
							"<span class='notice'>You shaped [src] into a sheet with the welding tool.</span>", \
							"<span class='italics'>You hear welding.</span>")
				var/obj/item/stack/rods/R = src
				src = null
				var/replace = (user.get_inactive_held_item()==R)
				R.use(4)
				if (!R && replace)
					user.put_in_hands(new_item)
	else
		return ..()

//Grass
/obj/item/stack/tile/grass
	name = "Grass Tile"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they use on space golf courses."
	icon_state = "tile_grass"
	turf_type = /turf/open/floor/grass
	resistance_flags = FLAMMABLE
	tile_reskin_types = list(
	/obj/item/stack/tile/grass,
	/obj/item/stack/tile/grass/grass0,
	/obj/item/stack/tile/grass/grass1,
	/obj/item/stack/tile/grass/grass2,
	/obj/item/stack/tile/grass/grass3,
	)

/obj/item/stack/tile/grass
	name = "Grass Tile 1"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they use on space golf courses."
	turf_type = /turf/open/floor/grass
	icon_state = "tile_grass"

/obj/item/stack/tile/grass/grass0
	name = "Grass Tile 2"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they use on space golf courses."
	turf_type = /turf/open/floor/grass/grass0
	icon_state = "tile_grass"

/obj/item/stack/tile/grass/grass1
	name = "Grass Tile 3"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they use on space golf courses."
	turf_type = /turf/open/floor/grass/grass1
	icon_state = "tile_grass"

/obj/item/stack/tile/grass/grass2
	name = "Grass Tile 4"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they use on space golf courses."
	turf_type = /turf/open/floor/grass/grass2
	icon_state = "tile_grass"

/obj/item/stack/tile/grass/grass3
	name = "Grass Tile 5"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they use on space golf courses."
	turf_type = /turf/open/floor/grass/grass3
	icon_state = "tile_grass_gross"

/turf/open/floor/grass/grass0
	icon_state = "grass0"

/turf/open/floor/grass/grass1
	icon_state = "grass1"

/turf/open/floor/grass/grass2
	icon_state = "grass2"

/turf/open/floor/grass/grass3
	icon_state = "grass3"

//Fairygrass
/obj/item/stack/tile/fairygrass
	name = "fairygrass tile"
	singular_name = "fairygrass floor tile"
	desc = "A patch of odd, glowing blue grass."
	icon_state = "tile_fairygrass"
	item_state = "tile-fairygrass"
	turf_type = /turf/open/floor/grass/fairy
	resistance_flags = FLAMMABLE
	color = "#33CCFF"

/obj/item/stack/tile/fairygrass/white
	name = "white fairygrass tile"
	singular_name = "white fairygrass floor tile"
	desc = "A patch of odd, glowing white grass."
	turf_type = /turf/open/floor/grass/fairy/white
	color = "#FFFFFF"

/obj/item/stack/tile/fairygrass/red
	name = "red fairygrass tile"
	singular_name = "red fairygrass floor tile"
	desc = "A patch of odd, glowing red grass."
	turf_type = /turf/open/floor/grass/fairy/red
	color = "#FF3333"

/obj/item/stack/tile/fairygrass/yellow
	name = "yellow fairygrass tile"
	singular_name = "yellow fairygrass floor tile"
	desc = "A patch of odd, glowing yellow grass."
	turf_type = /turf/open/floor/grass/fairy/yellow
	color = "#FFFF66"

/obj/item/stack/tile/fairygrass/green
	name = "green fairygrass tile"
	singular_name = "green fairygrass floor tile"
	desc = "A patch of odd, glowing green grass."
	turf_type = /turf/open/floor/grass/fairy/green
	color = "#99FF99"

/obj/item/stack/tile/fairygrass/blue
	name = "blue fairygrass tile"
	singular_name = "blue fairygrass floor tile"
	desc = "A patch of odd, glowing blue grass."
	turf_type = /turf/open/floor/grass/fairy/blue

/obj/item/stack/tile/fairygrass/purple
	name = "purple fairygrass tile"
	singular_name = "purple fairygrass floor tile"
	desc = "A patch of odd, glowing purple grass."
	turf_type = /turf/open/floor/grass/fairy/purple
	color = "#D966FF"

/obj/item/stack/tile/fairygrass/pink
	name = "pink fairygrass tile"
	singular_name = "pink fairygrass floor tile"
	desc = "A patch of odd, glowing pink grass."
	turf_type = /turf/open/floor/grass/fairy/pink
	color = "#FFB3DA"

//Wood
/obj/item/stack/tile/wood
	name = "wooden plank floor tile"
	singular_name = "wood floor tile"
	desc = "An easy to fit wood floor tile."
	icon_state = "tile-wood"
	turf_type = /turf/open/floor/wood
	resistance_flags = FLAMMABLE

/obj/item/stack/tile/wood/wood_large
	name = "large wooden plank floor tile"
	singular_name = "large wooden plank floor tile"
	icon_state = "tile-wood_large"
	turf_type = /turf/open/floor/wood/wood_large

/obj/item/stack/tile/wood/wood_tiled
	name = "tiled wooden plank floor tile"
	singular_name = "tiled wooden plank floor tile"
	icon_state = "tile-wood_tile"
	turf_type = /turf/open/floor/wood/wood_tiled

/obj/item/stack/tile/wood/wood_diagonal
	name = "diagonal wooden plank floor tile"
	singular_name = "diagonal wooden plank floor tile"
	icon_state = "tile-wood_diagonal"
	turf_type = /turf/open/floor/wood/wood_diagonal

/obj/item/stack/tile/wood/wood_parquet
	name = "parquet wooden plank floor tile"
	singular_name = "parquet wooden plank floor tile"
	icon_state = "tile-wood_parquet"
	turf_type = /turf/open/floor/wood/wood_parquet

//Cloth Floors

/obj/item/stack/tile/padded
	name = "padded floor tile"
	desc = "These are soft and cushy, they'd make good pillows. They look very comfortable, although what they're used for is discomforting."
	icon_state = "tile_padded"
	turf_type = /turf/open/floor/padded

//Basalt
/obj/item/stack/tile/basalt
	name = "basalt tile"
	singular_name = "basalt floor tile"
	desc = "Artificially made ashy soil themed on a hostile environment."
	icon_state = "tile_basalt"
	turf_type = /turf/open/floor/grass/fakebasalt

//Carpets
/obj/item/stack/tile/carpet
	name = "carpet"
	singular_name = "carpet"
	desc = "A piece of carpet. It is the same size as a floor tile."
	icon_state = "tile-carpet"
	turf_type = /turf/open/floor/carpet
	resistance_flags = FLAMMABLE
	tableVariant = /obj/structure/table/wood/fancy

/obj/item/stack/tile/carpet/black
	name = "black carpet"
	icon_state = "tile-carpet-black"
	turf_type = /turf/open/floor/carpet/black
	tableVariant = /obj/structure/table/wood/fancy/black

/obj/item/stack/tile/carpet/arcade
	name = "arcade carpet"
	icon_state = "tile-carpet-arcade"
	turf_type = /turf/open/floor/carpet/arcade
	tableVariant = null

/obj/item/stack/tile/carpet/blackred
	name = "red carpet"
	icon_state = "tile-carpet-blackred"
	turf_type = /turf/open/floor/carpet/blackred
	tableVariant = /obj/structure/table/wood/fancy/blackred

/obj/item/stack/tile/carpet/monochrome
	name = "monochrome carpet"
	icon_state = "tile-carpet-monochrome"
	turf_type = /turf/open/floor/carpet/monochrome
	tableVariant = /obj/structure/table/wood/fancy/monochrome

/obj/item/stack/tile/carpet/blue
	name = "blue carpet"
	icon_state = "tile-carpet-blue"
	item_state = "tile-carpet-blue"
	turf_type = /turf/open/floor/carpet/blue
	tableVariant = /obj/structure/table/wood/fancy/blue

/obj/item/stack/tile/carpet/cyan
	name = "cyan carpet"
	icon_state = "tile-carpet-cyan"
	item_state = "tile-carpet-cyan"
	turf_type = /turf/open/floor/carpet/cyan
	tableVariant = /obj/structure/table/wood/fancy/cyan

/obj/item/stack/tile/carpet/green
	name = "green carpet"
	icon_state = "tile-carpet-green"
	item_state = "tile-carpet-green"
	turf_type = /turf/open/floor/carpet/green
	tableVariant = /obj/structure/table/wood/fancy/green

/obj/item/stack/tile/carpet/orange
	name = "orange carpet"
	icon_state = "tile-carpet-orange"
	item_state = "tile-carpet-orange"
	turf_type = /turf/open/floor/carpet/orange
	tableVariant = /obj/structure/table/wood/fancy/orange

/obj/item/stack/tile/carpet/purple
	name = "purple carpet"
	icon_state = "tile-carpet-purple"
	item_state = "tile-carpet-purple"
	turf_type = /turf/open/floor/carpet/purple
	tableVariant = /obj/structure/table/wood/fancy/purple

/obj/item/stack/tile/carpet/red
	name = "red carpet"
	icon_state = "tile-carpet-red"
	item_state = "tile-carpet-red"
	turf_type = /turf/open/floor/carpet/red
	tableVariant = /obj/structure/table/wood/fancy/red

/obj/item/stack/tile/carpet/royalblack
	name = "royal black carpet"
	icon_state = "tile-carpet-royalblack"
	item_state = "tile-carpet-royalblack"
	turf_type = /turf/open/floor/carpet/royalblack
	tableVariant = /obj/structure/table/wood/fancy/royalblack

/obj/item/stack/tile/carpet/royalblue
	name = "royal blue carpet"
	icon_state = "tile-carpet-royalblue"
	item_state = "tile-carpet-royalblue"
	turf_type = /turf/open/floor/carpet/royalblue
	tableVariant = /obj/structure/table/wood/fancy/royalblue

/obj/item/stack/tile/eighties
	name = "retro tile"
	singular_name = "retro floor tile"
	desc = "A stack of floor tiles that remind you of simpler times.."
	icon_state = "tile_eighties"
	merge_type = /obj/item/stack/tile/eighties
	turf_type = /turf/open/floor/eighties

/obj/item/stack/tile/carpet/ten
	amount = 10

/obj/item/stack/tile/carpet/twenty
	amount = 20

/obj/item/stack/tile/carpet/fifty
	amount = 50

/obj/item/stack/tile/carpet/black/ten
	amount = 10

/obj/item/stack/tile/carpet/black/twenty
	amount = 20

/obj/item/stack/tile/carpet/black/fifty
	amount = 50

/obj/item/stack/tile/carpet/arcade/ten
	amount = 10

/obj/item/stack/tile/carpet/arcade/twenty
	amount = 20

/obj/item/stack/tile/carpet/arcade/fifty
	amount = 50

/obj/item/stack/tile/carpet/blackred/ten
	amount = 10

/obj/item/stack/tile/carpet/blackred/twenty
	amount = 20

/obj/item/stack/tile/carpet/blackred/thirty
	amount = 30

/obj/item/stack/tile/carpet/blackred/fifty
	amount = 50

/obj/item/stack/tile/carpet/monochrome/ten
	amount = 10

/obj/item/stack/tile/carpet/monochrome/twenty
	amount = 20

/obj/item/stack/tile/carpet/monochrome/thirty
	amount = 30

/obj/item/stack/tile/carpet/monochrome/fifty
	amount = 50

/obj/item/stack/tile/carpet/blue/ten
	amount = 10

/obj/item/stack/tile/carpet/blue/twenty
	amount = 20

/obj/item/stack/tile/carpet/blue/thirty
	amount = 30

/obj/item/stack/tile/carpet/blue/fifty
	amount = 50

/obj/item/stack/tile/carpet/cyan/ten
	amount = 10

/obj/item/stack/tile/carpet/cyan/twenty
	amount = 20

/obj/item/stack/tile/carpet/cyan/thirty
	amount = 30

/obj/item/stack/tile/carpet/cyan/fifty
	amount = 50

/obj/item/stack/tile/carpet/green/ten
	amount = 10

/obj/item/stack/tile/carpet/green/twenty
	amount = 20

/obj/item/stack/tile/carpet/green/thirty
	amount = 30

/obj/item/stack/tile/carpet/green/fifty
	amount = 50

/obj/item/stack/tile/carpet/orange/ten
	amount = 10

/obj/item/stack/tile/carpet/orange/twenty
	amount = 20

/obj/item/stack/tile/carpet/orange/thirty
	amount = 30

/obj/item/stack/tile/carpet/orange/fifty
	amount = 50

/obj/item/stack/tile/carpet/purple/ten
	amount = 10

/obj/item/stack/tile/carpet/purple/twenty
	amount = 20

/obj/item/stack/tile/carpet/purple/thirty
	amount = 30

/obj/item/stack/tile/carpet/purple/fifty
	amount = 50

/obj/item/stack/tile/carpet/red/ten
	amount = 10

/obj/item/stack/tile/carpet/red/twenty
	amount = 20

/obj/item/stack/tile/carpet/red/thirty
	amount = 30

/obj/item/stack/tile/carpet/red/fifty
	amount = 50

/obj/item/stack/tile/carpet/royalblack/ten
	amount = 10

/obj/item/stack/tile/carpet/royalblack/twenty
	amount = 20

/obj/item/stack/tile/carpet/royalblack/thirty
	amount = 30

/obj/item/stack/tile/carpet/royalblack/fifty
	amount = 50

/obj/item/stack/tile/carpet/royalblue/ten
	amount = 10

/obj/item/stack/tile/carpet/royalblue/twenty
	amount = 20

/obj/item/stack/tile/carpet/royalblue/thirty
	amount = 30

/obj/item/stack/tile/carpet/royalblue/fifty
	amount = 50

/obj/item/stack/tile/fakespace
	name = "astral carpet"
	singular_name = "astral carpet"
	desc = "A piece of carpet with a convincing star pattern."
	icon_state = "tile_space"
	turf_type = /turf/open/floor/fakespace
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fakespace

/obj/item/stack/tile/fakespace/loaded
	amount = 30

/obj/item/stack/tile/fakepit
	name = "fake pits"
	singular_name = "fake pit"
	desc = "A piece of carpet with a forced perspective illusion of a pit. No way this could fool anyone!"
	icon_state = "tile_pit"
	turf_type = /turf/open/floor/fakepit
	resistance_flags = FLAMMABLE
	merge_type = /obj/item/stack/tile/fakepit

/obj/item/stack/tile/fakepit/loaded
	amount = 30

/turf/open/floor/fakeice
	desc = "Is it marble, polished to a mirror finish? Or just really, really grippy ice?"
	icon = 'icons/turf/floors/ice_turf.dmi'
	icon_state = "ice_turf-0"
	base_icon_state = "ice_turf-0"

/turf/open/floor/fakeice/slippery
	desc = "Somehow, it is not melting under these conditions. Must be some very thick ice. Just as slippery too."

/turf/open/floor/fakeice/slippery/Initialize(mapload)
	. = ..()
	MakeSlippery(TURF_WET_PERMAFROST, INFINITY, 0, INFINITY, TRUE)

//High-traction
/obj/item/stack/tile/noslip
	name = "high-traction floor tile"
	singular_name = "high-traction floor tile"
	desc = "A high-traction floor tile. It feels rubbery in your hand."
	icon_state = "tile_noslip"
	turf_type = /turf/open/floor/noslip
	merge_type = /obj/item/stack/tile/noslip

/obj/item/stack/tile/noslip/thirty
	amount = 30

//Circuit
/obj/item/stack/tile/circuit
	name = "blue circuit tile"
	singular_name = "blue circuit tile"
	desc = "A blue circuit tile."
	icon_state = "tile_bcircuit"
	turf_type = /turf/open/floor/circuit

/obj/item/stack/tile/circuit/green
	name = "green circuit tile"
	singular_name = "green circuit tile"
	desc = "A green circuit tile."
	icon_state = "tile_gcircuit"
	turf_type = /turf/open/floor/circuit/green

/obj/item/stack/tile/circuit/green/anim
	turf_type = /turf/open/floor/circuit/green/anim

/obj/item/stack/tile/circuit/red
	name = "red circuit tile"
	singular_name = "red circuit tile"
	desc = "A red circuit tile."
	icon_state = "tile_rcircuit"
	turf_type = /turf/open/floor/circuit/red

/obj/item/stack/tile/circuit/red/anim
	turf_type = /turf/open/floor/circuit/red/anim

//Pod floor
/obj/item/stack/tile/pod
	name = "pod floor tile"
	singular_name = "pod floor tile"
	desc = "A grooved floor tile."
	icon_state = "tile_pod"
	turf_type = /turf/open/floor/pod

/obj/item/stack/tile/pod/light
	name = "light pod floor tile"
	singular_name = "light pod floor tile"
	desc = "A lightly colored grooved floor tile."
	icon_state = "tile_podlight"
	turf_type = /turf/open/floor/pod/light

/obj/item/stack/tile/pod/dark
	name = "dark pod floor tile"
	singular_name = "dark pod floor tile"
	desc = "A darkly colored grooved floor tile."
	icon_state = "tile_poddark"
	turf_type = /turf/open/floor/pod/dark

//Plasteel (normal)
/obj/item/stack/tile/plasteel
	name = "напольная плитка"
	singular_name = "floor tile"
	desc = "Поверхность, по которой ты ходишь."
	icon_state = "tile"
	force = 6
	custom_materials = list(/datum/material/iron=500)
	throwforce = 10
	flags_1 = CONDUCT_1
	turf_type = /turf/open/floor/plasteel
	mineralType = "metal"
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 70)
	resistance_flags = FIRE_PROOF

/obj/item/stack/tile/plasteel/cyborg
	custom_materials = null // All other Borg versions of items have no Metal or Glass - RR
	is_cyborg = TRUE
	source = /datum/robot_energy_storage/metal
	cost = MINERAL_MATERIAL_AMOUNT * 0.0625

/obj/item/stack/tile/material
	name = "напольная плитка"
	singular_name = "floor tile"
	desc = "Поверхность, по которой ты ходишь."
	throwforce = 10
	icon_state = "material_tile"
	turf_type = /turf/open/floor/material
	material_flags = MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS

/obj/item/stack/tile/bronze
	name = "bronze tile"
	singular_name = "bronze floor tile"
	desc = "A tile made out of bronze. Looks like clockwork."
	icon_state = "material_tile"
	color = "#92661A"
	turf_type = /turf/open/floor/bronze
	custom_materials = list(/datum/material/bronze = 250)

/obj/item/stack/tile/catwalk_tile //This is our base type, sprited to look maintenance-styled
	name = "catwalk plating"
	singular_name = "catwalk plating tile"
	desc = "Flooring that shows its contents underneath. Engineers love it!"
	icon_state = "maint_catwalk"
	mats_per_unit = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT)
	turf_type = /turf/open/floor/catwalk_floor
	merge_type = /obj/item/stack/tile/catwalk_tile //Just to be cleaner, these all stack with each other
	tile_reskin_types = list(
		/obj/item/stack/tile/catwalk_tile,
		/obj/item/stack/tile/catwalk_tile/iron,
		/obj/item/stack/tile/catwalk_tile/iron_white,
		/obj/item/stack/tile/catwalk_tile/iron_dark,
		/obj/item/stack/tile/catwalk_tile/titanium,
		/obj/item/stack/tile/catwalk_tile/iron_smooth //this is the original greenish one
	)

/obj/item/stack/tile/catwalk_tile/sixty
	amount = 60

/obj/item/stack/tile/catwalk_tile/iron
	name = "iron catwalk floor"
	singular_name = "iron catwalk floor tile"
	icon_state = "iron_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/iron

/obj/item/stack/tile/catwalk_tile/iron_white
	name = "white catwalk floor"
	singular_name = "white catwalk floor tile"
	icon_state = "whiteiron_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/iron_white

/obj/item/stack/tile/catwalk_tile/iron_dark
	name = "dark catwalk floor"
	singular_name = "dark catwalk floor tile"
	icon_state = "darkiron_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/iron_dark

/obj/item/stack/tile/catwalk_tile/titanium
	name = "titanium catwalk floor"
	singular_name = "titanium catwalk floor tile"
	icon_state = "titanium_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/titanium

/obj/item/stack/tile/catwalk_tile/iron_smooth //this is the greenish one
	name = "smooth iron catwalk floor"
	singular_name = "smooth iron catwalk floor tile"
	icon_state = "smoothiron_catwalk"
	turf_type = /turf/open/floor/catwalk_floor/iron_smooth
