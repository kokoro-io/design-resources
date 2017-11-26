if (Test-Path -Path "$Env:ProgramFiles\Inkscape\") {
    Set-Item Env:Path "$Env:Path;$Env:ProgramFiles\Inkscape\"
} else {
    Set-Item Env:Path "$Env:Path;${env:ProgramFiles(x86)}\Inkscape\"
}

function OutputSingle ([string]$src, [string]$dest, [int]$width, [int]$height) {
    $dp = [System.IO.Path]::Combine($PSScriptRoot, $dest)
    $f = New-Object System.IO.FileInfo $dp

    if(!$f.Directory.Exists){
        $f.Directory.Create()
    }

    Start-Process -FilePath inkscape -ArgumentList "-z $PSScriptRoot\$src -w $width -h $height -e $dp"
}

function OutputIosIcon ([string]$src, [string]$type, [single]$size, [int]$scale) {
    $dest = [System.String]::Format("gen\ios\AppIcon.appiconset\Icon-{0}-{1:.#}x{1:.#}@{2}x.png", $type, $size, $scale)
    $size = $size * $scale
    OutputSingle $src $dest $size $size
}

function OutputIosIconAll([string]$src) {
    OutputIosIcon $src "App" 20 1
    OutputIosIcon $src "App" 20 2
    OutputIosIcon $src "App" 20 3
    OutputIosIcon $src "App" 29 1
    OutputIosIcon $src "App" 29 2
    OutputIosIcon $src "App" 29 3
    OutputIosIcon $src "App" 40 1
    OutputIosIcon $src "App" 40 2
    OutputIosIcon $src "App" 40 3
    OutputIosIcon $src "App" 57 1
    OutputIosIcon $src "App" 57 2
    OutputIosIcon $src "App" 60 1
    OutputIosIcon $src "App" 60 2
    OutputIosIcon $src "App" 60 3
    OutputIosIcon $src "App" 72 1
    OutputIosIcon $src "App" 72 2
    OutputIosIcon $src "App" 76 1
    OutputIosIcon $src "App" 76 2
    OutputIosIcon $src "App" 76 3
    OutputIosIcon $src "App" 83.5 2
    OutputIosIcon $src "Small" 50 1
    OutputIosIcon $src "Small" 50 2
}

function OutputAndroidIcon ([string]$src, [string]$name, [int]$size) {
	$dest = [System.String]::Format("gen\drawable-{0}\kokoro.png", $name)
    OutputSingle $src $dest $size $size
}

function OutputAndroidIconAll([string]$src) {
	OutputAndroidIcon $src "mdpi" 48
	OutputAndroidIcon $src "hdpi" 72
	OutputAndroidIcon $src "xhdpi" 96
	OutputAndroidIcon $src "xxhdpi" 144
	OutputAndroidIcon $src "xxxhdpi" 192
}

OutputSingle "kokoroio.svg" "gen\logo@2x.png" 424 112
OutputIosIconAll "kokoroio_icon_rounded.svg"
OutputAndroidIconAll "kokoroio_icon_rounded.svg"
