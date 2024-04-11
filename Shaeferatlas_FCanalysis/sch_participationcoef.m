%Script to call participation_coef function

%W is correlation matrix
%Ci is community affiliation vector (one column with every node as a row
%with the value of what network number it belongs to)
addpath '/Users/sara/Downloads/BCT/2019_03_03_BCT'
addpath '/Users/sara/Desktop/surface_analysis_sch'
load('nodessorted.mat')

%% Run participation coefficient on all nodes in dots parcellation
subs = dir('/Users/sara/Desktop/02_Data/P*');

for ii= 1:length(subs)
    sub=subs(ii).name
    load(['/Users/sara/Desktop/02_Data/' sub '/' sub 'sch_funccorrsorted_zmatrix_posonly.mat']);
    %Change "inf" values in the correlation matrix to "0" since the
    %function will error out with any "inf" in the matrix
    diagonalMask = logical(eye(size(individualcorrpossort)));
    individualcorrpossort(diagonalMask) = 0;
    %set the inputs
    W=individualcorrpossort;
    Ci=netsorted;
    %run participation coefficient on all nodes
    P=participation_coef(W,Ci);
    %save participation coeffiecients to participant folders
    save(['/Users/sara/Desktop/02_Data/' sub '/' sub 'sch_nodes_pcoef.mat'], 'P');
end

%% Subset desired nodes
sz = [length(subs) 2];
varTypes = ["string","double"];
varNames = ["ID","172sch"];
pcoefanalysis = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
for ii= 1:length(subs)
    sub=subs(ii).name
    pcoefanalysis(ii,1) = {sub}; %put participant id into table
    load(['/Users/sara/Desktop/02_Data/' sub '/' sub 'sch_nodes_pcoef.mat']);
        %node 172
        sch={P(172,1)};
        pcoefanalysis(ii,2)=(sch);
end
filename = 'participationcoef_PUSH1_4112024_sch172.xlsx';
writetable(pcoefanalysis,filename);
