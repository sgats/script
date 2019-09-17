#!/bin/bash
SERVICE_NAME=$1
ARTIFACT_ID=$2
root_PATH=$3
md5=$4
tomcat_name=$6
package_PATH=/home/jyapp/package/$SERVICE_NAME
jar_name=.jar
tar_name=.tar.gz
h5_name=h5
backup=/home/jyapp/backup/$SERVICE_NAME
startShell=$root_PATH/start_boot.sh
starttar_shell=$tomcat_name/bin/startup.sh
md5_package=$(md5sum $package_PATH/$ARTIFACT_ID|awk -F / '{print $1}')
WebUrl=$5


function main () {




if [[ $ARTIFACT_ID == *$jar_name ]]
then
     echo "*******************检测为jar包部署，开始部署$ARTIFACT_ID*******************"
     PID=$(ps -ef | grep $SERVICE_NAME | grep java | grep -v grep | awk '{ print $2 }')
	if [ $md5 == $md5_package ]
	then
   	echo "*********************部署包传输无误************************"  
    		if [ -z "$PID" ]       
    		then
	  	echo "$SERVICE_NAME进程不存在，无需关闭进程，开始备份部署........"
		echo "********************[开始]备份$ARTIFACT_ID********************"
	  	backupjar
	  	cp $package_PATH/$ARTIFACT_ID $root_PATH
          		if [ $? == 0 ]
	  		then
			echo "****************成功拷贝$package_PATH$ARTIFACT_ID 到 $root_PATH***************"
        		echo "****************开始启动$SERVICE_NAME服务****************"
	    		startjar
			echo "****************开始监控页面是否启动成功*****************"
	    		jiantingweb
	  		else
			echo "*************拷贝$package_PATH$ARTIFACT_ID 到 $root_PATH 失败*************！！"
        		echo "!!!!!!!!!!!!!!!!!!!!!!!!!启动原服务!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	    		startbakjar
			echo "****************开始监控页面是否启动成功*****************"
	    		jiantingweb
			echo "****************启动的是备份服务，新应用部署失败*****************"
			exit 1
          		fi
    	       else
	       echo "****************当前服务进程ID为: $PID******************"
               echo "*****************[开始]停止服务******************"
	       jiantingPID
	       echo "********************[开始]备份$ARTIFACT_ID********************"
	       backupjar
	       cp $package_PATH/$ARTIFACT_ID $root_PATH
			if [ $? == 0 ]
          		then
			echo "****************成功拷贝$package_PATH$ARTIFACT_ID 到 $root_PATH***************"
                        echo "****************开始启动$SERVICE_NAME服务****************"
            		startjar
			echo "****************开始监控页面是否启动成功*****************"
            		jiantingweb
          		else
			echo "*************拷贝$package_PATH$ARTIFACT_ID 到 $root_PATH 失败*************！！"
                        echo "!!!!!!!!!!!!!!!!!!!!!!!!!启动原服务!!!!!!!!!!!!!!!!!!!!!!!!!!!"
            		startbakjar
			echo "****************开始监控页面是否启动成功*****************"
            		jiantingweb
			echo "****************启动的是备份服务，新应用部署失败*****************"
                        exit 1
        		fi	
    	      fi	
	else
   	echo "部署包传输出现问题，请排查部署包"
	exit 1     
	fi

elif [[ $ARTIFACT_ID == *$tar_name ]]
then
	if [[ $ARTIFACT_ID == $h5_name* ]]
	then
        	if [ $md5 == $md5_package ]
        	then
		echo "*********************检测为h5项目************************"
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

	else
     	echo "****************检测为tar包部署，开始部署$ARTIFACT_ID**********"
     	PID=$(ps -ef | grep $SERVICE_NAME | grep java | grep -v grep | awk '{ print $2 }')
	if [ $md5 == $md5_package ]
	then
     	echo "***************部署包传输无误***********"
		if [ -z "$PID" ]
     		then
          	echo "$SERVICE_NAME进程不存在，无需关闭进程，开始备份部署........"
		echo "********************[开始]备份$SERVICE_NAME*********************"
          	backuptar
		tar -zxvf $package_PATH/$SERVICE_NAME.tar.gz -C $SERVICE_NAME
          		if [ $? == 0 ]
          		then
			echo "***************成功解压$ARTIFACT_ID 到 $SERVICE_NAME 目录中************"
        		echo "***************开始启动$SERVICE_NAME服务*****************"
            		starttar
			echo "****************开始监控页面是否启动成功*****************"
            		jiantingweb
			jiantingexit
          		else
			echo "***************解压$ARTIFACT_ID 到 $SERVICE_NAME 目录失败！！********************"
        		echo "*************************启动原服务！！************************"
            		startbaktar
			echo "****************开始监控页面是否启动成功*****************"
            		jiantingweb
			jiantingexit
			echo "****************启动的是备份服务，新应用部署失败*****************"
                        exit 1
          		fi
		else
		echo "*********************当前服务进程ID为: $PID******************************"
                echo "****************************[开始]停止服务****************************"
        	jiantingPID
		echo "********************[开始]备份$SERVICE_NAME*********************"
        	backuptar
		tar -zxvf $package_PATH/$SERVICE_NAME.tar.gz -C $SERVICE_NAME
        		if [ $? == 0 ]
          		then
			echo "***************成功解压$ARTIFACT_ID 到 $SERVICE_NAME 目录中************"
                        echo "***************开始启动$SERVICE_NAME服务*****************"
            		starttar
			echo "****************开始监控页面是否启动成功*****************"
            		jiantingweb
			jiantingexit
          		else
			echo "***************解压$ARTIFACT_ID 到 $SERVICE_NAME 目录失败！！********************"
                        echo "*************************启动原服务！！************************"
            		startbaktar
			echo "****************开始监控页面是否启动成功*****************"
            		jiantingweb
			jiantingexit
			echo "****************启动的是备份服务，新应用部署失败*****************"
                        exit 1
       			fi
    		fi
	else
	echo "***********************部署包传输出现问题，请排查部署包*************************"
	exit 1						
	fi
    fi
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
        tar -zxvf $package_PATH$SERVICE_NAME.tar.gz -C $root_PATH/$SERVICE_NAME
}





function backupjar () {
	if [ -d $backup ];then
	echo "$backup目录存在"
	else
	echo "$backup目录不存在"
	mkdir -p $backup
	fi
	rm -f $backup/*.jar
	mv $root_PATH/$ARTIFACT_ID $backup/
	echo "[完成]备份服务"	    
}

function backuptar () {
	if [ -d $backup ];then
	echo "$backup目录存在"
	else
	echo "$backup目录不存在"
	mkdir -p $backup
	fi
        rm -f $backup/*
        tar -zcf $backup/$SERVICE_NAME.tar.gz $SERVICE_NAME
        echo "[完成]备份服务"       
}


function startjar () {
        cd $root_PATH
        sh $startShell $root_PATH/$ARTIFACT_ID
        echo "等待20秒"
        sleep 20;
}

function starttar () {
        sh $starttar_shell
        echo "等待20秒"
        sleep 20;
}


function jiantingweb () {
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
}

function jiantingexit () {
	 TomcatServiceCode=$(curl -L -s -o -m 20 --connect-timeout 20  -w%{http_code} $WebUrl | sed '/^$/!h;$!d;g' | grep -o '[0-9]\{3\}' | awk 'END {print}' )
	if [ $TomcatServiceCode -eq 200 ];then
		echo "页面返回码为$TomcatServiceCode,启动成功,测试页面正常......"
	else
		echo "页面访问失败，请检查报错"
		exit 1
	fi	
}

function startbakjar () {
        mv $backup/$ARTIFACT_ID $root_PATH/
       	cd $root_PATH
        sh $startShell $root_PATH/$ARTIFACT_ID
        echo "等待20秒"
        sleep 20;
}

function startbaktar () {
	tar -zxvf $package_PATH$SERVICE_NAME.tar.gz -C $root_PATH/$SERVICE_NAME
	sh $starttar_shell
        echo "等待20秒"
        sleep 20;
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
