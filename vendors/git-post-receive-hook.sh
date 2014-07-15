#!/bin/bash
#
# 1. Write in .git/config file:
#    url of bedita instance, ending with /tickets/noteHook
#    user/password of a BEdita user with grants on tickets module     
#
# [tickets]
#       url = http://bedita.example.com/tickets/noteHook
#       user = bedita
#       passwd = bedita
#       log = /path/to/local/logfile

read oldrev newrev

url=$(git config tickets.url)
userid=$(git config tickets.user)
passwd=$(git config tickets.passwd)
logfile=$(git config tickets.log)

cat "oldrev: $oldrev - newrev: $newrev" >> $logfile

# formatted commit data to send
COMMIT_DATA=`git log --pretty=format:"%cn|%H|%s###" $oldrev..$newrev | tr "\n" " "`

repo=`git remote -v | head -n1 | awk '{print $2}' | sed 's/.*\///'`

cat "repo=$repo - userid=$userid - passwd=$passwd - commit_data=$COMMIT_DATA - url=$url" >> $logfile
curl --request POST --data-urlencode "repo=$repo" --data-urlencode "userid=$userid" --data-urlencode "passwd=$passwd" --data-urlencode "commit_data=$COMMIT_DATA" $url >> $logfile
