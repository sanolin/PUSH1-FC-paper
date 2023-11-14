%loads surface overlays of cleaned bold data, pulls out timeseries, and concatenates 3 scans
rhsurfs = dir('/data/project/vislab/a/HCP_diff_Sara/wholeFNstoallV1tprob/wholeFNstoallV1t_biggest_surf/fsavg*rh*');

for ii = 1:length(lhsurfs)
for patient in 
do
  for scan in 1:3
  do
  %load mgh surface overlap files
  R=load_mgh('BOLDsurfrh.mgh');
  L=load_mgh('BOLDsurflh.mgh');
  
  %created plot of data if wanted
  %stackedplot(L);
  
  %pull out timeseries data from 4d array mgh
  timeseriesL =squeeze(L);
  timeseriesR=squeeze(R);
  
  %concatenate 3 scans
  
  done
done
