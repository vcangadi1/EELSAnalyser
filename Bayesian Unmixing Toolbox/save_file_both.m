function save_file_both(obj,event)

global geo_method booleen plot_state handles Nmc Nbi data FileName

global M_est T_MMSE A_est handles   

disp('save_file_both')

%%%Error test
if isempty(M_est)
disp('Error while attempting to save')
return
end
    
%% Spectra saving

[sfilename, pathname] = uiputfile('*.txt', 'Save spectra file as');

if (sfilename == 0) %dans le cas où l'on décide d'annuler la sélection
    
    return;
    
else

[r c]=size(M_est);

%ouvre un fichier ou le créé
fid = fopen([pathname sfilename],'w');
%écrit dans ce fichier, fid est sa reference pour matlab
i=1;
j=1;

while i<=r
    while j<c
        fprintf(fid,'%f\t',M_est(i,j));
        j=j+1;
    end
    fprintf(fid,'%f\n',M_est(i,j));
    i=i+1;
    j=1;
end

fclose(fid);        %on ferme le fichier

end
%% Abundance saving


[afilename, pathname] = uiputfile('*.txt', 'Save unmixing coefficients as');

if (afilename == 0) %dans le cas où l'on décide d'annuler la sélection
    
    return;
    
else

[r c]=size(A_est);

%ouvre un fichier ou le créé
fid = fopen([pathname afilename],'w');
%écrit dans ce fichier, fid est sa reference pour matlab
i=1;
j=1;

while i<=r
    while j<c
        fprintf(fid,'%f\t',A_est(i,j));
        j=j+1;
    end
    fprintf(fid,'%f\n',A_est(i,j));
    i=i+1;
    j=1;
end

fclose(fid);        %on ferme le fichier
end

%% LOG
sfilename=sfilename(1,1:(end-4));
afilename=afilename(1,1:(end-4));
log=[int2str(R) 'sources unmixed ' 'realized with ' int2str(Nmc) ' iterations via ' geo_method ' with ' int2str(Nbi) ' burn-in points.']
%ouvre un fichier ou le créé
fid = fopen([pathname sfilename '_' afilename '_log.txt'],'w');
%écrit dans ce fichier, fid est sa reference pour matlab
fprintf(fid,log);
fclose(fid);        %on ferme le fichier


disp('Files saved')
end