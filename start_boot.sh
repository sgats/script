#!/bin/sh
source /etc/profile
rootPath=${pwd}
ARTIFACT_ID=$2
jarPath=$rootPath/$ARTIFACT_ID
confPath=$rootPath/application.properties
JAVA_OPTS="-Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=256m"
#JAVA_OPTS="$JAVA_OPTS -javaagent:/home/jyapp/pinpoint-agent/pinpoint-bootstrap-1.7.3.jar"
#JAVA_OPTS="$JAVA_OPTS -Dpinpoint.agentId=loan-insurance-stg-212"
#JAVA_OPTS="$JAVA_OPTS -Dpinpoint.applicationName=loan-insurance"

nohup java -jar $JAVA_OPTS $jarPath --sping.config.location=file:$confPath >> nohup.out 2>&1 &
