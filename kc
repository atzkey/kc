#!/bin/bash
set -e

script=${0##*/}
transaction=${script#kc}
ledger="$HOME/.kc"
journal=${JOURNAL:-$(date '+%Y-%m')}

[ ! -d "$ledger" ] && mkdir "$ledger"
touch "$ledger/$journal"

if [ "$1" = "-h" -o "$1" = "--help" ] # Help! Help! Help!
then
  cat <<DOCUMENTATION
Usage: kc [pattern]
       kc+ <account> <amount> <currency> <category>
       kc- <account> <amount> <currency> <category>
DOCUMENTATION
  exit 0
fi

case $transaction in
  "+"|"-")
    echo $transaction $@ >> $ledger/$journal
    exit # +/-
  ;;
  "")
    # kc!
  ;;
  *)
    echo "Hmm..."
  ;;
esac

# exit 0

cat $ledger/${1}* |
awk '
  BEGIN {
    count[""] = 0;
    balance[""] = 0;
  }
  NF >= 5 {
    direction = $1;
    account = $2;
    amount = $3;
    currency = $4;
    subject = substr($0,length($1 $2 $3 $4) + 5);
    
    # I"m the operator with my pocket calculator
    count["* " currency " balance"]++;
    count[currency " " subject]++;
    count[account " " currency " balance"]++;
    
    # I am adding and subtracting
    if (direction == "-") {
      amount *= -1;
    }
    
    # I"m controlling and composing
    balance["* " currency " balance"] += amount;
    balance[currency " " subject] += amount;
    balance[account " " currency " balance"]+= amount;
  }
  END {
    # By pressing down a special key, it plays a little melody
    for (i in count) {
      if (i != "") {
        printf("%5d %10d  %s\n", count[i], balance[i], i)
      }
    }
  }
  # ka`ching!' |
# sorting numerically by first field (num transactions), reversing
sort -nr
