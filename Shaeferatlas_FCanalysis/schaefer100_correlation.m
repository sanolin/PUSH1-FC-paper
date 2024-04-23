%code to sort timeseries data by Schaefer 500 parcellation and create correlation matrix then create a group averaged correlation matrix

%% Import label files
% import shaefer atlas left hemisphere
opts = spreadsheetImportOptions("NumVariables", 1);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A1:A40962";

% Specify column names and types
opts.VariableNames = "node_network";
opts.VariableTypes = "double";

% Import the data
Schaeferlhvertexnodes = readtable("/Users/sara/Downloads/Schaefer100_lh_vertexnodes.xlsx", opts, "UseExcel", false);
Schaeferlhvertexnodes=table2array(Schaeferlhvertexnodes);
Schaeferlhvertexnodes(1,:)=[];
% Clear temporary variables
clear opts

% import shaefer atlas right hemisphere
opts = spreadsheetImportOptions("NumVariables", 1);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A1:A40962";

% Specify column names and types
opts.VariableNames = "node_network";
opts.VariableTypes = "double";

% Import the data
Schaeferrhvertexnodes = readtable("/Users/sara/Downloads/Schaefer100_rh_vertexnodes.xlsx", opts, "UseExcel", false);
Schaeferrhvertexnodes=table2array(Schaeferrhvertexnodes);
Schaeferrhvertexnodes(1,:)=[];

% Clear temporary variables
clear opts

%% sort by system and remove nodes not in association or S/M system
% Import meta data
opts = spreadsheetImportOptions("NumVariables", 6);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:F102";

% Specify column names and types
opts.VariableNames = ["NodeNumber", "NetworkName", "NetworkNumber", "SystemName", "SystemNumber", "Hemisphere"];
opts.VariableTypes = ["double", "string", "double", "categorical", "double", "categorical"];

% Specify variable properties
opts = setvaropts(opts, "NetworkName", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["NetworkName", "SystemName", "Hemisphere"], "EmptyFieldRule", "auto");

% Import the data
Schaefermetadata = readtable("/Users/sara/Downloads/Schaefer100_metadata.xlsx", opts, "UseExcel", false);
% Clear temporary variables
clear opts
Schaefermetadata(1,:) = [];

%% remove non-system networks and sort by network of remaining nodes
nodes = Schaefermetadata(:,"NetworkNumber");
nodes=table2array(nodes);
[netsorted, netorder] = sort(nodes);
   
subs = dir('/Users/sara/Desktop/02_Data/P*');
%% Make sorted individual matrices
for ii= 1:length(subs)
    sub=subs(ii).name
    timepoint=strlength(sub)
        cd /Users/sara/Desktop/02_Data/
        cd (sub)
               for scan = 1:3
              %load mgh surface overlap files
              rh=['BOLDsurfrh', num2str(scan), '.mgh'];
              R=load_mgh(rh);
              lh=['BOLDsurflh', num2str(scan), '.mgh'];
              L=load_mgh(lh);
              
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
    
    uroiL = unique(Schaeferlhvertexnodes);    
    uroiL=uroiL(uroiL~=0);
    
    uroiR = unique(Schaeferrhvertexnodes);
    uroiR=uroiR(uroiR~=0);
    
    glm = zeros(length(uroiL),size(alltimeseriesL,2)); %Left
    grm = zeros(length(uroiR),size(alltimeseriesR,2)); %Right     
    
    for j = 1:length(uroiL) % loop ROIs
        glm(j,:) = mean(alltimeseriesL(Schaeferlhvertexnodes(:,1)==uroiL(j), :));
    end
    
    for k = 1:length(uroiR) % loop ROIs
        grm(k,:) = mean(alltimeseriesR(Schaeferrhvertexnodes(:,1)==uroiR(k), :));
    end
    allnodestimeseries=[glm;grm];

    %sort the matrix by node network membership
    sortedtp = allnodestimeseries(netorder,:);
    
    %% save timepoints
    save(['/Users/sara/Desktop/02_Data/' sub '/Schaefer100_sortedtimepointswnetworks.mat'], 'sortedtp');
    
    %% run correlation on sorted matrix
    r = corrcoef(sortedtp'); % Correlation matrix
    z = 0.5 * log((1+r)./(1-r)); % Fisher-z transform
    %save the z-matrix
    save(['/Users/sara/Desktop/02_Data/' sub '/sch100_funccorrsorted_zmatrix.mat'], 'z');
    %remove negative z values and save
    individualcorrpossort = max(0, z);
    save(['/Users/sara/Desktop/02_Data/' sub '/' sub 'sch100_funccorrsorted_zmatrix_posonly.mat'], 'individualcorrpossort');


    %% Create group correlation matrix
     % run timepoint 1 and timepoint 2 separately
    if timepoint==4 %timepoint 1
        if ii==1
            meancorrA = individualcorrpossort;
            countA=1;
        else
            meancorrA = meancorrA + individualcorrpossort;
            countA=countA+1;
        end
    elseif timepoint==5 %timepoint 2
         if ii==2
            meancorrB = individualcorrpossort;
            countB=1;
        else
            meancorrB = meancorrB + individualcorrpossort;
            countB=countB+1;
        end
    end
end
meancorrA = meancorrA/countA;
meancorrB = meancorrB/countB;
save('/Users/sara/Desktop/ScanTP1_sch100_meanfunccorrpos.mat', 'meancorrA');
save('/Users/sara/Desktop/ScanTP2_sch100_meanfunccorrpos.mat', 'meancorrB');
FigA=imagesc(meancorrA)
FigB=imagesc(meancorrB)

%create sorted metadata
sortedmeta = Schaefermetadata(netorder,:);
writetable(sortedmeta, '/Users/sara/Desktop/Shaefer100_sortedmetadata.xlsx');
