%% loads surface overlays of cleaned bold data, pulls out timeseries, and concatenates 3 scans

%location of participants data
patients = dir('/Users/sara/Desktop/02_Data/P*');
datahome='/Users/sara/Desktop/02_Data/';
for patient = 1:length(patients) 
    patient=patients(patient).name
    cd(datahome);
    cd(patient);
      for scan = 1:3
      %load mgh surface overlap files
      rh=['BOLDsurfrh', num2str(scan), '.mgh'];
      R=load_mgh(rh);
      lh=['BOLDsurflh', num2str(scan), '.mgh'];
      L=load_mgh(lh);
      
      %created plot of data if wanted
      %stackedplot(L);
      
      %pull out timeseries data from 4d array mgh
      timeseriesL =squeeze(L);
      timeseriesR=squeeze(R);
    
            if scan==1
            alltimeseriesL=(timeseriesL);
            alltimeseriesR=(timeseriesR);
            else
            %concatenate 3 scans
            alltimeseriesL=cat(2, alltimeseriesL, timeseriesL);
            alltimeseriesR=cat(2, alltimeseriesR, timeseriesR);
            end
      end
%export excel file of full timeseries data
T = array2table(alltimeseriesR);
filenameT = ['/Users/sara/Desktop/02_Data/', patient, '/RHfulltimeseries.xlsx'];
writetable(T,filenameT);
S = array2table(alltimeseriesL);
filenameS = ['/Users/sara/Desktop/02_Data/', patient, '/LHfulltimeseries.xlsx'];
writetable(S,filenameS);
end
