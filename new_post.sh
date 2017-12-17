read -p "Title: " TITLE
read -p "Tags: " TAGS
read -p "Date: " DATE

TITLE_STRIPPED=${TITLE// /_}
TITLE_STRIPPED=${TITLE_STRIPPED//\//_}

PERMALINK=$(tr A-Z a-z <<< $TITLE_STRIPPED)

if [ -z "$DATE" ] ; then
   DATE=`date +%F\ %T\ %z`
   SHORT_DATE=`date +%F`
else
   SHORT_DATE=${DATE}
fi

TYPE='.md'

PERMALINK=$(tr A-Z a-z <<< $TITLE_STRIPPED)

FILENAME=${SHORT_DATE}-${PERMALINK}${TYPE}

POSTS_DIR='_posts/'

FILEPATH=${POSTS_DIR}${FILENAME}

echo -e "---
layout: post
title:  ${TITLE}
date:   ${DATE}
tags:   ${TAGS}
---" >> ${FILEPATH}

vi + ${FILEPATH}
