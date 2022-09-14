#!/bin/bash

# node1 129.204.0.226   172.17.0.4

n=0
for ((i=n;i<=5461;i++))
do
/usr/bin/redis-cli -h 129.204.0.226 -p 6379 -a 620620  CLUSTER ADDSLOTS $i
done

# node2 129.204.0.226    172.17.0.5

n=5462
for ((i=n;i<=10922;i++))
do
/usr/bin/redis-cli -h 129.204.0.226 -p 6380 -a 620620 CLUSTER ADDSLOTS $i
done

# node3 129.204.0.226    172.17.0.6

n=10923
for ((i=n;i<=16383;i++))
do
/usr/bin/redis-cli -h 129.204.0.226 -p 6381 -a 620620 CLUSTER ADDSLOTS $i
done
