---
layout: post
title: "Bokeh Plots and JS9"
categories: [log]
tags: [bokeh,plot, spectra, interactive]
---

## Bokeh

One idea is that instead of having to take screenshots of the iraf spectra, I can use a plotting library like [Bokeh](http://bokeh.pydata.org/en/latest/) to display interactive plots in here. Bokeh can be installed with conda. One way of getting the plot is:

* Create a javascript file and put in in the **{{site.baseurl}}/images/bokehgraphs** folder
* Then in here call the script. For example:

{% highlight html %}
<script
    src="{{site.baseurl}}/images/bokehgraphs/bokeh1.js"
    id="deab7ab7-b894-4eb4-81be-488c6d136d17"
    data-bokeh-model-id="5dcc4051-f29b-439a-8c65-43090c7bab7c"
    data-bokeh-doc-id="d572a467-6563-4a98-859c-4e5242fa207f"
></script>
{% endhighlight %}


The minimal python script is:

{% highlight python linenos %}

from bokeh.resources import CDN
from bokeh.plotting import figure
from bokeh.embed import autoload_static

name= 'bokeh1.js'

#Plot commands
plot = figure()
plot.circle([1,2], [3,4])

#Js is a js file that provides data for the plot and the tag is the tag to include in the html document.
js, tag = autoload_static(plot, CDN, "{{site.baseurl}}/images/bokehgraphs/"+name+".js")

##To save it in files
with open(name+'.js','w') as jsfile:
	jsfile.write(js)
with open(name+'.html','w') as htmlfile:
	htmlfile.write(tag)

{% endhighlight %}


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



### Boxcar Smooth

IRAF very useful smooth function applies a boxcar smooth. A nice short reference is in [here](http://joseph-long.com/writing/AstroPy-boxcar/). This is using the astropy functions:

`from astropy.convolution import convolve, Box1DKernel`

Following the example [here](https://demo.bokehplots.com/apps/sliders) and [here](https://github.com/bokeh/bokeh/blob/master/examples/app/sliders.py) I can try to have it in bokeh. The only ploblem is that to generate the static html and js the widget I think needs to be written in JS and you have to pass a ColumnDataSource. One easy, but not efficient way is to create several Data sets. It does the work but could be more efficient. Also to get back to the unsmooth one needs to refresh the whole page.  

{% highlight python %}
source3 = ColumnDataSource(data=dict(x=x,y=ysmooth3))
source5 = ColumnDataSource(data=dict(x=x,y=ysmooth5))

plot = figure(x_axis_label='Angstrom', y_axis_label='Y')
plot.add_tools(hover)
plot.add_tools(tools.ResizeTool())
#Eraaseplot.line(xlist,secondstar)
plot.line('x','y',source=source)

##Callback in JS
callback = CustomJS(args=dict(source=source,source3=source3,source5=source5), code="""
        var data = source.data;
        var data3 = source3.data;
        var data5 = source5.data;
        var f = cb_obj.value
        y = data['y']
        y3 = data3['y']
        y5 = data5['y']
        
        if (f == 3.0){
        for (i = 0; i < y.length; i++) {
            y[i] = y3[i]
        }
        }
        
        if (f == 5.0){
        for (i = 0; i < y.length; i++) {
            y[i] = y5[i]
        }
        }
        source.trigger('change');
    """)


# Set up slider
slider = Slider(title="Smooth Curve", value=1.0, start=1.0, end=5.0, step=2.0,callback=callback)

layout = column(slider, plot)
output_file(name+'try.html')
{% endhighlight %}



# Javascript 

For javascript there are some interesting libraries like [JS9](http://js9.si.edu/) to display astronomical image in your browser and [Numeric Javascript](http://www.numericjs.com/) for 


## JS9 Demo: the basics

The menubar does not work, but the image can be control via the [JS9 Public API](http://js9.si.edu/js9/help/publicapi.html). The API can be called from the console using firefox or google. Or using the js9 console below. One example with custom made buttons using the API is found [here](http://js9.si.edu/js9/js9bespoke.html).


<table cellspacing="15">
<tr valign="top">
<td>
PNG files from FITS:
<ul>
<li> <a href='javascript:JS9.Load("{{site.baseurl}}/images/png/m13.png", {scale:"linear", colormap:"sls"});'>m13 (via SkyView)</a>
</ul>
</td>
<td>
FITS images and binary tables:
<ul>
<li> <a href='javascript:JS9.Load("{{site.baseurl}}/images/fits/cx25.fits", {scale:"log"});'>CX0025</a>
<li> <a href='javascript:JS9.LoadRegions("{{site.baseurl}}/images/regions/cx25.reg");'>Region fileCX0025</a>
</ul>
</td>
</tr>
</table>
<!--<div class="JS9Menubar"></div>-->
<!--<div class="JS9"></div>-->
<!--<div class="JS9Colorbar"></div>-->
<div class="JS9" id="myJS9" ></div>
<!--data-width="300px" data-height="300px"></div>-->
<div class="JS9Console" id="myJS9Console" ></div>
