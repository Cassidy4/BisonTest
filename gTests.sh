#!/bin/bash
echo > testy/accept/act.txt

./kompilator.sh testy/accept/in/0-div-mod.imp testy/accept/out/0-div-mod.txt
./kompilator.sh testy/accept/in/00-div-mod.imp testy/accept/out/00-div-mod.txt
./kompilator.sh testy/accept/in/1-numbers.imp  testy/accept/out/1-numbers.txt
./kompilator.sh testy/accept/in/2-fib.imp testy/accept/out/2-fib.txt
./kompilator.sh testy/accept/in/3-fib-factorial.imp testy/accept/out/3-fib-factorial.txt
./kompilator.sh testy/accept/in/4-factorial.imp testy/accept/out/4-factorial.txt 
./kompilator.sh testy/accept/in/5-tab.imp testy/accept/out/5-tab.txt 
./kompilator.sh testy/accept/in/6-mod-mult.imp testy/accept/out/6-mod-mult.txt 
./kompilator.sh testy/accept/in/7-loopiii.imp testy/accept/out/7-loopiii.txt 
./kompilator.sh testy/accept/in/8-for.imp testy/accept/out/8-for.txt 
./kompilator.sh testy/accept/in/9-sort.imp testy/accept/out/9-sort.txt 
./kompilator.sh testy/accept/in/program0.imp testy/accept/out/program0.txt 
./kompilator.sh testy/accept/in/program1.imp testy/accept/out/program1.txt  
./kompilator.sh testy/accept/in/program2.imp testy/accept/out/program2.txt 
./kompilator.sh testy/accept/in/p1.imp testy/accept/out/p1.txt
 
./kompilator.sh testy/accept/in/my.txt testy/accept/out/my.txt


echo 1 0 | ./testy/accept/maszyna-wirtualna testy/accept/out/0-div-mod.txt
echo 33 7 | ./testy/accept/maszyna-wirtualna testy/accept/out/00-div-mod.txt
echo 20 | ./testy/accept/maszyna-wirtualna testy/accept/out/1-numbers.txt
echo 1 | ./testy/accept/maszyna-wirtualna testy/accept/out/2-fib.txt
echo 20 | ./testy/accept/maszyna-wirtualna testy/accept/out/2-fib.txt
echo 20 | ./testy/accept/maszyna-wirtualna testy/accept/out/3-fib-factorial.txt
echo 20 | ./testy/accept/maszyna-wirtualna testy/accept/out/4-factorial.txt 
./testy/accept/maszyna-wirtualna testy/accept/out/5-tab.txt 
echo 1234567890 1234567890987654321 987654321| ./testy/accept/maszyna-wirtualna testy/accept/out/6-mod-mult.txt 
echo 0 0 0 | ./testy/accept/maszyna-wirtualna testy/accept/out/7-loopiii.txt  
echo 1 0 2 | ./testy/accept/maszyna-wirtualna testy/accept/out/7-loopiii.txt 
echo 12 23 34 | ./testy/accept/maszyna-wirtualna testy/accept/out/8-for.txt 
./testy/accept/maszyna-wirtualna testy/accept/out/9-sort.txt 
echo 1345601 | ./testy/accept/maszyna-wirtualna testy/accept/out/program0.txt
./testy/accept/maszyna-wirtualna testy/accept/out/program1.txt 
echo 1234567890 |./testy/accept/maszyna-wirtualna testy/accept/out/program2.txt
echo 12345678901 |./testy/accept/maszyna-wirtualna testy/accept/out/program2.txt
echo 12345678903 |./testy/accept/maszyna-wirtualna testy/accept/out/program2.txt
#./testy/accept/maszyna-wirtualna testy/accept/out/p1.txt


echo 1 0 | ./testy/accept/maszyna-wirtualnaTime testy/accept/out/0-div-mod.txt  >>  testy/accept/act.txt
echo 33 7 | ./testy/accept/maszyna-wirtualnaTime testy/accept/out/00-div-mod.txt  >>  testy/accept/act.txt
echo 20 | ./testy/accept/maszyna-wirtualnaTime testy/accept/out/1-numbers.txt  >>  testy/accept/act.txt
echo 1 | ./testy/accept/maszyna-wirtualnaTime testy/accept/out/2-fib.txt  >>  testy/accept/act.txt
echo 20 | ./testy/accept/maszyna-wirtualnaTime testy/accept/out/2-fib.txt  >>  testy/accept/act.txt
echo 20 | ./testy/accept/maszyna-wirtualnaTime testy/accept/out/3-fib-factorial.txt  >>  testy/accept/act.txt
echo 20 | ./testy/accept/maszyna-wirtualnaTime testy/accept/out/4-factorial.txt   >>  testy/accept/act.txt 
./testy/accept/maszyna-wirtualnaTime testy/accept/out/5-tab.txt  >>  testy/accept/act.txt 
echo 1234567890 1234567890987654321 987654321| ./testy/accept/maszyna-wirtualnaTime testy/accept/out/6-mod-mult.txt  >>  testy/accept/act.txt 
echo 0 0 0 | ./testy/accept/maszyna-wirtualnaTime testy/accept/out/7-loopiii.txt  >>  testy/accept/act.txt  
echo 1 0 2 | ./testy/accept/maszyna-wirtualnaTime testy/accept/out/7-loopiii.txt  >>  testy/accept/act.txt 
echo 12 23 34 | ./testy/accept/maszyna-wirtualnaTime testy/accept/out/8-for.txt  >>  testy/accept/act.txt 
./testy/accept/maszyna-wirtualnaTime testy/accept/out/9-sort.txt  >>  testy/accept/act.txt 
echo 1345601 | ./testy/accept/maszyna-wirtualnaTime testy/accept/out/program0.txt  >>  testy/accept/act.txt
./testy/accept/maszyna-wirtualnaTime testy/accept/out/program1.txt  >>  testy/accept/act.txt 
echo 1234567890 |./testy/accept/maszyna-wirtualnaTime testy/accept/out/program2.txt  >>  testy/accept/act.txt
echo 12345678901 |./testy/accept/maszyna-wirtualnaTime testy/accept/out/program2.txt  >>  testy/accept/act.txt
echo 12345678903 |./testy/accept/maszyna-wirtualnaTime testy/accept/out/program2.txt  >>  testy/accept/act.txt
#./testy/accept/maszyna-wirtualnaTime testy/accept/out/p1.txt  >>  testy/accept/act.txt



    cmp --silent testy/accept/act.txt testy/accept/exp.txt || echo "files are different"


