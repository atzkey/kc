
:<<KACHING
account direction amount currency subject
------------------------------------------
cash    +         100    USD      salary
cash    -         5      USD      food
cash    -         6      USD      food
cash    -         7      USD      food
cash    -         15     USD      fuel
cash    -         10     USD      exchange
cash    +         500    BRB      exchange
cash    -         500    BRB      food

kc calculates number of transactions and remainder by currency, by currency and account, by currency and subject
KACHING

program=`basename $0`

if [ -z "$1" -o ! -r "$1" -o "$1" = "-h" -o "$1" = "--help" ] # Help! Help! Help!
then
  cat <<DOCUMENTATION
Usage: $program <ka-ching file>
DOCUMENTATION
  exit 0
fi

cat $1 |
awk '
  BEGIN {
    count[""] = 0;
    balance[""] = 0;
  }
  {
    # validate input
    if (NF != 5) {
      # do nothing
    } else {
      # assign field names
      account = $1;
      direction = $2;
      amount = $3;
      currency = $4;
      subject = $5;
      
      # I"m the operator with my pocket calculator
      count["* * * " currency " *"]++;
      count["* * * " currency " " subject]++;
      count[account " * * " currency " *"]++;
      
      # I am adding and subtracting
      if (direction == "-") {
        amount *= -1;
      }
      
      # I"m controlling and composing
      balance["* * * " currency " *"] += amount;
      balance["* * * " currency " " subject] += amount;
      balance[account " * * " currency " *"]+= amount;
    }
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