require 'rails_helper'

RSpec.describe V1::CampaignsController do
  describe 'GET /campagins' do
    it 'returns 200 status' do
      get('v1/campaigns')

      expect(response).to have_http_status :ok
    end

    it 'returns an empty array when there is no campaigns' do
      get('v1/campaigns')

      json = JSON.parse(response.body)

      expect(json).to be_empty
    end

    it 'returns an array of existing campaigns' do
      Campaign.create(name: 'campaign1')
      Campaign.create(name: 'campaign2')

      get('v1/campaigns')

      json = JSON.parse(response.body)

      expect(json.length).to eq(2)
    end
  end

  describe 'POST /campaigns' do
    it 'returns 201 when a campaign is created' do
      parameters = { name: 'campaign1' }
      post('v1/campaigns', parameters)

      expect(response).to have_http_status :created
    end

    it 'creates a valid campaign' do
      parameters = { name: 'campaign1' }
      post('v1/campaigns', parameters)

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'campaign1')
    end

    it 'returns 400 when no name is provided for the campaign' do
      post('v1/campaigns')

      expect(response).to have_http_status :bad_request
    end
  end

  describe 'PUT /campaigns' do
    it 'returns 200 when a campaign is updated' do
    end
  end
end
