/obj/machinery/vending/kink/Initialize()
	var/list/extra_products = list(
		/obj/item/clothing/under/dress/skirt/lustymaid = 5,
		/obj/item/clothing/under/dress/skirt/maidsexy = 5,
	)
	var/list/extra_contraband = list(
		/obj/item/storage/box/tentaclescubes = 1, //Just one, because someone is going to spam it, I swear to Azura
		/obj/item/storage/box/tentacle_panties =3
	)
	var/list/extra_premium = list()

	LAZYADD(products, extra_products)
	LAZYADD(contraband, extra_contraband)
	LAZYADD(premium, extra_premium)
	. = ..()
