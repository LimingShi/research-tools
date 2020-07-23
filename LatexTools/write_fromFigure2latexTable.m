function write_fromFigure2latexTable(filename,data_mode,full_tex_flag,float_num)
% This function can be used for producing latex table from a figure;
% Written by Liming Shi in Aalborg University 16-03-2017
% input:
% filename --> output file name
% data_mode --> either column_mode or row_mode
% full_tex_flag --> 1 or 0; when full_tex_flag=1, a full compliable latex
% file will be created, ohterwise only table part will be produced.
% float_num --> float number
if nargin==0
    filename='latex_table.tex';
    data_mode='column_mode';
    full_tex_flag=0;
    float_num=2;
end
if nargin==1
    data_mode='column_mode';
    full_tex_flag=0;
    float_num=2;
end
if nargin==2
    full_tex_flag=0;
    float_num=2;
end
if nargin==3
    float_num=2;
end
write_table_from_figure(filename,float_num);
cell_data=read_table(filename);
write_table_latex(filename,cell_data,data_mode,full_tex_flag,float_num);
return
function write_table_from_figure(filename,float_num,varargin)
% this program can be used for extracting data from a matlab figure;
% varargin should be the labels of different data
% example:
% first, click on the figure which you want to extract line data with
% write_table_from_figure('test.table','time','algorithm_1','algorithm_2')
% Written by Liming Shi in Aalborg University, 2017-03-13;
labels=varargin;
lh = findall(gca, 'type', 'line');
xc = get(lh, 'xdata');            
yc = get(lh, 'ydata'); 

if isempty(xc) && isempty(yc)
    h1=gcf;
    close(h1);
    disp('Nothing happened because you do not have a figure');
    return;
end
if ~iscell(xc)
    xc_cell{1}=xc;
    yc_cell{1}=yc;
else
    xc_cell=xc;
    yc_cell=yc;
end

if isempty(labels) || isempty(labels{1});
    labels{1}='x_arg';
    for ii=1:length(yc_cell)
        labels{ii+1}=strcat('Algorithm_',num2str(ii));
    end
end

if length(labels)~=length(yc_cell)+1;
   for ii=length(labels):length(yc_cell)
        labels{ii+1}=strcat('Algorithm_',num2str(ii));
    end
end


temp=xc_cell{1};
for ii=2:length(xc_cell)
    if(sum(temp==xc_cell{ii})==length(temp))
    else
        error('x coordinates are different');
    end
end

cell_data{1,1}=labels{1};
x_temp=xc_cell{1};
for ii=1:length(x_temp)
    cell_data{ii+1,1}=x_temp(ii);
end
for ii=1:length(yc_cell)
    cell_data{1,ii+1}=labels{ii+1};
    y_temp=yc_cell{length(yc_cell)-ii+1};
    for jj=1:length(y_temp)
        cell_data{jj+1,ii+1}=y_temp(jj);
    end
end
write_table(filename,cell_data,float_num);
return

function write_table(a,cell_data,float_num)
% Each row should be the result of different algorithms
% Each first column should be the different conditions(using numbers)
% for producing figure table

% Replace the dash('-') to the underscore ('_')
for ii=1:size(cell_data(:))
    temp=cell_data{ii};
    for jj=1:length(temp);
        if strcmp(temp(jj),'-')
            temp(jj)='_';
        end
    end
    cell_data{ii}=temp;
end
% Replace the point('.') to the _ 
for ii=1:size(cell_data,2)
    temp=cell_data{1,ii};
    for jj=1:length(temp);
        if strcmp(temp(jj),'.')
            temp(jj)='_';
        end
    end
    cell_data{1,ii}=temp;
end
fid = fopen(a, 'wt');
for ii=1:size(cell_data,1)
    for jj=1:size(cell_data,2)
        if ii==1 
            fprintf(fid,'%s\t', cell_data{ii,jj});
        else
             fprintf(fid,strcat('%.',num2str(float_num),'f\t'), cell_data{ii,jj});
        end
        if jj==size(cell_data,2)
            fprintf(fid,'\n');
        end
    end
end
fclose(fid);
return
function [cell_data,matrix_data]=read_table(file_name,row_num)
% only for table with rows as results from different algorithms and the first column is digit
temp_cell_data = textread(file_name,'%s');
if nargin<2
    for ii=1:length(temp_cell_data)
        if isdigit(temp_cell_data{ii}) ||...
                (strcmp(temp_cell_data{ii}(1),'-') &&isdigit(temp_cell_data{ii}(2:end)))
            row_num=length(temp_cell_data)/(ii-1);
            break;
        end
    end 
end
cell_data=reshape(temp_cell_data,length(temp_cell_data)/row_num,row_num)';
for ii=2:size(cell_data,1)
    for jj=1:size(cell_data,2)
        temp=cell_data{ii,jj};
        cell_data{ii,jj}=str2num(temp);
    end
end
temp_data2=reshape(temp_cell_data,length(temp_cell_data)/row_num,row_num)';
matrix_data=zeros(size(temp_data2));
for ii=2:size(cell_data,1)
    for jj=1:size(temp_data2,2)
        temp=temp_data2{ii,jj};
        matrix_data(ii,jj)=str2num(temp);
    end
end
matrix_data=matrix_data(2:end,:);

return
function write_table_latex(filename,cell_data,mode,full_tex_flag,float_num)
% Replace the underscore ('_') to the dash('-')
for ii=1:size(cell_data(:))
    temp=cell_data{ii};
    for jj=1:length(temp);
        if strcmp(temp(jj),'_')
            temp(jj)='-';
        end
    end
    cell_data{ii}=temp;
end
fid = fopen(filename, 'wt');

if full_tex_flag
    doc_header={['\documentclass{article}'];['\usepackage{booktabs}'];['\begin{document}']};
    [nrows,~] = size(doc_header);
    for row = 1:nrows
        fprintf(fid,'%s\n',doc_header{row,:});
    end
end


if strcmp(mode,'column_mode')
    header = ['\begin{tabular}','{',repmat('c',1,size(cell_data,2)),'}'];
else
    if strcmp(mode,'row_mode')
        header = ['\begin{tabular}','{',repmat('c',1,size(cell_data,1)),'}'];
    end
end
latex_table_header = {['\begin{table}'];'\centering';header;'\toprule[.5pt]';'\toprule[.5pt]'};
[nrows,~] = size(latex_table_header);
for row = 1:nrows
    fprintf(fid,'%s\n',latex_table_header{row,:});
end

if strcmp(mode,'column_mode')
    for ii=1:size(cell_data,1)
        for jj=1:size(cell_data,2)
            if ii==1
                if jj==size(cell_data,2)
                    fprintf(fid,'%s\t \\\\', cell_data{ii,jj});
                else
                    fprintf(fid,'%s\t &', cell_data{ii,jj});
                end
            else
                if jj==size(cell_data,2)
                    fprintf(fid,strcat('%.',num2str(float_num),'f\t \\\\'), cell_data{ii,jj});
                else
                    fprintf(fid,strcat('%.',num2str(float_num),'f\t &'), cell_data{ii,jj});
                end
            end
            if jj==size(cell_data,2)
                if ii==1
                    fprintf(fid,'\t');
                    fprintf(fid,'\\midrule[.5pt]');
                end
                fprintf(fid,'\n');
            end
        end
    end
else
    if strcmp(mode,'row_mode')
        for jj=1:size(cell_data,2)
            for ii=1:size(cell_data,1)
                if ii==1
                    fprintf(fid,'%s\t &', cell_data{ii,jj});
                else
                    if ii==size(cell_data,1)
                        fprintf(fid,strcat('%.',num2str(float_num),'f\t \\\\'), cell_data{ii,jj});
                    else
                        fprintf(fid,strcat('%.',num2str(float_num),'f\t &'), cell_data{ii,jj});
                    end
                end
                if ii==size(cell_data,1)
                    if jj==1
                        fprintf(fid,'\t');
                        fprintf(fid,'\\midrule[.5pt]');
                    end
                    fprintf(fid,'\n');
                end
            end
        end
    end
end
latex_tableFooter = {'\bottomrule[.5pt]';'\bottomrule[.5pt]';'\end{tabular}';['\caption{','MyTable','}']; ...
    ['\label{table:','MyLabel','}'];'\end{table}'};
[nrows,~] = size(latex_tableFooter);
for row = 1:nrows
    fprintf(fid,'%s\n',latex_tableFooter{row,:});
end

if full_tex_flag
    doc_header={['\end{document}']};
    [nrows,~] = size(doc_header);
    for row = 1:nrows
        fprintf(fid,'%s\n',doc_header{row,:});
    end
end
fclose(fid);
return
function result=isdigit(my_string)
% This program determines whether the input string is digit or not
if ischar(my_string)
    
else
    result=true;
    return;
end
if sum(isstrprop(my_string, 'digit'))==length(my_string)
    result=true;
else
    result=false;
    if sum(isstrprop(my_string, 'digit'))+1==length(my_string)
        result=strcmp(my_string(find(isstrprop(my_string, 'digit')==0)),'.');
    end
    
end
return
