# coding: utf-8

import os
import math

import FWCore.ParameterSet.Config as cms
from FWCore.ParameterSet.VarParsing import VarParsing
from reco_prodtools.templates.NanoML_fragment import process

# option parsing
options = VarParsing('python')
options.setDefault('outputFile', 'file:partGun_PDGid22_x96_Pt1.0To100.0_GSD_1.root')
options.setDefault('maxEvents', 1)
options.register("pileup", 0, VarParsing.multiplicity.singleton, VarParsing.varType.int,
    "pileup")
options.register("seed", 1, VarParsing.multiplicity.singleton, VarParsing.varType.int,
    "random seed")
options.register("nThreads", 1, VarParsing.multiplicity.singleton, VarParsing.varType.int,
    "number of threads")
options.register("doFineCalo", 1, VarParsing.multiplicity.singleton, VarParsing.varType.int,
    "turn do fineCalo on/off")
options.parseArguments()

process.maxEvents.input = cms.untracked.int32(options.maxEvents)

seed = int(options.seed)+1
# random seeds
process.RandomNumberGeneratorService.generator.initialSeed = cms.untracked.uint32(seed)
process.RandomNumberGeneratorService.VtxSmeared.initialSeed = cms.untracked.uint32(seed)
process.RandomNumberGeneratorService.mix.initialSeed = cms.untracked.uint32(seed)

# Input source
process.source.firstLuminosityBlock = cms.untracked.uint32(seed)

process.generator = cms.EDProducer("FlatEtaRangeGunProducer",
    # particle ids
    particleIDs=cms.vint32(22, 22, 11,-11,211,-211,13,-13, 310, 130, 111, 311, 321, -321),
    # max number of particles to shoot at a time
    nParticles=cms.int32(5),
    # shoot exactly the particles defined in particleIDs in that order
    exactShoot=cms.bool(False),
    # randomly shoot [1, nParticles] particles, each time randomly drawn from particleIDs
    randomShoot=cms.bool(False),
    # energy range
    eMin=cms.double(20),
    eMax=cms.double(200.0),
    # phi range
    phiMin=cms.double(-math.pi),
    phiMax=cms.double(math.pi),
    # eta range
    etaMin=cms.double(1.52),
    etaMax=cms.double(3.00),

    debug=cms.untracked.bool(True),
)

process.options.numberOfThreads=cms.untracked.uint32(options.nThreads)
process.NANOAODSIMoutput.fileName = cms.untracked.string(options.outputFile)
