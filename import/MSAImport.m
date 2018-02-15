function varargout = MSAImport(filename)


if nargin<1
%    filename = 'eelsdb/APL_article_interface_oxygen2.msa';
    filename = 'eelsdb/Dspec.1220441.1.msa';
%    filename = 'C:\Users\elp13va.VIE\Downloads\Dspec.56364.13.msa';
%    filename = 'C:\Users\elp13va.VIE\Downloads\Dspec.530614.13.msa';
end

%% Open .msa file
fileID = fopen(filename);

%% Extract Spectrum
frewind(fileID)
% 
t = textscan(fileID,'%s %s',...
            'Delimiter',':','EmptyValue',-Inf);

%
S_start = find(not(cellfun('isempty', regexpi(t{1},'#spectrum'))))+1; %Spectrum data starts from next line. Hence '+1'
S_end = find(not(cellfun('isempty', regexpi(t{1},'#end*\w'))))-1;
if ~isempty(S_start) && ~isempty(S_end)
    S = cell2mat(arrayfun(@(ii) eval(['[',t{1}{ii},']']), S_start:S_end,'UniformOutput',false)');
    EELS.energy_loss_axis = S(:,1);      % Energy-loss axis
    EELS.spectrum = S(:,2);              % Spectrum
    EELS.dispersion = mean(diff(S(:,1)));% Dispersion
end
%% BeamKV
frewind(fileID)

%
beam_idx = not(cellfun('isempty', regexpi(t{1},'#beam*\w')));
if sum(beam_idx)>0
    EELS.beamKV = str2double(t{2}{beam_idx});
end

%% Close file
frewind(fileID);
fclose(fileID);

if nargout<1
    plotEELS(EELS.energy_loss_axis,EELS.spectrum)
else
    varargout{1} = EELS;
end