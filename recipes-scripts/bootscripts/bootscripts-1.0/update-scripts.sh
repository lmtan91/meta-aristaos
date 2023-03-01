#! /bin/bash
#
# Create QMX6 U-Boot scripts for each .txt file in directory

for file in *.txt;
        do name=${file:0:${#file}-4};
        mkimage -A arm -T script -C none -n "${name}" -d ${name}.txt ${name}.scr;
done;

cp *.scr /home/tftp/;
