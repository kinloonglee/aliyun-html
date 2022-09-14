#!/bin/bash
##############################################################
# File Name: rename.sh
# Version: V1.0
# Author: ljl
# Organization: www.oldboyedu.com
# Created Time : 2017-09-15 18:16:01
# Description:
##############################################################

renameDir="/test"
renameList=$(ls $renameDir)
cd  $renameDir
for i in ${renameList}
   do
	echo $i
      rename oldgirl oldboy $i   

    
done
