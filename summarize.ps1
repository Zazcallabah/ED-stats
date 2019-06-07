
	mkdir starstats
	$props = @(
		"Terraformable High metal content world",
		"Terraformable Rocky body",
		"Terraformable Water world",
		"High metal content world",
		"Class III gas giant",
		"Class I gas giant",
		"Icy body",
		"Rocky body",
		"Metal-rich body",
		"Gas giant with water-based life",
		"Class II gas giant",
		"Water world",
		"Rocky Ice world",
		"Ammonia world",
		"Gas giant with ammonia-based life",
		"Class IV gas giant",
		"Class V gas giant",
		"Earth-like world",
		"Water giant",
		"Helium-rich gas giant",
		"No bodies"
	)

	gci ./jsonsystems | %{
		write-host "`ndoing $($_.name)"
		$stats = @{
			"Terraformable High metal content world"=0;
			"Terraformable Rocky body"=0;
			"Terraformable Water world"=0;
			"High metal content world"=0;
			"Class III gas giant"=0;
			"Class I gas giant"=0;
			"Icy body"=0;
			"Rocky body"=0;
			"Metal-rich body"=0;
			"Gas giant with water-based life"=0;
			"Class II gas giant"=0;
			"Water world"=0;
			"Rocky Ice world"=0;
			"Ammonia world"=0;
			"Gas giant with ammonia-based life"=0;
			"Class IV gas giant"=0;
			"Class V gas giant"=0;
			"Earth-like world"=0;
			"Water giant"=0;
			"Helium-rich gas giant"=0;
			"No bodies"=0;
			"total"=0;
			"subtype"=$_.name
		}
		[IO.Directory]::enumeratefiles($_.fullname) | %{
			$stats["total"]++;
			if($stats["total"] % 1000 -eq 0)
			{
				write-host -nonewline "."
			}
			$obj = gc $_ | convertfrom-json
			$props | %{
				$stats[$_] += $obj."$_"
			}
		}
		$stats | convertto-json | set-content "./starstats/$($_.name)"
	}
