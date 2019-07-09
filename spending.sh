#!/bin/bash

if [ "$#" -ne 1 ] ; then
    echo "Usage $0 bean-file" >&2
    exit 1
fi

# This script will display all spending from begining,
# the spending exclude all income from salary and expenses to Government related.
# So the number means without salary how my finance performing, negative means
# I earned more, positive means I spend more.

cat << EOF | bean-query $1
SELECT year, month, currency, cost(sum(position)) as spending
WHERE account ~ "Expenses:(?!Gov)"
  OR (account ~ "Income:"
      AND account != "Income:MS:Salary"
      AND account != "Income:MS:StateDeduction")
  AND month > 3
GROUP BY year, month, currency
ORDER by year, month, currency
EOF
