#!bin/bash
anacha "${1}","${2}","${3}",,,all |grep -vE "\[31m|\[0m" > attempt.txt
grep -i "stop" attempt.txt > complete.txt
#grep -iE "h264|h265" complete.txt > ./video_codec/video_complete_2019${1}_${2}_${3}.txt
grep -iE "h263|h264|h265" attempt.txt > v_attempt.txt
grep -i "stop" v_attempt.txt > v_complete.txt
grep -iE "h263|h264|h265" complete.txt > tmp_value.txt


ATTEMPT=$(wc -l attempt.txt | awk '{print $1}'|sed -e 's/^*//g' -e 's/*$//g');
COMPLETE=$(wc -l complete.txt| awk '{print $1}'|sed -e 's/^*//g' -e 's/*$//g');
COMPLETE_RATIO=$(echo "scale=3;$COMPLETE/$ATTEMPT*100" | bc |cut -c 1-4);
V_ATTEMPT=$(wc -l v_attempt.txt | awk '{print $1}' | sed -e 's/^*//g' -e 's/*$//g');
V_COMPLETE=$(wc -l v_complete.txt | awk '{print $1}' | sed -e 's/^*//g' -e 's/*$//g');
V_COMPLETE_RATIO=$(echo "scale=3;$V_COMPLETE/$V_ATTEMPT*100" |bc |cut -c 1-4)
VIDEO_CODEC=$(cat complete.txt | awk '{print $5}' | sort |uniq -dc |sort -nr);
#COMPLETE_RATIO=`expr "$COMPLETE" / "$ATTEMPT"`


echo -e "\n"
echo -e "========================================================= Traffic Summary ==============================================================================\n"
printf "%10s\t%10s\t%10s\t%10s\t%10s\t%10s\t%10s\n"  "CODEC(COMPLETE)"      "ATTEMPT"       "COMPLETE"  "COMPLETE_RATIO"    "V_ATTEMPT"     "V_COMPLETE"    "V_COMPLETE_RATIO" 
printf "%10s\t%10s\t%10s\t%10s\t%10s\t%10s\t%10s\n"  "$VIDEO_CODEC" "$ATTEMPT"      "$COMPLETE"  "$COMPLETE_RATIO %"        "$V_ATTEMPT"    "$V_COMPLETE"   "$V_COMPLETE_RATIO %"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
mv ./tmp_value.txt ./video_codec/2019-${1}-${2}-${3}.txt
rm -rf ./attempt.txt ./complete.txt ./v_attempt.xtx ./v_complete.txt
