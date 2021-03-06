# Configurations :
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

echo "____    ____  __    __   __      .__   __.  __    __   __    __  .__   __. .___________. _______ .______      	"
echo "\   \  /   / |  |  |  | |  |     |  \ |  | |  |  |  | |  |  |  | |  \ |  | |           ||   ____||   _  \     	"
echo " \   \/   /  |  |  |  | |  |     |   \|  | |  |__|  | |  |  |  | |   \|  |  ---|  |---- |  |__   |  |_)  |    	"
echo "  \      /   |  |  |  | |  |     |  .    | |   __   | |  |  |  | |  .    |     |  |     |   __|  |      /     	"
echo "   \    /    |   --'  | |   ----.|  |\   | |  |  |  | |   --'  | |  |\   |     |  |     |  |____ |  |\  \----.	"
echo "    \__/      \______/  |_______||__| \__| |__|  |__|  \______/  |__| \__|     |__|     |_______||__|  ._____|	"
echo "													   @utkarsh24122"
echo ""
target=$1
echo ""
echo "Target ===> $target"
        echo ""
echo "" 
echo "All Output stored in /$target "
echo "" 
mkdir $target
cd $target
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Passive Subdomain Enumeration Running for $target \e[0m\n"
echo ""
subfinder -all -d $target -silent >> tempsubdomain.txt
assetfinder --subs-only $target >> tempsubdomain.txt
findomain --quiet -t $target >> tempsubdomain.txt
waybackurls $target | unfurl -u domains >> tempsubdomain.txt
crobat -s $target >> tempsubdomain.txt
cat tempsubdomain.txt | sort -u >> temp2.txt
rm tempsubdomain.txt
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Passive Subdomain Enumeration Completed \e[0m\n"
echo ""
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Now Running Active Subdomain Enumeration \e[0m\n" 
echo $target | dnsx -retry 3 -silent -r $PATH_TO_DNS_Resolvers >> temp2.txt
echo ""
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Active Subdomain Enumeration Completed \e[0m\n" 
echo ""
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Now Running crt.sh Subdomain Enumeration \e[0m\n" 
python3 $path_to_ctfr_tool -d $target -o lolo1.txt >> lolo2.txt
cat lolo1.txt >> ctrshtemp.txt
rm lolo1.txt lolo2.txt
curl "https://tls.bufferover.run/dns?q=.$target" 2>>"verytemp.txt" | jq -r .Results[] 2>>"verytemp.txt" | cut -d ',' -f3 | grep -F ".$target" >> ctrshtemp.txt
rm verytemp.txt
curl "https://dns.bufferover.run/dns?q=.$target" 2>>"verytemp.txt" | jq -r '.FDNS_A'[],'.RDNS'[] 2>>"verytemp.txt" | cut -d ',' -f2 | grep -F ".$target"  >> ctrshtemp.txt
rm verytemp.txt
cat ctrshtemp.txt | sort -u >> crtsh_subs.txt
rm  ctrshtemp.txt
mv temp2.txt temp.txt
cat crtsh_subs.txt >> temp.txt
cat temp.txt | sort -u >> temp2.txt;rm temp.txt;rm crtsh_subs.txt
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m crt.sh  Subdomain Enumeration Completed \e[0m\n" 
echo ""
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Now Running DNS Subdomain Enumeration \e[0m\n" 
# dnsx -retry 3 -a -aaaa -cname -ns -ptr -mx -soa -resp -silent -l temp2.txt -r  $PATH_TO_DNS_Resolvers >> sub_cname.txt
# cat sub_cname.txt | cut -d '[' -f2 | sed 's/.$//' | grep ".$domain$" >> verytemp.txt
# cat verytemp.txt | sort -u >> sub_dns.txt
# rm verytemp.txt
# puredns resolve sub_dns.txt -r $PATH_TO_DNS_Resolvers >> rresolved.txt
# cat rresolved.txt >> temp2.txt
# rm rresolved.txt
cat temp2.txt | grep www. | cut -d w -f4 | sed 's/^.//' >> temp3.txt
cat temp3.txt >> temp2.txt
cat temp2.txt | grep -v www. | sort -u | grep -v '*' >> all_subs.txt
rm temp2.txt temp3.txt

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Probing \e[0m\n" 
cat all_subs.txt | httprobe -prefer-https >> probed.txt
cat probed.txt | cut -d / -f3 >> alive_subs.txt
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Segregating \e[0m\n" 

cat probed.txt | cut -d / -f3 | httpx -status-code -silent >> codes.txt
cat codes.txt | grep 200 | cut -d [ -f1 >> 200.txt
cat codes.txt | grep 30 | cut -d [ -f1 >> 30x.txt
cat codes.txt | grep 403 | cut -d [ -f1 >> 403.txt
cat codes.txt | grep 404 | cut -d [ -f1 >> 404.txt
rm codes.txt

#										Subdomain Takeover Check

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Checking For Subdomain Takeover \e[0m\n" 


touch tko.txt
cat probed.txt | nuclei -silent -t $PATH_TO_NucleiTakeoverTemplate -o tko.txt
NUMOFLINES=$(cat tko.txt | wc -l)
if [ "$NUMOFLINES" -gt 0 ]; then
			echo "Possible Subdomain Takeover Found" 
else echo "NOT Found XD "
		fi

#										Nuclei templates Check

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Running Nuclei Templates \e[0m\n" 
mkdir nuclei_output
eval cat probed.txt | nuclei -silent -t $PATH_TO_NucleiTemplates -severity info -o nuclei_output/info.txt
eval cat probed.txt | nuclei -silent -t $PATH_TO_NucleiTemplates -severity low -o nuclei_output/low.txt
eval cat probed.txt | nuclei -silent -t $PATH_TO_NucleiTemplates -severity medium -o nuclei_output/medium.txt
eval cat probed.txt | nuclei -silent -t $PATH_TO_NucleiTemplates -severity high -o nuclei_output/high.txt
eval cat probed.txt | nuclei -silent -t $PATH_TO_NucleiTemplates -severity critical -o nuclei_output/critical.txt

#										URL Extraction , JavaScript files extraction & Parameter Discovery

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m URL Extraction started \e[0m\n"
echo ""
echo "Running waybackurls ..."
cat probed.txt | waybackurls >> turl.txt
echo ""
echo "Running gauplus ..."
cat probed.txt | gauplus -subs -t 10 >> turl.txt
echo ""
echo "Running gospider ..."
gospider -S probed.txt --js -t 50 -d 2 -w -r --sitemap --robots >> tempspider.txt
sed -i '/^.\{2048\}./d' tempspider.txt
[ -s "tempspider.txt" ] && cat tempspider.txt | grep -Eo 'https?://[^ ]+' | sed 's/]$//' | grep ".$domain" | sort -u >> turl.txt
mv turl.txt utemp.txt;cat utemp.txt | sort -u >> turl.txt;rm utemp.txt
cat turl.txt | urldedupe >> all_urls.txt
cat all_urls.txt | grep -Eiv "\.(eot|jpg|jpeg|gif|css|tif|tiff|png|ttf|otf|woff|woff2|ico|pdf|svg|txt|js)$" >> imp_urls.txt
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m URLs Extracted ; Saved in all_urls.txt & imp_urls.txt \e[0m\n"
echo ""
cat turl.txt | grep "${domain}" | grep -Ei "\.(js)" >> JSFiles.txt
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m JavaScript FIles Extracted ; Saved in JSFiles.txt \e[0m\n"
echo ""

cat all_urls.txt | grep "${domain}" | grep "=" | qsreplace -a | grep -Eiv "\.(eot|jpg|jpeg|gif|css|tif|tiff|png|ttf|otf|woff|woff2|ico|pdf|svg|txt|js)$" | sort -u | urldedupe >> params.txt
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Parameters Discovered ; Saved in params.txt \e[0m\n"
echo ""

mv tempspider.txt gospider_out.txt
rm turl.txt

echo ""

#										GF Pattern Search

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m GF Pattern Search  \e[0m\n"
echo ""
mkdir gf
echo "	#	Finding potential XSS..."
echo ""


			gf xss all_urls.txt | sort -u >> ./gf/xss.txt
echo "Saved in /gf/xss.txt"
echo ""
echo "	#	Finding potential SSTI..."
echo ""
			gf ssti all_urls.txt | sort -u >> ./gf/ssti.txt
echo "Saved in /gf/ssti.txt"
echo ""

echo "	#	Finding potential SSRF..."
echo ""

			gf ssrf all_urls.txt | sort -u >> ./gf/ssrf.txt
echo "Saved in /gf/ssrf.txt"
echo ""
echo "	#	Finding potential SQLi..."
echo ""
			gf sqli all_urls.txt | sort -u >> ./gf/sqli.txt
echo "Saved in /gf/sqli.txt"
echo ""

echo "	#	Finding potential Open Redirect..."
echo ""

			gf redirect all_urls.txt | sort -u >> ./gf/redirect.txt
			[ -f "./gf/ssrf.txt" ] && cat ./gf/ssrf.txt | sort -u >> ./gf/redirect.txt
echo "Saved in /gf/redirect.txt"
echo ""
echo "	#	Finding potential RCE..."
echo ""
			gf rce all_urls.txt | sort -u >> ./gf/rce.txt
echo "Saved in /gf/rce.txt"
echo ""

echo "	#	Finding potential LFI..."
echo ""
			gf potential all_urls.txt | cut -d ':' -f3-5 | sort -u >> ./gf/potential.txt
			[ -s "all_urls.txt" ] && cat all_urls.txt | grep -Eiv "\.(eot|jpg|jpeg|gif|css|tif|tiff|png|ttf|otf|woff|woff2|ico|pdf|svg|txt|js)$" | unfurl -u format %s://%d%p | sort -u >> ./gf/endpoints.txt

			gf lfi all_urls.txt | sort -u >> ./gf/lfi.txt
echo "Saved in /gf/lfi.txt"
echo ""
echo ""			
		
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m GF Pattern Search Completed ; Saved in /gf/ \e[0m\n"
echo ""

echo ""

#										Vulnerability Checks

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Vulnerability Checks \e[0m\n"
			
mkdir vulns

#										CORS Check

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Testing for CORS \e[0m\n"

python3 $cors_path -i probed.txt >> ./vulns/cors.txt 

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m CORS Output Saved in /vulns/cors.txt \e[0m\n" 

#										Open Redirect Check

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Testing for Open Redirects \e[0m\n"

if [ -s "./gf/redirect.txt" ]; then

	if [[ $(cat ./gf/redirect.txt | wc -l) -le 1000 ]]; then

		cat ./gf/redirect.txt | qsreplace FUZZ | sort -u >> tempred.txt
		python3 $path_OR -l tempred.txt --keyword FUZZ -p $OR_payloads | grep "^http" >> ./vulns/redirect.txt
		sed -r -i "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" ./vulns/redirect.txt
		rm tempred.txt

	else echo "Too many potential URLs ... skipping ... try seperately"
	fi

else echo "No potential Open Redirects"
fi

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Open Redirect Output Saved in /vulns/redirect.txt \e[0m\n" 
echo ""

#										Local File Inclusion Check

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Testing for Local File Inclusion \e[0m\n"

if [ -s "./gf/lfi.txt" ]; then

	if [[ $(cat ./gf/lfi.txt | wc -l) -le 1000 ]]; then

		cat ./gf/lfi.txt | qsreplace FUZZ | sort -u >> tempred.txt
		

		for url in $(cat tempred.txt); do
		
		HEADER="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0"
		ffuf -v -t 40 -H "${HEADER}" -w $lfi_wordlist -u $url -mr "root:" 2>/dev/null | grep "URL" | sed 's/| URL | //' | sort -u >> ./vulns/lfi.txt		

		done


		rm tempred.txt

	else echo "Too many potential URLs ... skipping ... try seperately"
	fi

else echo "No potential Local File Inclusions"
fi

if [[ $(cat ./vulns/lfi.txt | wc -l) -le 1 ]]; then
echo "No LFI found"
fi
echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m LFI Output Saved in /vulns/lfi.txt \e[0m\n" 
echo ""

#										CRLF Check

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Testing for Carriage Return Line Feed (CRLF) Injection \e[0m\n"

if [[ $(cat probed.txt | wc -l) -le 500 ]]; then

	crlfuzz -l probed.txt -o vulns/crlf.txt &>/dev/null

else echo "Too many URLs ... check seperately"
fi

if [[ $(cat ./vulns/crlf.txt | wc -l) -le 1 ]]; then
echo "No CRLF found"
fi

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m CRLF Output Saved in /vulns/crlf.txt \e[0m\n" 
echo ""

#										SQLi Check

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Testing for SQL Injection \e[0m\n"

if [ -s "./gf/sqli.txt" ]; then

	if [[ $(cat ./gf/sqli.txt | wc -l) -le 1000 ]]; then

		cat ./gf/sqli.txt | qsreplace FUZZ | sort -u >> tempred.txt
		

	interlace -tL tempred.txt -threads 10 -c "python3 $sqlmap -u _target_ -b --batch --disable-coloring --random-agent --output-dir=_output_" -o vulns/sqlmap &>/dev/null


		rm tempred.txt

	else echo "Too many potential URLs ... skipping ... try seperately"
	fi

else echo "No potential SQLi"
fi


echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m SQLi Output Saved in /vulns/sqlmap/ \e[0m\n" 

echo ""

#										SSTI Check

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Testing for Server Side Template Injection \e[0m\n"

if [ -s "./gf/ssti.txt" ]; then

	if [[ $(cat ./gf/ssti.txt | wc -l) -le 1000 ]]; then

		cat ./gf/ssti.txt | qsreplace FUZZ | sort -u >> tempred.txt
		
		for url in $(cat tempred.txt); do
			HEADER="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0"
			ffuf -v -t 40 -H "${HEADER}" -w $ssti_payloads -u $url -mr "ssti49" 2>/dev/null | grep "URL" | sed 's/| URL | //' | sort -u >> vulns/ssti.txt
		done
		rm tempred.txt

	else echo "Too many potential URLs ... skipping ... try seperately"
	fi

else echo "No potential SSTI"
fi

if [[ $(cat ./vulns/ssti.txt | wc -l) -le 1 ]]; then
echo "No SSTI found"
fi

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m SSTI Output Saved in /vulns/ssti.txt \e[0m\n" 
echo ""

#										XSS Check

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Testing for Cross Site Scripting \e[0m\n"

if [ -s "./gf/xss.txt" ]; then

cat ./gf/xss.txt | qsreplace FUZZ | Gxss -c 100 -p Xss | sort -u >> tempxss.txt
		
		if [[ $(cat tempxss.txt | wc -l) -le 1 ]]; then
		echo "No Potential XSS"
		else
			if [[ $(cat tempxss.txt | wc -l) -le 1000 ]]; then
		
				if [ -n "$XSS_SERVER" ]; then
				cat tempxss.txt | dalfox pipe --silence --no-color --no-spinner --mass --mass-worker 100 --multicast --skip-bav -b ${XSS_SERVER} -w 200 | sort -u >> vulns/xss.txt
				else
					printf "\n No XSS_SERVER defined, blind xss skipped\n\n"
					cat tempxss.txt | dalfox pipe --silence --no-color --no-spinner --mass --mass-worker 100 --multicast --skip-bav -w 200 | sort -u >> vulns/xss.txt
				fi


			else echo "Too many URLs ... Check seperately"
			fi 

		fi
rm -f tempxss.txt
else echo "No potential xss"
fi

if [[ $(cat ./vulns/xss.txt | wc -l) -le 1 ]]; then
echo ""
echo "No XSS found"
fi

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m XSS Output Saved in /vulns/xss.txt \e[0m\n" 


#										Fuzzing


echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Fuzzing \e[0m\n" 
mkdir fuzz_out
touch logfile.txt
HEADER="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0"
interlace -tL probed.txt -threads 10 -c "ffuf -mc all -fc 404 -ac -sf -s -H \"${HEADER}\" -w $Path_To_FUZZ_Wordlist -u  _target_/FUZZ -of csv -o _output_/_cleantarget_.csv -ac" -o fuzz_out >> logfile.txt
rm logfile.txt

for sub in $(cat probed.txt); do
sub_out=$(echo $sub | sed -e 's|^[^/]*//||' -e 's|/.*$||')
[ -s "./fuzz_out/${sub_out}.csv" ] && cat ./fuzz_out/${sub_out}.csv | cut -d ',' -f2,5,6 | tr ',' ' ' | awk '{ print $2 " " $3 " " $1}' | tail -n +2 | sort -k1 | sort -u >> ./fuzz_out/${sub_out}.txt
rm -f ./fuzz_out/${sub_out}.csv
done

echo -e "\n\e[36m[\e[32m+\e[36m]\e[92m Fuzzing Output Saved in /fuzz_out \e[0m\n" 

