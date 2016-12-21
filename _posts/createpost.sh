#!/bin/bash
# Creates a new post and ask you with today's date and ask you for the 
#filename, tags and layout
#Ideas from https://blog.mwzhang.com/2015/08/23/creating-template-jekyll-post-using-bash/
#and http://nateeagle.com/2011/09/21/easier-post-creation-for-jekyll-with-bash/


# Config and defaults
editor="vim"
layoutpostdefault=post
categoriesdefault=log


# Read parameters

echo "Title:"
read -e title
echo ""


echo "Layout. The default is post. The options are:"
a=(`ls ../_layouts/*`)
aa=`echo ${a[*]##*/}`
echo $aa
read -e layout
echo ""

echo "Date. Default is today. YYYY-MM-DD"
read -e datepost
echo ""


echo "Filename. The default is the Title."
read -e fname
echo ""

echo "Categories. Default is log"
read -e categories
echo ""


# Defaults

if [ -z "$fname" ]
then
    fname=$title
fi


if [ -z "$categories" ]
then
    categories=$categoriesdefault
fi

if [ -z "$layout" ]
then
    layout=$layoutpostdefault
fi


if [ -z "$datepost" ]
then
    datepost="`date +%F`"
fi




# change to lower case and replace spaces with '-'
fname=`echo $fname| tr "[:upper:]" "[:lower:]" | tr " " "-"`

echo "Tags. Separated by commas:"
read -e tags
echo ""

NAME="$datepost-$fname.md"

if [ -e $NAME ]
then
    echo "File $NAME exists already, exit now."
    echo ""
    exit 1
fi

# Write to $NAME until ENDOFFILE
cat > $NAME << ENDOFFILE  
---
layout: $layout
title: "$title"
categories: [$categories]
tags: [$tags]
---

ENDOFFILE


${editor} + $NAME

