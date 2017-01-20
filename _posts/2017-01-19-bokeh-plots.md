---
layout: post
title: "Bokeh Plots"
categories: [log]
tags: [bokeh,plot, spectra, interactive]
---

## Bokeh

One idea is that instead of having to take screenshots of the iraf spectra, I can use a plotting library like [Bokeh](http://bokeh.pydata.org/en/latest/) to display interactive plots in here. Bokeh can be installed with conda. One way of getting the plot is:

* Create a javascript file and put in in the **{{site.baseurl}}/images/bokehgraphs** folder
* Then in here call the script. For example:

```html
<script
    src="{{site.baseurl}}/images/bokehgraphs/bokeh1.js"
    id="deab7ab7-b894-4eb4-81be-488c6d136d17"
    data-bokeh-model-id="5dcc4051-f29b-439a-8c65-43090c7bab7c"
    data-bokeh-doc-id="d572a467-6563-4a98-859c-4e5242fa207f"
></script>

```
This renders the example plot shown below:


<script
    src="{{site.baseurl}}/images/bokehgraphs/bokeh1.js"
    id="deab7ab7-b894-4eb4-81be-488c6d136d17"
    data-bokeh-model-id="5dcc4051-f29b-439a-8c65-43090c7bab7c"
    data-bokeh-doc-id="d572a467-6563-4a98-859c-4e5242fa207f"
></script>



The minimal python script is:

```python
from bokeh.resources import CDN
from bokeh.plotting import figure
from bokeh.embed import autoload_static

name= 'bokeh1.js'

#Plot commands
plot = figure()
plot.circle([1,2], [3,4])

#Js is a js file that provides data for the plot and the tag is the tag to include in the html document.
js, tag = autoload_static(plot, CDN, "{[site.baseurl}}/images/bokehgraphs/"+name+".js")

##To save it in files
with open(name+'.js','w') as jsfile:
	jsfile.write(js)
with open(name+'.html','w') as htmlfile:
	htmlfile.write(tag)
```


### Bokeh and Docker

In the docker container can create an html as output and if the docker container was created exposing a port with the `-p 8888:8888` for example can create a simple HTTP server with python (`python -m SimpleHTTPServer 8888`)and preview the Bokeh plot in localhost at the specified port.  


To plot the spectra from the header information this page was very useful:

* [The IRAF/NOAO Spectral World Coordinate Systems](http://stsdas.stsci.edu/cgi-bin/gethelp.cgi?specwcs)

> The FITS image header keywords describing the spectral world coordinates are CTYPEi, CRPIXi, CRVALi, and CDi_j where i and j are axis numbers. As with the physical coordinate transformation the nondiagonal or rotation terms are not expected in the spectral WCS and may cause problems if they are not zero. The CTYPEi keywords will have the value LINEAR to identify the type of of coordinate system. The transformation between dispersion coordinate, wi, and logical pixel coordinate, li, along axis i is given by  wi = CRVALi + CDi_i * (li - CRPIXi)

Regarding the defaults

> If the keywords are missing then the values are assumed to be zero except for the diagonal elements of the scale/rotation matrix, the CDi_i, which are assumed to be 1. If only some of the keywords are present then any missing CDi_i keywords will take the value 0 which will cause IRAF tasks to fail with arithmetic or matrix inversion errors. If the CTYPEi keyword is missing it is assumed to be "LINEAR".


See the Python file [createspectra1.py](https://github.com/manuelmarcano22/VIMOSReduced/blob/master/cx0025/createspectra1.py) in the VIMOSReduced git repo. 


The output is:

<script
    src="{{site.baseurl}}/images/bokehgraphs/spectraap2cx25.js"
    id="f7e81da9-3760-4cb2-a8bb-2a33f908d8c3"
    data-bokeh-model-id="60f28dc8-0f87-48c3-9143-a19cac57a213"
    data-bokeh-doc-id="4db13c27-df1f-4859-b48e-332b7b666604"
></script>


