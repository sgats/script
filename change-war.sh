#!/bin/bash
build=$1

cd /home/jyapp/workspace/.jenkins/jobs/SEAL-PT-98-step1/builds/"$build"/com.fintech.platform\$seal/archive/com.fintech.platform/seal/1.0.0/

tar -zcvf seal-1.0.0.tar.gz seal-1.0.0.war

