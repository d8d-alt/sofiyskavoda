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


XSRF=$(<<<${WOut} grep 'XSRF-TOKEN' |  cut -d'=' -f2 | cut -d';' -f1 )
SFWTSESS=$(<<<${WOut} grep 'sofia_water_session' |  cut -d'=' -f2 | cut -d';' -f1 )

TOKEN=$(<<<$WOut grep '_token'| awk -F 'value="' {'print $2'} | cut -d'"' -f1)
MNAME=$(<<<${WOut} grep 'my_name' | tail -1 | awk -F 'name="' {'print $2'} | cut -d'"' -f1 )
VALFROM=$(<<<${WOut} grep valid_from | tail -1| awk -F 'value="' {'print $2'} | cut -d'"' -f1 )

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

PXSRF=$(<<<${POut} grep 'XSRF-TOKEN' | head -1 |  cut -d'=' -f2 | cut -d';' -f1 )
PSFWTSESS=$(<<<${POut} grep 'sofia_water_session' | head -1 |  cut -d'=' -f2 | cut -d';' -f1 )

sleep 1


ZOut=$(curl -s -k -i -L 'https://www.sofiyskavoda.bg/login' \
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

NXSRF=$(<<<${ZOut} grep 'XSRF-TOKEN' | head -1 |  cut -d'=' -f2 | cut -d';' -f1 )
NSFWTSESS=$(<<<${ZOut} grep 'sofia_water_session' | head -1 |  cut -d'=' -f2 | cut -d';' -f1 )

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
