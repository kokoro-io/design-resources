$xmlns = "http://www.w3.org/2000/svg"

function OutputWhite ([System.Xml.Linq.XDocument]$bkDoc, [string]$dest) {
    $whDoc = New-Object System.Xml.Linq.XDocument $bkDoc
    foreach($path in $whDoc.Descendants("{$xmlns}path")) {
        $path.SetAttributeValue("fill", "#fff")
    }
    
    $dp = Join-Path $PSScriptRoot $dest
    $whDoc.Save($dp)
}

function OutputLogo ([System.Xml.Linq.XDocument]$bkDoc, [System.Xml.Linq.XDocument]$bgDoc, [string]$dest) {

    $doc = New-Object System.Xml.Linq.XDocument $bgDoc
    
    $xn = [System.Xml.Linq.XName]::Get("defs", $xmlns)
    $defs = New-Object System.Xml.Linq.XElement $xn
    
    $xn = [System.Xml.Linq.XName]::Get("mask", $xmlns)
    $mask = New-Object System.Xml.Linq.XElement $xn
    
    foreach($path in $bkDoc.Root.Elements()) {
        $np = New-Object System.Xml.Linq.XElement $path
        $np.SetAttributeValue("fill", "#fff")
        $mask.Add($np)
    }
    
    $mask.SetAttributeValue("id", "m")
    $mask.SetAttributeValue("maskUnits", "userSpaceOnUse")
    
    $defs.Add($mask)
    
    
    $xn = [System.Xml.Linq.XName]::Get("g", $xmlns)
    $g = New-Object System.Xml.Linq.XElement $xn
    
    foreach($path in $doc.Root.Elements()) {
        $np = New-Object System.Xml.Linq.XElement $path
        $g.Add($np)
    }
    $g.SetAttributeValue("mask", "url(#m)")
    
    $doc.Root.RemoveNodes()
    $doc.Root.SetAttributeValue("width", $bkDoc.Root.Attribute("width").Value)
    $doc.Root.SetAttributeValue("height", $bkDoc.Root.Attribute("height").Value)
    $doc.Root.Add($defs)
    $doc.Root.Add($g)
    
    $dp = Join-Path $PSScriptRoot $dest
    $doc.Save($dp)
}

function OutputIcon ([System.Xml.Linq.XDocument]$bkDoc, [System.Xml.Linq.XDocument]$bgDoc) {
    
    $doc = New-Object System.Xml.Linq.XDocument $bgDoc
    
    $xn = [System.Xml.Linq.XName]::Get("defs", $xmlns)
    $defs = New-Object System.Xml.Linq.XElement $xn
    
    $xn = [System.Xml.Linq.XName]::Get("mask", $xmlns)
    $mask = New-Object System.Xml.Linq.XElement $xn
    
    $i = 0
    foreach($path in $bkDoc.Root.Elements()) {
        if($i++ -lt 4){
           
            $np = New-Object System.Xml.Linq.XElement $path
            $np.SetAttributeValue("fill", "#fff")
            $mask.Add($np)
        }
    }
    
    $mask.SetAttributeValue("id", "m")
    $mask.SetAttributeValue("maskUnits", "userSpaceOnUse")
    
    $defs.Add($mask)
    
    
    $xn = [System.Xml.Linq.XName]::Get("g", $xmlns)
    $g = New-Object System.Xml.Linq.XElement $xn
    
    foreach($path in $doc.Root.Elements()) {
        $np = New-Object System.Xml.Linq.XElement $path
        $g.Add($np)
    }
    $g.SetAttributeValue("mask", "url(#m)")
    $g.SetAttributeValue("transform", "translate(6,32)")
    
    $doc.Root.RemoveNodes()
    $doc.Root.SetAttributeValue("width", "120")
    $doc.Root.SetAttributeValue("height", "120")
    $doc.Root.SetAttributeValue("viewBox", "0 0 120 120")
    $doc.Root.Add($defs)
    $doc.Root.Add($g)
    
    $dp = Join-Path $PSScriptRoot "kokoroio_icon.svg"
    $doc.Save($dp)
}
function OutputIconWhite ([System.Xml.Linq.XDocument]$bkDoc) {
    
    $doc = New-Object System.Xml.Linq.XDocument $bgDoc
    
    $xn = [System.Xml.Linq.XName]::Get("g", $xmlns)
    $g = New-Object System.Xml.Linq.XElement $xn

    $i = 0
    foreach($path in $bkDoc.Root.Elements()) {
        if($i++ -lt 4){
           
            $np = New-Object System.Xml.Linq.XElement $path
            $np.SetAttributeValue("fill", "#fff")
            $g.Add($np)
        }
    }
    
    $g.SetAttributeValue("transform", "translate(6,32)")
    
    $doc.Root.RemoveNodes()
    $doc.Root.SetAttributeValue("width", "120")
    $doc.Root.SetAttributeValue("height", "120")
    $doc.Root.SetAttributeValue("viewBox", "0 0 120 120") 
    $doc.Root.Add($g)
    
    $dp = Join-Path $PSScriptRoot "kokoroio_icon_white.svg"
    $doc.Save($dp)
}

$dp = Join-Path $PSScriptRoot "kokoroio_black.svg"
$bkDoc = [System.Xml.Linq.XDocument]::Load($dp)

$dp = Join-Path $PSScriptRoot "kokoroio_background.svg"
$bgDoc = [System.Xml.Linq.XDocument]::Load($dp)

OutputWhite $bkDoc "kokoroio_white.svg"
OutputLogo $bkDoc $bgDoc "kokoroio.svg"
OutputIcon $bkDoc $bgDoc
OutputIconWhite $bkDoc

$dp = Join-Path $PSScriptRoot "kokoroio_black_small.svg"
$bkDoc = [System.Xml.Linq.XDocument]::Load($dp)

OutputWhite $bkDoc "kokoroio_white_small.svg"
OutputLogo $bkDoc $bgDoc "kokoroio_small.svg"