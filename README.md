# AdPro
Usage

```shell
#CREATE CAMPAIGN AND BANNERS
> http POST localhost:3000/campaigns/ name='christmas eve'
HTTP/1.1 201 Created
Content-Type: application/json
Date: Thu, 21 Dec 2017 18:14:38 GMT

{
    "created_at": "2017-12-21T18:14:38.174Z",
    "id": 3,
    "name": "christmas eve",
    "updated_at": "2017-12-21T18:14:38.174Z"
}

> http POST localhost:3000/banners/ name='iphoneX' url='http://someurl'
HTTP/1.1 201 Created
Content-Type: application/json
Date: Thu, 21 Dec 2017 18:17:38 GMT

{
    "created_at": "2017-12-21T18:17:38.596Z",
    "id": 1,
    "name": "iphoneX",
    "updated_at": "2017-12-21T18:17:38.596Z",
    "url": "http://someurl"
}

> http POST localhost:3000/banners/ name='Alexa Device' url='http://someurl2'
HTTP/1.1 201 Created
Content-Type: application/json
Date: Thu, 21 Dec 2017 18:18:35 GMT

{
    "created_at": "2017-12-21T18:18:35.054Z",
    "id": 2,
    "name": "Alexa Device",
    "updated_at": "2017-12-21T18:18:35.054Z",
    "url": "http://someurl2"
}

#ASSIGN BANNERS TO CAMPAIGN
> http PUT localhost:3000/campaigns/3/banners \
banners:='[{"banner_id": "1", "time_slot": "19"},\
{"banner_id": "2","time_slot": "19"}]'

HTTP/1.1 200 OK
Content-Type: application/json
Date: Thu, 21 Dec 2017 18:18:35 GMT
{
    "banners": [
        {
            "id": 1,
            "name": "iphoneX",
            "time_slot": 19,
            "url": "http://someurl"
        },
        {
            "id": 2,
            "name": "Alexa Device",
            "time_slot": 19,
            "url": "http://someurl2"
        }
    ],
    "created_at": "2017-12-21T18:14:38.000Z",
    "id": 3,
    "name": "christmas eve",
    "updated_at": "2017-12-21T18:14:38.000Z"
}

#GET ALL ADS CONFIGURED 9 AM Berlin Time
> http GET localhost:3000/ads
HTTP/1.1 200 OK
Content-Type: application/json
Date: Thu, 21 Dec 2017 18:33:32 GMT

{
    "time_slot" => 9,
    "banners": [
        {
            "id": 1,
            "name": "iphoneX",
            "url": "http://someurl"
        },
        {
            "id": 1,
            "name": "iphoneX",
            "url": "http://someurl"
        }
    ]
}
```
