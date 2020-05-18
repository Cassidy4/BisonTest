#!/bin/bash
echo "" > all.txt
for i in {1..41}
do
    echo "" >> all.txt
    echo "Test $i" >> all.txt
    echo "" >> all.txt
    cat >> all.txt < test$i.txt
    echo "" >> all.txt
done
