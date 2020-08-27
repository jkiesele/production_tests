#!/bin/bash

maxEvents=5 #70
if [[ $# -lt 1 ]]; then
    echo "Must pass the job label as input"
    exit 1
fi
inputnumber=${1}

mergedSC=0
finalfile="${inputnumber}_windowntup_mergedSC${mergedSC}.root"
#finalfile="${inputnumber}_windowntup.root"
#eosoutdir="/eos/cms/store/user/kelong/ML4Reco/SingleParticleMixGen/CMSPeprFineCaloIDOnlyWithBoundaryCross"
#eosoutdir="/eos/cms/store/user/kelong/ML4Reco/TruthCompare/BoundaryCross_PropUpdate"
eosoutdir="/eos/cms/store/cmst3/group/hgcal/CMG_studies/kelong/GeantTruthStudy/MixGun10Particles"

THISDIR=`pwd`
cmsswdir="/afs/cern.ch/user/k/kelong/work/ML4Reco/CMSSW_11_1_0_pre7/src"
cd $cmsswdir
eval `scramv1 runtime -sh`
cd $THISDIR

scriptdir="$cmsswdir/production_tests"

ntupleOnly=0
if [[ $# -gt 0 ]]; then
    ntupleOnly=$2
fi

if [[ $ntupleOnly -gt 0 ]]; then
    eoscp $eosoutdir/${inputnumber}_RECO.root ${inputnumber}_RECO.root 
else
    cmsRun $scriptdir/GSD_GUN.py seed=$inputnumber outputFile="file:${inputnumber}_GSD.root" maxEvents=$maxEvents doFineCalo=1 storeHGCBoundaryCross=1
    echo "${inputnumber} GSD done"
    eoscp ${inputnumber}_GSD.root $eosoutdir/${inputnumber}_GSD.root
    cmsRun $scriptdir/RECO.py inputFiles="file://${inputnumber}_GSD.root" outputFile="file:${inputnumber}_RECO.root" 
    eoscp ${inputnumber}_RECO.root $eosoutdir/${inputnumber}_RECO.root
    echo "${inputnumber} RECO done"
fi
cmsRun $scriptdir/windowNTuple_cfg.py inputFiles="file://${inputnumber}_RECO.root" outputFile="file:${finalfile}"
echo "${inputnumber} window done"
eoscp $finalfile $eosoutdir/$finalfile
#rm -f *.root
