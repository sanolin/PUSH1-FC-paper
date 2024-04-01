%load annotation
[vertices, label, colortable]=read_annotation('rh.Schaefer2018_500parcels_7Networks_order.annot');
T=cell2table(colortable.struct_names);
T.Properties.VariableDescriptions{'Var1'} = 'Network name';
%lh
nodes=[0:250];
nodes=nodes'
nodes=table(nodes);
T=[T nodes];
%rh
nodes=[0 251:500]
nodes=nodes'
nodes=table(nodes);
T=[T nodes];

code=colortable.table(:,5);
code=table(code);
T=[T code];
writetable(T,'Shaefer500_rh.xlsx');
%lh
for ii=1:length(label)
number=label(ii,1);
nodenum=find(T.code==number);
nodenum=nodenum-1;
label(ii,2)=nodenum;
end

%rh
for ii=1:length(label)
number=label(ii,1);
nodenum=find(T.code==number);
nodenum=nodenum+249;
if nodenum==250
    nodenum=0;
end
label(ii,2)=nodenum;
end

tlabel=table(label(:,2));
writetable(tlabel, 'Shaefer500_rh_vertexnodes.xlsx')