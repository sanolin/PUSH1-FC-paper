%Script to call participation_coef function

%W is correlation matrix
%Ci is community affiliation vector (one column with every node as a row
%with the value of what network number it belongs to)
addpath '/Users/sara/Downloads/BCT/2019_03_03_BCT'
addpath '/Users/sara/Desktop/surface_analysis_sch'
load('nodessorted.mat')

%% Schaefer 500
%% Run participation coefficient on all nodes in dots parcellation
subs = dir('/Users/sara/Desktop/02_Data/P*');

for ii= 1:length(subs)
    sub=subs(ii).name
    load(['/Users/sara/Desktop/02_Data/' sub '/' sub 'sch500_funccorrsorted_zmatrix_posonly.mat']);
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
    save(['/Users/sara/Desktop/02_Data/' sub '/' sub 'sch500_nodes_pcoef.mat'], 'P');
end

%% Subset desired nodes
sz = [length(subs) 5];
varTypes = ["string","double","double","double","double"];
varNames = ["ID","172sch_ldlpfc","sch_rdlpfc","sch_lV1","sch_rV1"];
pcoefanalysis = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
for ii= 1:length(subs)
    sub=subs(ii).name
    pcoefanalysis(ii,1) = {sub}; %put participant id into table
    load(['/Users/sara/Desktop/02_Data/' sub '/' sub 'sch500_nodes_pcoef.mat']);
    %add 250 if on rh, then look at netorder find the value of your node and the row number is the row it is on in P   
        %node 172 (ldlpfd)
        sch={P(336,1)};
        pcoefanalysis(ii,2)=(sch);
         %node 188 aka 438 (rdlpfc)
        sch={P(373,1)};
        pcoefanalysis(ii,3)=(sch);
         %node 28 (lV1)
        sch={P(28,1)};
        pcoefanalysis(ii,4)=(sch);
         %node 21 aka 271 (rV1)
        sch={P(271,1)};
        pcoefanalysis(ii,5)=(sch);
end
filename = 'participationcoef_PUSH1_4232024_sch500ROIs.xlsx';
writetable(pcoefanalysis,filename);

%% Schaefer 100
%% Run participation coefficient on all nodes in dots parcellation
subs = dir('/Users/sara/Desktop/02_Data/P*');

for ii= 1:length(subs)
    sub=subs(ii).name
    load(['/Users/sara/Desktop/02_Data/' sub '/' sub 'sch100_funccorrsorted_zmatrix_posonly.mat']);
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
    save(['/Users/sara/Desktop/02_Data/' sub '/' sub 'sch100_nodes_pcoef.mat'], 'P');
end

%% Subset desired nodes
sz = [length(subs) 5];
varTypes = ["string","double","double","double","double"];
varNames = ["ID","sch_ldlpfc","sch_rdlpfc","sch_lV1","sch_rV1"];
pcoefanalysis = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
for ii= 1:length(subs)
    sub=subs(ii).name
    pcoefanalysis(ii,1) = {sub}; %put participant id into table
    load(['/Users/sara/Desktop/02_Data/' sub '/' sub 'sch100_nodes_pcoef.mat']);
    %add 50 if on rh, then look at netorder find the value of your node and the row number is the row it is on in P   
        %node 35 (ldlpfd)
        sch={P(65,1)};
        pcoefanalysis(ii,2)=(sch);
         %node 34 aka 84 (rdlpfc)
        sch={P(71,1)};
        pcoefanalysis(ii,3)=(sch);
         %node 6 (lV1)
        sch={P(6,1)};
        pcoefanalysis(ii,4)=(sch);
         %node 5 aka 55 (rV1)
        sch={P(14,1)};
        pcoefanalysis(ii,5)=(sch);
end
filename = 'participationcoef_PUSH1_4232024_sch100ROIs.xlsx';
writetable(pcoefanalysis,filename);

