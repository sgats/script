#!/bin/bash
SERVICE_NAME=$1
ARTIFACT_ID=$2
root_PATH=$3
md5=$4
#tomcat_name=$6
#package_PATH=/home/jyapp/package/$SERVICE_NAME
package_PATH=$6
backup=/home/jyapp/backup/$SERVICE_NAME
md5_package=$(md5sum $package_PATH/$ARTIFACT_ID|awk -F / '{print $1}')
WebUrl=$5


function main () {




        	if [ $md5 == $md5_package ]
        	then
        	echo "*********************部署包传输无误************************"
        	echo "********************[开始]备份$SERVICE_NAME*********************"
        	backuph5
        	tar -zxvf $package_PATH/$ARTIFACT_ID -C $root_PATH/$SERVICE_NAME
                	if [ $? == 0 ]
                        then
                        echo "***************成功解压$ARTIFACT_ID 到 $SERVICE_NAME 目录中************"
                        echo "****************开始监控页面是否启动成功*****************"
                        jiantingweb
                        jiantingexit
                        else
                        echo "***************解压$ARTIFACT_ID 到 $SERVICE_NAME 目录失败！！********************"
                        echo "*************************启动原服务！！************************"
                        startbakh5
                        echo "****************开始监控页面是否启动成功*****************"
                        jiantingweb
                        jiantingexit
                        echo "****************启动的是备份服务，新应用部署失败*****************"
                        exit 1
                	fi
        	else
        	echo "***********************部署包传输出现问题，请排查部署包*************************"
        	exit 1
		fi

	  	
} 

function backuph5 () {
        if [ -d $backup ];then
        echo "$backup目录存在"
        else
        echo "$backup目录不存在"
        mkdir -p $backup
        fi
        rm -rf $backup/*
        cp -r $root_PATH/$SERVICE_NAME $backup/$SERVICE_NAME
	rm -rf $root_PATH/$SERVICE_NAME/*
        echo "[完成]备份服务"       
}

function startbakh5 () {
        tar -zxvf $package_PATH/$ARTIFACT_ID -C $root_PATH/$SERVICE_NAME
}







function jiantingweb () {
         if [ -z "$WebUrl" ];
         then
         echo "无登录地址，无法检测页面是否正常"
         else
         for a in {1..20}
         do
              echo "开始第 $a/20 次检查:"
              TomcatServiceCode=$(curl -L -s -o -m 20 --connect-timeout 20  -w%{http_code} $WebUrl | sed '/^$/!h;$!d;g' | grep -o '[0-9]\{3\}' | awk 'END {print}' )
          if [ $TomcatServiceCode -ne 200 ];then
	      echo "页面访问失败，请检查报错"
          sleep 5
          else
	      echo "页面返回码为$TomcatServiceCode,启动成功,测试页面正常......"	
	      break
          fi
         done
	fi
}

function jiantingexit () {
         if [ -z "$WebUrl" ];
         then
         echo "无登录地址，无法检测页面是否正常"
         else
	 TomcatServiceCode=$(curl -L -s -o -m 20 --connect-timeout 20  -w%{http_code} $WebUrl | sed '/^$/!h;$!d;g' | grep -o '[0-9]\{3\}' | awk 'END {print}' )
	if [ $TomcatServiceCode -eq 200 ];then
		echo "页面返回码为$TomcatServiceCode,启动成功,测试页面正常......"
	else
		echo "页面访问失败，请检查报错"
		exit 1
	fi
	fi	
}

function jiantingPID () {
           kill -9 $PID
           echo "等待10秒"
           sleep 10;
           echo "[完成]停止服务。"
           echo "[开始]进程状态检查...."
      for i in {1..12}
        do
        echo "开始第 $i/12 次检查:"
        COUNT=$(ps -ef | grep $PID | grep -v "grep" | wc -l)
        if [ $COUNT -gt 0 ]
        then
            echo "当前进程 $PID 未关闭，等待5秒后进行下一次检查"
           sleep 5;
        else
            echo "当前进程 $PID 已经关闭，结束检查"
            break
        fi
    done
}

main
