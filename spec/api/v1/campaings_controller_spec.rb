require 'rails_helper'

RSpec.describe V1::CampaignsController do
  describe 'GET /campagins' do
    it 'returns 200 status' do
      get('campaigns/')

      expect(response).to have_http_status :ok
    end

    it 'returns an empty array when there is no campaigns' do
      get('campaigns/')

      json = JSON.parse(response.body)

      expect(json).to be_empty
    end

    it 'returns an array of existing campaigns' do
      Campaign.create(name: 'campaign1')
      Campaign.create(name: 'campaign2')

      get('campaigns/')

      json = JSON.parse(response.body)

      expect(json.length).to eq(2)
    end
  end

  describe 'POST /campaigns' do
    it 'returns 201 when a campaign is created' do
      parameters = { name: 'campaign1' }
      post('campaigns/', parameters)

      expect(response).to have_http_status :created
    end

    it 'creates a valid campaign' do
      parameters = { name: 'campaign1' }
      post('campaigns/', parameters)

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'campaign1')
    end

    it 'returns 400 when no name is provided for the campaign' do
      post('campaigns/')

      json = JSON.parse(response.body)

      expect(response).to have_http_status :bad_request
      expect(json['error']).to eq('name is missing')
    end
  end

  describe 'PUT /campaigns' do
    it 'returns 200 if it tries to modify an existent campaign' do
      Campaign.create(name: 'campaign1', id: 1)

      parameters = { name: 'modified' }
      put('campaigns/1', parameters)

      expect(response).to have_http_status :ok
    end

    it 'modifies succesfully an existing campaign' do
      Campaign.create(name: 'campaign1', id: 1)

      parameters = { name: 'modified' }
      put('campaigns/1', parameters)

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'modified')
    end

    it 'returns 404 if it tries to modify an unexistent campaign' do
      parameters = { name: 'modified' }
      put('campaigns/1', parameters)

      expect(response).to have_http_status :not_found
    end
  end

  describe 'PATCH /campaigns' do
    it 'returns 200 if it tries to modify an existent campaign' do
      Campaign.create(name: 'campaign1', id: 1)

      parameters = { name: 'modified' }
      patch('campaigns/1', parameters)

      expect(response).to have_http_status :ok
    end

    it 'modifies succesfully an existing campaign' do
      Campaign.create(name: 'campaign1', id: 1)

      parameters = { name: 'modified' }
      patch('campaigns/1', parameters)

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'modified')
    end

    it 'returns 404 if it tries to modify an unexistent campaign' do
      parameters = { name: 'modified' }
      patch('campaigns/1', parameters)

      expect(response).to have_http_status :not_found
    end
  end
end
