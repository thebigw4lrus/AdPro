require 'rails_helper'

RSpec.describe AdPro::V1 do
  describe 'Integration' do
    let(:banners) do
      get('banners/')
      JSON.parse(response.body).map do |banner|
        [banner['name'], banner['id']]
      end.to_h
    end

    let(:campaigns) do
      get('campaigns/')
      JSON.parse(response.body).map do |campaign|
        [campaign['name'], campaign['id']]
      end.to_h
    end

    before do
      Timecop.freeze(Date.new(2015, 10, 21))

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
    end

    after { Timecop.return }

    it 'manages properly all operations campaign/banners related' do
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

    it 'retrieves all possible ads at 14:00' do
      campaign_id = campaigns['campaign1']
      banner1_id = banners['banner1']
      banner2_id = banners['banner2']

      # Set up external IpToTime service to
      # retrieve 14:00
      ip_to_time = double('ip_to_time')
      allow(ip_to_time).to receive(:get)
        .and_return(DateTime.new(2015, 1, 1, 14, 0, 0))
      allow(AdPro::IpToTime).to receive(:new).and_return(ip_to_time)

      # A campaign is configured with
      # banners at 14 and 17
      input = {
        'id' => campaigns['campaign1'],
        'banners' => [
          {
            'banner_id' => banner1_id,
            'time_slot' => 14
          },
          {
            'banner_id' => banner2_id,
            'time_slot' => 17
          }
        ]
      }
      put("campaigns/#{campaign_id}/banners",
          input.to_json, 'CONTENT_TYPE' => 'application/json')

      # Get all ads (It will  try to get the one at 14:00)
      get('ads/')
      json = JSON.parse(response.body)

      expected = {
        'time_slot' => 14,
        'banners' => [
          {
            'id' => banner1_id,
            'name' => 'banner1',
            'url' => 'http://somebanner1',
            'campaign_id' => campaign_id,
            'campaign_name' => 'campaign1'
          }
        ]
      }

      expect(json).to eq(expected)
    end
  end
end
