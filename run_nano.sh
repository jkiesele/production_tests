#!/bin/bash

## USAGE
# events input_no outdir_id nparticles nthreads

cmssw_install="/afs/cern.ch/user/j/jkiesele/work/HGCal/pepr_production/May2022/CMSSW_12_1_1/src"
output_basedir="/eos/home-${USER:0:1}/${USER}/ML4Reco/$3"

#no adaptations below needed
echo "output will be copied to ${output_basedir}"

maxEvents=$1
declare -i inputnumber=$2

finalfile="${inputnumber}_nanoML.root"
outdir="${output_basedir}/$3"

nParticles=10
if [ $# -gt 3 ]; then
    nParticles=$4
fi

echo "Processing $maxEvents events for seed $inputnumber"
echo "    Gun of $nParticles particles"

numThreads=1
if [ $# -gt 4 ]; then
    numThreads=$5
fi

pushd $cmssw_install
eval `scramv1 runtime -sh`
popd

gsd=${finalfile/.root/_GSD.root}
recoout=${finalfile/.root/_RECO.root}

cmsRun GSD_GUN.py seed=$inputnumber outputFile="file:$gsd" maxEvents=$maxEvents nThreads=$numThreads nParticles=$nParticles
# Don't fully understand when it sticks numevent ont the end
if [ ! -f $gsd ]; then
    gsd=${finalfile/.root/_GSD_numEvent$1.root}
fi
cmsRun RECO.py inputFiles="file:$gsd" outputFile=$recoout nThreads=$numThreads
cmsRun nanoML_cfg.py inputFiles=file:$recoout outputFile=file:$finalfile nThreads=$numThreads
echo "${inputnumber} done"
mv $finalfile $outdir/$finalfile 
