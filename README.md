AdPro Plarform
--------------------------------
This project look forward to represent a very first version of a super simple advertisement platform. We will have campaigns that will have banners on them.
It doesn't make sense for all campaigns to be displayed at any time of day. For example, campaigns that focus sports are more effective in the afternoon.

We want to be able to administer the campaigns and banners in our web application. Our consultants need some help also with knowing which campaigns are being displayed now and which banners are being displayed now.

Since not all places in the world have the same time of day we tend to use https://worldtimeiodeveloper.p.mashape.com to find the time of day depending on the visitor's IP address.

Take into account that:
- A campaign needs to have a name.
- A banner needs to have a name too.
- Banners can belong to one or more campaigns.
- Campaigns can be displayed at different times of a day. We can assume that we will only manage display in complete hours. This means that we can say that it will be displayed at 1pm, 3pm and 7pm but not at 12:30 only.
- You can retrieve the date of time of an IP with a request like: https://worldtimeiodeveloper.p.mashape.com/ip?ipaddress=195.110.64.205
- We like clean, efficient code that your team mates will feel comfortable working with and improving.
- Forget about the deployment of the application. Just a simple "rails s" will work.
- The application should be operable though the UI or an API.
- Do not focus in making the UI beautiful. We will value more the quality of the code.

-----------------------------------------
## Asumptions and considerations
* The application only will be operable via API.  I preferred specialize on the API, rather than create an UI that wouldn't looks good.
* This version does not take in account fills or impressions per banner. Concepts that could be added into the code.  This time I preferred to focus in the base design of the structure.
* A different API to translate the IP into Time was used. https://worldtimeiodeveloper.p.mashape.com was down at the moment I built the application.  However, I designed it in a way that such external API can be changed to other provider.  I would recommend for further versions download a DB like GeoDB and from there do the translation.  It is better performance-wise and more secure.
* The upload of the banner image was not taken in account for this phase. Instead it is assumed that some image data bank exists.

## API Design
### Storage
The Data was modeled as a mono-transitive association between Campaign and Banners.  In this kind of association, one needs a third entitiy which is crucial to properly relate those two entities(TimeSlots). Time slot conceptually speaking is not more than the hour in which a banner can be shown in a given Campaign.  TimeSlot is transparent to the REST resource naming(campaigns/1/banners). The storage implementation is kept in the adapter and is not exposed to the API.

For instance: a Campaign can be related to a Banner only through a TimeSlot.  Let's put as an example a campaign that wants to reach working people, when they go to lunch and when they leave office in the evening.. Such campaign would have banners with TimeSlots(hrs) = [12, 13, 14, 17, 18, 19].

### API layering
Efforts were made to maintain the storage logic decoupled from the API.  This is looking forward to balance the code weight among different domains
making the code more readable and scalable.

#### API Layer 
4 different sub-APIS are provided: Campaign, Banner, CampaignBanners(setup of campaigns), Ads (get ads hour-based).  The first 3 are classicals REST
designs.  The fourth one(Ads) is more like a controller resource that will take care of extracting the hour to the client and requesting the proper information
to the Storage.

#### Adapter Layer
The API talks with an adapter.  A very first adapter was created for ActiveRecord.  The motivation behind this is to provide a swappable storage.  If one wants
to implement this in a different storage (partially or totally), a new adapter can be written with the same interface.  Also, it would be appreciated it if this 
grows, to have a way protect the Ad Request latency. For instance, creating a campaign/banner can afford to be slow.  But the association with TimeSlot could be 
high demanded (Ad Request), so new adapters like Redis, MongoDB can be written to fulfill this.

## The good, the bad and the ugly
### The good
- Short classes
- Modularised design
- Unit Test / Integration Test
### The bad
- No time to implement security :(
- Requests tests are done against the DB. The adapter's one too. According with this design, the adapters should talk with the DB, and the request themselves should talk with the adapter, so testing the requests against the DB is an overkill(they should be tested mocking the adapter responses). This represents a coupling point (next version ;))
- I'm aware some corner cases validation-wise can be still need polish.
### The ugly
- Error handling can be improved
- Rails is overkill to host this project. Something simpler could be used.

## Technology Stack
- ruby 2.3.3
- Rails 4
- Mysql 5.6.38
- Grape API
- Rspec
- Rubocop

## Running it
```ruby
bundle install
bundle exec db:create
bundle exec db:migrate
RAILS_ENV=test bundle exec rake db:migrate
bundle exec rspec
bundle exec rails s
```

## An example of usage

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

HOPE YOU LIKE IT ;)
