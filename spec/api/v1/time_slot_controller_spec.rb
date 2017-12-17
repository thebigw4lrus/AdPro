require 'rails_helper'

RSpec.describe 'TimeSlot resource' do
  describe 'GET|POST|DELETE campaigns/x/banners/y/time_slots/z' do
    it 'returns an array of existing time_slots' do
      campaign1 = Campaign.create(name: 'campaign1', id: 1)
      banner2 = Banner.create(name: 'banner2', url: 'http://somebanner2', id: 2)
      TimeSlot.create(slot: 7, campaign: campaign1, banner: banner2)

      get('campaigns/1/banners/2/time_slot/7')

      json = JSON.parse(response.body)

      expect(json.length).to eq(1)
    end
  end
end
