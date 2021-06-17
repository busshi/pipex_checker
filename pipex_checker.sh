#!/bin/bash


PROJECT_DIR=../			# CHANGE THIS IF YOU WANT...


### COLORS

red="\033[0;31m"
green="\033[0;32m"
clear="\033[0;m"
blue="\033[0;94m"
orange="\033[0;33m"
purple="\033[0;35m"

OK="[ ${green}OK${clear} ]"
KO="[ ${red}KO${clear} ]"


### HEADER
clear

echo -e "${orange}________________________________________________________________________________________________________\n"
echo -e "____________________________________________ PIPEX CHECKER _____________________________________________\n"
echo -e "________________________________________________________________________________________________________\n\n${clear}"


### COMPILATION

compil=$( make -C ${PROJECT_DIR})
[ $? -eq 0 ] && echo -e "${purple}Compilation${clear}\t${OK}\n\n" || { echo -e "${purple}Compilation${clear}\t${KO}\n\n"; echo ${compil}; exit 1; }


### RUN TESTS
run_test()
{
cd mine
../../pipex in "$cmd1" "$cmd2" out
cd ..
}

compare_test()
{
cd true
< in $cmd1 | $cmd2 > out
dif=$( diff ../mine/out out | wc -l )
[[ $dif -eq 0 ]] && res=${OK} || { res=${KO}; err=$(( $err + 1 )); }
echo -e "${res}\n\n"
rm -f ../mine/out out
cd ..
}


### PICK RANDOM COMMAND
randomize()
{
liste=("$@")
random=$(( $RANDOM % ${#liste[@]} ))
rand=${liste[$random]}
}

random_cmd()
{
randomize wc cat whoami "wc -l" "ls -al" "ls -l" echo "echo -n" "wc -w" id
}



err=0
i=1
mkdir mine true 2> /dev/null
while [ $i -lt 100 ] ; do
	random_cmd
	cmd1=$rand
	random_cmd
	cmd2=$rand
	echo -e "${blue}Test ${i}${clear}\033[15G./pipex in \"${cmd1}\" \"${cmd2}\" out\033[60Gvs\t\t< in \"${cmd1}\" | \"${cmd2}\" > out"
	run_test
	compare_test
	i=$(( $i + 1 ))
done

[[ $err -eq 0 ]] && echo -e "${OK} Congrats!!! All tests passed." || echo -e "${KO} ${red}${err}${clear} error(s) / ${i} tests..."




exit 0

