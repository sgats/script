#!/bin/bash

nowtime=`date "+%Y%m%d%H%M%S"`
#project=seal-pt_"$nowtime".tar.gz
project=seal_pt_incr.tar
joburl=$1
select=$2
build=$3
#incrurl=/home/jyapp/workspace/.jenkins/workspace/SEAL-PT-package
#incrurl=/home/jyapp/workspace/.jenkins/workspace/SEAL-PT-STG1-98
incrurl=/home/jyapp/jenkins/.jenkins/workspace/SEAL-PT-STG1-98
before_versions=`cat $incrurl/before_versions`
after_versions=`cat $incrurl/after_versions`

#rm -rf $incrurl/seal-pt*
cd $joburl

git log HEAD | head -n 1 | awk '{print $2}' > $incrurl/after_versions

#判断：如果是根据list.txt打增强包，就执行第一个脚本，如果是根据git版本差异比较出来的文件列表，就执行第二个脚本

if [ list = $select ]; then
        echo "根据list列表打增量包："
        cat $joburl/list.txt | xargs tar -czvf $incrurl/$project
#        echo "构建物地址：http://10.50.180.66:8080/jenkins/job/SEAL-PT-package/ws/$project"
   elif [ $before_versions != $after_versions ]; then
        echo "根据两个版本之间的差异打增量包："
        git diff `cat $incrurl/before_versions` `cat $incrurl/after_versions` --name-only | xargs tar -czvf $incrurl/$project
        echo "构建物地址：http://10.50.180.66:8080/jenkins/job/SEAL-PT-package/ws/$project"
else
        echo "没有差异，不用打增量包"
fi
#删除老的文件
#cat $joburl/list.txt | xargs rm -rf
#解压新的文件
#tar -xvf $incrurl/$project -C $incrurl

git log HEAD"^" | head -n 1 | awk '{print $2}' > $incrurl/before_versions

