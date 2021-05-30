#!/bin/bash
set -x

# DEPLOY NODE
export NODENAME=MYZERONODE
export NODEID=0
export SUBDOMAIN=subdomain
export DOMAIN=domain.net

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
	cargo install --force subkey --git https://github.com/paritytech/substrate --version 2.0.1
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
PWD=." > .env
echo -e " > environment file edited!"

sed -i "s/server_name node.*;/server_name $SUBDOMAIN.*;/" config/node.subdomain.conf
sed -i "s/URL=example.com/URL=$DOMAIN/" config/letsencrypt-env
sed -i "s/SUBDOMAINS=node/SUBDOMAINS=$SUBDOMAIN/" config/letsencrypt-env
#sed -i "s/$PWD/./" config/letsencrypt-env
echo -e " > Config files edited!"

# RUN ZEROIO NODE
if ! type -P docker; then 
	echo -e " \U274C docker binary doesn't exist. Let's install it!"
	sudo apt update
	sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
	sudo apt update
	apt-cache policy docker-ce
	sudo apt install docker-ce -y
	echo -e " \U2714 Docker installed!"
	sudo systemctl status docker
	echo -e " \U2714 Docker daemon configured!"
else
    echo -e " \U2714 We have docker!"
fi

if ! type -P docker-compose; then 
    echo -e " \U274C docker-compose binary doesn't exist. Let's install it!"
    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	echo -e " \U2714 docker-compose installed!"
else
    echo -e " \U2714 We have docker-compose!"                                                    
fi

sudo docker-compose up -d
echo -e " > Docker-compose done!"

