# Create folder structure in a project folder
# Original: Super magic folder copy tool.bat
# 2019-03-01

$SourceFolder = "C:\Users\Kees Hiemstra\Desktop\Kees\Mappenstructuur"
$TargetFolder = "C:\Tmp\Folder01"

# mkdir "01 Contractstukken\00-Vervallen"
# mkdir "01 Contractstukken\01-Inschrijvingsdocumenten"
# mkdir "01 Contractstukken\02-Contractdocumenten"
# mkdir "01 Contractstukken\03-NvI"
# mkdir "01 Contractstukken\04-Planning"
# mkdir "01 Contractstukken\05-Uitslag"
# mkdir "02 Financieel\00-Vervallen"
# mkdir "03 Correspondentie\00-Vervallen"

New-Item -Path "$TargetFolder\01 Contractstukken\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\01 Contractstukken\01-Inschrijvingsdocumenten" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\01 Contractstukken\02-Contractdocumenten" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\01 Contractstukken\03-NvI" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\01 Contractstukken\04-Planning" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\01 Contractstukken\05-Uitslag" -ItemType Directory -ErrorAction SilentlyContinue

New-Item -Path "$TargetFolder\02 Financieel\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\03 Correspondentie\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue

# copy "W:\damsteegt\KAM\Bedrijfshandboek DAMSTEEGT-CS-BdE\AD-05-05 Documentenlijst review formulier rev4.xlsx" "03 Correspondentie\"
# copy "W:\damsteegt\KAM\Bedrijfshandboek DAMSTEEGT-CS-BdE\AD-05-07C Werkbon Engineering rev3.docx" "03 Correspondentie\"  

if ( -not (Test-Path "$TargetFolder\03 Correspondentie\AD-05-05 Documentenlijst review formulier *.xlsx") )
{
    $FileToCopy = Get-ChildItem -Path "W:\damsteegt\KAM\Bedrijfshandboek DAMSTEEGT-CS-BdE\AD-05-05 Documentenlijst review formulier *.xlsx" | Sort-Object -Descending | Select-Object -First 1
    Copy-Item -Path $FileToCopy -Destination "$TargetFolder\03 Correspondentie\"
}

if ( -not  (Test-Path "$TargetFolder\03 Correspondentie\AD-05-07C Werkbon Engineering *.do*x") )
{
    $FileToCopy = Get-ChildItem -Path "W:\damsteegt\KAM\Bedrijfshandboek DAMSTEEGT-CS-BdE\AD-05-07C Werkbon Engineering *.dotx" | Sort-Object -Descending | Select-Object -First 1
    Copy-Item -Path $FileToCopy -Destination "$TargetFolder\03 Correspondentie\"

    $FileToRename = Get-ChildItem -Path "$TargetFolder\03 Correspondentie\AD-05-07C Werkbon Engineering *.dotx" | Sort-Object -Descending | Select-Object -First 1
    try
    {
        Rename-Item -Path $FileToRename -NewName $FileToRename.FullName.Replace('.dotx', '.docx') -ErrorAction Stop
    }
    catch
    {
        Remove-Item -Path $FileToRename
    }
}

# mkdir "04 Ontwerp\00-Vervallen"
# mkdir "04 Ontwerp\01-Ter Goedkeuring\00-Vervallen"
# mkdir "04 Ontwerp\02-Voor Uitvoering\00-Vervallen"
# mkdir "04 Ontwerp\02-Voor Uitvoering\Bestellen"
# mkdir "04 Ontwerp\03-As Built\00-Vervallen"
# mkdir "04 Ontwerp\X-Ref"
# mkdir "05 Berekeningen\01-BER\00-Vervallen"
# mkdir "05 Berekeningen\01-BER\Rev-00"
# mkdir "05 Berekeningen\02-Sondering"
# mkdir "06 Leveranciers\00-Vervallen"
# mkdir "07 Afwijkingen\00-Vervallen"

New-Item -Path "$TargetFolder\04 Ontwerp\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\04 Ontwerp\01-Ter Goedkeuring\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\04 Ontwerp\02-Voor Uitvoering\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\04 Ontwerp\02-Voor Uitvoering\Bestellen" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\04 Ontwerp\03-As Built\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\04 Ontwerp\X-Ref" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\05 Berekeningen\01-BER\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\05 Berekeningen\01-BER\Rev-00" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\05 Berekeningen\02-Sondering" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\06 Leveranciers\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\07 Afwijkingen\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue

# copy "W:\damsteegt\KAM\Bedrijfshandboek DAMSTEEGT-CS-BdE\AD-04-04A Afwijkingsrapport AD rev3.xlsx" "07 Afwijkingen\"

if ( -not (Test-Path "$TargetFolder\07 Afwijkingen\AD-04-04A Afwijkingsrapport AD *.xlsx") )
{
    $FileToCopy = Get-ChildItem -Path "W:\damsteegt\KAM\Bedrijfshandboek DAMSTEEGT-CS-BdE\AD-04-04A Afwijkingsrapport AD *.xlsx" | Sort-Object -Descending | Select-Object -First 1
    Copy-Item -Path $FileToCopy -Destination "$TargetFolder\07 Afwijkingen\"
}

# mkdir "08 Werkplannen\00-Vervallen"
# mkdir "09 Omgeving\00-Vervallen"
# mkdir "10 Foto's\00-Vervallen"
# mkdir "11 Opleverdossier\00-Vervallen"

New-Item -Path "$TargetFolder\08 Werkplannen\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\09 Omgeving\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\10 Foto's\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "$TargetFolder\11 Opleverdossier\00-Vervallen" -ItemType Directory -ErrorAction SilentlyContinue
