function varargout = readEELSdata(fullpathname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Input: (OPTIONAL)
%       fullpathname = 'C:\x\y\z.dm3'
%       fullpathname = No input or []
%
%   Output:(DEFAULT = EELS)
%       EELS = EELS data structure
%       si_struct = All data in structure format
%       (No output argument) = plotEELS(EELS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% The routine construct a structure datatype _EELS_ which contains all the
% required fields for EELS analysis. The data is read from a .dm3 file
% format of Gatan Digital Micrograph.

%% Select .dm3 file from the folder.
% If no input argument then use _uigetfile_ to open an file selector and
% select a _.dm3_ file. A _.dm3_ file could be a spectrum image or a single
% spectrum. If the file is not present then select _cancel_ from the file
% selector window. This will send an error message in the command window.
% If the file is present, then path name of the selected file will be
% assigned to _EELS.Fullpathname_. A _fullpathname_ can be passed as an
% input argument. The _fullpathname_ is assigned to _EELS.Fullpathname_.
%%
if(nargin<1)
    [filename, pathname] = uigetfile({'*.*',  'All Files (*.*)' ;...
        '*.dm3', '.dm3 files (*.dm3)';...
        '*.msa', '.msa files (*.msa)';...
        '*.mat', '.mat files (*.mat)';...
        '*.hdf5','.hdf5 files (*.hdf5)';...
        '*.hspy','.hspy files (*.hspy)';...
        '*.dm4', '.dm4 files (*.dm4)'},...
        'Pick a file');
    if isequal(filename,0) || isequal(pathname,0)
        error('User pressed cancel')
    else
        Fullpathname = strcat(pathname,filename);
    end
else
    Fullpathname = fullpathname;
end

[~,~,ext] = fileparts(Fullpathname);
if strcmpi(ext,'.dm3') || strcmpi(ext,'.dm4')
    
    %% Read spectrum data from .dm3 file
    % The _.dm3_ file is read using _DM3Import.m_ routine. The routine is written
    % by <http://www.mathworks.com/matlabcentral/fileexchange/29351-dm3-import-for-gatan-digital-micrograph Robert McLeod>.
    %%
    si_struct=DM3Import(Fullpathname);
    EELS.Fullpathname = Fullpathname;
    %%
    % All the data fields from dturcture _si_struct_ are reassigned in the data
    % structure _EELS_. The _si_struct_ can be used independently. The
    % orientation of the data correspends to $(X,Y)$ cartesian axis. The SI
    % field in _EELS_ structure will have image indexing $(row,column)$.
    % Increase in $X$-coordinates correspends to increase in $column$ and
    % increase in $Y$-coordinates corresponds to increase in $row$. Spectrum
    % image will be treated as an image rather than points scattered in
    % $(X,Y)$-coordinates.
    
    %% Create an EELS structure from si_struct
    % * The presence of _image_data_ and _zaxis_ fields in _si_struct_
    % corresponds to the presence of EELS spectrum image. It will be asigned to
    % the field _EELS.SImage_. The data from _si_struct.image_data_ are in the
    % cartesian format. use _reshape_ and _permute_ functions of matlab to swap
    % the $X$ and $Y$-coordinates which now corrsponds to $row$ and $column$.
    % * The presence of _image_data_, _xaxis, _yaxis_ and no _zaxis_ in
    % _si_struct_ corresponds to the presence of overview image or survey
    % image. It could be dark field (DF) or bright field (BF) image.
    % * The presence of _image_data_ and only _xaxis_ field in _si_struct_
    % corrsponds to the presence of single spectrum.
    % * The presence of _spectra_data_ field in _si_struct_ correspends to
    % single spectrum. This type of spectra are found in EELS atlas reference
    % spectrum in Gatan Digital Micrograph.
    % * The presence of only _xaxis_ field in _si_struct_ corresponds to a
    % single spectrum.
    % * For spectrum image the dispersion is mapped directly from
    % _si_struct.zaxis.origin_ to _EELS.dispersion_ and for single spectrum the
    % _si_struct.xaxis.origin_ to _EELS.dispersion_.
    % * If the probe step size $<0.1 \mu m$ use $nm$ scale.
    % * Read convergence ($\alpha$) and collection angle ($\beta$). While
    % saving the _.dm3_ file in Gatan Digital Micrograph, if the $\alpha$ and
    % $\beta$ are were not specified then the values will be dummy. User need to
    % assign $\alpha$ and $\beta$ saperately in the code.
    % * The number of channels are defined as same length as the spectrum. The
    % energy-loss axis is calibrated from start of the spectra which is not
    % channel number 1 (approx channel 100 for JEOL 2010F @sheffield) and the
    % dispersion will be acounted by multiplying the channels by dispersion.
    % * The dimensions of the spectrum image will be present in the field
    % _SI_x_ (no. of rows), _SI_y_ (no. of columns) and _SI_z_ (length of
    % spectrum). The dimensions of survey image will be present in _Image_x_
    % (no. of rows) and _Image_y_ (no. of columns).
    % If none of the fields described above are present the the routine shows an
    % error message.
    %%
    if(isfield(si_struct,'image_data'))
        %EELS.data=si_struct.image_data;
        if(isfield(si_struct,'zaxis'))
            % Read SI_x, SI_y and SI_z size
            [EELS.SI_y,EELS.SI_x,EELS.SI_z] = size(si_struct.image_data);
            EELS.SImage = permute(reshape(si_struct.image_data,...
                EELS.SI_x,EELS.SI_y,EELS.SI_z),...
                [2,1,3]);
            [EELS.SI_x,EELS.SI_y,EELS.SI_z] = size(EELS.SImage);
            % SImage anonymous functions
            EELS.S = @(SI_x,SI_y) squeeze(EELS.SImage(SI_x,SI_y,:));
            % Read Dispersion information
            EELS.dispersion = si_struct.zaxis.scale;
            % Calibrate energy_loss_axis of the spectrum
            channels = (0:EELS.SI_z-1);
            EELS.energy_loss_axis=((channels-si_struct.zaxis.origin)*EELS.dispersion)';
            % Spectrum offset
            if EELS.energy_loss_axis(1) > 0
                EELS.offset_eV = EELS.energy_loss_axis(1);
            else
                EELS.offset_eV = 0;
            end
            % Voltage kV
            EELS.E0_eV = si_struct.voltage_kV;
            % Exposure time (sec)
            % This reading is not coded to read from .dm3 file and has to
            % be put manually while quantifying.
            EELS.exposure_time_sec = [];
            % Read step size and units
            if(si_struct.xaxis.scale < 0.1)
                EELS.step_size.x = si_struct.xaxis.scale*1000;
                EELS.step_size.xunit = 'nm';
            else
                EELS.step_size.x = si_struct.xaxis.scale;
                EELS.step_size.xunit = si_struct.xaxis.units;
            end
            if(si_struct.yaxis.scale < 0.1)
                EELS.step_size.y = si_struct.yaxis.scale*1000;
                EELS.step_size.yunit = 'nm';
            else
                EELS.step_size.y = si_struct.yaxis.scale;
                EELS.step_size.yunit = si_struct.yaxis.units;
            end
            % Define probe size
            EELS.probe_size_nm = 0;
            % Define Convergence and Collection angle
            EELS.conv_angle_mrad = si_struct.conv_angle_mrad;
            EELS.coll_angle_mrad = si_struct.coll_angle_mrad;
            % Read Magnification
            if isfield(si_struct,'mag')
                EELS.mag = si_struct.mag;
            end
        elseif(isfield(si_struct,'xaxis') && isfield(si_struct,'yaxis'))
            % Read Image
            EELS.Image=si_struct.image_data;
            % Read Image_x and Image_y size
            [EELS.Image_x,EELS.Image_y] = size(EELS.Image);
            % Read scale and units
            %if(si_struct.xaxis.scale < 0.1)
            %    EELS.scale.x = si_struct.xaxis.scale*1000;
            %    EELS.scale.xunit = 'nm';
            %else
            EELS.scale.x = si_struct.xaxis.scale;
            EELS.scale.xunit = si_struct.xaxis.units;
            %end
            %if(si_struct.yaxis.scale < 0.1)
            %    EELS.scale.y = si_struct.yaxis.scale*1000;
            %    EELS.scale.yunit = 'nm';
            %else
            EELS.scale.y = si_struct.yaxis.scale;
            EELS.scale.yunit = si_struct.yaxis.units;
            %end
            % Read Magnification
            if isfield(si_struct,'mag')
                EELS.mag = si_struct.mag;
            end
            if isfield(si_struct,'conv_angle_mrad')
                EELS.conv_angle_mrad = si_struct.conv_angle_mrad;
            end
            if isfield(si_struct,'coll_angle_mrad')
                EELS.coll_angle_mrad = si_struct.coll_angle_mrad;
            end
        elseif(isfield(si_struct,'xaxis'))
            % Read spectrum
            if iscolumn(si_struct.image_data)
                EELS.spectrum = si_struct.image_data;
            else
                EELS.spectrum = si_struct.image_data';
            end
            % Read Dispersion information
            EELS.dispersion=si_struct.xaxis.scale;
            % Calibrate energy_loss_axis of the spectrum
            channels=(0:length(EELS.spectrum)-1);
            EELS.energy_loss_axis=((channels-si_struct.xaxis.origin)*EELS.dispersion)';
            % Read Magnification
            if isfield(si_struct,'mag')
                EELS.mag = si_struct.mag;
            end
        end
    elseif(isfield(si_struct,'spectra_data'))
        % Read spectrum
        if(iscolumn(si_struct.spectra_data{1,1}))
            EELS.spectrum=si_struct.spectra_data{1,1};
        else
            EELS.spectrum=si_struct.spectra_data{1,1}';
        end
        if(isfield(si_struct,'xaxis'))
            % Read Dispersion information
            EELS.dispersion=si_struct.xaxis.scale;
            % Define number of channels
            channels=(0:length(si_struct.spectra_data{1,1})-1);
            % Calibrate energy_loss_axis of the spectrum
            EELS.energy_loss_axis=((channels-si_struct.xaxis.origin)*EELS.dispersion)';
        end
    else
        error('Not a valid file');
    end
    
    % Call EELS output management function.
    if nargout < 1
        manage_output_arguments(nargout, EELS);
    elseif nargout < 2
        EELS = manage_output_arguments(nargout, EELS);
        varargout{1} = EELS;
    else
        [EELS,si_struct] = manage_output_arguments(nargout, EELS, si_struct);
        varargout{1} = EELS;
        varargout{2} = si_struct;
    end
    
elseif strcmpi(ext,'.msa')
    EELS = MSAImport(Fullpathname);
    EELS.Fullpathname = Fullpathname;
    % Call EELS output management function.
    if nargout < 1
        manage_output_arguments(nargout, EELS);
    else
        EELS = manage_output_arguments(nargout, EELS);
        varargout{1} = EELS;
    end
    
elseif strcmpi(ext,'.mat')
    load_data = load(Fullpathname);
    if isfield(load_data,'EELS')
        varargout{1} = load_data.EELS;
    else
        varargout{1} = load_data;
        whos('-file',Fullpathname);
    end
    
elseif strcmpi(ext,'.hdf5') || strcmpi(ext,'.hspy')
    [data, ax_scales, ax_units, ~, ~, ax_offsets, ~] = readHyperSpyH5(Fullpathname);
    EELS.SImage = permute(data,[2 1 3]);
    % Read SI_x, SI_y and SI_z size
    [EELS.SI_x,EELS.SI_y,EELS.SI_z] = size(EELS.SImage);
    % SImage anonymous functions
    EELS.S = @(SI_x,SI_y) squeeze(EELS.SImage(SI_x,SI_y,:));
    % Read Dispersion information
    EELS.dispersion = ax_scales(3);
    % Calibrate energy_loss_axis of the spectrum
    channels = (0:EELS.SI_z-1)';
    EELS.energy_loss_axis = channels*ax_scales(3)-ax_offsets(3);
    % Spectrum offset
    if EELS.energy_loss_axis(1) > 0
        EELS.offset_eV = EELS.energy_loss_axis(1);
    else
        EELS.offset_eV = 0;
    end
    % Voltage kV
    EELS.E0_eV = [];
    % Exposure time (sec)
    % This reading is not coded to read from .dm3 file and has to
    % be put manually while quantifying.
    EELS.exposure_time_sec = [];
    % Read step size and units
    if(ax_scales(2) < 0.1)
        EELS.step_size.x = ax_scales(2)*1000;
        switch cell2mat(ax_units{2})
            case {'nm','nano'}
                EELS.step_size.xunit = 'µm';
            case {'µm','um','micro','micron'}
                EELS.step_size.xunit = 'mm';
            case {'mm','milli'}
                EELS.step_size.xunit = 'm';
            otherwise
                EELS.step_size.xunit = [];
        end
    else
        EELS.step_size.x = ax_scales(2);
        EELS.step_size.xunit = cell2mat(ax_units{2});
    end
    if(ax_scales(1) < 0.1)
        EELS.step_size.y = ax_scales(1)*1000;
        switch cell2mat(ax_units{1})
            case {'nm','nano'}
                EELS.step_size.yunit = 'µm';
            case {'µm','um','micro','micron'}
                EELS.step_size.yunit = 'mm';
            case {'mm','milli'}
                EELS.step_size.yunit = 'm';
            otherwise
                EELS.step_size.yunit = [];
        end
    else
        EELS.step_size.y = ax_scales(1);
        EELS.step_size.yunit = cell2mat(ax_units{1});
    end
    % Define probe size
    EELS.probe_size_nm = [];
    % Define Convergence and Collection angle
    EELS.conv_angle_mrad = [];
    EELS.coll_angle_mrad = [];
    % Read Magnification
    EELS.mag = [];
    
    % Call EELS output management function.
    if nargout < 1
        manage_output_arguments(nargout, EELS);
    elseif nargout < 2
        EELS = manage_output_arguments(nargout, EELS);
        varargout{1} = EELS;
    else
        [EELS,si_struct] = manage_output_arguments(nargout, EELS, si_struct);
        varargout{1} = EELS;
        varargout{2} = si_struct;
    end
end

function varargout = manage_output_arguments(num_out_arg, EELS, si_struct)

%% Manage output arguments
% There can be up to two output argument. The primary output argument is
% _EELS_ structure and secondary is _si_struct_ from _DM3Import.m_. If no
% output arguments present then plot EELS.
%%
if num_out_arg < 1
    plotEELS(EELS);
elseif num_out_arg < 2
    varargout{1} = EELS;
elseif strcmpi(ext,'.dm3') && nargout > 1
    varargout = {EELS,si_struct};
end

%% Display EELS
% Display the _EELS_ structure tree.

%%
if num_out_arg > 0
    strucdisp(varargout{1});
end