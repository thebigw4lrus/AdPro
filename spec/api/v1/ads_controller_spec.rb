require 'rails_helper'

RSpec.describe 'V1::CampaignsController' do
  describe 'GET /ads' do
    before do
      Timecop.freeze(Date.new(2015, 10, 21))

      campaign1 = Campaign.create(name: 'campaign1', id: 1)
      banner1 = Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)
      banner2 = Banner.create(name: 'banner2', url: 'http://somebanner2', id: 2)
      TimeSlot.create(slot: 2, banner: banner1, campaign: campaign1)
      TimeSlot.create(slot: 7, banner: banner2, campaign: campaign1)
    end
    after { Timecop.return }

    it 'retrieves a list a banners per hour querying the time from remote' do
      ip_to_time = double('ip_to_time')
      mock_time = DateTime.new(2015, 1, 1, 2, 0, 0) # hour = 2
      allow(ip_to_time).to receive(:get).and_return(mock_time)
      allow(AdPro::IpToTime).to receive(:new).and_return(ip_to_time)

      get('/ads/')

      expected = {
        'banners' => [
          {
            'id' => 1,
            'name' => 'banner1',
            'url' => 'http://somebanner1'
          }
        ]
      }

      json = JSON.parse(response.body)

      expect(json).to eq(expected)
    end
  end
end
