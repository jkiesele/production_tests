#!/bin/bash

maxEvents=100 #70
if [[ $# -lt 1 ]]; then
    echo "Must pass the job label as input"
    exit 1
fi
inputnumber=$1

finalfile="${inputnumber}_windowntup.root"
eosoutdir="/eos/cms/store/user/kelong/ML4Reco/SingleParticleMixGen/CMSPeprFineCaloIDOnlyWithBoundaryCross"
#eosoutdir="/eos/cms/store/user/kelong/ML4Reco/SunandasFixesWithTransition"

THISDIR=`pwd`
cmsswdir="/afs/cern.ch/user/k/kelong/work/ML4Reco/CMSSW_11_0_0_patch1/src"
cd $cmsswdir
eval `scramv1 runtime -sh`
cd $THISDIR

scriptdir="/afs/cern.ch/user/k/kelong/work/ML4Reco/CMSSW_11_0_0_patch1/src/production_tests"

cmsRun $scriptdir/GSD_GUN.py seed=$inputnumber outputFile="file:${inputnumber}_GSD.root" maxEvents=$maxEvents doFineCalo=0 storeHGCBoundaryCross=0
echo "${inputnumber} GSD done"
cmsRun $scriptdir/RECO.py inputFiles="file://${inputnumber}_GSD.root" outputFile="file:${inputnumber}_RECO.root" outputFileDQM="file:${inputnumber}_DQM.root"
rm -f "${inputnumber}_GSD.root" "${inputnumber}_DQM.root"
echo "${inputnumber} RECO done"
eoscp ${inputnumber}_RECO.root $eosoutdir/${inputnumber}_RECO.root
cmsRun $scriptdir/windowNTuple_cfg.py inputFiles="file://${inputnumber}_RECO.root" outputFile="file:${finalfile}"
rm -f "${inputnumber}_RECO.root"
echo "${inputnumber} window done"
eoscp $finalfile $eosoutdir/$finalfile
rm -f *.root
