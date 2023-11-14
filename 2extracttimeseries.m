%loads surface overlays of cleaned bold data, pulls out timeseries, and concatenates 3 scans
patients = dir('/Volumes/vdrive/helpern_users/benitez_a/PUSH/PUSH_1/PUSH_Analyses/fMRI_Analysis/Sara/02_Data/P*');

for patient in 1:length(patients) 
      for scan in 1:3
      %load mgh surface overlap files
      R=load_mgh('BOLDsurfrh(scan).mgh');
      L=load_mgh('BOLDsurflh(scan).mgh');
      
      %created plot of data if wanted
      %stackedplot(L);
      
      %pull out timeseries data from 4d array mgh
      timeseriesL =squeeze(L);
      timeseriesR=squeeze(R);
    
            if scan=1
            %concatenate 3 scans
            alltimeseriesL=(timeseriesL);
            alltimeseriesR=(timeseriesR);
            else
            alltimeseriesL=cat(alltimeseries, timeseriesL);
            alltimeseriesR=cat(alltimeseries, timeseriesR);
            end
      end
end
