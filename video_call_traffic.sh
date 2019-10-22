
anacha "${1}","${2}","${3}",,,all > attempt_tmp.txt
#sed 's/\[0m/xxx/g' attempt_tmp.txt > attempt.txt

$(awk '{if(match($4,/^Stop/)) {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t\t"$6"\t"$7"\t"$8"\t"$9"t\t"$10"\t\t"$11"\t"$12"\t"$13} else{print $1"\t"$2"\t"$3"\t"$4"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13}}'  attempt_tmp.txt > attempt.txt)
#$(awk '{if(match($4,/^Stop/)) {print $1" "$2" "$13} else{print $1" "$12" "$13}}'  attempt_tmp.txt > attempt.txt)
#exit;
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


echo -e "\n"  >>./video_codec/video_traffic.log
echo -e "============================================================= Traffic Summary============================================================\n"
printf "%10s\t%10s\t%10s\t%10s\t%10s\t%10s\t%10s\n"  "CODEC(COMPLETE)"      "ATTEMPT"       "COMPLETE"  "COMPLETE_RATIO"    "V_ATTEMPT"     "V_COMPLETE"    "V_COMPLETE_RATIO"
printf "%10s\t%10s\t%10s\t%10s\t%10s\t%10s\t%10s\n"  "$VIDEO_CODEC" "$ATTEMPT"      "$COMPLETE"  "$COMPLETE_RATIO %"        "$V_ATTEMPT"    "$V_COMPLETE"   "$V_COMPLETE_RATIO %"
echo -e "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
echo -e "\n"
mv ./tmp_value.txt ./video_codec/2019-${1}-${2}-${3}.txt
rm -rf ./attempt_tmp.txt ./attempt.txt ./complete.txt ./v_attempt.txt ./v_complete.txt ./tmp_value.txt >/dev/null 2>&1
#rm -rf ./v_attempt.txt ./v_complete.txt
~
~
