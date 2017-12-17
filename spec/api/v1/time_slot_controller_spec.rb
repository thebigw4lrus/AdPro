require 'rails_helper'

RSpec.describe 'TimeSlot resource' do
  describe 'GET|POST|DELETE campaigns/x/banners/y/time_slots/z' do
    it 'assigns a time slot to an existing campaign/banner' do
      Campaign.create(name: 'campaign1', id: 1)
      Banner.create(name: 'banner2', url: 'http://somebanner2', id: 2)

      post('campaigns/1/banners/2/time_slots/7')

      json = JSON.parse(response.body)

      expect(json).to include('slot' => 7)
    end

    it 'deletes a time slot from an existing campaign/banner' do
      campaign = Campaign.create(name: 'campaign1', id: 1)
      banner = Banner.create(name: 'banner2', url: 'http://somebanner2', id: 2)
      TimeSlot.create(slot: 7, banner: banner, campaign: campaign)

      delete('campaigns/1/banners/2/time_slots/7')

      json = JSON.parse(response.body)

      expect(json).to include('slot' => 7)
    end

    it 'it returns 200 when it deletes a time slot' do
      campaign = Campaign.create(name: 'campaign1', id: 1)
      banner = Banner.create(name: 'banner2', url: 'http://somebanner2', id: 2)
      TimeSlot.create(slot: 7, banner: banner, campaign: campaign)

      delete('campaigns/1/banners/2/time_slots/7')

      expect(response).to have_http_status :success
    end
  end
end
