%load annotation
[vertices, label, colortable]=read_annotation('lh.Schaefer2018_100parcels_7Networks_order.annot');
T=cell2table(colortable.struct_names);
T.Properties.VariableDescriptions{'Var1'} = 'Network name';
%lh
nodes=[0:50];
nodes=nodes'
nodes=table(nodes);
T=[T nodes];

code=colortable.table(:,5);
code=table(code);
T=[T code];
writetable(T,'Shaefer100_lh.xlsx');

for ii=1:length(label)
number=label(ii,1);
nodenum=find(T.code==number);
nodenum=nodenum-1;
label(ii,2)=nodenum;
end
tlabel=table(label(:,2));
writetable(tlabel, 'Shaefer100_lh_vertexnodes.xlsx')

%rh
clear
[vertices, label, colortable]=read_annotation('rh.Schaefer2018_100parcels_7Networks_order.annot');
T=cell2table(colortable.struct_names);
T.Properties.VariableDescriptions{'Var1'} = 'Network name';
nodes=[0 51:100]
nodes=nodes'
nodes=table(nodes);
T=[T nodes];

code=colortable.table(:,5);
code=table(code);
T=[T code];
writetable(T,'Shaefer100_rh.xlsx');

%rh
for ii=1:length(label)
number=label(ii,1);
nodenum=find(T.code==number);
nodenum=nodenum+99;
if nodenum==100
    nodenum=0;
end
label(ii,2)=nodenum;
end

tlabel=table(label(:,2));
writetable(tlabel, 'Shaefer100_rh_vertexnodes.xlsx')