#!/bin/bash
echo "===================================================================================="
echo "||   ___       ___                                                                ||";
echo "||  |  _|     |_  |    _           _   _                                          ||";
echo "||  | | ___ ___ | |___| |_ ___ ___| |_|_|___ ___    ___ ___ ___ _ _ ___ ___ ___   ||";
echo "||  | ||  _| -_|| |_ -|  _| .'|  _|  _| |   | . |  |_ -| -_|  _| | | -_|  _|_ -|  ||";
echo "||  | ||_| |___|| |___|_| |__,|_| |_| |_|_|_|_  |  |___|___|_|  \_/|___|_| |___|  ||";
echo "||  |___|     |___|                         |___|                                 ||";
echo "||                                                                                ||"
echo "===================================================================================="
echo "      "
echo "      "

# REMOVE DEFAULT
rm -rf /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/sites-available/default

rm -rf /etc/nginx/sites-enabled/default.dpkg-dist
rm -rf /etc/nginx/sites-available/default.dpkg-dist

# SYMLINKING ALL FILES THAT AREN'T ALREADY THERE
FILES=/etc/nginx/sites-available/*
for f in $FILES
do
    if [ -e $f ]
    then
        filename="${f##*/}"
        if [ ! -e "/etc/nginx/sites-enabled/$filename" ] ; then
            sudo ln -s $f /etc/nginx/sites-enabled/
        fi
    fi
done

# RESTARTUNG NGINX
sudo service nginx restart

SERVERID=`ps ax | grep -v grep | grep bin/nodejs | awk '{print $1}'`
if [ ! -z "$SERVERID" ]
then
    echo "server running"
    ps ax | grep -v grep | grep bin/nodejs | awk '{print $1}' | xargs sudo kill
fi

dir=/var/www
forever start --minUptime 1000 --spinSleepTime 1000 --no-colors --sourceDir $dir --watchDirectory $dir --watchIgnore **/*.log --watch server.js 

