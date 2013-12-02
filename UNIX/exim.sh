# Clear out frozen emails
exipick -i -z -s '' -o 4h |  xargs exim -Mrm

# Count of mails FROM addresses
exim -bp | awk '{print $4}' | sort | uniq -c | sort -k1g
