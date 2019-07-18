#!/bin/bash

if [ "$#" -eq 1 ] ; then
    path=$1
else
    path=main.beancount
fi

# This script will display all holdings

cat << EOF | bean-query $path
SELECT account, currency, cost(sum(position)) as holding
WHERE account ~ "Assets:(?!Funding)"
  OR account ~ "Liabilities:"
GROUP BY account, currency
ORDER by currency, holding, account
EOF

cat << EOF | bean-query $path
SELECT currency, cost(sum(position)) as holding
WHERE account ~ "Assets:(?!Funding)"
  OR account ~ "Liabilities:"
GROUP BY currency
ORDER by currency
EOF
