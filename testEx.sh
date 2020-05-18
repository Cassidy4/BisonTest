#!/bin/bash
make
echo "Sprawdzenie identyczności:"
for i in {1..86}
do
    ./calc < testy/test/test$i.txt > testy/out/out$i.txt
    cp testy/out/out$i.txt testy/useTest/maked
    cmp --silent testy/res/res$i.txt testy/out/out$i.txt || echo "files $i are different"
done
