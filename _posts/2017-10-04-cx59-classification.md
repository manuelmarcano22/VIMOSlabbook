---
layout: post
title: "CX59 Classification"
categories: [log]
tags: [CX59,spectra, classification]
---


The [folder](https://vimos.manuelpm.me/cx59) with CX 59 has at least 4 sources in the same field: CX 572, CX 1033, two labeld with CX1032,  and CX172. In the preimage left to right translate to  decreasing y (top to bottom) in the SEXM. We have going from y equal 0 to 450:



By looking at the pre-image with the region file and the SEXM below or [here](https://vimos.manuelpm.me/cx59) I think:

- CX 59: from 370 - 450. It is the section on the top of the SEXM. The brightest source in the field. It seems saturated. 

-  CX572: 300 to 370

- CX1033: 230 to 300

- **Pipeline star?**.:170-230 The closest is CX1032, but this fourth one from top to bottom maybe a star put by the pipeline? Has different dimensions.

- CX1032: 80-170

- CX172: 0-80.

- - - 


![]({{site.baseurl}}/images/cx59preimage.png)

![]({{site.baseurl}}/images/cx59sexm.png)

<!--![]({{site.baseurl}}/images/aperturescx59.png)-->

# CX59

## Information


- - -

Regarding CX59 [@TychoIdentification] says in section 6.14:

> 6.14. CX59 (CXOGBS J174500.5–261228)
> CX59 was matched with TYC 6832-663-1 with a quite large
> offset of 3.53 arcsec. This source was detected only 3 arcmin
> off-axis by Chandra with 27 photons, so there is no reason to
> expect such a large offset. This star has not been reported as a
> double, and the X-ray source is also the hardest of the sources
> considered here for which we can calculate a hardness ratio. We
> conclude that this is likely to be a chance alignment.

From [Simbad](http://simbad.u-strasbg.fr/simbad/sim-id?Ident=%402494373&Name=CD-26%2012293&submit=submit) it was classified as a A0, but this was done in 1939. 



### Spectra:


Extracted spectrum without normalizing:

<script
    src="{{site.baseurl}}/images/bokehgraphs/cx59notnorm.js"
    id="86843a4d-7ec2-49b9-b287-4c1f942bbd52"
    data-bokeh-model-id="8b1891aa-bd7b-47a9-b5f4-ec7513d4c9f7"
    data-bokeh-doc-id="84f75ad8-1a1d-4683-8432-fc9840e88dd4"
></script>



## Normalized Spectrum


<script
    src="{{site.baseurl}}/images/bokehgraphs/cx59.js"
    id="ab66b99e-57ef-4e47-8d10-3c06e7b81725"
    data-bokeh-model-id="0157a18c-e04d-4ff8-bdc1-20b329450cdb"
    data-bokeh-doc-id="cd25848f-1723-4707-856a-3d20b6b71dbb"
></script>


## Classification


From [@SpectralClassBook]:
 
> The blue-violet spectra of B-type stars are dominated by the Balmer lines of hydrogen and lines of neutral helium (He I). The some A0 stars show weak lines of He I. The Balmer lines strengthen thought the B-type stars into the A-type stars, coming to a maximum at a spectral type of A2 in the dwarfs. Lines of neutral helium first show up in the O-type stars, strengthen through the O-type stars, come to a maximum at B2, and then weaken toward cooler types, finally disappearing from classification spectra at a spectral type of about A0. 


From [@andrillat1995]:

Regarding Supergiants:

> "The general aspect of the spectra permits to single out easily the supergiants, which have narrow and sharp profiles. For instance OI 8446 lines is distinctly separated from P18, from B2 on. 


For other than supergiants:

> Using the Paschen lines: If there is a smooth, regular sequence in the depths of P18 to P12, the star is of type B. If P16, P15 and P13 stand out in the sequence, the star is of type A. This is due to the fact that each of these lines is blended with a Ca II line. In F-type stars the Ca lines are much larger than the lines of the Paschen series, which decrease with advancing spectral type. The Paschen lines become insignificant at type G. Furthermore in F-type stars the metallic lines become more numerous and stronger with advancing spectral type. 

> For stars earlier than B3 the Paschen region alone is incapable of fixing spectral type and luminosity. We recommend the use of He I 7065 line. 

[@andrillat1995] provide equivalent width of P14, P14/(P15+Ca), OI 8446, and 7065 HeI as a function of spectral type and luminosity class. 


Regarding the Paschen series [@atlaslow93] say that:

> The Paschen area itself gives a good first approximation of spectral type for early type stars (O-F), especially for A stars. For early types, the PAschen area can distinguish supergiants from luminosity class V or III. The Paschen lines in the supergiants are much narrower than in giants or main-sequence stars, so more lines can be resolved in the series. In addition ,the O I $\lambda8446$ line is a good indicator of luminosity, as is the Paschen jump (8207 A) in A and F stars. [...] So is the Ca II $\lambda 8498,8542, 8662$ triplet in A to M. 





## [@andrillat1995] EW relations

<table width="500" border="1" cellpadding="5">

<tr>

<td align="center" valign="center">
<img src="{{site.baseurl}}/images/fig14andrillat.png" alt="description here" />
<br />
</td>

<td align="center" valign="center">
<img src="{{site.baseurl}}/images/fig15andrillat.png" alt="description here" />
<br />
</td>

</tr>


<tr>

<td align="center" valign="center">
<img src="{{site.baseurl}}/images/fig16andrillat.png" alt="description here" />
<br />
</td>

<td align="center" valign="center">
<img src="{{site.baseurl}}/images/fig17andrillat.png" alt="description here" />
<br />
</td>

</tr>

</table>


## Equivalent Width for CX59

## Plotting it

the line  center, continuum intensity at the line center, the flux, and the equivalent width.

```python
splot cx59ssem.ms.fits cursor=cur.cur save_file=cx59.log band=1
```

## Other relevant sources:

- [@danks1994]

- [@Morgan43]


# References
