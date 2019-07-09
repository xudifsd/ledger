#!/bin/bash

if [ "$#" -ne 1 ] ; then
    echo "Usage $0 bean-file" >&2
    exit 1
fi

# This script will display all holdings

cat << EOF | bean-query $1
SELECT account, currency, cost(sum(position)) as holding
WHERE account ~ "Assets:(?!Funding)"
  OR account ~ "Liabilities:"
GROUP BY account, currency
ORDER by currency, holding, account
EOF

cat << EOF | bean-query $1
SELECT currency, cost(sum(position)) as holding
WHERE account ~ "Assets:(?!Funding)"
  OR account ~ "Liabilities:"
GROUP BY currency
ORDER by currency
EOF
