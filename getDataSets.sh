dasgoclient -query "file dataset=/DYJetsToLL_M-50_TuneCP5_13TeV-madgraphMLM-pythia8/RunIISummer20UL18MiniAODv2-106X_upgrade2018_realistic_v16_L1v1-v2/MINIAODSIM" > MINIAOD.txt
sed -i 's@/store@root://cmsxrootd-kit.gridka.de//store@g' MINIAOD.txt
sed -i ':a;N;s/\n/,/g' MINIAOD.txt
