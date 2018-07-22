---
layout: post
title: "Too Many Files Open"
categories: [log]
tags: [astropy, fits, python]
---


# Fitting lines to many spectra. 

Trying to fit the lines to a lot of spectra from SDSS I was getting the following error:

`IOError: [Errno 24] Too many open files`

About this issue the FAQ of Astropy says:

### [I’m opening many FITS files in a loop and getting OSError: Too many open files](http://docs.astropy.org/en/stable/io/fits/appendix/faq.html#i-m-opening-many-fits-files-in-a-loop-and-getting-oserror-too-many-open-files)

> As explained in the note on [working with large files](http://docs.astropy.org/en/stable/io/fits/index.html#fits-large-files), because Astropy uses mmap by default to read the data in a FITS file, even if you correctly close a file with HDUList.close a handle is kept open to that file so that the memory-mapped data array can still be continued to be read transparently.


I tried with gc.collect and deleting the variable that manps to the fit and it didn't work. At the end I had to simply open the fit file with the opton `memmap=False`. I am not sure this was the optimal solution to the problem but it works. 


In the documentation it says:

> In order to force the mmap to close either wait for the containing HDUList object to go out of scope, or manually call del hdul[0].data (this works so long as there are no other references held to the data array).



So maybe I have to just try harder to do it this way instead of the easy solution of memmap=False. 


