require 'rails_helper'

RSpec.describe AdPro::V1::Banners do
  context 'GET /banners' do
    it 'returns 200 status' do
      get('v1/banners/')

      expect(response).to have_http_status :ok
    end

    it 'returns an empty array when there is no banners' do
      get('v1/banners/')

      json = JSON.parse(response.body)

      expect(json).to be_empty
    end

    it 'returns an array of existing banners' do
      Banner.create(name: 'banner1', url: 'http://somebanner1')
      Banner.create(name: 'banner2', url: 'http://somebanner2')

      get('v1/banners/')

      json = JSON.parse(response.body)

      expect(json.length).to eq(2)
    end
  end

  context 'POST /banners' do
    it 'returns 201 when a banner is created' do
      parameters = { name: 'banner1', url: 'http://somebanner1' }
      post('v1/banners/',
           parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      expect(response).to have_http_status :created
    end

    it 'creates a valid banner' do
      parameters = { name: 'banner1', url: 'http://somebanner1' }
      post('v1/banners/',
           parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'banner1')
    end

    it 'returns 400 when no name is provided for the banner' do
      parameters = { url: 'http://somebanner1' }
      post('v1/banners/',
           parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      json = JSON.parse(response.body)

      expect(response).to have_http_status :bad_request
      expect(json['error']).to eq('name is missing')
    end

    it 'returns 400 when no url is provided for the banner' do
      parameters = { name: 'banner1' }
      post('v1/banners/',
           parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      json = JSON.parse(response.body)

      expect(response).to have_http_status :bad_request
      expect(json['error']).to eq('url is missing')
    end
  end

  context 'PUT /banners' do
    before do
      Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)
    end

    it 'returns 200 if it tries to modify an existent banner' do
      parameters = { name: 'some_name', url: 'some_url' }
      put('v1/banners/1',
          parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      expect(response).to have_http_status :ok
    end

    it 'modifies succesfully an existing banner' do
      parameters = { name: 'modified_name', url: 'modified_url' }
      put('v1/banners/1',
          parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'modified_name',
                              'url' => 'modified_url')
    end

    it 'returns 404 if it tries to modify an unexistent banner' do
      parameters = { name: 'modified_name', url: 'modified_url' }
      put('v1/banners/99',
          parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      expect(response).to have_http_status :not_found
    end
  end

  context 'PATCH /banners' do
    before do
      Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)
    end

    it 'returns 200 if it tries to modify an existent banner' do
      parameters = { name: 'some_name', url: 'some_url' }
      patch('v1/banners/1',
            parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      expect(response).to have_http_status :ok
    end

    it 'modifies succesfully an existing banner' do
      parameters = { name: 'modified_name', url: 'modified_url' }
      patch('v1/banners/1',
            parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'modified_name',
                              'url' => 'modified_url')
    end

    it 'returns 404 if it tries to modify an unexistent banner' do
      parameters = { name: 'some_name', url: 'some_url' }
      patch('v1/banners/99',
            parameters.to_json, 'CONTENT_TYPE' => 'application/json')

      expect(response).to have_http_status :not_found
    end
  end

  context 'DELETE /banners' do
    before { Banner.create(name: 'banner1', id: 1) }

    it 'returns 200 if it tries to delete an existent campaign' do
      delete('v1/banners/1')

      expect(response).to have_http_status :ok
    end

    it 'deletes succesfully an existing campaign' do
      delete('v1/banners/1')

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'banner1')
    end

    it 'returns 404 if it tries to modify an unexistent campaign' do
      delete('v1/banners/99')

      expect(response).to have_http_status :not_found
    end
  end
end
