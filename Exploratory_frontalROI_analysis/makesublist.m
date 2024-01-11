cfiles = dir('/Users/sara/Desktop/02_Data/P*');
cfiles = rmfield(cfiles, {'folder', 'date', 'bytes', 'isdir', 'datenum'});

cd('/Users/sara/Desktop/');
writetable(struct2table(cfiles), 'sublist.txt')  
