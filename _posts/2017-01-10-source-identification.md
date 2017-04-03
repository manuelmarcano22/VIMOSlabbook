---
layout: post
title: "Apall"
categories: [log]
tags: [data, spectra,apall, vimx, dbus,iraf, pyraf,SEXM,SRFM]
---


## Conda

To run pyraf you need to activate the conda enviroment called iraf27. 

To list enviroments do:

`conda env list`

The one with pyraf installed is iraf27. To use it then do: `source activate iraf27`


This is using [astroconda](https://astroconda.readthedocs.io/en/latest/). It has python 2.7 with pyraf installed. 

### Pyraf

I was getting the error `IrafError: "Undefined variable uparm' in string ..."`. This is 2.10 in the [pyraff_faq](http://www.stsci.edu/institute/software_hardware/pyraf/pyraf_faq). This got solve by running mkiraf and selecting xterm. This will change from system to system. So at each folder of the differnet sources might need to do mkiraf.  


## Creating the region files

To try to identify the souces I need to create a region file to use with the preimages.  The script **fits2slit.csh** by Dr. Torres is written in csh shell. I will translate to Python 2.7. Python 2.7 since pyraf still doesnt have full suppor twith python 3. 

>To make the region files we need both the pre-images and the spectra. The reason is that the fits headers for the spectra contain the the slit definitions in MASK coordinates while the the pre images contain the transformation coefficients to convert from mask to CCD coordinates. Details on these transformations can be found in [http://www.eso.org/observing/dfo/quality/VIMOS/qc/mask2ccd_qc1.html](http://www.eso.org/observing/dfo/quality/VIMOS/qc/mask2ccd_qc1.html)

### fits2slit.py

I finished translating the .csh scrip to Python 2. 


## Apall

I will have to use the routine apall to extract the spectra. The SRFM given by the pipeline is just a tool to have an idea about the general shape or trend since this ones are response rectified. The flux calibration is not to trust since in this case the sources might not be in the right place of the slit like the standard star was. The best is to normalize the spectra. Also for the SRFM maybe the star is saturated. Saturated if the count is more than about 50 000. This is of course after I multiply the 2D spectra by the integration time. If they are saturated take the wings of the spectra. For example CX25 is saturated. So just center the aperture around the wings without including the peak, and don't fit the trace or recenter the apertures.    

Like mentioned before since the 2D spectra are in count rates (counts/second). So you need to multiply (imarith) the data by the integration time before extracting the spectrum. This is very important as IRAF uses the SNR ratio to weight the extracted signal. This is crucial for not so bright sources. The sources I am working with should be bright enough and should be a problem but just in case I need to multiply it before running apall. 

Also it is important to remember that for this project I would use the images with the sky lines. This is because IRAF would make a better job, maybe, to identidfy skylines. So use the SEXM and the ones called `mos_science_sky_extracted`. 

To identify the sources in the preimage how the preimage and 2D data are related should be constant from year to year. So if the source in the preimage one year looks to be in the left border, this means it is in the bottom of the 2D data. 

In the epar  of apall also might want to change the line and nsum parameter. The dispersion line (line or column perpendicular to the dispersion axis) and number of adjacent lines (half before and half after unless at the end of the image) used in finding, recentering, resizing, and editing operations. A line of INDEF selects the middle of the image along the dispersion axis. A positive nsum selects a sum of lines and a negative selects a median of lines. You might want to play with this since a star might be saturated in the red and not in the blue for example. 

To use apall in pyraf do:

```
noao
twodspec
apextract
```

I was having a problem before to extract the spectrum. I had to do `epar apextract` and change the **dispersion axis** to **1** or along the lines and not column. Then need to select the apertures and fit the trace function. Since the spectra is rectified I should net a ordr of the polynomial more than 3 and 2 should be enough. For example for the trace can do `:or` and then the order of the polynomial to fit.  

It then produces a file with extension **.ms.fits**. You can plot it with *splot* and it will plot with pixels in the x axis. You will have a file with various line, one for each aperture. For example to plot one spectrum do:

`splot file.ms.fits[*,1]`

where the number represent like in the SRFM file the file and represent each aperture.  

To normalize it maybe use the [continuum](http://stsdas.stsci.edu/cgi-bin/gethelp.cgi?continuum) function from the noao and onedspec package. 

All the apertures are safe in the log file under the folder called *database*

### Apertures

In this database files the apertures will be saved. For example:

```
begin	aperture copy_mos_science_sky_extracted_Q3 2 1250. 48.08994
	image	copy_mos_science_sky_extracted_Q3
	aperture	2
	beam	2
	center	1250. 48.08994
	low	-1249. -5.
	high	1250. 5.
```

The last two lines tells you the width of the apertures. These are IRAF default values. These are the limits relative to the aperture center. This values will change if it is saturated (more than 50 000 counts). Then I will need to not center the aperture, or just include the left or right wings. If these limits are changed to exclude the peak and include only the wings then don't do the trace fit. 

#### Useful Apall refences

- [Durham Postgraduate Data Reduction Course](http://astro.dur.ac.uk/~cpnc25/pg_dr_spectroscopy.html)
- [IRAF spectroscopy Documentation](http://iraf.noao.edu/docs/spectra.html)
- [VI. Basic Reductions for Spectroscopic Data](http://www.twilightlandscapes.com/IRAFtutorial/IRAFintro_06.html)
- [Spectral Reduction Procedures](http://www.ucolick.org/~bolte/AY257/ay257_6.pdf)



# VIMOS Quality Control

The VIMOS Quality Control page has some good resouces including some important information about the instrument like the response curve and know issues. Relevant to this work is this found [here](http://www.eso.org/observing/dfo/quality/VIMOS/qc/problems_qc1.html):

> **Absorption feature in GG475 filter** <br/>
> The GG475 filters in quadrants 3 and 1 introduce an absorption feature between about 5800 and 6000A. The filters have about 10 to 20% of their weight in sodium oxide. Impure manufacturing is likely the cause of this feature. Example observations showing the absorption in a featureless white dwarf for quadrants 3 (strong) and 1 (less strong) can be found [here](http://www.eso.org/observing/dfo/quality/VIMOS/img/MR_GG475_Q13.png).


## Response

After I extract and identify the relevant source, I can response correct the spectra. I can do it following the directions in the page [VIMOS response curves and flux calibration](http://www.eso.org/observing/dfo/quality/VIMOS/qc/response.html). 

It comes in a table with 7 fields. Only the first (wave) and 7 (response) are relevant. 

For example for CX25 the relevant information to decide what response curve to use is:

- GRISM: **MR** from *GRIS4 NAME* in the SSEm header 
- Filter name: **GG475** from *FILT4 NAME* in the SSEM header
- Quadrant: **4** from *OCS CON QUAD* in the SSEM header

so in this case according to the observing date:

{% highlight python %}
resp = fits.open('VI_GRSM_101001A_GG475_MR_Q4.fits')
wave = np.array([ resp[1].data[i][0] for i in np.arange(resp[1].data.shape[0]) ])
response = np.array([ resp[1].data[i][6] for i in np.arange(resp[1].data.shape[0]) ])
{% endhighlight %}

It looks like this:

![Response for MR and Quandrant 4]({{site.baseurl}}/images/MR_Q4_resp.png)

Then as it is stated in the website apply to the spectrum:


> Usage: Master response curves R_mst can be applied by hand to extracted spectra with the following procedure:
> F_obs = R_mst * f_raw * 10**(0.4 * airmass * extinction)

In the header there is a line called `HIERARCH ESO TEL AIRM START = 1.082 / Airmass at start` and here it mentions some extinction coefficients for different pediods for each filters and quadrants. [Colour terms and extinction coefficients](http://www.eso.org/observing/dfo/quality/VIMOS/qc/zeropoints.html)




## Dbus

I was having problems with matplotlib. It was a problem with the dbus. I found the solution [here](http://www.torkwrench.com/2012/12/16/d-bus-library-appears-to-be-incorrectly-set-up-failed-to-read-machine-uuid-failed-to-open-varlibdbusmachine-id/). It was doing:


`root@container#dbus-uuidgen >/etc/machine-id`

For some people it was 

`
dbus-uuidgen > /var/lib/dbus/machine-id
`

In some places it said to start the docker image with the `-net=host` option but I didn't have to do this to make it work. 


## vim and vimx

I installed `vim-x11` and `vim-enhanced` in the docker image to be able to support pasting from the terminal to and from vim. When I need it I need to do `vimx` instead of just `vim`. I might put an alias in the .bashrc.

`alias vim='vimx'`

<!-- Not relevant
#### Failed attempt

I tried to used python to reduce the spectra by averaging the data. Something like the following. I will better learn to do it the "right way" with IRAF.


{% highlight python %}
fits.writeto('newcx25.fits',original[0].data[30:180,:] ,original[0].header)
#!/usr/bin/python2

from astropy.io import fits
import numpy as np

ssem = fits.open('VI_SSEM_575273_2011-05-26T05:19:50.824_G475_MR_202166_Q2_hi.fits')
header1 = ssem[0].header
header1['NAXIS2'] = 1

fits.writeto('lastmedian.fits', np.median(ssem[0].data, axis=0)  ,header1)          
mediannorm = [ i/np.max(ssem[0].data) for i in np.median(ssem[0].data,axis=0)]  
fits.writeto('lastmediannorm.fits', mediannorm  ,header1)
{% endhighlight  %}

![SRFM vs SSEM]({{site.baseurl}}/images/cx59both.png)-->


