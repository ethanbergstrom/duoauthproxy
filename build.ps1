$username = 'ethanbergstrom'
$imagename = "$username/duoauthproxy"

$uri = [System.Uri]((Invoke-WebRequest -Uri https://duo.com/docs/checksums).links | Where-Object href -Like '*duoauthproxy*src*' | Select-Object -ExpandProperty href)
$version = ([System.Version]($uri.LocalPath).Split('-')[1]).ToString()

$latestContainerVersion = [System.Version](podman search $imagename --list-tags --format=json | ConvertFrom-Json | Select-Object -ExpandProperty Tags | Where-Object {$_ -ne 'latest'} | Sort-Object -Descending | Select-Object -First 1)

if ($version -lt $latestContainerVersion) {
    $versiontag = "${imagename}:$version"
    $latesttag = "${imagename}:latest"

    podman build . --build-arg URI=$uri -t $versiontag

    podman login docker.io -u $username -p $env:DOCKER_KEY
    podman push $versiontag docker://docker.io/$versiontag
    podman push $versiontag docker://docker.io/$latesttag
}