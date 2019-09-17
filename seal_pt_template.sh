#!bin/bash

nowtime=`date "+%Y%m%d"`
nowyear=`date "+%Y"`
cd /home/jyapp/workspace/.jenkins/workspace/ESB-SEAL-PT-package/
#cp /home/jyapp/workspace/.jenkins/workspace/ESB-SEAL-PT-STG1-96/seal_pt.tar ./
cp /home/jyapp/workspace/.jenkins/workspace/ESB-SEAL-PT-ZS/seal_pt.tar ./
tar -xvf seal_pt.tar
sleep 2
rm -rf seal_pt$nowyear*
sleep 1
tar -zcvf seal_pt$nowtime.tar.gz contractTemplate  seal-1.0.0.war template
sleep 3
rm -rf contractTemplate template seal_pt.tar
echo "构建物地址：http://10.50.180.66:8080/jenkins/job/ESB-SEAL-PT-package/ws/seal_pt$nowtime.tar.gz"
