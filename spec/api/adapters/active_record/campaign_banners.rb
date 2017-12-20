require 'rails_helper'

RSpec.describe AdPro::Adapters::ActiveRecord::CampaignBanners do
  let(:time_slot_adapter) { AdPro::Adapters::ActiveRecord::TimeSlot.new }
  let(:campaign_banners) { described_class.new(time_slot_adapter) }
  let(:frozen_time) { Time.utc(2015, 10, 21).in_time_zone }

  before do
    Timecop.freeze(frozen_time)

    Banner.create(name: 'banner1', url: 'http://url1', id: 1)
    Banner.create(name: 'banner2', url: 'http://url2', id: 2)
    Banner.create(name: 'banner3', url: 'http://url3', id: 3)

    Campaign.create(name: 'campaign1', id: 1)
  end
  after do
    Timecop.return
  end

  it 'retrieves an existent campaigns with banners configured' do
    TimeSlot.create(slot: 7, campaign_id: 1, banner_id: 1)
    TimeSlot.create(slot: 3, campaign_id: 1, banner_id: 2)
    TimeSlot.create(slot: 5, campaign_id: 1, banner_id: 3)

    expected = {
      'id' => 1,
      'name' => 'campaign1',
      'created_at' => frozen_time,
      'updated_at' => frozen_time,
      'banners' => [
        {
          'id' => 1,
          'name' => 'banner1',
          'url' => 'http://url1',
          'time_slot' => 7
        },
        {
          'id' => 2,
          'name' => 'banner2',
          'url' => 'http://url2',
          'time_slot' => 3
        },
        {
          'id' => 3,
          'name' => 'banner3',
          'url' => 'http://url3',
          'time_slot' => 5
        }
      ]
    }

    expect(campaign_banners.get(1)).to eq(expected)
  end

  context '.upsert' do
    it 'upsert when there is no record' do
      banners = [
        {
          'banner_id' => 1,
          'time_slot' => 7
        },
        {
          'banner_id' => 2,
          'time_slot' => 3
        },
        {
          'banner_id' => 3,
          'time_slot' => 5
        }
      ]

      campaign_banners.upsert(1, banners)

      expect(campaign_banners.get(1)).to eq(
        'id' => 1,
        'name' => 'campaign1',
        'created_at' => frozen_time,
        'updated_at' => frozen_time,
        'banners' => [
          {
            'id' => 1,
            'name' => 'banner1',
            'url' => 'http://url1',
            'time_slot' => 7
          },
          {
            'id' => 2,
            'name' => 'banner2',
            'url' => 'http://url2',
            'time_slot' => 3
          },
          {
            'id' => 3,
            'name' => 'banner3',
            'url' => 'http://url3',
            'time_slot' => 5
          }
        ]
      )
    end

    it 'upsert when there one record is added' do
      TimeSlot.create(slot: 7, campaign_id: 1, banner_id: 1)

      banners = [
        {
          'banner_id' => 1,
          'time_slot' => 7
        },
        {
          'banner_id' => 2,
          'time_slot' => 3
        }
      ]

      campaign_banners.upsert(1, banners)

      expect(campaign_banners.get(1)).to eq(
        'id' => 1,
        'name' => 'campaign1',
        'created_at' => frozen_time,
        'updated_at' => frozen_time,
        'banners' => [
          {
            'id' => 1,
            'name' => 'banner1',
            'url' => 'http://url1',
            'time_slot' => 7
          },
          {
            'id' => 2,
            'name' => 'banner2',
            'url' => 'http://url2',
            'time_slot' => 3
          }
        ]
      )
    end

    it 'upsert when there one record is deleted' do
      TimeSlot.create(slot: 7, campaign_id: 1, banner_id: 1)
      TimeSlot.create(slot: 3, campaign_id: 1, banner_id: 2)

      banners = [
        {
          'banner_id' => 1,
          'time_slot' => 7
        }
      ]

      campaign_banners.upsert(1, banners)

      expect(campaign_banners.get(1)).to eq(
        'id' => 1,
        'name' => 'campaign1',
        'created_at' => frozen_time,
        'updated_at' => frozen_time,
        'banners' => [
          {
            'id' => 1,
            'name' => 'banner1',
            'url' => 'http://url1',
            'time_slot' => 7
          }
        ]
      )
    end

    it 'upsert when all records are deleted' do
      TimeSlot.create(slot: 7, campaign_id: 1, banner_id: 1)
      TimeSlot.create(slot: 3, campaign_id: 1, banner_id: 2)

      banners = []

      campaign_banners.upsert(1, banners)

      expect(campaign_banners.get(1)).to eq(
        'id' => 1,
        'name' => 'campaign1',
        'created_at' => frozen_time,
        'updated_at' => frozen_time,
        'banners' => []
      )
    end
  end
end
