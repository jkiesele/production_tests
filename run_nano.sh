#!/bin/bash

maxEvents=$1
declare -i inputnumber=$2
echo "Processing $maxEvents events for seed $inputnumber"

finalfile="${inputnumber}_nanoML.root"
outdir="/eos/cms/store/user/kelong/ML4Reco/$3"
eosoutdir="root://eosuser.cern.ch/$outdir"
if [ ! -d $outdir ]; then
    mkdir $outdir
fi

numThreads=1
if [ $# -gt 3 ]; then
    numThreads=$4
fi

pushd /afs/cern.ch/user/k/kelong/work/ML4Reco/CMSSW_11_3_0_pre3/src
eval `scramv1 runtime -sh`
popd

gsd=${finalfile/.root/_GSD.root}
recoout=${finalfile/.root/_RECO.root}

cmsRun GSD_GUN.py seed=$inputnumber outputFile="file:$gsd" maxEvents=$maxEvents nThreads=$numThreads
# Don't fully understand when it sticks numevent ont the end
if [ ! -f $gsd ]; then
    gsd=${finalfile/.root/_GSD_numEvent$1.root}
fi
cmsRun RECO.py inputFiles="file:$gsd" outputFile=$recoout nThreads=$numThreads
cmsRun nanoML_cfg.py inputFiles=file:$recoout outputFile=file:$finalfile nThreads=$numThreads
echo "${inputnumber} done"
xrdcp $finalfile $eosoutdir/$finalfile 
