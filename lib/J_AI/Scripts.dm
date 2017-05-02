mob
	var/tmp
		/*
		(shopping) if set to 1 the statpanel will show displaying your shop_list
		*/
		shopping=0
		list/shop_list=list()

/*
Just a few more varibles

(is_shop) if true when clicked it will open the shop panel and show you there contents

(speaks) This varible goes with the scripts/list() if true the mob will speak when clicked
*/
mob
	Monster
		var
			is_shop=0
			speaks=0
			scripts=list()
		Click()
			if(src in view(3,usr))
				if(is_shop)
					if(!usr.shopping)
						if(speaks) usr<<"<b>[src.name]</b>: [pick(scripts)]"
						usr.shopping=1
						usr.shop_list=src.contents
						usr.client.statpanel="Shop"
					else
						usr.shopping=0
						usr.shop_list=list()
				else
					if(speaks) usr<<"<b>[src.name]</b>: [pick(scripts)]"
				..()
			else
				..()