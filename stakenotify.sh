#!/bin/bash

# You must add the following line to your ~/.komodo/VRSC/VRSC.conf for this to work:
# walletnotify = ~/verus-cli/stakenotify.sh %s


function pusho {
    curl -s -F "token=YOUR PUSHOVER API TOKEN HERE" \
    -F "user=YOUR PUSHOVER USER KEY HERE" \
    -F "title=Verus" \
    -F "message=$1" https://api.pushover.net/1/messages.json
}
function pushb {
    curl --silent -u """YOUR PUSHBULLET API TOKEN HERE"":" \
    -d type="note" \
    -d title="Verus" \
    -d body="$1" https://api.pushbullet.com/v2/pushes
}


category=$(~/verus-cli/verus gettransaction $1 | grep category)


case $category in

*receive*                                                                                                                                                         *receive*)
  pusho "You just received more Verus!"
  pushb "You just received more Verus!"
  ;;

*mint*)                                                                                                                                                         *mint*)
  pusho "You just staked more Verus!"
  pushb "You just staked more Verus!"
  ;;

*generate*)
  pusho "You just mined more Verus!"                                                                                                                       pushb "You just mined more Verus!"
  ;;

esac
