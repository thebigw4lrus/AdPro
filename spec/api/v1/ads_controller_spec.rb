require 'rails_helper'

RSpec.describe V1::CampaignsController do
  describe 'GET /ads' do
    before { Timecop.freeze(Date.new(2015, 10, 21)) }
    after { Timecop.return }

    it 'retrieves a list a banners per hour' do
      campaign1 = Campaign.create(name: 'campaign1', id: 1)
      banner1 = Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)
      banner2 = Banner.create(name: 'banner2', url: 'http://somebanner2', id: 2)
      TimeSlot.create(slot: 2, banner: banner1, campaign: campaign1)
      TimeSlot.create(slot: 7, banner: banner2, campaign: campaign1)

      get('/ads/7')

      expected = {
        'banners' => [
          {
            'id' => 2,
            'name' => 'banner2',
            'url' => 'http://somebanner2'
          }
        ]
      }

      json = JSON.parse(response.body)

      expect(json).to eq(expected)
    end
  end
end
