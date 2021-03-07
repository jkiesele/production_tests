#!/bin/bash

maxEvents=$1
inputnumber=$2

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

THISDIR=`pwd`
#cmsswdir="/afs/cern.ch/user/k/kelong/work/ML4Reco/CMSSW_11_3_0_pre3/src"
cmsswdir="/data/home/kelong/work/ML4Reco/CMSSW_11_3_0_pre3/src/"
cd $cmsswdir
eval `scramv1 runtime -sh`
cd $THISDIR

scriptdir="${cmsswdir}/production_tests"

cmsRun $scriptdir/nanoHGC_cfg.py seed=$inputnumber outputFile="file:$finalfile" maxEvents=$maxEvents nThreads=$numThreads
echo "${inputnumber} done"
xrdcp ${finalfile/.root/_numEvent$2.root} $eosoutdir/$finalfile 
