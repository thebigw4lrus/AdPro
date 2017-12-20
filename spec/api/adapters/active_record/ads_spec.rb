require 'rails_helper'

RSpec.describe AdPro::Adapters::ActiveRecord::Ads do
  let(:time_slot_adapter) { AdPro::Adapters::ActiveRecord::TimeSlot.new }
  let(:ads) { described_class.new }

  it 'only retrieves banners to be shown at 17:00' do
    Campaign.create(name: 'campaign1', id: 1)

    Banner.create(name: 'banner1', url: 'http://url1', id: 1)
    Banner.create(name: 'banner2', url: 'http://url2', id: 2)
    Banner.create(name: 'banner3', url: 'http://url3', id: 3)

    TimeSlot.create(slot: 7, campaign_id: 1, banner_id: 1)
    TimeSlot.create(slot: 17, campaign_id: 1, banner_id: 2)
    TimeSlot.create(slot: 17, campaign_id: 1, banner_id: 3)

    expected = {
      'banners' => [
        {
          'id' => 2,
          'name' => 'banner2',
          'url' => 'http://url2'
        },
        {
          'id' => 3,
          'name' => 'banner3',
          'url' => 'http://url3'
        }
      ]
    }

    expect(ads.get(17)).to eq(expected)
  end
end
