# production_tests

Simple productions scripts based on the HGCAL Reco prod tools: https://github.com/CMS-HGCAL/reco-prodtools


NOTE: The NanoML ntuples require pepr_CMSSW_12_0_0 (some older pepr_CMSSW_X_Y_Z branches are available, if you prefer). A version working with more minimal changes is in progress

A simple recipe in CMSSW_12_0_0 is:

```shell
version=CMSSW_12_0_0
cmsrel $version
cd $version/src
cmsenv
git cms-init
git cms-merge-topic cms-pepr:pepr_${version}
scram b -j 8

# Note: Here follow the same instructions as in the main reco-prodtools repo, but use the D49 geometry
git clone git@github.com:kdlong/reco-prodtools.git reco_prodtools
cd reco_prodtools/templates/python
./produceSkeletons_D49_NoSmear_NoDQMNoHLT_PU_AVE_200_BX_25ns.sh
cd ../../..
scram b
```

To run the GSD step, you should edit the [GSD_GUN.py](GSD_GUN.py) file to select the number of particles, IDs, and energy range you would like to generate. The

```cmsRun GSD_GUN.py seed=X outputFile=testGSD.root```

Then process the output of this using the RECO config

```cmsRun RECO.py seed=X inputFiles=file:testGSD.root outputFile=testRECO.root```

For the NanoML ntuples, you should use the configurations [nanoML_cfg.py](nanoML_cfg.py) for samples with RECO content. Conversely, use [nanoMLGSD_cfg.py](nanoMLGSD_cfg) if you have a file with only GEN content. Several aspects of this are configurable (store simclusters or not, store merged simclusters or not). configureX functions in the configuration take care of this. This will be made configurable at some point, but open the configuration file and edit to include or not these functions for now.

Then you run them in the expected way

```cmsRun nanoML_cfg.py inputFiles=file:testRECO.root outputFile=testNanoML.root```

