#!/bin/bash
echo "Authors Service to OpenShift using UrbanCode Deploy"

IMAGENAME=authors
BUILD_VERSION=0.0.0

echo "Parameters are:"
while true; do
    case $1 in 
        -v | --version )
            BUILD_VERSION=$2; echo "Version for new build=$BUILD_VERSION"; shift 2 ;;
        -- ) echo "-- $1"; shift; break ;;
        * ) break ;;
    esac
done

if [[ "$BUILD_VERSION" == "0.0.0" ]]; 
then 
    echo "Please enter new Version with -v parameter"
    exit 1 
fi 

# first step build with maven
mvn package

# second step build container image, need input variable for version
docker build . -t "$IMAGENAME":"${BUILD_VERSION}"
docker tag "$IMAGENAME":"${BUILD_VERSION}" quay.io/osmanburucuibm/"$IMAGENAME":"${BUILD_VERSION}"

docker push quay.io/osmanburucuibm/"$IMAGENAME":"${BUILD_VERSION}"