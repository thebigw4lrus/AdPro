require 'rails_helper'

RSpec.describe AdPro::Adapters::ActiveRecord::Banner do
  let(:banner) { described_class.new }
  let(:frozen_time) { Time.utc(2015, 10, 21).in_time_zone }

  before do
    Timecop.freeze(frozen_time)

    Banner.create(name: 'banner1', url: 'http://url1', id: 1)
    Banner.create(name: 'banner2', url: 'http://url2', id: 2)
  end
  after do
    Timecop.return
  end

  it 'retrieves all existent campaigns' do
    expected = [
      {
        'id' => 1,
        'name' => 'banner1',
        'url' => 'http://url1',
        'created_at' => frozen_time,
        'updated_at' => frozen_time
      },
      {
        'id' => 2,
        'name' => 'banner2',
        'url' => 'http://url2',
        'created_at' => frozen_time,
        'updated_at' => frozen_time
      }
    ]

    expect(banner.all).to eq(expected)
  end

  it 'retrieves one single banner' do
    expected = {
      'id' => 1,
      'name' => 'banner1',
      'url' => 'http://url1',
      'created_at' => frozen_time,
      'updated_at' => frozen_time
    }

    expect(banner.get(1)).to eq(expected)
  end

  it 'creates a banner' do
    new_banner = banner.create('banner_created',
                               'http://url',
                               10)
    expected = {
      'id' => 10,
      'name' => 'banner_created',
      'url' => 'http://url',
      'created_at' => frozen_time,
      'updated_at' => frozen_time
    }

    expect(new_banner).to eq(expected)
    expect { Banner.find(10) }.not_to raise_error
  end

  it 'updates a banner' do
    updated_banner = banner.update(1, 'new_name',
                                   'http://new_url')

    expected = {
      'id' => 1,
      'name' => 'new_name',
      'url' => 'http://new_url',
      'created_at' => frozen_time,
      'updated_at' => frozen_time
    }

    expect(updated_banner).to eq(expected)
    expect(Banner.find(1).name).to eq('new_name')
  end

  it 'deletes a banner' do
    deleted_banner = banner.delete(1)

    expected = {
      'id' => 1,
      'name' => 'banner1',
      'url' => 'http://url1',
      'created_at' => frozen_time,
      'updated_at' => frozen_time
    }

    expect(deleted_banner).to eq(expected)
    expect { Banner.find(1) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
