
	$i = 0
	$systemsdirectory = Resolve-Path "./systems"

	# There are so many files, iterating using gci or ls creates problems (probably because they also do sorting and grabbing metadata). So we use a .net method to just get all full paths, one by one.
	[IO.Directory]::enumeratefiles($systemsdirectory) | %{
		$i++
		if( $i % 10000 -eq 0)
		{
			# write progress indicator every once in a while
			write-host -nonewline "."
		}
		# these files are small enough we can use the regular jsonconverter. Remember to trim the trailing comma.
		$objects = gc $_ | %{ $_.trimend(",") |convertfrom-json}

		# the main star is the one closest to arrival
		$main = $objects | ?{ $_.distanceToArrival -eq 0 }
		if( $main.type -eq "Star" )
		{
			# these are the properties we want to track. Some names exactly match properties in the jsondata, makes it easier to set them later.
			$outputobject = new-object psobject -property @{
				"id"=$main.systemid64;
				"type"=$main.type;
				"subtype"=$main.subtype;
				"name"=$main.systemName;
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
				"No bodies"=1;
			}

			$objects | %{
				if( $_.terraformingState -eq "Candidate for terraforming" )
				{
					$name = "Terraformable $($_.subtype)"

				}
				else
				{
					$name = $_.subtype
				}
				# propertyname matches the subtype exactly, so we can just use the variable itself to set the property
				if( $outputobject."$name" -eq 0 )
				{
					$outputobject."$name" = 1
					$outputobject."No bodies" = 0
				}
			}

			# group by star type using folders
			$folderlabel = $main.subtype.replace("/","-") # guard against invalid folder name
			if(!(Test-Path "./jsonsystems/$($folderlabel)"))
			{
				mkdir "./jsonsystems/$($folderlabel)"
			}
			$outputobject | convertto-json | set-content "./jsonsystems/$($folderlabel)/$($main.systemid64)"
		}
	}
