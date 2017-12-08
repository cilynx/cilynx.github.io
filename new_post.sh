read -p "Title: " TITLE
read -p "Tags: " TAGS

TITLE_STRIPPED=${TITLE// /_}

PERMALINK=$(tr A-Z a-z <<< $TITLE_STRIPPED)

DATE=`date +%F\ %T\ %z`

SHORT_DATE=`date +%F`

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
