require 'rails_helper'

RSpec.describe V1::CampaignsController do
  describe 'GET /campaigns/banners' do
    before { Timecop.freeze(Date.new(2015, 10, 21)) }
    after { Timecop.return }

    it 'retrieves a list a banners per campaign' do
      campaign1 = Campaign.create(name: 'campaign1', id: 1)
      banner1 = Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)
      banner2 = Banner.create(name: 'banner2', url: 'http://somebanner2', id: 2)
      TimeSlot.create(slot: 2, banner: banner1, campaign: campaign1)
      TimeSlot.create(slot: 7, banner: banner2, campaign: campaign1)

      get('campaigns/1/banners')

      expected = {
        'id' => 1,
        'name' => 'campaign1',
        'created_at' => '2015-10-21T00:00:00.000Z',
        'updated_at' => '2015-10-21T00:00:00.000Z',
        'banners' => [
          {
            'id' => 1,
            'name' => 'banner1',
            'url' => 'http://somebanner1',
            'time_slot' => 2
          },
          {
            'id' => 2,
            'name' => 'banner2',
            'url' => 'http://somebanner2',
            'time_slot' => 7
          }
        ]
      }

      json = JSON.parse(response.body)

      expect(json).to eq(expected)
    end
  end
end
