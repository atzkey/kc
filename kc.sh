set -e

script=${0##*/}
transaction=${script#kc}
bank="$HOME/.kc"
file=${bank}/$(date '+%Y-%m-%d')

[ ! -d "$bank" ] && mkdir "$bank"
touch "$file"

if [ "$1" = "-h" -o "$1" = "--help" ] # Help! Help! Help!
then
  cat <<DOCUMENTATION
Usage: kc [file ...]
       kc+ <account> <amount> <currency> <category>
       kc- <account> <amount> <currency> <category>
DOCUMENTATION
  exit 0
fi

cat $(ls $bank/*) |
awk '
  BEGIN {
    count[""] = 0;
    balance[""] = 0;
  }
  NF == 5 {
    account = $1;
    direction = $2;
    amount = $3;
    currency = $4;
    subject = $5;
    
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