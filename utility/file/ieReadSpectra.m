function [res,wave,comment,partialName] = ieReadSpectra(fname,wave,extrapVal)
% Read in spectral data and interpolate to the specified wavelengths
%
%      [res,wave,comment,fName] = ieReadSpectra(fname,wave,extrapVal)
%
%   Spectral data are stored in files that include both the sampled data
%   and the wavelength values.  This routine reads the stored values and
%   returns them interpolated or extrapolated to the values in parameter
%   WAVE.  Also see ieReadColorFilter.
%
%   The spectral files are created by ieSaveSpectralFile, and the format is
%   determined by that function.
%
%   ISET spectral files are generally saved in the form: save(fname,'data','wavelength')
%   and most have comment fields:                        save(fname,'data','wavelength','comment')
%   
%   If the FNAME file does not exist, the return variable, res, is empty on return.
%   If wave is specified, the returned data are interpolated to those values.
%   If wave is not specified, the data are returned at native resolution of the data file 
%      and the values of wavelength can be returned.
%
%   IMPORTANT: Color filters are handled a little differently because we
%   also store their names. See the functions ieReadColorFilter and
%   ieSaveColorFilter
%
% If you are reading a color filter, you should probably use
% ieReadColorFilter rather than this routine
%
% Copyright ImagEval Consultants, LLC, 2005.

% Examples:
%{
  fileName = 'XYZQuanta.mat';
  wave = 400:10:700;
  data = ieReadSpectra(fileName,wave)
  [data,wave] = ieReadSpectra(fileName)
%}

if ieNotDefined('fname'), fname = ''; end

% Create a partialpath for this file name.  For this to work, we need to
% keep all of the spectral data in a single directory, I am afraid.
if isempty(fname)
    fname = vcSelectDataFile('');
    if isempty(fname), disp('User canceled'); return; end
end

% Load in spectral data
tmp = load(fname);
if isfield(tmp,'data'), data = tmp.data; else, data = []; end
if isfield(tmp,'wavelength'), wavelength = tmp.wavelength; else, wavelength = []; end
if isfield(tmp,'comment'), comment = tmp.comment; else, comment = []; end
if length(wavelength) ~= size(data,1)
    error('Mis-match between wavelength and data variables in %s',fname);
end

% If wave was not sent in, return the native resolution in the file.  No
% interpolation will occur.
if ieNotDefined('wave'),  wave = wavelength; end
if ieNotDefined('extrapVal'),  extrapVal = 0;  end

res = interp1(wavelength(:), data, wave(:),'linear',extrapVal);
    
end
