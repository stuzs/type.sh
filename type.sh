#!/bin/bash
# Randomly choose 10 words from dictionary for typing training,
# and then show typing errors if any.
# Use './type.sh -r' to re-type last time's 10 words
# Use 'time ./type.sh' to roughly measure your typing speed
# Try '(time ./type.sh) 2>&1| tee tt.report; ./score.sh' for scoring further
# Use './type.sh -f' to type a fixed sentence ONLY

DICT_FILE='/usr/share/dict/words'
TOTYPE_FILE='./totype.sav.txt'
TYPED_FILE='./typed.sav.txt'
FIXED_SENTENCE='The quick brown Fox, jumps over a lazy Dog.'

rm $TYPED_FILE 2> /dev/null
if [ "$1" == "-f" ] ; then
 echo $FIXED_SENTENCE>$TOTYPE_FILE
 typing_times=1
else 
 if [ "$1" != "-r" ] || [ ! -f $TOTYPE_FILE ] ; then
  rm $TOTYPE_FILE 2> /dev/null
  words_total=$(wc -l $DICT_FILE | cut -f1 -d" ")
  for ((i=0; i<10; i++)); do
   rand_num=$(expr $RANDOM '*' $RANDOM % $words_total '+' '1')
   echo "$(head -n$rand_num $DICT_FILE | tail -n1)" >> $TOTYPE_FILE
  done
 fi
 typing_times=$(wc -l $TOTYPE_FILE | cut -f1 -d" ")
fi

for ((i=1; i<$typing_times+1; i++)); do
 echo "${i}#####    $(sed -n "${i}p" $TOTYPE_FILE)";  # sed works too
 echo -n "${i}typing>>>"
 read key_in; echo $key_in >> $TYPED_FILE
done

if [ $typing_times != 1 ] ; then
 diff_options='-y -W60 --suppress-common-lines'
fi
echo; echo "Error(s) found by diff:"
echo "$(diff $diff_options $TOTYPE_FILE $TYPED_FILE)"
# can use vimdiff for visual comparing
