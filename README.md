# VulnHunt
Finds CVEs, Subdomain Takeovers, XSS, SQLi, Sensitive files/directories and many more on the target and its subdomains. Check : [Features](https://github.com/utkarsh24122/VulnHunt/blob/main/README.md#features)

Automated Vulnerability Checks

Run in background while you are testing manually 🍕

```
____    ____  __    __   __      .__   __.  __    __   __    __  .__   __. .___________. _______ .______      
\   \  /   / |  |  |  | |  |     |  \ |  | |  |  |  | |  |  |  | |  \ |  | |           ||   ____||   _  \     
 \   \/   /  |  |  |  | |  |     |   \|  | |  |__|  | |  |  |  | |   \|  |  ---|  |---- |  |__   |  |_)  |    
  \      /   |  |  |  | |  |     |  .    | |   __   | |  |  |  | |  .    |     |  |     |   __|  |      /     
   \    /    |   --'  | |   ----.|  |\   | |  |  |  | |   --'  | |  |\   |     |  |     |  |____ |  |\  \----.
    \__/      \______/  |_______||__| \__| |__|  |__|  \______/  |__| \__|     |__|     |_______|| _|  ._____|
                                                                   	                         @utkarsh24122
  
```

Jump To :

- [Features](https://github.com/utkarsh24122/VulnHunt/blob/main/README.md#features)                

- [Installation](https://github.com/utkarsh24122/VulnHunt/blob/main/README.md#installation)

- [Requirements](https://github.com/utkarsh24122/VulnHunt/blob/main/README.md#requirements)

- [Usage](https://github.com/utkarsh24122/VulnHunt/blob/main/README.md#usage)

- [ScreenShots](https://github.com/utkarsh24122/VulnHunt/blob/main/README.md#screenshots)


# Features

- Passive Subdomain Enumeration (All latest Tools used)
- Active Subdomain Enumeration  (DNSx)
- Subdomain Enum by Certificate Transparency
- DNS Subdomain Enumeration

.

- Scans for Subdomain Takeover using Nuclei Templates

.

- Filters active subdomains (DNS Resolution & probing)
- Segregates Subdomains according to response code

.

- CVE scans using nuclei templates 

.

- All vulnerabilties Check using extra templates  

.
- URL Extraction
- JavaScript Files Extraction
- Parameter Discovery

.

- GF Pattern Search for XSS, SSTI, OpenRedirect, SQLi, SSRF, RCE, LFI

.

- Vulnerability Checks for 

XSS

SSRF

SQLi

CORS

Open Redirect

LFI

CRLF

SSTI

.

- Fuzzing to find sensitive files/directories

  Faster fuzzing using interlace multithreading

# Installation
```
$ git clone https://github.com/utkarsh24122/VulnHunt
$ cd VulnHunt
$ chmod +x vulnhunt.sh

```
open the bash file and configure
```
#  Configurations:
PATH_TO_DNS_Resolvers="/path/resolvers.txt"
PATH_TO_NucleiTakeoverTemplate="/path/nuclei-templates/takeovers/"
PATH_TO_NucleiTemplates="/path/nuclei-templates/"
Path_To_FUZZ_Wordlist="/path/list.txt" 
# Recomended Wordlist : https://raw.githubusercontent.com/six2dez/OneListForAll/main/onelistforallshort.txt
path_to_paramspider="/path/ParamSpider/paramspider.py" 
# wget: https://github.com/devanshbatham/ParamSpider/blob/master/paramspider.py
path_to_ctfr_tool="/path/ctfr/ctfr.py"
# wget https://github.com/UnaPibaGeek/ctfr/blob/master/ctfr.py
cors_path="/path/Corsy/corsy.py" # Path to corsy.py 
path_OR="/path/OpenRedireX/openredirex.py" #path to openredirex.py
OR_payloads="/path/OpenRedireX/payloads.txt" # Path to OpenRedirect payloads
lfi_wordlist="/path/lfi_wordlist.txt" # Path to LFI wordlist
sqlmap="/path/sqlmap/sqlmap.py" # Path to sqlmap.py
# XSS_SERVER="" # Add XSS server and uncomment; else leave commented
```
# Requirements
- Golang
- Check: [Required Tools](https://github.com/utkarsh24122/VulnHunt/blob/main/Required_tools.txt)

PS: working on a single script to install all tools at once!

# Usage
```
./vulnhunt.sh target.com
```
