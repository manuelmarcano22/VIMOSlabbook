---
layout: post
title: "Apall"
categories: [log]
tags: [data, spectra,apall, vimx, dbus,iraf, pyraf,SEXM,SRFM]
---


## Dbus

I was having problems with matplotlib. It was a problem with the dbus. I found the solution [here](http://www.torkwrench.com/2012/12/16/d-bus-library-appears-to-be-incorrectly-set-up-failed-to-read-machine-uuid-failed-to-open-varlibdbusmachine-id/). It was doing:

```
root@container#dbus-uuidgen >/etc/machine-id
```
For some people it was 

`
dbus-uuidgen > /var/lib/dbus/machine-id
`

In some places it said to start the docker image with the `-net=host` option but I didn't have to do this to make it work. 


## vim and vimx

I installed `vim-x11` and `vim-enhanced` in the docker image to be able to support pasting from the terminal to and from vim. When I need it I need to do `vimx` instead of just `vim`. I might put an alias in the .bashrc.

`alias vim='vimx'`

## Apall

To use apall in pyraf do:

```
noao
twodspec
apextract
```

I was having a problem before to extract the spectrum. I had to do `epar apextract` and change the **dispersion axis** to **1** or along the lines and not column. Then need to select the apertures and fit the trace function. For example for the trace can do `:or` and then the order of the polynomial to fit.  

It then produces a file with extension **.ms.fits**. You can plot it with *splot* and it will plot with pixels in the x axis. You will have a file with various line, one for each aperture. For example to plot one spectrum do:

`splot file.ms.fits[*,1]`

where the number represent like in the SRFM file the file and represent each aperture.  

To normalize it maybe use the [continuum](http://stsdas.stsci.edu/cgi-bin/gethelp.cgi?continuum) function from the noao and onedspec package. 

All the apertures are safe in the log file under the folder called *database*

#### Useful Apall refences

- [Durham Postgraduate Data Reduction Course](http://astro.dur.ac.uk/~cpnc25/pg_dr_spectroscopy.html)
- [IRAF spectroscopy Documentation](http://iraf.noao.edu/docs/spectra.html)
- [VI. Basic Reductions for Spectroscopic Data](http://www.twilightlandscapes.com/IRAFtutorial/IRAFintro_06.html)

## Response

After I extract and identify the relevant source, I can response correct the spectra. I can do it following the directions in the page [VIMOS response curves and flux calibration](http://www.eso.org/observing/dfo/quality/VIMOS/qc/response.html). 

It comes in a table with 7 fields. Only the first (wave) and 7 (response) are relevant. 

For example for CX25 the relevant information to decide what response curve to use is:

- GRISM: **MR** from *GRIS4 NAME* in the SSEm header 
- Filter name: **GG475** from *FILT4 NAME* in the SSEM header
- Quadrant: **4** from *OCS CON QUAD* in the SSEM header

so in this case according to the observing date:

```
resp = fits.open('VI_GRSM_101001A_GG475_MR_Q4.fits')
wave = np.array([ resp[1].data[i][0] for i in np.arange(resp[1].data.shape[0]) ])
response = np.array([ resp[1].data[i][6] for i in np.arange(resp[1].data.shape[0]) ])

```
It looks like this:

![Response for MR and Quandrant 4]({{site.baseurl}}/images/MR_Q4_resp.png)

Then as it is stated in the website apply to the spectrum:


> Usage: Master response curves R_mst can be applied by hand to extracted spectra with the following procedure:
> F_obs = R_mst * f_raw * 10**(0.4 * airmass * extinction)

In the header there is a line called `HIERARCH ESO TEL AIRM START = 1.082 / Airmass at start` and here it mentions some extinction coefficients for different pediods for each filters and quadrants. [Colour terms and extinction coefficients](http://www.eso.org/observing/dfo/quality/VIMOS/qc/zeropoints.html)

#### Failed attempt

I tried to used python to reduce the spectra by averaging the data. Something like the following. I will better learn to do it the "right way" with IRAF.

fits.writeto('newcx25.fits',original[0].data[30:180,:] ,original[0].header)

```python
#!/usr/bin/python2

from astropy.io import fits
import numpy as np

ssem = fits.open('VI_SSEM_575273_2011-05-26T05:19:50.824_G475_MR_202166_Q2_hi.fits')
header1 = ssem[0].header
header1['NAXIS2'] = 1

fits.writeto('lastmedian.fits', np.median(ssem[0].data, axis=0)  ,header1)          
mediannorm = [ i/np.max(ssem[0].data) for i in np.median(ssem[0].data,axis=0)]  
fits.writeto('lastmediannorm.fits', mediannorm  ,header1)
```

![SRFM vs SSEM]({{site.baseurl}}/images/cx59both.png)

