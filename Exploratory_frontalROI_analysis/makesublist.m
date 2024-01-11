cfiles = dir('/Users/sara/Desktop/02_Data/P*');
cfiles = rmfield(cfiles, {'folder', 'date', 'bytes', 'isdir', 'datenum'});
[cfiles(1:38).unnamed] = deal([]); 
for ii= 1:length(subs)
    sub=cfiles(ii).name
    timepoint=strlength(sub)
        if timepoint==4 %timepoint 1
              [cfiles(ii).unnamed] = deal('.pre');
            elseif timepoint==5 %timepoint 2
               [cfiles(ii).unnamed] = deal('.post');
               cfiles(ii).name=sub(1:4);
            end
end
cd('/Users/sara/Desktop/');
writetable(struct2table(cfiles), 'sublist.txt')  