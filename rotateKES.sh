#!/bin/bash
#
tput clear
trap ctrl_c INT

function ctrl_c() {
        echo "**You pressed Ctrl+C...Exiting"
        exit 0;
}

echo -e "##############################################################################"
echo -e "##############################################################################"
echo "   _____          _____  _____          _   _  ____           ";
echo "  / ____|   /\   |  __ \|  __ \   /\   | \ | |/ __ \          ";
echo " | |       /  \  | |__) | |  | | /  \  |  \| | |  | |         ";
echo " | |      / /\ \ |  _  /| |  | |/ /\ \ | . \` | |  | |         ";
echo " | |____ / ____ \| | \ \| |__| / ____ \| |\  | |__| |         ";
echo "  \_____/_/__  \_\_|  \_\_____/_/__ _\_\_|_\_|\____/__ ______ ";
echo " | |/ /  ____|/ ____| |  __ \ / __ \__   __|/\|__   __|  ____|";
echo " | ' /| |__  | (___   | |__) | |  | | | |  /  \  | |  | |__   ";
echo " |  < |  __|  \___ \  |  _  /| |  | | | | / /\ \ | |  |  __|  ";
echo " | . \| |____ ____) | | | \ \| |__| | | |/ ____ \| |  | |____ ";
echo " |_|\_\______|_____/  |_|  \_\\____/  |_/_/    \_\_|  |______|";
echo "                                                              ";
echo
echo "v1.0.0"
echo "by FRADA stake pool"
echo
echo "#################################################################################"
echo "KES rotation companion script for cardano noe installation with Coincashew guide"
echo "#################################################################################"
echo
echo
echo
echo
# MOVE TO CARDANO HOME
cd $NODE_HOME

# CHECK CURRENT COUNTER VALUE

echo -e "-------------------------------------------------------"
echo " CURRENT COUNTER VALUE "
echo

cardano-cli query kes-period-info \
    --${NODE_CONFIG} \
    --op-cert-file node.cert

echo
echo " REMINDER :"
echo " - If your pool minted 1 block, NodeState value and OnDisk must be THE SAME"
echo "	 --> Your node.counter value on your air-gapped machine must be exactly 1 greater than NodeState value"
echo
echo " - If your pool did not mint a block since KES renewal, NodeState value should be 1 less than OnDisk value"
echo "   --> In that case, node.counter value on your air-gapped machine needs to be rolled back by exactly 1"
echo
echo " - If your pool never minted a block since its creation, NodeState should be 'null'"
echo "   --> In that case, node.counter value on your air-gapped machine must be set to '0'"
echo
echo

# BACKUP
echo -e "-------------------------------------------------------"
echo " BACKUP KES KEYS AND NODE CERT"
echo

mv kes.skey kes.skey.bak
mv kes.vkey kes.vkey.bak
mv node.cert node.cert.bak

if [ -f "kes.skey.bak" ]; then
	echo " BACKUP kes.skey : done"
else
	echo -e " \e[1;31mCouldn't backup kes.skey. Please check the file and directory\e[0m"
fi
if [ -f "kes.vkey.bak" ]; then
	echo " BACKUP kes.veky : done"
else
	echo -e " \e[1;31mCouldn't backup kes.vkey. Please check the file and directory\e[0m"
fi
if [ -f "node.cert.bak" ]; then
        echo " BACKUP node.cert : done"
else
	echo -e " \e[1;31mCouldn't backup node.cert. Please check the file and directory\e[0m"
fi
echo
echo

# KES PAIR GENERATE
echo -e "-------------------------------------------------------"
echo " KES KEYS GENERATE "
echo

cardano-cli node key-gen-KES \
    --verification-key-file kes.vkey \
    --signing-key-file kes.skey

if [ -f "kes.skey" ]; then
	chmod 400 kes.skey
	echo " GENERATE new kes.skey : done"
else
        echo -e " \e[1;31mCouldn't generate kes.skey\e[0m"
fi
if [ -f "kes.vkey" ]; then
	chmod 400 kes.vkey
        echo " GENERATE kes.vkey : done"
else
	echo -e " \e[1;31mCouldn't generate kes.vkey\e[0m"
fi
echo
echo

# STARTING KES PERIOD CALCULATION
echo -e "-------------------------------------------------------"
echo " STARTING KES PERIOD CALCULATION "
echo

slotNo=$(cardano-cli query tip --mainnet | jq -r '.slot')
slotsPerKESPeriod=$(cat $NODE_HOME/shelley-genesis.json | jq -r '.slotsPerKESPeriod')
kesPeriod=$((${slotNo} / ${slotsPerKESPeriod}))
StartingKESPeriod=${kesPeriod}
echo " The starting KES period is : " ${StartingKESPeriod}
echo
echo " This is the period that must be used when you generate the new OP Certificate on your air-gapped machine"
echo
echo

echo -e "-------------------------------------------------------"
echo " NEXT-STEPS "
echo
echo " 1- copy your kes.skey and kes.vkey to your air-gapped machine"
echo " 2- don't forget to check your node.counter file on your air-gapped machine"
echo " 3- generate your new OP certificate on your air-gapped machine"
echo " 4- copy your new node.cert to your on Block Producer"
echo " 5- restart your block producer"
echo " 6- check if your new OP certificate is OK : cardano-cli query kes-period-info --mainnet --op-cert-file $NODE_HOME/node.cert"
echo " 7- backup your kes keys and node.cert files on a secured storage"
echo
exit 0;
