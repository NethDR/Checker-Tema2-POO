#!/bin/bash

# stdin input(commands)
INPUTS="tests/input"
# stdout output
OUTPUTS="tests/output"
# exceptions and other stderr
ERRORS="tests/error"
# exports/.csv output
EXPORTS="tests/csv-output"
# refs for stdout output
OUTPUT_REFS="tests/refs"
# refs for exports/.csv output
EXPORT_REFS="tests/csv-refs"

rm -f ${OUTPUTS}/test*
rm -f ${EXPORTS}/test*
rm -f ${ERRORS}/test*

testcount = $(find ${INPUTS} | grep test0$i | wc -l)
for ((i = 0; i < testcount; i++))
do
	java -jar Tema2.jar < ${INPUTS}/test0$i.in 1> ${OUTPUTS}/test0$i.out 2> ${ERRORS}/test0$i.err
	if test -z "$(diff --changed-group-format='%>' --unchanged-group-format='' ${OUTPUTS}/test0$i.out ${OUTPUT_REFS}/test0$i.ref | grep -v 2021-01)"
	then
		correctexports=1
		exportfiles=$(find ${EXPORT_REFS} | grep test0$i | wc -l)
		for ((j = 0; j < exportfiles; j++))
		do
			if test -n "$(diff ${EXPORTS}/test0${i}_${j}.csv ${EXPORT_REFS}/test0${i}_${j}.csv)"
			then
				correctexports=0
			fi
		done
		if test -n "$correctexports"
		then
			echo Test $i passed!
		else
			echo Test $i failed!
		fi
	else
		echo Test $i failed!
	fi
done
