# AdPro
Usage

```shell
#CREATE CAMPAIGN AND BANNERS
> http POST localhost:3000/v1/campaigns/ name='christmas eve'
HTTP/1.1 201 Created
Content-Type: application/json
Date: Thu, 21 Dec 2017 18:14:38 GMT

{
    "created_at": "2017-12-21T18:14:38.174Z",
    "id": 1,
    "name": "christmas eve",
    "updated_at": "2017-12-21T18:14:38.174Z"
}

> http POST localhost:3000/v1/banners/ name='iphoneX' url='http://someurl'
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

> http POST localhost:3000/v1/banners/ name='Alexa Device' url='http://someurl2'
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
> http PUT localhost:3000/v1/campaigns/1/banners \
banners:='[{"banner_id": "1", "time_slot": "10"},\
{"banner_id": "2","time_slot": "10"}]'

HTTP/1.1 200 OK
Content-Type: application/json
Date: Thu, 21 Dec 2017 18:18:35 GMT
{
    "banners": [
        {
            "id": 1,
            "name": "iphoneX",
            "time_slot": 10,
            "url": "http://someurl"
        },
        {
            "id": 2,
            "name": "Alexa Device",
            "time_slot": 10,
            "url": "http://someurl2"
        }
    ],
    "created_at": "2017-12-21T18:14:38.000Z",
    "id": 3,
    "name": "christmas eve",
    "updated_at": "2017-12-21T18:14:38.000Z"
}

#GET ALL ADS CONFIGURED 10 Hrs Berlin Time
> http GET localhost:3000/v1/ads
HTTP/1.1 200 OK
Content-Type: application/json
Date: Thu, 21 Dec 2017 18:33:32 GMT

{
    "banners": [
        {
            "id": 1,
            "name": "iphoneX",
            "url": "http://someurl"
            "campaign_id": 1,
            "campaign_name": "christmas eve"
            
        },
        {
            "id": 2,
            "name": "Alexa Device",
            "url": "http://someurl2",
            "campaign_id": 1,
            "campaign_name": "christmas eve"
        }
    ],
    "time_slot": 10
}
```
