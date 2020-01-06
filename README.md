# `EELSAnalyser`

**Note1: Please contact [Veer.Angadi@brunel.ac.uk](mailto:Veer.Angadi@brunel.ac.uk) for information and usage. Thanks.**

**Note2: If this package is used please cite `Angadi, V. C. et al (2016)` [DOI: 10.1111/jmi.12397](https://onlinelibrary.wiley.com/doi/full/10.1111/jmi.12397).**

**Note3: The documentation is not complete. It has basic import, visualising EELS and quantification through background subtraction.**

## Table of Contents
**[Import EELS data into `EELSAnalyser`](#import-eels-data-into-eelsanalyser)**<br>
**[Visualization of Spectrum Image in  `EELSAnalyser`](#visualization-of-spectrum-image-in--eelsanalyser)**<br>
**[Quantification of EELS Spectrum Image](#quantification-of-eels-spectrum-image)**<br>

## Import EELS data into `EELSAnalyser`

```MATLAB
EELS = readEELSdata('/path/to/file');
```
The supported files are `.dm3`, `.msa`, `.mat`, `.hdf5`, `.hspy`. The `.hdf5` and `.hspy` are data exported from [Hyperspy](http://hyperspy.org/). This makes it flexible to work with Gatan's [DigitalMicrograph](http://www.gatan.com/products/tem-analysis/gatan-microscopy-suite-software) and [Hyperspy](http://hyperspy.org/).
`readEELSdata()` is combines the codes written by [Robert McLeod](https://uk.mathworks.com/matlabcentral/fileexchange/29351-dm3-import-for-gatan-digital-micrograph) (for `.dm3` format)
```MATLAB
si_struct = DM3Import('/path/to/file');
```
and [Joshua Taillon](https://github.com/jat255/readHyperSpyH5) (for `.hdf5` and `.hspy`)
```MATLAB
[data, ax_scales, ax_units, ax_names, ax_sizes, ax_offsets, ax_navigates] = readHyperSpyH5('/path/to/file');
```
`EELS` data could be spectrum image (SI), annular dark field (ADF) image or a singe spectrum. The `EELS` data structure from `readEELSdata()` contains following fields:
* EELS Spectrum Image (3-D Spectrum Image)

```MATLAB
EELS
|
|------Fullpathname : '/path/to/file.ext'
|-------------E0_eV : [ ]
|-exposure_time_sec : [ ]
|--------------SI_y : [ ]
|--------------SI_x : [ ]
|--------------SI_z : [ ]
|------------SImage : [ ] % 3-D Array
|--------dispersion : [ ]
|---------offset_eV : [ ]
|-----probe_size_nm : [ ]
|---conv_angle_mrad : [ ]
|---coll_angle_mrad : [ ]
|---------------mag : [ ]
|--energy_loss_axis : [ ]
|-----------------S : [1x1 Unknown]
|-step_size
0   |
    |--xunit : ' '
    |--yunit : ' '
    |------x : [ ]
    |------y : [ ]
    0
```

* EELS Image (2-D Image)
```MATLAB
EELS
|
|--Fullpathname : '/path/to/file.ext'
|-------Image_y : [ ]
|-------Image_x : [ ]
|---------Image : [ ] % 2-D Array
|-scale
0   |
    |--xunit : ' '
    |--yunit : ' '
    |------x : [ ]
    |------y : [ ]
    0
```
* EELS Spectrum (1-D Spectrum)

```MATLAB
EELS
|
|------Fullpathname : '/path/to/file.ext'
|--------dispersion : [ ]
|----------spectrum : [ ] % 1-D Array
|--energy_loss_axis : [ ]
0   
```
## Visualization of Spectrum Image in  `EELSAnalyser`
The visualization of EELS SI is inspired by Hyperspy. [link](http://hyperspy.org/hyperspy-doc/current/user_guide/visualisation.html). The command in `EELSAnalyser` for plotting EELS data is

```MATLAB
plotEELS(EELS)
```
Simply plots the EELS data irrespective of whether the data is EELS SI, Image or a spectrum.

![SImage](images/SImage.png?raw=true)

```MATLAB
plotEELS(EELS, 'stem')
```
plots only the image of EELS SI by integrating the spectrum.

```MATLAB
plotEELS(I, 'map')
```
Elemental map `I` can be visualised as an image. The colour maps can be changed as per the standard MATLAB documentation for e.g. `colormap jet` or `colormap gray`. The limits of colormaps can be changed using command `colormapeditor` in the command window of MATLAB.

The additional advantage of visualizing EELS SI in `EELSAnalyser` is that there are navigational advantages using arrow keys. The location of the spectrum being displayed is the red box on the image. Use following keys to navigate <kbd>up</kbd>, <kbd>down</kbd>, <kbd>left</kbd>, <kbd>right</kbd>, <kbd>home</kbd>, <kbd>end</kbd>, <kbd>page up</kbd>, <kbd>page down</kbd>. Use <kbd>escape</kbd> key to close the image object.

The spectrum axes can be put on hold to observe a particular energy-loss axis range in the spectrum.

* Press <kbd>x</kbd> to hold the energy_loss_axis. This makes sure the energy_loss_axis limits will remain same even after navigating to different locations in the SI.

* Similarly, Press <kbd>y</kbd> to hold the count axis.

```MATLAB
l = EELS.energy_loss_axis;
% Squeeze spectrum from EELS SI data cube
S = squeeze(EELS.SImage(10,20,:));
% Or simply use EELS.S(ii,jj) anonymous function to extract spectrum
S = EELS.S(10,20);
plotEELS(l,S)
```
## Quantification of EELS Spectrum Image
EELS spectrum image can be quantified using background subtraction method. The `stem_map_back_sub()` uses parallel computing toolbox from MATLAB to get the elemental maps.
```MATLAB
Map = stem_map_back_sub(EELS,...
                        model_begin_eV, model_end_eV,...
                        edge_onset_eV, delta_eV,...
                        background_model_options);
```
The inputs for `stem_map_back_sub()` are:
* `EELS` EELS structure obtained from `readEELSdata()`
* `model_begin_eV` background model begin in `eV`.
* `model_end_eV` background model end in `eV`.
* `edge_onset_eV` Ionization edge onset value.
* `delta_eV` Integration range in `eV`.
* `background_model_options` Options such as `'pow'`, `'exp1'` or `'exp2'`. Default is inverse power-law function, `'pow'`. `'exp1'` and `'exp2'` are one and two exponential decay functions respectively.
