#!/usr/bin/env python3

import argparse
import logging
import datetime
import sys

log = logging.getLogger(__name__)

def format_time(date):
    return date.strftime("%Y-%m-%d")

def to_valid_commodity(s):
    return s + "_S" if len(s) == 1 else s

def buy(args):
    template = """
%s * "Bought %s" #%s
    Assets:Investing:Robinhood:Cash    -%.2f USD
    Assets:Investing:Robinhood:Stock   %d %s {%.2f USD}
"""
    cash = args.quantity * args.cost

    print(template % (
        args.date, args.symbol, args.symbol,
        cash,
        args.quantity, to_valid_commodity(args.symbol), args.cost))

def sell(args):
    template = """
%s * "Sold %s" #%s
    Assets:Investing:Robinhood:Cash     %.2f USD
    Assets:Investing:Robinhood:Stock   -%d %s {%.2f USD} @ %.2f USD
    Income:Investing:Robinhood:PnL      %.2f USD
%s
"""
    cash = args.quantity * args.cost - args.fee
    pnl = (args.price - args.cost) * args.quantity
    if args.fee != 0.0:
        fee_line = "    Expenses:Fee:Investing:Robinhood   %.2f USD" % (args.fee)
    else:
        fee_line = ""

    print(template % (
        args.date, args.symbol, args.symbol,
        cash,
        args.quantity, to_valid_commodity(args.symbol), args.price, args.cost,
        pnl,
        fee_line))

def main(args):
    if args.date is None:
        args.date = format_time(datetime.datetime.now())

    if args.action == "sell":
        if args.price is None:
            log.error("should provide price when selling")
            sys.exit(1)
        sell(args)
    elif args.action == "buy":
        buy(args)
    else:
        log.error("unknown action %s", args.action)
        sys.exit(2)

if __name__ == '__main__':
    logging.basicConfig(format="%(asctime)s - %(levelname)s - %(filename)s:%(lineno)s - %(message)s",
            level=logging.INFO)

    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=["sell", "buy"])
    parser.add_argument("--date", "-d", help="date of transcation, like 2019-01-01")
    parser.add_argument("--symbol", "-s", required=True, help="stock symbol")
    parser.add_argument("--quantity", "-q", required=True, type=int,
            help="stock quantity of transcation")
    parser.add_argument("--cost", "-c", required=True, type=float,
            help="cost to buy this stock")
    parser.add_argument("--fee", "-f", default=0.0, type=float,
            help="fee to buy this stock")
    parser.add_argument("--price", "-p", type=float,
            help="price of bough, only used in sell action")

    args = parser.parse_args()
    main(args)
