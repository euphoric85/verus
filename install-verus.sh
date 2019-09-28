#!/bin/bash

echo Installing prerequisities...
sudo apt update
sudo apt --yes install build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git python python-zmq zlib1g-dev wget libcurl4-openssl-dev bsdmainutils automake curl

echo Downloading latest Verus wallet and bootstrap
echo This will take some time...
wget $(curl -s https://api.github.com/repos/veruscoin/veruscoin/releases/latest | grep browser_download_url | grep 'Linux.*\.gz\"' | cut -d '"' -f 4)
wget https://bootstrap.0x03.services/veruscoin/VRSC-bootstrap.tar.gz


echo Moving things into place...
mkdir -p .komodo/VRSC
tar -xvf VRSC-bootstrap.tar.gz -C ~/.komodo/VRSC/
tar -xvf Verus*.tar.gz -C ~/
rm VRSC-bootstrap.tar.gz
rm Verus*.tar.gz

echo "Initializing Verus daemon..."
~/verus-cli/fetch-params

echo "Do you already have a VRSC wallet you'd like to import? Y or N"
echo "Note: exchange wallets do not count"
read existingwallet
if [ "$existingwallet" == "y" ]; then
  echo "Is it an Agama desktop wallet? Y or N"
  read agama
  if [ "$agama" == "y" ]; then
    echo "Please copy your wallet.dat from that computer-"
    echo "Unless you specified an alternate location, it should be in ~/.komodo/VRSC/"
    read -p "Please copy wallet.dat to the same location on this computer, then press enter"
  elif [ "$agama" == "n" ]; then
    echo "We need your WIF/wallet seed. If you already have this handy, ignore the following instructions and enter your seed now."
    echo "To get your seed in Verusmobile, login to your wallet, click the 3 lines in the top-right corner"
    echo "Then go to Settings -> Profile -> Recover Seed. Enter your wallet password then click Recover.  Please review the warning prompt!!"
    echo "If you're okay to proceed, click Yes.  Your wallet seed with QR code should show now.  Enter that seed below:"
    read seed
  fi
fi


echo "Launching Verus daemon!"
echo "This will run in the background on this computer. If you want to stake VRSC, this computer and the verus daemon need to be running 24/7."
screen -dmS verusd ~/verus-cli/verusd -mint

if [ "$existingwallet" == "y" ]; then
  echo "Waiting for the daemon to finish loading..."
  until ~/verus-cli/verus importprivkey $seed
  do
    sleep 60
  done
  echo "Your wallet ^^^ has been successfully imported"
else
  ~/verus-cli/verus getaccountaddress ""
  echo "^^ this is your transparent address. Any coins you want to stake live here."
  echo "You will also use mainly this address for trading between other users and exchanges."
  echo ""
  ~/verus-cli/verus z_getnewaddress sapling
  echo "^^ this is your z address. You use this for shielding coins as well as for private transactions where supported"
  echo "Please save both of these addresses in a safe place" 
fi

echo "You're done! Verus daemon is now running on this computer."
echo ""
echo "For more information about Veruscoin, please visit https://veruscoin.io"
echo "Verus has an active, friendly community.  Join the conversation on the official Discord server https://discord.gg/VRKMP2S"
