#!/bin/bash

echo "" > out.txt
cd ../../..

for i in {1..38}
do
    ./BisonTest/calc < BisonTest/testy/useTest/test$i.txt > BisonTest/testy/useTest/maked/out$i.txt
    ./odG/maszyna_wirtualna/maszyna-wirtualna BisonTest/testy/useTest/maked/out$i.txt 
    #cmp --silent testy/res/res$i.txt testy/out/out$i.txt || echo "files $i are different"
done


#for i in {1..41}
#do
#    echo "" >> all.txt
#    echo "Test $i" >> all.txt
#    echo "" >> all.txt
#    cat >> all.txt < test$i.txt
#    echo "" >> all.txt
#done
