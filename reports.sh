#!/bin/bash

# This function will display all holdings
holding() {
    cat << EOF | bean-query $path
    SELECT account, currency, COST(sum(position)) as holding
    WHERE account ~ "Assets:(?!Funding)"
      OR account ~ "Liabilities:"
    GROUP BY account, currency
    ORDER by currency, holding, account
EOF

    cat << EOF | bean-query $path
    SELECT currency, COST(sum(position)) as holding
    WHERE account ~ "Assets:(?!Funding)"
      OR account ~ "Liabilities:"
    GROUP BY currency
    ORDER by currency
EOF
}

# This function will display all spending from begining,
# the spending exclude all income from salary and expenses to Government related.
# So the number means without salary how my finance performing, negative means
# I earned more, positive means I spend more.
spending() {
    cat << EOF | bean-query $path
    SELECT year, month, currency, COST(sum(position)) as spending
    WHERE (NOT 'payslip' IN tags) AND (account ~ "Expenses:*" OR account ~ "Income:*")
    GROUP BY year, month, currency
    ORDER by year, month, currency
EOF
}

investing() {
    cat << EOF | bean-query $path
    SELECT tags AS symbol, COST(sum(position)) AS profit
    WHERE (account = "Income:Investing:Tiger:PnL" OR account = "Expenses:Investing:Tiger:Fees")
    GROUP BY symbol
    ORDER BY profit
EOF
echo
    cat << EOF | bean-query $path
    SELECT year, month, COST(sum(position)) as profit
    WHERE (account = "Income:Investing:Tiger:PnL" OR account = "Expenses:Investing:Tiger:Fees")
    GROUP BY year, month
    ORDER BY year, month
EOF
echo
    cat << EOF | bean-query $path
    SELECT COST(sum(position)) as total_profit
    WHERE (account = "Income:Investing:Tiger:PnL" OR account = "Expenses:Investing:Tiger:Fees")
EOF
}

usage="Usage: $0 [spending|holding|investing]"

if [ "$#" -ne 1 -a "$#" -ne 2 ] ; then
    echo "$usage" >&2
    exit 1
fi

if [ "$#" -eq 2 ] ; then
    path=$1
else
    path=main.beancount
fi

if [ "$1x" = "holdingx" ] ; then
    holding $path
elif [ "$1x" = "spendingx" ] ; then
    spending $path
elif [ "$1x" = "investingx" ] ; then
    investing $path
else
    echo "$usage" >&2
    exit 1
fi
