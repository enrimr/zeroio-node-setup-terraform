#!/bin/bash
set -x

# DEPLOY NODE
export NODENAME=PAYPLE
export NODEID=1
export SUBDOMAIN=loyal-gray-donkey
export DOMAIN=payple.net

mkdir nodes
cd nodes

# if local program 'git' returns 1 (doesn't exist) then...                                                                               
if ! type -P git; then                                                             
    echo -e " \U274C git binary doesn't exist. Let's install it!"
    sudo apt update
	sudo apt install git -y 
	echo -e " \U2714 git installed!"                                                    
else                                                                               
    echo -e " \U2714 We have git!"                                                    
fi 

git clone https://gitlab.com/zero.io/subzero-node-setup.git
cd subzero-node-setup
echo -e " \U274C repository clonned!"

# CONFIGURATION
# GENERATE KEYS
echo -e "Generating Keys..."

# Check
if ! type -P subkey; then                                                             
    echo -e " \U274C subkey binary doesn't exist. Let's install it!"
	echo -e " > Installing substrate..."
	curl https://getsubstrate.io -sSf | bash -s -- --fast
	source ~/.cargo/env
	#cargo install --force subkey --git https://github.com/paritytech/substrate --version 2.0.1
	echo -e " \U2714 subkey installed!"                                                    
else                                                                               
    echo -e " \U2714 We have subkey!"                                                    
fi 

echo -e " > Generating sr25519 key..."
subkey generate --scheme sr25519 > sr25519.key
suri=$(cat sr25519.key | grep "Secret phrase" | sed 's/.*Secret phrase `\(.*\)` is account.*/\1/' 2>&1)
public_sr25519=$(cat sr25519.key | grep "key (hex)" | sed 's/.*0x\(.*\).*/\1/' 2>&1)
echo $suri > keys/62616265${public_sr25519}
echo -e " > sr25519 generated!"

echo -e " > Generating ed25519 key..."
subkey inspect --scheme ed25519 "${suri}" > ed25519.key
public_ed25519=$(cat ed25519.key | grep "key (hex)" | sed 's/.*0x\(.*\).*/\1/' 2>&1)
echo $suri > keys/6772616e${public_ed25519}
echo -e " > ed25519 generated!"

# NODE PARAMETERS
echo "NAME=${NODENAME}-${NODEID}-${SUBDOMAIN}-auto
UID=\${UID}
GID=\${GID}
PWD=\${PWD}" > .env
echo -e " > environment file edited!"

sed -i "s/server_name node.*;/server_name $SUBDOMAIN.*;/" config/node.subdomain.conf
sed -i "s/URL=example.com/URL=$DOMAIN/" config/letsencrypt-env
sed -i "s/SUBDOMAINS=node/SUBDOMAINS=$SUBDOMAIN/" config/letsencrypt-env
echo -e " > Config files edited!"

# RUN ZEROIO NODE
sudo docker-compose up -d
echo -e " > Docker-compose done!"

