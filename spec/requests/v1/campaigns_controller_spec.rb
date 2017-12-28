require 'rails_helper'

RSpec.describe AdPro::V1::Campaigns do
  context 'GET /campagins' do
    it 'returns 200 status' do
      get('v1/campaigns/')

      expect(response).to have_http_status :ok
    end

    it 'returns an empty array when there is no campaigns' do
      get('v1/campaigns/')

      json = JSON.parse(response.body)

      expect(json).to be_empty
    end

    it 'returns an array of existing campaigns' do
      Campaign.create(name: 'campaign1')
      Campaign.create(name: 'campaign2')

      get('v1/campaigns/')

      json = JSON.parse(response.body)

      expect(json.length).to eq(2)
    end
  end

  context 'POST /campaigns' do
    it 'returns 201 when a campaign is created' do
      parameters = { name: 'campaign1' }
      post('v1/campaigns/',
           parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      expect(response).to have_http_status :created
    end

    it 'creates a valid campaign' do
      parameters = { name: 'campaign1' }
      post('v1/campaigns/',
           parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'campaign1')
    end

    it 'returns 400 when no name is provided for the campaign' do
      post('v1/campaigns/')

      json = JSON.parse(response.body)

      expect(response).to have_http_status :bad_request
      expect(json['error']).to eq('name is missing')
    end
  end

  context 'PUT /campaigns' do
    before { Campaign.create(name: 'campaign1', id: 1) }

    it 'returns 200 if it tries to modify an existent campaign' do
      parameters = { name: 'modified' }
      put('v1/campaigns/1',
          parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      expect(response).to have_http_status :ok
    end

    it 'modifies succesfully an existing campaign' do
      parameters = { name: 'modified' }
      put('v1/campaigns/1',
          parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'modified')
    end

    it 'returns 404 if it tries to modify an unexistent campaign' do
      parameters = { name: 'modified' }
      put('v1/campaigns/99',
          parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      expect(response).to have_http_status :not_found
    end
  end

  context 'PATCH /campaigns' do
    before { Campaign.create(name: 'campaign1', id: 1) }

    it 'returns 200 if it tries to modify an existent campaign' do
      parameters = { name: 'modified' }
      patch('v1/campaigns/1',
            parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      expect(response).to have_http_status :ok
    end

    it 'modifies succesfully an existing campaign' do
      parameters = { name: 'modified' }
      patch('v1/campaigns/1',
            parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'modified')
    end

    it 'returns 404 if it tries to modify an unexistent campaign' do
      parameters = { name: 'modified' }
      patch('v1/campaigns/99',
            parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      expect(response).to have_http_status :not_found
    end
  end

  context 'DELETE /campaigns' do
    before { Campaign.create(name: 'campaign1', id: 1) }

    it 'returns 200 if it tries to delete an existent campaign' do
      delete('v1/campaigns/1')

      expect(response).to have_http_status :ok
    end

    it 'deletes succesfully an existing campaign' do
      delete('v1/campaigns/1')

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'campaign1')
    end

    it 'returns 404 if it tries to modify an unexistent campaign' do
      delete('v1/campaigns/99')

      expect(response).to have_http_status :not_found
    end
  end
end
