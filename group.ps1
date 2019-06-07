mkdir systems
get-content ./bodies7days.json | ?{ $_.Length -ge 10 } | %{
	$marker = """systemId64"":"
	$markerindex = $_.indexof($marker)
	$idstart = $markerindex + $marker.length
	if( $markerindex -ne -1 )
	{
		$idend = $_.indexof( ",", $idstart )
		$id = $_.substring( $idstart, $idend-$idstart )
		echo $_ >> "./systems/$id"
	}
}
