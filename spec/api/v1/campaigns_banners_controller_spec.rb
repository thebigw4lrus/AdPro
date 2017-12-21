require 'rails_helper'

RSpec.describe 'V1::CampaignsController' do
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

    it 'update banners assignation when there is no previous setup' do
      Campaign.create(name: 'campaign1', id: 1)
      Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)
      Banner.create(name: 'banner2', url: 'http://somebanner2', id: 2)

      input = {
        'id' => 1,
        'banners' => [
          {
            'banner_id' => 1,
            'time_slot' => 2
          },
          {
            'banner_id' => 2,
            'time_slot' => 7
          }
        ]
      }

      put('campaigns/1/banners', input)

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

    it 'update banners assignation when all banners are removed' do
      Campaign.create(name: 'campaign1', id: 1)
      Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)
      Banner.create(name: 'banner2', url: 'http://somebanner2', id: 2)
      TimeSlot.create(id: 1, banner_id: 1, slot: 7)

      input = {
        'id' => 1,
        'banners' => []
      }

      put('campaigns/1/banners', input.to_json)

      expected = {
        'id' => 1,
        'name' => 'campaign1',
        'created_at' => '2015-10-21T00:00:00.000Z',
        'updated_at' => '2015-10-21T00:00:00.000Z',
        'banners' => []
      }

      json = JSON.parse(response.body)

      expect(json).to eq(expected)
    end

    it 'update banners assignation when banners are updated' do
      Campaign.create(name: 'campaign1', id: 1)
      Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)
      Banner.create(name: 'banner2', url: 'http://somebanner2', id: 2)
      TimeSlot.create(id: 1, banner_id: 1, slot: 2)

      input = {
        'id' => 1,
        'banners' => [
          {
            'banner_id' => 1,
            'time_slot' => 2
          },
          {
            'banner_id' => 2,
            'time_slot' => 7
          }
        ]
      }

      put('campaigns/1/banners', input)

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

    it 'returns 409 when a campaign an invalid banner is introduced' do
      Campaign.create(name: 'campaign1', id: 1)
      Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)
      Banner.create(name: 'banner2', url: 'http://somebanner2', id: 2)
      TimeSlot.create(id: 1, banner_id: 1, slot: 2)

      input = {
        'id' => 1,
        'banners' => [
          {
            'banner_id' => 1,
            'time_slot' => 2
          },
          {
            'banner_id' => 2,
            'time_slot' => 24
          }
        ]
      }

      put('campaigns/1/banners', input)

      expect(response).to have_http_status :bad_request
    end
  end
end
