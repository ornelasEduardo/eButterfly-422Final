#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q windfall
#PBS -l select=1:ncpus=4:mem=8gb
#PBS -l pvmem=7gb
#PBS -l place=free:shared
#PBS -l walltime=200:00:00
#PBS -l cput=200:00:00
#PBS -M jamesthornton@email.arizona.edu
#PBS -m bea

#LOAD R
module load R

#MOVE INTO DIRECTORY CONTAINING OBSERVATIONS
cd $FILE_DIR

#LIST+JOB_ARRAY_INDEX
LIST="list${PBS_ARRAY_INDEX}"

#FOR OBSERVATION FILE IN LIST, RUN SDM TO GENERATE MAPS
for file in $(cat $LIST); do
 
  ID=$(basename $file | cut -d '-' -f 1)
  
  mkdir -p $OUT_DIR/$ID/GLM/  
  $SCRIPT_DIR/run-sdm-algo.R $file $ID $OUT_DIR/$ID/GLM GLM 1
  $SCRIPT_DIR/run-sdm-algo.R $file $ID $OUT_DIR/$ID/GLM GLM 10
  $SCRIPT_DIR/run-sdm-algo.R $file $ID $OUT_DIR/$ID/GLM GLM 50 

  cd $OUT_DIR/$ID
  tar -zcvf $ID.GLM.tar.gz GLM
  rm -rf GLM  

done

echo "Completed GLM SDMS for $ID"

