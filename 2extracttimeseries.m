%load mgh surface overlap files
R=load_mgh('BOLDsurfrh.mgh');
L=load_mgh('BOLDsurflh.mgh');

%created plot of data if wanted
%stackedplot(L);

%pull out timeseries data from 4d array mgh
timeseriesL =squeeze(L);
timeseriesR=squeeze(R);
