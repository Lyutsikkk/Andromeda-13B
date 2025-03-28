/datum/crafting_recipe/crowbar
	name = "Makeshift Crowbar"
	result = /obj/item/crowbar/makeshift
	reqs = list(/obj/item/stack/rods = 1)
	time = 40
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/screwdriver
	name = "Makeshift Screwdriver"
	result = /obj/item/screwdriver/makeshift
	reqs = list(/obj/item/stack/rods = 1)
	tools = list(TOOL_CROWBAR)
	time = 20
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/wirecutters
	name = "Кусачки"
	result = /obj/item/wirecutters/makeshift
	reqs = list(/obj/item/stack/rods = 2,
				/obj/item/stack/cable_coil = 5)
	tools = list(TOOL_CROWBAR, TOOL_SCREWDRIVER)
	time = 50
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/wrench
	name = "Гаечный ключ"
	result = /obj/item/wrench/makeshift
	reqs = list(/obj/item/stack/rods = 1,
				/obj/item/stack/sheet/metal = 1)
	tools = list(TOOL_CROWBAR, TOOL_SCREWDRIVER)
	time = 30
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/emergency_welder
	name = "Makeshift Welder"
	result = /obj/item/weldingtool/makeshift
	reqs = list(/obj/item/stack/rods = 1,
				/obj/item/assembly/igniter = 1,
				/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/cable_coil = 5)
	tools = list(TOOL_CROWBAR, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 30
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/toolbox
	name = "Ящик инструментов"
	result = /obj/item/storage/toolbox/greyscale
	reqs = list(/obj/item/stack/rods = 3,
				/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 5)
	tools = list(TOOL_CROWBAR, TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 70
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/bin
	name = "Makeshift Matter Bin"
	result = /obj/item/stock_parts/matter_bin/makeshift
	reqs = list(/obj/item/stack/sheet/metal = 3)
	tools = list(TOOL_WIRECUTTER, TOOL_WELDER)
	time = 70
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/makeshift_manipulator
	name = "Makeshift Manipulator"
	result = /obj/item/stock_parts/manipulator/makeshift
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/obj/item/stack/cable_coil = 5)
	tools = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER, TOOL_WELDER)
	time = 70
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/slime_core
	name = "Slime Core"
	result = /obj/item/slime_extract/grey
	reqs = list(/datum/reagent/toxin/slimejelly = 100,
				/datum/reagent/toxin/plasma = 20)
	tools = list(TOOL_WELDER)
	time = 100
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/blowing_rod
	name = "Glassblowing rod"
	result = /obj/item/glasswork/blowing_rod
	reqs = list(/obj/item/stack/rods = 3)
	tools = list(TOOL_WELDER)
	time = 10 SECONDS
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/glasskit
	name = "Glasswork Tools"
	result = /obj/item/glasswork/glasskit
	reqs = list(/obj/item/stack/sheet/leather = 2,
				/obj/item/stack/sheet/mineral/wood = 2,
				/obj/item/stack/rods = 4,
				/obj/item/stack/sheet/metal = 2
				)
	tools = list(TOOL_WELDER, TOOL_WIRECUTTER)
	time = 10 SECONDS
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/cable_coil
	name = "Кабеля"
	result = /obj/item/stack/cable_coil
	reqs = list(/obj/item/stack/rods = 30,
			/obj/item/stack/sheet/glass = 15)
	tools = list(TOOL_CROWBAR, TOOL_SCREWDRIVER)
	time = 70
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS

/datum/crafting_recipe/autolathe
	name = "Makeshift autolathe"
	result = /obj/item/circuitboard/machine/autolathe_makeshift
	reqs = list(/obj/item/stack/rods = 1,
				/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/sheet/glass = 4,
				/obj/item/stack/cable_coil = 5,
				/obj/item/gibtonite = 1)
	tools = list(TOOL_CROWBAR, TOOL_SCREWDRIVER,TOOL_WELDER)
	time = 70
	subcategory = CAT_TOOL
	category = CAT_MISCELLANEOUS
