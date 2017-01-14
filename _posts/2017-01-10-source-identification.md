---
layout: post
title: "Source Identification"
categories: [log]
tags: [data, spectra]
---

fits.writeto('newcx25.fits',original[0].data[30:180,:] ,original[0].header)

dbus-uuidgen > /var/lib/dbus/machine-id

root@container#dbus-uuidgen >/etc/machine-id

and started with the net=host option

http://www.torkwrench.com/2012/12/16/d-bus-library-appears-to-be-incorrectly-set-up-failed-to-read-machine-uuid-failed-to-open-varlibdbusmachine-id/

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

## Compare aperture 7 with sum in python. 

Manually selected the rows then sum. compare to the one obtained with SRFM. 
Which one better?  
