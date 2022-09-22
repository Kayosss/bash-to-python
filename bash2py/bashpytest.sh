#!/bin/dash

# Ensure that bash2py.py is executable, has appropriate permissions and
# is in a directory included in your path
# Enter the following line to temporarily add the current directory to path:
# -------------------
#  PATH=$PATH:$(pwd)
# -------------------

# Test script which tests the expected behaviour of bashpy

# Directory where test will be run
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

numPassed=0

recieved=$(mktemp)
expected=$(mktemp)

echo '#!/bin/bash

# sum the integers $start .. $finish

start=1
finish=100
sum=0

i=1
while ((i <= finish))
do
    sum=$((sum + i))
    i=$((i + 1))
done

echo $sum' > sum.sh

echo '#!/usr/bin/env python3

# sum the integers $start .. $finish

start = 1
finish = 100
sum = 0

i = 1
while i <= finish:
    sum = sum + i
    i = i + 1

print(sum)' > sum.py

bash2py.py < "sum.sh" > "$recieved" 2>&1

echo "------------------"
echo "Testing sum"
echo "------------------"


if diff "$recieved" "sum.py" > /dev/null
then
    echo "\e[1;32mOutput scripts are same\e[0m"
else
    echo "\e[0;33mScripts differ\e[0m"
fi

bash2py.py < "sum.sh" | python3 > "$recieved" 2>&1
python3 sum.py > "$expected" 2>&1

if diff "$recieved" "$expected" > /dev/null
then
    echo "\e[1;32msum.sh Passed.\e[0m"
    numPassed=$((numPassed + 1))
else
    echo "\e[1;31msum.sh Failed.\e[0m"
fi

echo '#!/bin/bash

# calculate powers of 2 by repeated addition

i=1
j=1
while ((i < 31))
do
    j=$((j + j))
    i=$((i + 1))
    echo $i $j
done' > double.sh

echo '#!/usr/bin/env python3

# calculate powers of 2 by repeated addition

i = 1
j = 1
while i < 31:
    j = j + j
    i = i + 1
    print(i, j)' >  double.py

bash2py.py < "double.sh" > "$recieved" 2>&1

echo "------------------"
echo "Testing double"
echo "------------------"


if diff "$recieved" "double.py" > /dev/null
then
    echo "\e[1;32mOutput scripts are same.\e[0m"
else
    echo "\e[0;33mScripts differ.\e[0m"
fi

bash2py.py < "double.sh" | python3 > "$recieved" 2>&1
python3 double.py > "$expected" 2>&1

if diff "$recieved" "$expected" > /dev/null
then
    echo "\e[1;32msum.sh Passed.\e[0m"
    numPassed=$((numPassed + 1))
else
    echo "\e[1;31msum.sh Failed.\e[0m"
fi

echo '#!/bin/bash

# https://en.wikipedia.org/wiki/Collatz_conjecture
# https://xkcd.com/710/

n=65535
while ((n != 1))
do
    if ((n % 2 == 0))
    then
        n=$((n / 2))
    else
        n=$((3 * n + 1))
    fi
    echo $n
done' > collatz.sh

echo '#!/usr/bin/env python3

# https://en.wikipedia.org/wiki/Collatz_conjecture
# https://xkcd.com/710/

n = 65535
while n != 1:
    if n % 2 == 0:
        n = n // 2
    else:
        n = 3 * n + 1
    print(n)' > collatz.py

bash2py.py < "collatz.sh" > "$recieved" 2>&1

echo "------------------"
echo "Testing collatz"
echo "------------------"


if diff "$recieved" "collatz.py" > /dev/null
then
    echo "\e[1;32mOutput scripts are same.\e[0m"
else
    echo "\e[0;33mScripts differ.\e[0m"
fi

bash2py.py < "collatz.sh" | python3 > "$recieved" 2>&1
python3 collatz.py > "$expected" 2>&1

if diff "$recieved" "$expected" > /dev/null
then
    echo "\e[1;32msum.sh Passed.\e[0m"
    numPassed=$((numPassed + 1))
else
    echo "\e[1;31msum.sh Failed.\e[0m"
fi


echo '#!/bin/bash

max=42
a=1
while ((a < max))
do
    b=$a
    while ((b < max))
    do
        c=$b
        while ((c < max))
        do
            if ((a * a + b * b == c * c))
            then
                echo $a $b $c
            fi
            c=$((c + 1))
        done
        b=$((b + 1))
    done
    a=$((a + 1))
done' > pythag.sh

echo '#!/usr/bin/env python3

max = 42
a = 1
while a < max:
    b = a
    while b < max:
        c = b
        while c < max:
            if a * a + b * b == c * c:
                print(a, b, c)
            c = c + 1
        b = b + 1
    a = a + 1' > pythag.py

bash2py.py < "pythag.sh" > "$recieved" 2>&1

echo "------------------"
echo "Testing pythag"
echo "------------------"


if diff "$recieved" "pythag.py" > /dev/null
then
    echo "\e[1;32mOutput scripts are same.\e[0m"
else
    echo "\e[0;33mScripts differ.\e[0m"
fi

bash2py.py < "pythag.sh" | python3 > "$recieved" 2>&1
python3 pythag.py > "$expected" 2>&1

if diff "$recieved" "$expected" > /dev/null
then
    echo "\e[1;32msum.sh Passed.\e[0m"
    numPassed=$((numPassed + 1))
else
    echo "\e[1;31msum.sh Failed.\e[0m"
fi

echo "Summary:"
echo "Passed $numPassed/4 tests"

