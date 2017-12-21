require 'rails_helper'

RSpec.describe AdPro::Adapters::ActiveRecord::Campaign do
  let(:campaign) { described_class.new }
  let(:frozen_time) { Time.utc(2015, 10, 21).in_time_zone }

  before do
    Timecop.freeze(frozen_time)

    Campaign.create(name: 'campaign1', id: 1)
    Campaign.create(name: 'campaign2', id: 2)
  end
  after do
    Timecop.return
  end

  it 'retrieves all existent campaigns' do
    campaigns = campaign.all

    expected = [
      {
        'id' => 1,
        'name' => 'campaign1',
        'created_at' => frozen_time,
        'updated_at' => frozen_time
      },
      {
        'id' => 2,
        'name' => 'campaign2',
        'created_at' => frozen_time,
        'updated_at' => frozen_time
      }
    ]

    expect(campaigns).to eq(expected)
  end

  it 'retrieves one single campaigns' do
    campaigns = campaign.get 1

    expected = {
      'id' => 1,
      'name' => 'campaign1',
      'created_at' => frozen_time,
      'updated_at' => frozen_time
    }

    expect(campaigns).to eq(expected)
  end

  it 'creates a campaign' do
    new_campaign = campaign.create('campaign_created', 10)

    expected = {
      'id' => 10,
      'name' => 'campaign_created',
      'created_at' => frozen_time,
      'updated_at' => frozen_time
    }

    expect(new_campaign).to eq(expected)
    expect { Campaign.find(10) }.not_to raise_error
  end

  it 'updates a campaign' do
    updated_campaign = campaign.update(1, 'new_name')

    expected = {
      'id' => 1,
      'name' => 'new_name',
      'created_at' => frozen_time,
      'updated_at' => frozen_time
    }

    expect(updated_campaign).to eq(expected)
    expect(Campaign.find(1).name).to eq('new_name')
  end

  it 'deletes a campaign' do
    deleted_campaign = campaign.delete(1)

    expected = {
      'id' => 1,
      'name' => 'campaign1',
      'created_at' => frozen_time,
      'updated_at' => frozen_time
    }

    expect(deleted_campaign).to eq(expected)
    expect { Campaign.find(1) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
