#!/bin/bash

# Check if the cert is already generated
if [ -f local-cert.pem ]; then
    if [ -f local-key.pem ]; then
        echo "Certificate already generated!"
        exit 0
    else
        echo "Certificate is missing key, please delete local-cert.pem and try again"
        exit 1
    fi
else
    echo "Generating certificate..."
fi

echo "Checking if mkcert is installed..."
# Check if mkcert is installed
if ! [ -x "$(command -v mkcert)" ]; then
    echo "mkcert could not be found, installing (requires sudo)..."
    # Check linux or macOS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sudo apt update
        sudo apt install -y libnss3-tools mkcert # Install certutil and mkcert
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        # Check if brew is installed
        if ! [ -x "$(command -v brew)" ]; then
            echo "brew could not be found, please install it -> https://brew.sh/"
            exit 1
        fi
        brew install mkcert # Install mkcert
    else
        echo "Unsupported OS type: $OSTYPE"
        exit 1
    fi
    mkcert -install # Install the root certificate
fi

# See https://github.com/FiloSottile/mkcert/issues/53
unset JAVA_HOME

mkcert -cert-file local-cert.pem -key-file local-key.pem localhost '*.trouvoutils.localhost' 'trouvoutils.localhost'