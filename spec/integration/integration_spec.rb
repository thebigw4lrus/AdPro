require 'rails_helper'

RSpec.describe AdPro::V1 do
  describe 'Integration' do
    before do
      Timecop.freeze(Date.new(2015, 10, 21))
    end

    after { Timecop.return }

    it 'manages properly all operations campaign/banners related' do
      # Creates all banners
      banner1 = { name: 'banner1', url: 'http://somebanner1' }
      banner2 = { name: 'banner2', url: 'http://somebanner2' }
      post('banners/',
           banner1.to_json, 'CONTENT_TYPE' => 'application/json')
      post('banners/',
           banner2.to_json, 'CONTENT_TYPE' => 'application/json')

      # Create all campaigns
      parameters = { name: 'campaign1' }
      post('campaigns/',
           parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      # Gets banners and campaigns ids
      get('banners/')
      banners = JSON.parse(response.body).map do |banner|
        [banner['name'], banner['id']]
      end.to_h

      get('campaigns/')
      campaigns = JSON.parse(response.body).map do |campaign|
        [campaign['name'], campaign['id']]
      end.to_h

      campaign_id = campaigns['campaign1']
      banner1_id = banners['banner1']
      banner2_id = banners['banner2']

      # Inspect Banners attached to the campaign
      # Non-banners set up is expected
      get("campaigns/#{campaign_id}/banners/")
      json = JSON.parse(response.body)

      expected = {
        'id' => campaign_id,
        'name' => 'campaign1',
        'created_at' => '2015-10-21T00:00:00.000Z',
        'updated_at' => '2015-10-21T00:00:00.000Z',
        'banners' => []
      }
      expect(json).to eq(expected)

      # Two existent banners are assigned to the campaign
      # in the same time slot
      input = {
        'id' => campaigns['campaign1'],
        'banners' => [
          {
            'banner_id' => banner1_id,
            'time_slot' => 2
          },
          {
            'banner_id' => banner2_id,
            'time_slot' => 2
          }
        ]
      }
      put("campaigns/#{campaign_id}/banners",
          input.to_json, 'CONTENT_TYPE' => 'application/json')

      # Inspect Banners attached to the campaign
      # Two banners at 2:00  are expected
      get("campaigns/#{campaign_id}/banners/")
      json = JSON.parse(response.body)

      expected = {
        'id' => campaign_id,
        'name' => 'campaign1',
        'created_at' => '2015-10-21T00:00:00.000Z',
        'updated_at' => '2015-10-21T00:00:00.000Z',
        'banners' => [
          {
            'id' => banner1_id,
            'name' => 'banner1',
            'url' => 'http://somebanner1',
            'time_slot' => 2
          },
          {
            'id' => banner2_id,
            'name' => 'banner2',
            'url' => 'http://somebanner2',
            'time_slot' => 2
          }
        ]
      }
      expect(json).to eq(expected)

      # Now banner2 is removed and banner1 is reconfigured
      # to show up at 14:00
      input = {
        'id' => campaigns['campaign1'],
        'banners' => [
          {
            'banner_id' => banner1_id,
            'time_slot' => 14
          }
        ]
      }
      put("campaigns/#{campaign_id}/banners",
          input.to_json, 'CONTENT_TYPE' => 'application/json')

      # Inspect Banners attached to the campaign
      # One banner at 14:00 is expected
      get("campaigns/#{campaign_id}/banners/")
      json = JSON.parse(response.body)

      expected = {
        'id' => campaign_id,
        'name' => 'campaign1',
        'created_at' => '2015-10-21T00:00:00.000Z',
        'updated_at' => '2015-10-21T00:00:00.000Z',
        'banners' => [
          {
            'id' => banner1_id,
            'name' => 'banner1',
            'url' => 'http://somebanner1',
            'time_slot' => 14
          }
        ]
      }
      expect(json).to eq(expected)

      # Now banner2 is added back
      # to show up at 13:00
      input = {
        'id' => campaigns['campaign1'],
        'banners' => [
          {
            'banner_id' => banner1_id,
            'time_slot' => 14
          },
          {
            'banner_id' => banner2_id,
            'time_slot' => 13
          }
        ]
      }
      put("campaigns/#{campaign_id}/banners",
          input.to_json, 'CONTENT_TYPE' => 'application/json')

      # Inspect Banners attached to the campaign
      # One banner at 14 and the other at 13 is expected
      get("campaigns/#{campaign_id}/banners/")
      json = JSON.parse(response.body)

      expected = {
        'id' => campaign_id,
        'name' => 'campaign1',
        'created_at' => '2015-10-21T00:00:00.000Z',
        'updated_at' => '2015-10-21T00:00:00.000Z',
        'banners' => [
          {
            'id' => banner1_id,
            'name' => 'banner1',
            'url' => 'http://somebanner1',
            'time_slot' => 14
          },
          {
            'id' => banner2_id,
            'name' => 'banner2',
            'url' => 'http://somebanner2',
            'time_slot' => 13
          }
        ]
      }
      expect(json).to eq(expected)
    end
  end
end
