//defines for loadout categories
//no category defines
#define LOADOUT_CATEGORY_NONE			"Ошибка"
#define LOADOUT_SUBCATEGORY_NONE		"Разное"
#define LOADOUT_SUBCATEGORIES_NONE		list("Разное")

//accessory
#define LOADOUT_CATEGORY_ACCESSORY "Аксессуары"

//backpack
#define LOADOUT_CATEGORY_BACKPACK 				"В рюкзаке"
#define LOADOUT_SUBCATEGORY_BACKPACK_GENERAL 	"Общее" //basically anything that there's not enough of to have its own subcategory
#define LOADOUT_SUBCATEGORY_BACKPACK_TOYS 		"Игрушки"
#define LOADOUT_SUBCATEGORY_BACKPACK_ACCESSORIES	"АКСЕССУАРЫ"

//neck
#define LOADOUT_CATEGORY_NECK "Шея"
#define LOADOUT_SUBCATEGORY_NECK_GENERAL 	"Общее"
#define LOADOUT_SUBCATEGORY_NECK_TIE 		"Галстуки"
#define LOADOUT_SUBCATEGORY_NECK_SCARVES 	"Шарфы"

//mask
#define LOADOUT_CATEGORY_MASK "Маски"

//hands
#define LOADOUT_CATEGORY_HANDS 				"В кармане"

//uniform
#define LOADOUT_CATEGORY_UNIFORM 			"Униформа" //there's so many types of uniform it's best to have lots of categories
#define LOADOUT_SUBCATEGORY_UNIFORM_GENERAL "Общее"
#define LOADOUT_SUBCATEGORY_UNIFORM_JOBS 	"Профессия"
#define LOADOUT_SUBCATEGORY_UNIFORM_SUITS	"Костюмы"
#define LOADOUT_SUBCATEGORY_UNIFORM_SKIRTS	"Юбки"
#define LOADOUT_SUBCATEGORY_UNIFORM_DRESSES	"Платья"
#define LOADOUT_SUBCATEGORY_UNIFORM_SWEATERS	"Свитера"
#define LOADOUT_SUBCATEGORY_UNIFORM_PANTS	"Штаны"
#define LOADOUT_SUBCATEGORY_UNIFORM_SHORTS	"Шорты"

//suit
#define LOADOUT_CATEGORY_SUIT 				"Костюм"
#define LOADOUT_SUBCATEGORY_SUIT_GENERAL 	"Общее"
#define LOADOUT_SUBCATEGORY_SUIT_COATS 		"Пальто"
#define LOADOUT_SUBCATEGORY_SUIT_JACKETS 	"Куртки"
#define LOADOUT_SUBCATEGORY_SUIT_JOBS 		"Профессия"

//head
#define LOADOUT_CATEGORY_HEAD 				"Головной убор"
#define LOADOUT_SUBCATEGORY_HEAD_GENERAL 	"Общее"
#define LOADOUT_SUBCATEGORY_HEAD_JOBS 		"Провессия"

//shoes
#define LOADOUT_CATEGORY_SHOES 		"Обувь"

//gloves
#define LOADOUT_CATEGORY_GLOVES		"Перчатки"

//glasses
#define LOADOUT_CATEGORY_GLASSES	"Очки"

//donator items
#define LOADOUT_CATEGORY_DONATOR	"Донат"

//unlockable items
#define LOADOUT_CATEGORY_UNLOCKABLE	"Открываемые"

//errors with your savefile
#define LOADOUT_CATEGORY_ERROR		"Errors"

//how many prosthetics can we have
#define MAXIMUM_LOADOUT_PROSTHETICS	4

//what limbs can be amputated or be prosthetic
#define LOADOUT_ALLOWED_LIMB_TARGETS	list(BODY_ZONE_L_ARM,BODY_ZONE_R_ARM,BODY_ZONE_L_LEG,BODY_ZONE_R_LEG)

//options for modifiying limbs
#define LOADOUT_LIMB_NORMAL			"Нормальные"
#define LOADOUT_LIMB_PROSTHETIC		"Протезы"
#define LOADOUT_LIMB_AMPUTATED		"Ампутированные"

#define LOADOUT_LIMBS		 		list(LOADOUT_LIMB_NORMAL,LOADOUT_LIMB_PROSTHETIC,LOADOUT_LIMB_AMPUTATED) //you can amputate your legs/arms though

//loadout saving/loading specific defines
#define MAXIMUM_LOADOUT_SAVES		5
#define LOADOUT_ITEM				"loadout_item"
#define LOADOUT_COLOR				"Цвет"
#define LOADOUT_CUSTOM_NAME			"Название"
#define LOADOUT_CUSTOM_DESCRIPTION	"Описание"
#define LOADOUT_IS_HEIRLOOM			"loadout_is_heirloom" // BLUEMOON ADD - выбор вещей из лодаута как family heirloom

//loadout item flags
#define LOADOUT_CAN_NAME					(1<<0) //renaming items
#define LOADOUT_CAN_DESCRIPTION				(1<<1) //adding a custom description to items
#define LOADOUT_CAN_COLOR_POLYCHROMIC		(1<<2)

//the names of the customization tabs
#define SETTINGS_TAB			0
#define PREFERENCES_TAB			1
#define KEYBINDINGS_TAB			2

//subtabs for the character settings tab
#define GENERAL_CHAR_TAB		0
#define BACKGROUND_CHAR_TAB		1
#define APPEARANCE_CHAR_TAB		2
#define MARKINGS_CHAR_TAB		3
#define SPEECH_CHAR_TAB			4
#define LOADOUT_CHAR_TAB		5

//subtabs for preferences tab
#define GAME_PREFS_TAB			0
#define OOC_PREFS_TAB			1
#define CONTENT_PREFS_TAB		2

//quirks
#define QUIRK_POSITIVE	"Положительные"
#define QUIRK_NEGATIVE	"Негативные"
#define QUIRK_NEUTRAL	"Нейтральные"
