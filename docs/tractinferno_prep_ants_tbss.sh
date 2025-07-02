#!/bin/bash
# scripts to prepare for ANTs TBSS
# create the IMAGELIST and CASELIST files
# Jetro J. Tuulari, 02 / 2024; Ashmeet Jolly 04/2025

# to create the namelist files; using single shell data
ls -d $PWD'/'ants_tbss_project'/'sub*__fa.nii.gz > IMAGELIST_FA_ss.csv

# to merge these files
paste -d , IMAGELIST_FA_ss.csv > IMAGELIST_ss.csv

# convert IMAGELIST .csv to docker compliant version
p=`pwd`   
sed "s:$p:/root/data:g" IMAGELIST_ss.csv > IMAGELIST_ss_docker.csv

# to create the namelist file for the ANTs TBSS pipeline
> CASELIST.txt
for i in `ls $PWD/ants_tbss_project/sub*__fa.nii.gz | xargs -n 1 basename`
do
    prefix=${i%%__fa.nii.gz}
    echo $prefix >> CASELIST.txt
done

# END
