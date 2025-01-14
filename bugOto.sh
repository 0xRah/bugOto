#!/bin/bash

# Define colors
LR='\033[1;31m'
LG='\033[1;32m'
LY='\033[1;33m'
LB='\033[1;34m'
LP='\033[0;35m' # Purple
BOLD_WHITE='\033[1;97m'
BOLD_BLUE='\033[1;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
ORANGE='\033[38;5;214m'
NC='\033[0m'  # No Color

clear
echo
echo
echo -e "      ${LB}__                ____  __"
echo -e "     ${LB}/ /${LY}_  __  ______  ${LB}/${LY} __${LB} \\/ /_____ ${NC}"
echo -e "    ${LY}/ __ \\/ / / / __ \\/ / / / __/ __ \\"
echo -e "   ${LP}/ /_/ / /_/ / /_/ / /_/ / /_/ /_/ /"
echo -e "  ${LG}/_.___/\\__,_/\\__, /\\____/\\__/\\____/${NC}   v1.0.0"
echo -e "               ${LG}/___/${NC}"
echo -e "                          Made by Rahuman Mohamed (@rahuman_hamdi)"
echo

current_directory=$(pwd)
domain_name=""
normalized_domain=""
error_log="error_log.txt"
report_log="report_log.txt"
excluded_extensions="png|jpg|gif|jpeg|icon|swf|woff|svg|css|webp|woff|woff2|eot|ttf|tiff|otf|mp4"
move_extensions="js,txt,pdf,json"


# Function to display options
display_options() {
    echo -e "${BOLD_BLUE}Please select an option:${NC}"
    echo -e "${ORANGE}1: Install all tools (Pending Implementation)${NC}" # TODO: Not implimented yet
    echo -e "${ORANGE}2: Subdomain Enumeration - Single Domain (Pending Implementation)${NC}"
    echo -e "${ORANGE}3: Subdomain Enumeration - Multiple Domains (Pending Implementation)${NC}"
    echo -e "${GREEN}4: URL Crawling & Filtering - Single target (with Gf-Patterns outputs)${NC}"
    echo -e "${ORANGE}5: URL Crawling and Filtering - Multiple targets (with Gf-Patterns outputs) (Pending Implementation)${NC}"
    echo -e "${ORANGE}6: Content Discovery (Feroxbuster, Dirsearch, Ffuf) (Pending Implementation)${NC}"
    echo -e "${ORANGE}7: Find Hidden Parameters (Pending Implementation)${NC}"
    echo -e "${ORANGE}8: JavaScript analysis (Sensitive Data Search) (Pending Implementation)${NC}"
    echo -e "${ORANGE}9: Sqli Detection with Ghauri & Sqlmap (Pending Implementation)${NC}"
    echo -e "${ORANGE}10: CORS misconfigurations - Tool: Corsy by s0md3v  (Pending Implementation)${NC}"
    echo -e "${ORANGE}11: Help (Pending Implementation)${NC}"
    echo -e "${YELLOW}12: Exit${NC}"
}

# Check if the error log file exists, and remove it if it does
if [ -f "$error_log" ]; then
    rm "$error_log"
fi

# Function to show progress with emoji
show_progress() {
    echo -e "${GREEN}[*] Collecting URLs for $1 $2...⌛️${NC}"
    sleep 1
}

# =======================================================================================================

check_urls_tools() {

    echo -e "${BOLD_BLUE}[*] Checking URLs crawling tools${NC} ...⌛️"

    
    gau -h > /dev/null 2>&1 && echo -e "${GREEN}[~] Gau is installed${NC}" || echo -e "${RED}[x] Gau is not installed correctly${NC}"
    waybackurls -h > /dev/null 2>&1 && echo -e "${GREEN}[~] Waybackurls is installed${NC}" || echo -e "${RED}[x] Waybackurls is not installed correctly$NC}"
    #hakrawler -h > /dev/null 2>&1 && echo -e "${GREEN}[~] Hakrawler is installed${NC}" || echo -e "${RED}[x] Hakrawler is not installed correctly$NC}"
    katana -h > /dev/null 2>&1 && echo -e "${GREEN}[~] Katana is installed${NC}" || echo -e "${RED}[x] Katana is not installed correctly${NC}"
    urlfinder -h > /dev/null 2>&1 && echo -e "${GREEN}[~] Urlfinder is installed${NC}" || echo -e "${RED}[x] Urlfinder is not installed correctly${NC}"
    httpx -h > /dev/null 2>&1 && echo -e "${GREEN}[~] Httpx is installed${NC}" || echo -e "${RED}[x] Httpx is not installed correctly${NC}"
    subprober -h > /dev/null 2>&1 && echo -e "${GREEN}[~] Subprober is installed${NC}" || echo -e "${RED}[x] Subprober is not installed correctly${NC}"
    anew -h > /dev/null 2>&1 && echo -e "${GREEN}[~] Anew is installed${NC}" || echo -e "${RED}[x] Anew is not installed correctly${NC}"
    uro -h > /dev/null 2>&1 && echo -e "${GREEN}[~] Uro is installed${NC}" || echo -e "${RED}[x] Uro is not installed correctly${NC}"

    echo ""


}


echo ""

# Function - single domain crawling for urls......
single_domain_urls() {

    # Prompt the user for a domain name
    read -p "$(echo -e ${YELLOW}Enter the domain name: ${NC})" domain_name

    # Exit if the input is empty
    if [[ -z "$domain_name" ]]; then
        echo -e "${RED}[!] No domain name entered. Exiting...${NC}"
        exit 1
    fi

    # Check if the domain name contains a TLD (e.g., example.com)
    if [[ ! "$domain_name" =~ \.[a-zA-Z]{2,}$ ]]; then
        echo -e "${RED}[!] Please enter a domain name with TLD ${BOLD_WHITE}(e.g., example.com)${NC}"
        exit 1
    fi

    # Check if the user entered a scheme (e.g., http:// or https://)
    if [[ "$domain_name" =~ ^(http://|https://) ]]; then
        normalized_domain="$domain_name"
    else
        # Add "https://" if no scheme is provided
        normalized_domain="https://$domain_name"
    fi

    # Remove "http://" or "https://" if present
    domain_name="${domain_name//http:\/\//}"
    domain_name="${domain_name//https:\/\//}"

    # Check if the folder already exists // Only creating URL folder under domain_name ... TODO: need to loop and create folder if -f flag is used
    if [ -d "$current_directory/$domain_name" ]; then
        echo -e "${YELLOW}Folder '$domain_name' already exists in '$current_directory'.${NC}"
    
        if [ -d "$current_directory/$domain_name/urls" ]; then

            cd "$current_directory/$domain_name/urls"
            
            # Check if there are any .txt files in the current directory
            if ls *.txt &>/dev/null; then
                rm *.txt
            fi
        
        else
            # Create the folder if it doesn't exist
            mkdir -p "$current_directory/$domain_name/urls"
            cd "$current_directory/$domain_name/urls"
            echo -e "${YELLOW}Folder '$domain_name' created in '${current_directory}'.${NC}"
        fi
    else
        # Create the folder if it doesn't exist
        mkdir -p "$current_directory/$domain_name/urls"
        cd "$current_directory/$domain_name/urls"
        echo -e "${YELLOW}Folder '$domain_name' created in '${current_directory}'.${NC}"
    fi

}


# ==== Option 4 - URL Crawling & Filtering - Single target (with Gf-Patterns outputs) ====

get_urls() { 

    
    # Step 1: Collecting urls with Gau
    #{
        show_progress "${normalized_domain}" "using Gau"
        printf ${normalized_domain} | gau | anew "${domain_name}-gau.txt" # || handle_error "Gau crawl"
        # Output wordcount
    #} &

    # Step 2: Collecting urls with Waybackurls
    #{
        show_progress "${normalized_domain}" "using Waybackurls"
        echo ${normalized_domain} | waybackurls | anew "${domain_name}-waybacurls.txt" # || handle_error "Wayback crawl"
        # Output wordcount
    #} &

    # Step 3: Collecting urls with Hakrawler
    #{
        show_progress "${normalized_domain}" "using Hakrawler"
        echo ${normalized_domain} | hakrawler -subs -timeout 3 | anew "${domain_name}-hakrawler.txt" # || handle_error "Hakrawler crawl"
        # Output wordcount
    #} &

    # Step 4: Collecting urls with Urlfinder
    #{
        show_progress "${normalized_domain}" "using Urlfinder"
        urlfinder -d "${normalized_domain}" -v -f "${excluded_extensions}" -all -o "${domain_name}-urlfinder.txt" # || handle_error "Urlfinder crawl"
        # Output wordcount
    #} &

    # Step 5: Collecting urls with Katana
    #{
        show_progress "${normalized_domain}" "using Katana"
        katana -u "${normalized_domain}" -v -ef "${excluded_extensions}" -o "${domain_name}-katana.txt" # || handle_error "katana crawl"
        # Output wordcount
    #} &

    #wait # waiting till all the background taks to be completed

}

# Function - Combine urls......
combine_urls() { 

    # Combine all files matching the pattern and deduplicate
    cat "${domain_name}-"*.txt | sort -u | uro | anew "${domain_name}"-combined.txt

    # Use sed to remove ':80' after '.com' and save to a new file
    sed 's/\(\.[a-zA-Z]\+\):80/\1/g' "${domain_name}"-combined.txt > "${domain_name}"-cleaned.txt
    grep -Ev "\.(${excluded_extensions})(\?.*)?$" "${domain_name}"-cleaned.txt > "${domain_name}"-cleaned.txt
    rm "${domain_name}"-combined.txt

    echo ""
    echo -e "${GREEN}URL crawling completed !!!${NC}"
    echo ""

}

# Function - Probing urls......
probe_urls() {
    
    # TODO: Do some test why httpx is crashing the tmux session when urls numbers are so high
    #echo -e "${BOLD_BLUE}Running Httpx & Subprober, Subprober will take little time...!!! ${NC}"
    echo -e "${BOLD_BLUE}Running Subprober...!!! ${NC}"

    # Step 6: Probing with Httpx
    #{
        httpx -l "${domain_name}"-cleaned.txt -o "${domain_name}"-httpx.txt
    #} &

    # Step 6: Probing with Httpx
    #{
        subprober -f "${domain_name}"-cleaned.txt -o "${domain_name}"-subprober.txt
    #} &

    #wait # waiting till all the background taks to be completed
    sleep 2
    cat "${domain_name}-"httpx.txt "${domain_name}"-subprober.txt | sort -u | uro | anew "${domain_name}"-probed-httpx-subprober.txt
    #cat "${domain_name}"-subprober.txt | sort -u | uro | anew "${domain_name}"-probed.txt

}

gf_urls() {
    cd "${current_directory}/${domain_name}" 
    
    folder_name="gf_pattern_urls"
    clean_url_file="${current_directory}/${domain_name}/urls/${domain_name}-cleaned.txt"
    probed_url_file="${current_directory}/${domain_name}/urls/${domain_name}-probed-httpx-subprober.txt"
    #probed_url_file="${current_directory}/${domain_name}/urls/${domain_name}-probed.txt"

    echo ""
    # Check if the folder exists
    if [ -d "$folder_name" ]; then
        echo -e "${YELLOW}Folder '$folder_name' exists. Navigating to it...${NC}"
        cd "$folder_name" || { echo -e "${RED}Failed to navigate to '$folder_name'.${NC}"; exit 1; }
        
        if ls *.txt &>/dev/null; then
            rm *.txt
        fi
    else
        echo -e "${YELLOW}Folder '$folder_name' does not exist. Creating it...${NC}"
        mkdir "$folder_name"
        cd "$folder_name" || { echo -e "${RED}Failed to navigate to '$folder_name'.${NC}"; exit 1; }
    fi

    # Check if the file exists in the current directory
    if [ -f "${clean_url_file}" ]; then
        echo -e "${GREEN}The file '$clean_url_file' exists.${NC}"
        
        cat "${clean_url_file}" | gf xss | anew xss_all_urls.txt 
        cat "${clean_url_file}" | gf sqli | anew sqli_all_urls.txt 
        cat "${clean_url_file}" | gf lfi| anew lfi_all_urls.txt 
        cat "${clean_url_file}" | gf idor | anew idor_all_urls.txt 
        cat "${clean_url_file}" | gf jwt | anew jwt_all_urls.txt 
        cat "${clean_url_file}" | gf redirect | anew redirect_all_urls.txt 
        cat "${clean_url_file}" | gf rce | anew rce_all_urls.txt 
        cat "${clean_url_file}" | gf secret | anew secret_all_urls.txt 
        cat "${clean_url_file}" | gf ssrf | anew ssrf_all_urls.txt 
        cat "${clean_url_file}" | gf ssti | anew ssti_all_urls.txt 
        cat "${clean_url_file}" | gf takeovers | anew takeovers_all_urls.txt 
        cat "${clean_url_file}" | gf upload-fields | anew upload-fields_all_urls.txt 
    else
        echo -e "${RED}[x] Error: The file '$clean_url_file' does not exist.${NC}"
    fi

    # Check if the file exists in the current directory
    if [ -f "${probed_url_file}" ]; then
        echo -e "${GREEN}The file '$probed_url_file' exists.${NC}"

        cat "${probed_url_file}" | gf xss | anew xss_probed_urls.txt 
        cat "${probed_url_file}" | gf sqli | anew sqli_probed_urls.txt 
        cat "${probed_url_file}" | gf lfi | anew lft_probed_urls.txt 
        cat "${probed_url_file}" | gf idor | anew idor_probed_urls.txt 
        cat "${probed_url_file}" | gf jwt | anew jwt_probed_urls.txt 
        cat "${probed_url_file}" | gf redirect | anew redirect_probed_urls.txt 
        cat "${probed_url_file}" | gf rce | anew rce_probed_urls.txt 
        cat "${probed_url_file}" | gf secret | anew secret_probed_urls.txt 
        cat "${probed_url_file}" | gf ssrf | anew ssrf_probed_urls.txt 
        cat "${probed_url_file}" | gf ssti | anew ssti_probed_urls.txt 
        cat "${probed_url_file}" | gf takeovers | anew takeovers_probed_urls.txt 
        cat "${probed_url_file}" | gf upload-fields | anew upload-fields_probed_urls.txt 
    else
        echo -e "${RED}[x] Error: The file '$probed_url_file' does not exist.${NC}"
    fi

    # Find and remove all empty .txt files in the current directory
    if find . -maxdepth 1 -type f -name "*.txt" -size 0 | grep -q .; then
        #echo -e "${CYAN}Removing empty .txt files...${NC}"
        find . -maxdepth 1 -type f -name "*.txt" -size 0 -exec rm -v {} \;
    fi


}



run_option_4() {
    check_urls_tools
    single_domain_urls
    get_urls
    sleep 2
    combine_urls 
    probe_urls
    sleep 2
    gf_urls
    echo ""
    echo -e "${GREEN}[*] URLs scanning completed. Results are saved in ${domain_name}/urls${NC}"
    exit 1
}


# Main script logic

while true; do
    # Display options
    display_options
    read -p "Enter your choice [1-11]: " choice

    case $choice in
        1)
            #install_tools
            echo -e "${RED}[!] Pending Implementation${NC}"
            echo ""
            ;;
        
        2)
            #read -p "Please enter a domain name (example.com): " domain_name
            #echo -e "${BOLD_WHITE}You selected: Domain name set to $domain_name${NC}"
            
            echo -e "${RED}[!] Pending Implementation${NC}"
            echo ""
            ;;
        
        3)
            
            echo -e "${RED}[!] Pending Implementation${NC}"
            echo ""
            ;;
        
        4)
            run_option_4
            ;;
        
        5)
            
            run_option_5
            ;;
        
        6)
            
            echo -e "${RED}[!] Pending Implementation${NC}"
            echo ""
            ;;
        
        7)
            
            echo -e "${RED}[!] Pending Implementation${NC}"
            echo ""
            ;;
        
        8)
            
            echo -e "${RED}[!] Pending Implementation${NC}"
            echo ""
            ;;
        
        9)
            
            echo -e "${RED}[!] Pending Implementation${NC}"
            echo ""
            ;;
        
        10)
            
            echo -e "${RED}[!] Pending Implementation${NC}"
            echo ""
            ;;

        11)
        
            echo -r "${RED}[!] Pending Implementations${NC}"
            echo ""
            ;;
            
        12) # Exit..
            echo "Exiting script."
            exit 0
            ;;
        *)
            echo "Invalid option. Please select a number between 1 and 11."
            ;;
    esac
done

cd ${current_directory}
