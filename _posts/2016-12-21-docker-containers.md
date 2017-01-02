---
layout: post
title: "Docker Containers"
categories: [log]
tags: [docker,server,computer,reproducible]
---

Docker is an open-source project that allows you to easily create and share lightweight containers. The way I see it containers are sort of lightweight and portable virtual machines.

So docker allows you to easily build and share a portable and easily customizable container. To ensure reproducibility this containers can be build with the require software and documents using a [Dockerfile](https://docs.docker.com/engine/reference/builder/). These are the instructions to build the container. The one I will be using can be found [here](https://github.com/manuelmarcano22/VIMOSDocker). The Dockerfile can be shared and anybody can build the container or a very easy way to share the docker images is through their platform [Docker Hub](https://hub.docker.com/). The automatically build image can be found here:[https://hub.docker.com/r/manuelmarcano22/vimosdocker/](https://hub.docker.com/r/manuelmarcano22/vimosdocker/). An easy

`docker pull manuelmarcano22/vimosdocker`

will allow you to have all the necessary software with the right version.

Docker is widely used in the software development community and it is starting to be adopted by scientist. I have seen it being used in bioinformatics (for example, [here](http://biocontainers.pro/) and in this paper [An introduction to Docker for reproducible research, with examples from the R environment](https://arxiv.org/abs/1410.0846) ), in High energy physics (see for example the [CERN](https://hub.docker.com/u/cern/) repos and [LHC Docker images](https://twiki.cern.ch/twiki/bin/view/LHCb/LHCbSoftOnDocker)), and also in Radio Astronomy (see this [paper](https://gaia.ub.edu/Twiki/pub/GENIUS/TrimesterReportDec2015-Feb2016/dockerpaper.pdfs://gaia.ub.edu/Twiki/pub/GENIUS/TrimesterReportDec2015-Feb2016/dockerpaper.pdf) and [kernsuite](http://kernsuite.info/)).

All the major companies that provide cloud services have adopted Docker. This includes Digital Ocean, Amazon Web Services and Google cloud platform. So using docker containers not only allow you to easily share and replicate any computational workflow, but it also makes your analysis easily scalable and portable to move the analysis to the cloud. Computing in the cloud have been a really hot topic. Specially in the radio astronomy community. For example [ICRAR](http://www.icrar.org/) have announced some projects using the Amazon web services to perform its data analysis (see [here](https://aws.amazon.com/solutions/case-studies/icrar/) and the article [Imaging SKA-Scale data in three different computing environments](https://arxiv.org/abs/1511.00401).

I will be using an image of an Scientific Linux 7.2 with miniconda (python 3.5) installed. The idea is to try to follow the Reproducible Workflow shown in this paper [Reproducible Computational Workflows with Continuous Analysis](http://biorxiv.org/content/early/2016/08/11/056473).

### Resources

Some resources are listed below. This includes some articles and blog post talking about Docker and scientific computing.

*   [Use of Docker✩ for deployment and testing of astronomy software](https://gaia.ub.edu/Twiki/pub/GENIUS/TrimesterReportDec2015-Feb2016/dockerpaper.pdf)

*   Tutorial: [A hands-on introduction to Docker](http://angus.readthedocs.io/en/2015/week3/CTB_docker.html)

*   [An introduction to Docker for reproducible research, with examples from the R environment](https://arxiv.org/abs/1410.0846)

*   [Docker in Astronomy](http://caseyjlaw.github.io/docker-in-astronomy.html)

*   Video: [Docker and Radio Astronomy - Containing Fragile Scientific Software by Gijs Molenaar](https://www.youtube.com/watch?v=K98cbiQg-A8)

*   [KERN Radio Astronomy Software Suite](http://kernsuite.info/). It includes a base docker image which you can use to create custom docker images containers all the KERN packages combined with your own scripts.

*   [Reproducible Computational Workflows with Continuous Analysis](http://biorxiv.org/content/early/2016/08/11/056473).


### Docker SSH

After some help from [here](https://dzone.com/articles/docker-x11-client-via-ssh) I was able to get X forwarding. I now run in my VPS

`docker run -ti -e DISPLAY=$DISPLAY --net=host  -v /tmp/.X11-unix:/tmp/.X11-unix  --volume="$HOME/.Xauthority:/home/vimos/.Xauthority:rw"  --name xvaina manuelmarcano22/vimosdocker:latest`

I have to ssh with the **-Y**, with **-X**  I get  the error **X Error of failed request:  BadAccess (attempt to access private resource denied)**

Before I looked at the *.Xauthority* file and added the docker group just in case. 
 
`$ chown mmarcano22:docker ~/.Xauthority`

and 

`$ chmod 0600 ~/.Xauthority`

### Useful commands:

#### To pull from Docker hub:

`docker pull manuelmarcano22/vimosdocker`

Currently the default tag is auto (latest by default). So can do:

`docker pull manuelmarcano22/vimosdocker:auto`

were auto is the tag.

#### To run interactivelty (that is with a terminal) do:

`docker run -ti --name [name] manuelmarcano22/vimosdocker:auto`

#### To restart an exited container:

`docker start -i name`

#### To commit and push changes on the container:

Can commit doing:

`docker commit -m [message] [container name] [REPOSITORY[:TAG]]`

For example it can be commited to _manuelmarcano22/vimosdocker:v2_ and then push to the hub after doing `docker login` as:

`docker push manuelmarcano22/vimosdocker:v2`.

#### To delete all images and containers:

Delete all containers:

`docker rm $(docker ps -a -q)`

Delete all images:

`docker rmi $(docker images -q)`

#### To start using ds9 or pyraf

*   `docker run -ti -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --name vimos9 manuelmarcano22/vimosdocker:auto`. In this one might need to do `xhost -local:docker`.

Other ways can be found here: [http://wiki.ros.org/docker/Tutorials/GUI](http://wiki.ros.org/docker/Tutorials/GUI). Some is discused here: [Running GUI apps with Docker](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/).

#### If want to us X over ssh it is a bit tricky.

Still haven’t completely figure it out.

*   https://blog.docker.com/2013/07/docker-desktop-your-desktop-over-ssh-running-inside-of-a-docker-container/

*   https://dzone.com/articles/docker-x11-client-via-ssh
