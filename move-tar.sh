#!/bin/bash
#NUM=$1
#BUILD_PATH=/home/jyapp/workspace/.jenkins/jobs/CIMS-jc1-step1-52/builds/$NUM/
BUILD_PATH=$1
mv $BUILD_PATH/com-jy-cims-aggregator-0.0.1-SNAPSHOT.tar.gz $BUILD_PATH/com.jy.cims\$com-jy-cims-aggregator/archive/com.jy.cims/com-jy-cims-aggregator/0.0.1-SNAPSHOT/
