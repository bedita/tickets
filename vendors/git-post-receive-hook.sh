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
#       repo = git-repo-name

read oldrev newrev

url=$(git config tickets.url)
userid=$(git config tickets.user)
passwd=$(git config tickets.passwd)
# repo logic name (must be the same in bedita.cfg.php server side)
repo=$(git config tickets.repo)

echo "oldrev: $oldrev - newrev: $newrev"

# formatted commit data to send
commitData=`git log --pretty=format:"%cn|%H|%s###" $oldrev..$newrev | tr "\n" " "`

echo "repo=$repo - userid=$userid - passwd=$passwd - commit_data=$commitData - url=$url"
curl --request POST --data-urlencode "repo=$repo" --data-urlencode "userid=$userid" --data-urlencode "passwd=$passwd" --data-urlencode "commit_data=$commitData" $url
