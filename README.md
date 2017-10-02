# EELS_Matlab

Contain all the files related to EELS analysis using matlab.

Note: The files are not well organised.

### Import EELS data into `EELSAnalyser`

```MATLAB
EELS = readEELSdata('/path/to/file');
```
The supported files are `.dm3`, `.msa`, `.mat`, `.hdf5`, `.hspy`. The `.hdf5` and `.hspy` are data exported from Hyperspy. This makes it flexible to work with Gatan DigitalMicrograph and Hyperspy.
`readEELSdata()` is combines the codes written by [Robert McLeod](https://uk.mathworks.com/matlabcentral/fileexchange/29351-dm3-import-for-gatan-digital-micrograph) (for `.dm3` format)
```MATLAB
si_struct=DM3Import('/path/to/file');
```
and [Joshua Taillon](https://github.com/jat255/readHyperSpyH5) (for `.hdf5` and `.hspy`)
```MATLAB
[data, ax_scales, ax_units, ax_names, ax_sizes, ax_offsets, ax_navigates] = readHyperSpyH5('/path/to/file');
```
`EELS` data could be spectrum image (SI), annular dark field (ADF) image or a singe spectrum. The `EELS` data structure from `readEELSdata()` contains following fields:
```MATLAB
EELS
|
|-Fullpathname : '/path/to/file.ext'
|-E0_eV : [ ]
|-exposure_time_sec : [ ]
|-SI_y : [ ]
|-SI_x : [ ]
|-SI_z : [ ]
|-SImage : [ ] % 3-D Array
|-dispersion : [ ]
|-offset_eV : [ ]
|-probe_size_nm : [ ]
|-conv_angle_mrad : [ ]
|-coll_angle_mrad : [ ]
|-mag : [ ]
|-energy_loss_axis : [ ]
|-S : [1x1 Unknown]
|-step_size
0   |
    |-xunit : ' '
    |-yunit : ' '
    |-x : [ ]
    |-y : [ ]
    0
```
