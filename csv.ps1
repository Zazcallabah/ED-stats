 
	$props = @(
		"Earth-like world",
		"Class IV gas giant",
		"Water world",
		"No bodies",
		"High metal content world",
		"Metal-rich body",
		"Ammonia world",
		"Gas giant with water-based life",
		"Terraformable Rocky body",
		"Rocky Ice world",
		"Rocky body",
		"Class V gas giant",
		"Terraformable High metal content world",
		"Gas giant with ammonia-based life",
		"Class II gas giant",
		"Class III gas giant",
		"Terraformable Water world",
		"Icy body",
		"Water giant",
		"Helium-rich gas giant",
		"Class I gas giant"
	)

	# get one object for each star type with properties for each body type containing the percent chance the body can be found around the star
	$list = gci ./starstats | %{
		$obj = gc $_.fullname | convertfrom-json
		$p = @{"total"=$obj.total;"subtype"=$_.name}
		$props | %{
			$p.Add($_,$obj."$_"/$obj.total)
		}
		new-object psobject -property $p
	}
	$list | convertto-csv -notypeinformation -delimiter "`t" | set-content subtypes.csv

	$result = @{}

	gci ./starstats | %{
		$subtype = $_.name
		$type = $subtype.substring(0,$subtype.indexof(" "))
		if(!($result.ContainsKey($type)))
		{
			$result.Add($type,@{"type"=$type;"total"=0;})
		}
		$obj = gc $_.fullname | convertfrom-json
		$result[$type]["total"] += $obj.total

		$props | %{
			if(!($result[$type].containskey($_)))
			{
				$result[$type].Add($_,0)
			}
			$result[$type][$_] += $obj."$_"
		}
	}

	$result.values | %{
		$v = $_
		$f = @{"type"=$_.type;"total"=$_.total;}
		$props | %{
			$f.Add($_,$v."$_"/$v.total)
		}

		new-object psobject -property $f
	}| convertto-csv -notypeinformation -delimiter "`t" | set-content maintypes.csv
