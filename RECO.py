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
options.register("nThreads", 1, VarParsing.multiplicity.singleton, VarParsing.varType.int,
    "number of threads")
options.parseArguments()

process.maxEvents.input = cms.untracked.int32(options.maxEvents)

process.load("SimTracker.TrackAssociation.trackingParticleRecoTrackAsssociation_cfi")
# append the HGCTruthProducer to the recosim step
process.trackingParticleMergedSCAssociation = cms.EDProducer("TrackingParticleSimClusterAssociationProducer",
    simClusters = cms.InputTag("mix:MergedCaloTruth"),
    trackingParticles= cms.InputTag("mix:MergedTrackTruth")

)

process.trackingParticleSimClusterAssociation = cms.EDProducer("TrackingParticleSimClusterAssociationProducer",
    #simClusters = cms.InputTag("mix:MergedCaloTruth"),
    simClusters = cms.InputTag("hgcSimTruth"),
    trackingParticles= cms.InputTag("mix:MergedTrackTruth")

)
# If you want to run the associations or SC merging
# process.recosim_step *= process.hgcSimTruth
# process.recosim_step *= process.trackingParticleRecoTrackAsssociation
# process.recosim_step *= process.trackingParticleSimClusterAssociation
# process.recosim_step *= process.trackingParticleMergedSCAssociation

#process.dump=cms.EDAnalyzer('EventContentAnalyzer')
#process.recosim_step += process.dump

# Input source
process.source.fileNames = cms.untracked.vstring(options.inputFiles)

# Output definition
process.FEVTDEBUGoutput.fileName = cms.untracked.string(
    options.__getattr__("outputFile", noTags=True))
process.FEVTDEBUGoutput.outputCommands.append("keep *_*G4*_*_*")
process.FEVTDEBUGoutput.outputCommands.extend(["keep *_MergedTrackTruth_*_*",
    "keep *_trackingParticleRecoTrackAsssociation_*_*", 
    "keep *_trackingParticleSimClusterAssociation_*_*",
    "keep *_trackingParticleMergedSCAssociation_*_*", 
    "keep SimClustersedmAssociation_mix_*_*", "keep CaloParticlesedmAssociation_mix_*_*", 
    "keep *_pfParticles_*_*",
    "keep recoPFRecHits_*_*_*", 
    "keep *_hgcSimTruth_*_*",
])

process.options.numberOfThreads=cms.untracked.uint32(options.nThreads)

if hasattr(process, "DQMoutput"):
    process.DQMoutput.fileName = cms.untracked.string(options.outputFileDQM)

