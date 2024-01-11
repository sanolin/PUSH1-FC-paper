
clear
clc
diary_dir ='/Users/sara/Desktop/' %set location for output of diary
 diary([diary_dir '/preprocscriptlistlh.txt']); %diary location and filename
parentdir = '/Users/sara/Desktop/02_Data';
cd(parentdir);
cfiles = dir(['P*']);
str='';
for ii = 1:length(cfiles)
    sub = cfiles(ii).name;
    flag= [' --isp $in/', sub, '/lh.corrtoLHfrontalROI.mgh'];
    str = [str sprintf(flag)]
end
diary OFF;
%copy and paste the string output in the diary to the mris_preproc script


