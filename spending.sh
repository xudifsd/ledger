#!/bin/bash

if [ "$#" -eq 1 ] ; then
    path=$1
else
    path=main.beancount
fi

# This script will display all spending from begining,
# the spending exclude all income from salary and expenses to Government related.
# So the number means without salary how my finance performing, negative means
# I earned more, positive means I spend more.

cat << EOF | bean-query $path
SELECT year, month, currency, cost(sum(position)) as spending
WHERE (NOT 'payslip' IN tags) AND (account ~ "Expenses:*" OR account ~ "Income:*")
GROUP BY year, month, currency
ORDER by year, month, currency
EOF
