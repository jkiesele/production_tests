# production_tests

Simple productions scripts based on the HGCAL Reco prod tools: https://github.com/CMS-HGCAL/reco-prodtools

A simple recipe in CMSSW_11_2_0_pre9 is:

```shell
cmsrel CMSSW_11_2_0_pre9
cd CMSSW_11_2_0_pre9/src
git cms-init
git cms-merge-topic cms-pepr:pepr_CMSSW_11_2_0_pre9
scram b -j 8

# Note: Here follow the same instructions as in the main reco-prodtools repo, but use the D49 geometry
git clone git@github.com:CMS-HGCAL/reco-prodtools.git reco_prodtools
cd reco_prodtools/templates/python
./produceSkeletons_D49_NoSmear_NoDQMNoHLT_PU_AVE_200_BX_25ns.sh
cd ../../..
scram b

git clone git@github.com:cms-pepr/production_tests.git
cd production_tests
bash run_chain.sh 0
```
