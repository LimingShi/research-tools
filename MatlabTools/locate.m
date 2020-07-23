function locate(str_file)
if ismac
%     [~,files]=system(['mdfind -name ' str_file])
    system(['mdfind -name ' str_file]);
else
    if isunix
        system(['locate ' str_file]);
    else
        curdir=pwd;
        eq_inx=(curdir=='\');
        final_inx=find(eq_inx,1);
        pre_str=curdir(1:final_inx-1);
        [~,homedir]=system('echo %HOMEPATH%');

        cd([pre_str homedir(1:end-1)]);
        system(['dir ' str_file ' /s /p']);
        cd(curdir);
    end
end
end
