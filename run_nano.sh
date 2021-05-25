#!/bin/bash

maxEvents=$1
declare -i inputnumber=$2

finalfile="${inputnumber}_nanoML.root"
outdir="/eos/cms/store/user/kelong/ML4Reco/$3"
eosoutdir="root://eosuser.cern.ch/$outdir"
if [ ! -d $outdir ]; then
    mkdir $outdir
fi

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

pushd /afs/cern.ch/user/k/kelong/work/ML4Reco/CMSSW_11_3_0_pre3/src
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
xrdcp $finalfile $eosoutdir/$finalfile 
