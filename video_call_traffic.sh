#!bin/bash

DATE=$(date +"%Y-%m-%d %H:%M")
anacha "${1}","${2}","${3}",,,all > attempt_tmp.txt

$(awk '{if(match($4,/^Stop/)) {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t\t"$11"\t"$12"\t"$13} else{print $1"\t"$2"\t"$3"\t"$4"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13}}'  attempt_tmp.txt > attempt.txt)
#exit;
grep -i "stop" attempt.txt > complete.txt
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
OutGoing_RTE=$(awk '{print $9}' v_complete.txt | sort |uniq -dc |sort -nr)
InComing_RTE=$(awk '{print $10}' v_complete.txt | sort|uniq -dc |sort -nr)

echo -n "$1"-"$2"-"$3" >>xx.txt
echo  "( "$DATE")" >> xx.txt
echo -e "============================================================= Traffic Summary============================================================\n" >>xx.txt  
printf "%10s\t%10s\t%10s\t%10s\t%10s\t%10s\t%10s\n"  "CODEC(COMPLETE)"		"ATTEMPT"		"COMPLETE"	"COMPLETE_RATIO"	"V_ATTEMPT"		"V_COMPLETE"	"V_COMPLETE_RATIO" >>xx.txt
printf "%10s\t%10s\t%10s\t%10s\t%10s\t%10s\t%10s\n"  "$VIDEO_CODEC"	"$ATTEMPT"		"$COMPLETE"	 "$COMPLETE_RATIO %"		"$V_ATTEMPT"	"$V_COMPLETE"	"$V_COMPLETE_RATIO %"	   	>>xx.txt	
printf "\n" >>xx.txt
printf "\n" >>xx.txt
printf "%5s\t%20s\t\t%20s\t%20s\n"		"V_COUNT"	"V_OutGoing RTE"		"V_COUNT"	"V_InComing RTE" >>xx.txt
printf "%5s\t%20s\t\t%20s\t%20s\n"	    $OutGoing_RTE				$InComing_RTE	>>xx.txt	

OutGoing_DEVICE=$(awk '{print $11}' v_complete.txt | sort | uniq -dc |sort -nr|head -n10)
InComing_DEVICE=$(awk '{print $12}' v_complete.txt | sort | uniq -dc |sort -nr|head -n10)

printf "\n" >>xx.txt
printf "\n" >>xx.txt
printf "%5s\t%20s\t\t%20s\t%20s\n"		"V_COUNT"	"V_OutGing DEVICE Top 10"		"V_COUNT"		"V_InComng DEVICE Top 10" >>xx.txt
printf "%5s\t%20s\t\t%20s\t%20s\n"		$OutGoing_DEVICE					$InComing_DEVICE >>xx.txt
echo -e "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n" >>xx.txt
echo -e "\n" >>xx.txt
cat xx.txt >>./video_codec/traffic.log

cat xx.txt |more
mv ./tmp_value.txt ./video_codec/2019-${1}-${2}-${3}.txt
rm -rf ./xx.txt ./attempt_tmp.txt ./attempt.txt ./complete.txt ./v_attempt.txt ./v_complete.txt ./tmp_value.txt >/dev/null 2>&1
#rm -rf ./v_attempt.txt ./v_complete.txt
