function save_file_mat(obj,event)

global geo_method booleen plot_state handles Nmc Nbi data FileName

global M_est T_MMSE A_est handles   

disp('save_file_mat')

if isempty(M_est)
    disp('Error while attempting to save')
    return
end

   
    

[filename, pathname] = uiputfile('*.mat', 'Save File as');

if (filename == 0) %dans le cas où l'on décide d'annuler la sélection
    
    return;

else
    
save([pathname filename],'M_est','A_est')


%% LOG
filename=filename(1,1:(end-4));
log=['Realized with ' int2str(Nmc) ' iterations via ' geo_method ' with ' int2str(Nbi) ' burn-in points.']
%ouvre un fichier ou le créé
fid = fopen([pathname filename '_log.txt'],'w');
%écrit dans ce fichier, fid est sa reference pour matlab
fprintf(fid,log);
fclose(fid);        %on ferme le fichier




disp([filename ' saved'])

end
end