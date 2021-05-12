## Install go
#wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz
#sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.16.4.linux-amd64.tar.gz
#export PATH=$PATH:/usr/local/go/bin
#echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bashrc
#
##Install kind
#go get sigs.k8s.io/kind
#
## Install ctlptl
#export CTLPTL_VERSION="0.5.0"
#curl -fsSL \
#	https://github.com/tilt-dev/ctlptl/releases/download/v$CTLPTL_VERSION/ctlptl.$CTLPTL_VERSION.mac.x86_64.tar.gz \
#	| tar -xzv ctlptl && \
#sudo mv ctlptl /usr/local/bin/ctlptl

# Install localstack and awslocal
pip install -r requirements.txt
