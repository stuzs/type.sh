#!/bin/bash
# Randomly choose 10 words from dictionary for typing training,
# and then show typing errors if any.
# Use './type.sh -r' to re-type last time's 10 words
# Use 'time ./type.sh' to roughly measure your typing speed
# Try '(time ./type.sh) 2>&1| tee tt.report; ./score.sh' for scoring further

DICT_FILE='/usr/share/dict/words'
TOTYPE_FILE='./totype.sav.txt'
TYPED_FILE='./typed.sav.txt'

rm $TYPED_FILE 2> /dev/null
if [ "$1" != "-r" ] || [ ! -f $TOTYPE_FILE ] ; then
 rm $TOTYPE_FILE 2> /dev/null
 words_total=$(wc -l $DICT_FILE | cut -f1 -d" ")
 for ((i=0; i<10; i++)); do
  rand_num=$(expr $RANDOM '*' $RANDOM % $words_total)
  echo "$(head -n$rand_num $DICT_FILE | tail -n1)" >> $TOTYPE_FILE
 done
fi

for ((i=1; i<11; i++)); do
 echo "${i}#####    $(sed -n "${i}p" $TOTYPE_FILE)";  # sed works too
 echo -n "${i}typing>>>"
 read key_in; echo $key_in >> $TYPED_FILE
done

echo; echo "Error(s) found by diff:"
echo "$(diff -y -W60 --suppress-common-lines $TOTYPE_FILE $TYPED_FILE)"
