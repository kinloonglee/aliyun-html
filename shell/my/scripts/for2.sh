#!/bin/bash
n=1
for i in {5..1}
     do
      echo "第${n}次循环": $i
      ((n++))
done
