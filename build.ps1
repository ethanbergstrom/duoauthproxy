$username = 'ethanbergstrom'
$imagename = "$username/duoauthproxy"

$uri = [System.Uri]((Invoke-WebRequest -Uri https://duo.com/docs/checksums).links | Where-Object href -Like '*duoauthproxy*src*' | Select-Object -ExpandProperty href)
$version = ([System.Version]($uri.LocalPath).Split('-')[1]).ToString()
$versiontag = "${imagename}:$version"
$latesttag = "${imagename}:latest"

podman build . --build-arg URI=$uri -t $versiontag

podman login docker.io -u calan89 -p $env:DOCKER_KEY
podman push $versiontag docker://docker.io/$versiontag
podman push $versiontag docker://docker.io/$latesttag