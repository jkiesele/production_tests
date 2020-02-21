# coding: utf-8

import FWCore.ParameterSet.Config as cms
from FWCore.ParameterSet.VarParsing import VarParsing
from reco_prodtools.templates.RECO_fragment import process

# option parsing
options = VarParsing('python')
options.setDefault('outputFile', 'file:partGun_PDGid22_x96_Pt1.0To100.0_RECO_1.root')
options.setDefault('inputFiles', "file://partGun_PDGid22_x96_Pt1.0To100.0_GSD_1.root")
options.setDefault('maxEvents', -1)
options.register('outputFileDQM', 'file:partGun_PDGid22_x96_Pt1.0To100.0_DQM_1.root',
    VarParsing.multiplicity.singleton, VarParsing.varType.string, 'path to the DQM output file')
options.parseArguments()

process.maxEvents.input = cms.untracked.int32(options.maxEvents)

# append the HGCTruthProducer to the recosim step
process.hgcTruthProducer = cms.EDProducer("HGCTruthProducer",
    # options
)
process.recosim_step += process.hgcTruthProducer

# Input source
process.source.fileNames = cms.untracked.vstring(options.inputFiles)

# Output definition
process.FEVTDEBUGHLToutput.fileName = cms.untracked.string(
    options.__getattr__("outputFile", noTags=True))
process.FEVTDEBUGHLToutput.outputCommands.append("keep *_HGCTruthProducer_*_*")
process.DQMoutput.fileName = cms.untracked.string(options.outputFileDQM)

# Customisation from command line
# process.hgcalLayerClusters.minClusters = cms.uint32(3)
#those below are all now the default values - just there to illustrate what can be customised
#process.hgcalLayerClusters.dependSensor = cms.bool(True)
#process.hgcalLayerClusters.ecut = cms.double(3.) #multiple of sigma noise if dependSensor is true
#process.hgcalLayerClusters.kappa = cms.double(9.) #multiple of sigma noise if dependSensor is true
#process.hgcalLayerClusters.multiclusterRadii = cms.vdouble(2.,2.,2.) #(EE,FH,BH), in com
#process.hgcalLayerClusters.deltac = cms.vdouble(2.,2.,2.) #(EE,FH,BH), in cm
