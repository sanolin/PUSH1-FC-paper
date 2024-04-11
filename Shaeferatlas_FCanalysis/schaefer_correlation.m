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
Schaefer500lhvertexnodes = readtable("/Users/sara/Downloads/Schaefer500_lh_vertexnodes.xlsx", opts, "UseExcel", false);
Schaefer500lhvertexnodes=table2array(Schaefer500lhvertexnodes);
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
Schaefer500rhvertexnodes = readtable("/Users/sara/Downloads/Schaefer500_rh_vertexnodes.xlsx", opts, "UseExcel", false);
Schaefer500rhvertexnodes=table2array(Schaefer500rhvertexnodes);

% Clear temporary variables
clear opts

%% sort by system and remove nodes not in association or S/M system
% Import meta data
opts = spreadsheetImportOptions("NumVariables", 6);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:F502";

% Specify column names and types
opts.VariableNames = ["NodeNumber", "NetworkName", "NetworkNumber", "SystemName", "SystemNumber", "Hemisphere"];
opts.VariableTypes = ["double", "string", "double", "categorical", "double", "categorical"];

% Specify variable properties
opts = setvaropts(opts, "NetworkName", "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["NetworkName", "SystemName", "Hemisphere"], "EmptyFieldRule", "auto");

% Import the data
Schaefer500metadata = readtable("/Users/sara/Downloads/Schaefer500_metadata.xlsx", opts, "UseExcel", false);
% Clear temporary variables
clear opts
Schaefer500metadata(1,:) = [];
Systemid=Schaefer500metadata(:,"SystemNumber");
Systemid=table2array(Systemid);
[systemsorted, systemorder] = sort(Systemid);    
Del0sys=systemsorted(:,1)==0;


%% remove non-system networks and sort by network of remaining nodes
nodes = Schaefer500metadata(:,"NetworkNumber");
nodes=table2array(nodes);
nodes(Del0sys,:)=[];
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
    
    uroiL = unique(Schaefer500lhvertexnodes);    
    uroiL=uroiL(uroiL~=0);
    
    uroiR = unique(Schaefer500rhvertexnodes);
    uroiR=uroiR(uroiR~=0);
    
    glm = zeros(length(uroiL),size(alltimeseriesL,2)); %Left
    grm = zeros(length(uroiR),size(alltimeseriesR,2)); %Right     
    
    for j = 1:length(uroiL) % loop ROIs
        glm(j,:) = mean(alltimeseriesL(Schaefer500lhvertexnodes(:,1)==uroiL(j), :));
    end
    
    for k = 1:length(uroiR) % loop ROIs
        grm(k,:) = mean(alltimeseriesR(Schaefer500rhvertexnodes(:,1)==uroiR(k), :));
    end
    allnodestimeseries=[glm;grm];
    
    %remove unidentified systems
    sortedtp = allnodestimeseries(systemorder,:);
    sortedtp(Del0sys,:)=[];

    %sort the matrix by node network membership
    sortedtp = sortedtp(netorder,:);
    
    %% save timepoints
    save(['/Users/sara/Desktop/02_Data/' sub '/Schaefer_sortedtimepointswnetworks.mat'], 'sortedtp');
    
    %% run correlation on sorted matrix
    r = corrcoef(sortedtp'); % Correlation matrix
    z = 0.5 * log((1+r)./(1-r)); % Fisher-z transform
    %save the z-matrix
    save(['/Users/sara/Desktop/02_Data/' sub '/sch_funccorrsorted_zmatrix.mat'], 'z');
    %remove negative z values and save
    individualcorrpossort = max(0, z);
    save(['/Users/sara/Desktop/02_Data/' sub '/' sub 'sch_funccorrsorted_zmatrix_posonly.mat'], 'individualcorrpossort');


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
save('/Users/sara/Desktop/ScanTP1_sch_meanfunccorrpos.mat', 'meancorrA');
save('/Users/sara/Desktop/ScanTP2_sch_meanfunccorrpos.mat', 'meancorrB');
FigA=imagesc(meancorrA)
FigB=imagesc(meancorrB)
