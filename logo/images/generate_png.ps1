function generate([string]$source, [string]$dest, [int]$destWidth, [int]$destHeight, [bool]$wait = $false) {
	$bu = New-Object -TypeName System.Uri -ArgumentList "$PSScriptRoot/"
    $su = New-Object -TypeName System.Uri -ArgumentList ($bu, $source)
    $source = $su.LocalPath

    $du = New-Object -TypeName System.Uri -ArgumentList ($bu, $dest)
    $dest = $du.LocalPath

    $df = [System.IO.Path]::GetDirectoryName($dest);
    
    if ([System.IO.Directory]::Exists($df) -eq $false) {
        Write-Host "CreateDirectory $df"
        [System.IO.Directory]::CreateDirectory($df)
    }

    $exe = "inkscape.exe"
     
    $ar = "--export-filename=`"$dest`" --export-area-page --export-width=$destWidth --export-height=$destHeight `"$source`""

    Write-Host "$exe $ar"

    if ($wait) {
        Start-Process -FilePath $exe -Wait  -ArgumentList $ar
    } else {
        Start-Process -FilePath $exe -ArgumentList $ar
    }
}

function generateAndroid([string]$source, [string]$name, [int]$size, [double]$ratio = 1, [string]$root = "") {
    if ($root -eq "") {
        $root = $PSScriptRoot
    }
    $dpi = @("m","h","xh","xxh","xxxh")
    $sizes = @(1,1.5,2,3,4)

    for ($i=0; $i -lt 5; $i++) {
        $fn = $dpi[$i]
        $d = [System.IO.Path]::Combine($root, "android/mipmap-${fn}dpi", $name)
        generate $source $d ($sizes[$i] * $size) ($sizes[$i] * $size * $ratio)
    }
}
function generateiOS([string]$source, [string]$name,[int[]] $sizes = $null, [double]$ratio = 1, [string]$root = "") {
    if ($root -eq "") {
        $root = $PSScriptRoot
    }
    if ($sizes -eq $null) {
        $sizes = @(20,29,40,58,60,76,80,87,120,152,167,180,1024)
    }
    foreach($w in $sizes) {
        $d = [System.IO.Path]::Combine($root, "ios/${name}", "${w}.png")
        $h = $w * $ratio
        generate $source $d $w $h
    }
}

if (Test-Path -Path "$Env:ProgramFiles\Inkscape\") {
    Set-Item Env:Path "$Env:Path;$Env:ProgramFiles\Inkscape\bin\"
} else {
    Set-Item Env:Path "$Env:Path;${env:ProgramFiles(x86)}\Inkscape\bin\"
}

generateAndroid "./icon_foreground@108px.svg" "icon_foreground.png" 108
generateAndroid "./icon_background@108px.svg" "icon_background.png" 108
