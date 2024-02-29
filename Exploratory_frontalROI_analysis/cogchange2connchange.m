

%% import connectivity difference pre/post maps
lh=['/Users/sara/Downloads/lh.paired-diff.mgh'];
rh=['/Users/sara/Downloads/rh.paired-diff.mgh'];
lh=load_mgh(lh);
rh=load_mgh(rh);
lh=squeeze(lh);
rh=squeeze(rh);

%% Import cognitive change data
% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2, "Encoding", "UTF-8");

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["studyid", "fluid_change"];
opts.VariableTypes = ["double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "studyid", "TrimNonNumeric", true);
opts = setvaropts(opts, "studyid", "ThousandsSeparator", ",");

% Import the data
PUSHNIHTBfluidchange = readtable("/Users/sara/Desktop/PUSH_NIHTB_fluid_change.csv", opts);

%% Convert to output type
PUSHNIHTBfluidchange = table2array(PUSHNIHTBfluidchange);

%% Clear temporary variables
clear opts
%remove non-imaging participants
PUSHNIHTBfluidchange(4,:) = [];
PUSHNIHTBfluidchange(9,:) = [];

%reshape from long to wide
cogchange=PUSHNIHTBfluidchange(:,2);
cogchange=cogchange';
%% correlation for cog change with connectivity change
%left hemi
LHcorr=zeros(length(lh),1);
for ii=1:length(lh)
    R=corrcoef(lh(ii,:),cogchange(1,:));
    R=R(1,2);
    LHcorr(ii,1)=R;
end
%right hemi
RHcorr=zeros(length(rh),1);
for ii=1:length(rh)
    R=corrcoef(rh(ii,:),cogchange(1,:));
    R=R(1,2);
    RHcorr(ii,1)=R;
end

%% export mgh files
% Define output path and filenames
dpath=['/Users/sara/Desktop/'];
fname_lh = 'lh.cogandconnchangecorr.mgh';
fname_rh = 'rh.cogandconnchangecorr.mgh';

% Export data as .mgh / .mgz
save_mgh(LHcorr, [dpath, fname_lh], getaffine('fsa6', 'lh'));
save_mgh(RHcorr, [dpath, fname_rh], getaffine('fsa6', 'rh'));