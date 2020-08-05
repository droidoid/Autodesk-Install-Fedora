#!/usr/bin/env bash

if [[ $(grep "Fedora 32" /etc/os-release) ]]; then
  #echo "Fix Autodesk scripts"
  #sed -i 's/print "Installing CLM Licensing Components...."/print ("Installing CLM Licensing Components....")/' Packages/unix_installer.py
  #sed -i 's/$ABSPATH/"$ABSPATH"' Packages/unix_installer.sh
  echo "Install missings components"
  sudo dnf install -y audiofile audiofile-devel compat-openssl10 e2fsprogs-libs gamin glibc \
    liberation-fonts-common liberation-mono-fonts liberation-sans-fonts liberation-serif-fonts \
    libICE libpng12 libpng15 libSM libtiff libX11 libXau libxcb libXext libXi libXinerama libXmu \
    libXp libXt mesa-libGLU mesa-libGLw pcre-utf16 redhat-lsb tcsh xorg-x11-fonts-ISO8859-1-100dpi \
    xorg-x11-fonts-ISO8859-1-75dpi zlib
  (
    cd Packages
    echo "Install Maya and license client"
    sudo dnf install -y adlmapps17-17.0.49-0.x86_64.rpm
    sudo dnf install -y Maya2020_64-2020.0-235.x86_64.rpm
    sudo dnf install -y adsklicensing9.2.1.2399-0-0.x86_64.rpm
    sudo dnf install -y adlmflexnetclient-17.0.49-0.x86_64.rpm
    echo "Install Bifrost, Substance & Arnold"
    sudo dnf install -y Bifrost2020-2.1.0.0-1.x86_64.rpm Substance_in_Maya-2020-2.0.3-1.el7.x86_64.rpm
    sudo ./unix_installer.sh
    echo "Install Maya BonusTools"
    sudo ./MayaBonusTools-2017-2020-linux.sh
  )

  if [[ -d "CLM_usr" && -d "adsklic" ]]; then
    cp CLM_usr/libadlmint.so.17.0.49 /opt/Autodesk/Adlm/R17/lib64/
    cp CLM_usr/libadlmint.so.17.0.49 /opt/Autodesk/AdskLicensing/9.2.1.2399/AdskLicensingAgent/lib/
    cp CLM_usr/libadlmint.so.17.0.49 /opt/Autodesk/AdskLicensing/9.2.1.2399/helper/
    cp CLM_usr/libadlmint.so.17.0.49 /usr/autodesk/maya2020/lib/
    cp adsklic/libadlmutil.so.17.0.49 /opt/Autodesk/AdskLicensing/9.2.1.2399/AdskLicensingAgent/lib/
    cp adsklic/libadlmutil.so.17.0.49 /usr/autodesk/maya2020/lib/
  fi

  echo "Register Standalone License"
  sudo LD_LIBRARY_PATH=/opt/Autodesk/Adlm/R17/lib64 /opt/Autodesk/AdskLicensing/9.2.1.2399/helper/AdskLicensingInstHelper register --prod_key 657L1 --prod_ver 2020.0.0.F --config_file /var/opt/Autodesk/Adlm/Maya2020/MayaConfig.pit --eula_locale EN_US --feature_id MAYA --lic_method STANDALONE --serial_number 666-69696969 --sel_prod_key 657L1

  mkdir -p ~/maya/2020
  echo -e "MAYA_DISABLE_CIP=1\nMAYA_DISABLE_CER=1\nLC_ALL=C\nMAYA_CM_DISABLE_ERROR_POPUPS=1\nMAYA_COLOR_MGT_NO_LOGGING=1" >> ~/maya/2020/Maya.env
fi
