R=load_mgh('BOLDsurfrh.mgh');
L=load_mgh('BOLDsurflh.mgh');
stackedplot(L);
timeseriesL =squeeze(L);
timeseriesR=squeeze(R);