#!/bin/bash
# it needs registration in https://www.sofiyskavoda.bg/

user="" # user from registration 
pass="" # pass fron registration

WOut=$(curl 'https://www.sofiyskavoda.bg/' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'priority: u=0, i' \
  -H 'sec-ch-ua: "Not;A=Brand";v="8", "Chromium";v="150", "Google Chrome";v="150"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: none' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36' -i -s  | grep -e 'token' -e 'my_name' -e 'valid_from' -e 'XSRF-TOKEN' -e 'sofia_water_session')

XSRF=$(<<<${WOut} grep -Po 'XSRF-TOKEN=\K[^;]*')
SFWTSESS=$(<<<${WOut} grep -Po 'sofia_water_session=\K[^;]*')

TOKEN=$(<<<${WOut} grep '_token' | grep -Po 'value="\K[^"]*')
MNAME=$(<<<${WOut} grep -m1 'my_name' | grep -Po 'id="\K[^"]*')
VALFROM=$(<<<${WOut} grep valid_from -m1 | grep -Po 'value="\K[^"]*')
sleep 1


POut=$(curl -XGET -s -i 'https://www.sofiyskavoda.bg/survey/get' \
  -H 'accept: */*' \
  -H 'accept-language: en-US,en;q=0.9' \
  -b "XSRF-TOKEN=${XSRF}; sofia_water_session=${SFWTSESS}" \
  -H 'priority: u=1, i' \
  -H 'referer: https://www.sofiyskavoda.bg/login' \
  -H 'sec-ch-ua: "Not;A=Brand";v="8", "Chromium";v="150", "Google Chrome";v="150"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36' \
  -H 'x-requested-with: XMLHttpRequest' -L )

PXSRF=$(<<<${WOut} grep -m1 -Po 'XSRF-TOKEN=\K[^;]*')
PSFWTSESS=$(<<<${WOut} grep -m1 -Po 'sofia_water_session=\K[^;]*')
sleep 1


ZOut=$(curl -s -i -L 'https://www.sofiyskavoda.bg/login' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cache-control: max-age=0' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -b "XSRF-TOKEN=${PXSRF}; sofia_water_session=${PSFWTSESS}" \
  -H 'origin: https://www.sofiyskavoda.bg' \
  -H 'priority: u=0, i' \
  -H 'referer: https://www.sofiyskavoda.bg/login' \
  -H 'sec-ch-ua: "Not;A=Brand";v="8", "Chromium";v="150", "Google Chrome";v="150"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36' \
  --data-raw "_token=${TOKEN}&${MNAME}=&valid_from=${VALFROM}&email=${user}&password=${pass}")

NXSRF=$(<<<${WOut} grep -m1 -Po 'XSRF-TOKEN=\K[^;]*')
NSFWTSESS=$(<<<${WOut} grep -m1 -Po 'sofia_water_session=\K[^;]*')
sleep 1


yOut=$(curl -s 'https://www.sofiyskavoda.bg/cp/invoice-payments' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: en-US,en;q=0.9' \
  -b "XSRF-TOKEN=${NXSRF}; sofia_water_session=${NSFWTSESS}" \
  -H 'priority: u=0, i' \
  -H 'referer: https://www.sofiyskavoda.bg/cp/consumption-reports' \
  -H 'sec-ch-ua: "Not;A=Brand";v="8", "Chromium";v="150", "Google Chrome";v="150"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-user: ?1' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36' -L )

<<<${yOut} cat | lynx -dump -stdin | grep 'Клиентски баланс' -A23
