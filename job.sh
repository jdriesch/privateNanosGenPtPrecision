#!/bin/bash
# Navigate to working directory
cd /work/jdriesch/CMS_service/rochester/privateNanos || exit 1

# Set up CMS environment
export SCRAM_ARCH=slc7_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh

# Check if CMSSW is already installed, otherwise install it
if [ -r CMSSW_10_6_26/src ] ; then
  echo release CMSSW_10_6_26 already exists
else
  scram p CMSSW CMSSW_10_6_26 || exit 1
fi

# Setup runtime environment
cd CMSSW_10_6_26/src || exit 1
eval `scram runtime -sh`

# Build CMSSW
scram b
cd ../..

# Create job directory
mkdir -p "job_$1" && cd "job_$1" || exit 1

# Define Events maximum
EVENTS=500000

# Run cmsDriver command
cmsDriver.py  --python_filename TAU-RunIISummer20UL18NanoAODv9-00001_1_cfg.py --eventcontent NANOAODSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier NANOAODSIM --fileout file:/ceph/jdriesch/rochester/privateNanos/DY_${1}.root --conditions 106X_upgrade2018_realistic_v16_L1v1 --step NANO --filein "$2" --era Run2_2018,run2_nanoAOD_106Xv2 --no_exec --mc -n $EVENTS || {
  cd ..
  rm -r "job_$1"
  exit 1
}

cat TAU-RunIISummer20UL18NanoAODv9-00001_1_cfg.py ../producer.py > config_new.py

# Run generated config
REPORT_NAME=TAU-RunIISummer20UL18NanoAODv9-00001_report.xml
cmsRun -e -j $REPORT_NAME config_new.py || {
  cd ..
  rm -r "job_$1"
  exit 1
}

cd ..
rm -r job_$1
