domains=("PrestoPeak.is" "MovaQuest.is" "AlVefur.is" "MinEign.is" "OpinMarkadur.is" "Eignaheimur.is" "EignaPort.is" "VistVaktarinn.is" "RafraenEign.is"



# Forlykkja til að athuga hvert léni
for domain in "${domains[@]}"; do
    whois $domain | grep -E "No match|NOT FOUND|No Data Found|Domain not found"
    if [ $? -eq 0 ]; then
        echo "$domain er laust."
    fi
done
