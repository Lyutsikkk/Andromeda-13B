/datum/gas/oxygen
	id = GAS_O2
	specific_heat = 20
	name = "Oxygen"
	oxidation_temperature = T0C - 100 // it checks max of this and fire temperature, so rarely will things spontaneously combust
	powermix = 1
	heat_penalty = 1
	transmit_modifier = 1.5

/datum/gas/oxygen/generate_TLV()
	return new/datum/tlv(16, 19, 40, 50)

/datum/gas/nitrogen
	id = GAS_N2
	specific_heat = 20
	name = "Nitrogen"
	powermix = -1
	heat_penalty = -1.5
	fire_burn_rate = 1
	fire_temperature = 2300
	fire_products = list(GAS_NITRIC = 2)
	breath_alert_info = list(
		not_enough_alert = list(
			alert_category = "not_enough_nitro",
			alert_type = /atom/movable/screen/alert/not_enough_nitro
		),
		too_much_alert = list(
			alert_category = "too_much_nitro",
			alert_type = /atom/movable/screen/alert/too_much_nitro
		)
	)

/datum/gas/carbon_dioxide //what the fuck is this?
	id = GAS_CO2
	specific_heat = 30
	name = "Carbon Dioxide"
	powermix = 1
	heat_penalty = 0.1
	powerloss_inhibition = 1
	breath_results = GAS_O2
	breath_alert_info = list(
		not_enough_alert = list(
			alert_category = "not_enough_co2",
			alert_type = /atom/movable/screen/alert/not_enough_co2
		),
		too_much_alert = list(
			alert_category = "too_much_co2",
			alert_type = /atom/movable/screen/alert/too_much_co2
		)
	)
	fusion_power = 3
	enthalpy = -393500

/datum/gas/carbon_dioxide/generate_TLV()
	return new/datum/tlv(-1, -1, 5, 10)

/datum/gas/plasma
	id = GAS_PLASMA
	specific_heat = 200
	name = "Плазма"
	gas_overlay = "plasma"
	moles_visible = MOLES_GAS_VISIBLE
	flags = GAS_FLAG_DANGEROUS
	heat_penalty = 15
	transmit_modifier = 4
	powermix = 1
	fire_burn_rate = OXYGEN_BURN_RATE_BASE // named when plasma fires were the only fires, surely
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST
	fire_products = FIRE_PRODUCT_PLASMA
	enthalpy = FIRE_PLASMA_ENERGY_RELEASED // 3000000, 3 megajoules, 3000 kj

/datum/gas/nitrous_oxide
	id = GAS_NITROUS
	specific_heat = 40
	name = "Nitrous Oxide"
	gas_overlay = "nitrous_oxide"
	moles_visible = MOLES_GAS_VISIBLE * 2
	flags = GAS_FLAG_DANGEROUS
	fire_products = list(GAS_N2 = 1)
	oxidation_rate = 0.5
	oxidation_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST + 100
	enthalpy = 81600
	heat_resistance = 6

/datum/gas/water_vapor
	id = GAS_H2O
	specific_heat = 40
	name = "Water Vapor"
	gas_overlay = "water_vapor"
	moles_visible = MOLES_GAS_VISIBLE
	flags = GAS_FLAG_DANGEROUS
	fusion_power = 8
	heat_penalty = 8
	enthalpy = -241800 // FIRE_HYDROGEN_ENERGY_RELEASED is actually what this was supposed to be
	powermix = 1
	breath_reagent = /datum/reagent/water


/datum/gas/pluoxium
	id = GAS_PLUOXIUM
	specific_heat = 80
	name = "Pluoxium"
	fusion_power = 10
	oxidation_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST * 25 // it is VERY stable
	oxidation_rate = 8 // when it can oxidize, it can oxidize a LOT
	enthalpy = -2000000 // but it reduces the heat output a great deal (plasma fires add 3000000 per mole)
	powermix = -1
	heat_penalty = -1
	transmit_modifier = -5
	heat_resistance = 3
	price = 4

/datum/gas/pluoxium/generate_TLV()
	return new/datum/tlv(-1, -1, 5, 6)

/datum/gas/tritium
	id = GAS_TRITIUM
	specific_heat = 10
	name = "Tritium"
	gas_overlay = "tritium"
	moles_visible = MOLES_GAS_VISIBLE
	flags = GAS_FLAG_DANGEROUS
	fusion_power = 1
	powermix = 1
	heat_penalty = 10
	transmit_modifier = 30
	fire_products = list(GAS_H2O = 1)
	enthalpy = 300000
	fire_burn_rate = 2
	fire_radiation_released = 50 // arbitrary number, basically 60 moles of trit burning will just barely start to harm you
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 50
	price = 4

/datum/gas/nitric_oxide
	id = GAS_NITRIC
	specific_heat = 20
	name = "Nitric oxide"
	odor = "sharp sweetness"
	odor_strength = 1
	fusion_power = 15
	enthalpy = 91290
	heat_resistance = 2
	powermix = -1
	heat_penalty = -1

/datum/gas/nitryl
	id = GAS_NITRYL
	specific_heat = 20
	name = "Nitrogen dioxide"
	color = "#963"
	moles_visible = MOLES_GAS_VISIBLE
	flags = GAS_FLAG_DANGEROUS
	fusion_power = 15
	fire_products = list(GAS_N2 = 0.5)
	enthalpy = 33200
	oxidation_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 50
	price = 2

/datum/gas/hypernoblium
	id = GAS_HYPERNOB
	specific_heat = 2000
	name = "Hyper-noblium"
	gas_overlay = "freon"
	moles_visible = MOLES_GAS_VISIBLE
	price = 17

/datum/gas/hydrogen
	id = GAS_HYDROGEN
	specific_heat = 10
	name = "Hydrogen"
	flags = GAS_FLAG_DANGEROUS
	moles_visible = MOLES_GAS_VISIBLE
	color = "#ffe"
	fusion_power = 0
	powermix = 1
	heat_penalty = 3
	transmit_modifier = 10
	fire_products = list(GAS_H2O = 1)
	fire_burn_rate = 2
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 50

/datum/gas/bz
	id = GAS_BZ
	specific_heat = 20
	name = "BZ"
	flags = GAS_FLAG_DANGEROUS
	fusion_power = 8
	powermix = 1
	heat_penalty = 5
	enthalpy = FIRE_CARBON_ENERGY_RELEASED // it is a mystery
	transmit_modifier = -2
	radioactivity_modifier = 5
	price = 2

/datum/gas/stimulum
	id = GAS_STIMULUM
	specific_heat = 5
	odor = "the color blue" // fast
	odor_strength = 10
	name = "Stimulum"
	fusion_power = 7
	price = 10

/datum/gas/miasma
	id = GAS_MIASMA
	specific_heat = 20
	fusion_power = 50
	flags = GAS_FLAG_DANGEROUS
	// snowflaked odor
	name = "Miasma"
	gas_overlay = "miasma"
	color = "#963"
	moles_visible = MOLES_GAS_VISIBLE * 60
//	price = 2 BLUEMOON DELETE кому впринципе нужны миазмы?

/datum/gas/methane
	id = GAS_METHANE
	specific_heat = 30
	name = "Methane"
	odor = "natural gas"
	odor_strength = 2
	flags = GAS_FLAG_DANGEROUS
	powerloss_inhibition = 1
	heat_resistance = 3
	breath_results = GAS_METHYL_BROMIDE
	fire_products = list(GAS_CO2 = 1, GAS_H2O = 2)
	fire_burn_rate = 0.5
	breath_alert_info = list(
		not_enough_alert = list(
			alert_category = "not_enough_ch4",
			alert_type = /atom/movable/screen/alert/not_enough_ch4
		),
		too_much_alert = list(
			alert_category = "too_much_ch4",
			alert_type = /atom/movable/screen/alert/too_much_ch4
		)
	)
	enthalpy = -74600
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST
	price = 1

/datum/gas/methyl_bromide
	id = GAS_METHYL_BROMIDE
	specific_heat = 42
	name = "Methyl Bromide"
	powermix = 1
	heat_penalty = -1
	flags = GAS_FLAG_DANGEROUS
	breath_alert_info = list(
		not_enough_alert = list(
			alert_category = "not_enough_ch3br",
			alert_type = /atom/movable/screen/alert/not_enough_ch3br
		),
		too_much_alert = list(
			alert_category = "too_much_ch3br",
			alert_type = /atom/movable/screen/alert/too_much_ch3br
		)
	)
	fire_products = list(GAS_CO2 = 1, GAS_H2O = 1.5, GAS_BROMINE = 0.5)
	enthalpy = -35400
	fire_burn_rate = 4 / 7 // oh no
	fire_temperature = 808 // its autoignition; it apparently doesn't spark readily, so i don't put it lower
	price = 2

/datum/gas/bromine
	id = GAS_BROMINE
	specific_heat = 76
	name = "Bromine"
	flags = GAS_FLAG_DANGEROUS | GAS_FLAG_CHEMICAL
	group = GAS_GROUP_CHEMICALS
	color = "#6e1f00"
	moles_visible = MOLES_GAS_VISIBLE
	odor = "bromine" // it's a very recognizable smell
	odor_strength = 0.1
	enthalpy = 193 // yeah it's small but it's good to include it
	breath_reagent = /datum/reagent/bromine

/datum/gas/ammonia
	id = GAS_AMMONIA
	specific_heat = 35
	name = "Ammonia"
	odor = "ammonia"
	odor_strength = 0.01
	flags = GAS_FLAG_DANGEROUS | GAS_FLAG_CHEMICAL
	group = GAS_GROUP_CHEMICALS
	enthalpy = -45900
	breath_reagent = /datum/reagent/ammonia
	fire_products = list(GAS_H2O = 1.5, GAS_N2 = 0.5)
	fire_burn_rate = 4/3
	fire_temperature = 924

/datum/gas/quark_matter
	id = GAS_QCD
	specific_heat = 10
	name = "Quark Matter"
	flags = GAS_FLAG_DANGEROUS
	powermix = -1
	transmit_modifier = -10
	heat_penalty = -10
	price = 5 // IT'S NOT ACTUALLY THAT HARD TO GET INTO A CANISTER LOL
