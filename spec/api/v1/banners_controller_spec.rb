require 'rails_helper'

RSpec.describe 'Banner resource' do
  describe 'GET /banners' do
    it 'returns 200 status' do
      get('banners/')

      expect(response).to have_http_status :ok
    end

    it 'returns an empty array when there is no banners' do
      get('banners/')

      json = JSON.parse(response.body)

      expect(json).to be_empty
    end

    it 'returns an array of existing banners' do
      Banner.create(name: 'banner1', url: 'http://somebanner1')
      Banner.create(name: 'banner2', url: 'http://somebanner2')

      get('banners/')

      json = JSON.parse(response.body)

      expect(json.length).to eq(2)
    end
  end

  describe 'POST /banners' do
    it 'returns 201 when a banner is created' do
      parameters = { name: 'banner1', url: 'http://somebanner1' }
      post('banners/', parameters)

      expect(response).to have_http_status :created
    end

    it 'creates a valid banner' do
      parameters = { name: 'banner1', url: 'http://somebanner1' }
      post('banners/', parameters)

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'banner1')
    end

    it 'returns 400 when no name is provided for the banner' do
      parameters = { url: 'http://somebanner1' }
      post('banners/', parameters)

      json = JSON.parse(response.body)

      expect(response).to have_http_status :bad_request
      expect(json['error']).to eq('name is missing')
    end

    it 'returns 400 when no url is provided for the banner' do
      parameters = { name: 'banner1' }
      post('banners/', parameters)

      json = JSON.parse(response.body)

      expect(response).to have_http_status :bad_request
      expect(json['error']).to eq('url is missing')
    end
  end

  describe 'PUT /banners' do
    it 'returns 200 if it tries to modify an existent banner' do
      Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)

      parameters = { name: 'some_name', url: 'some_url' }
      put('banners/1', parameters)

      expect(response).to have_http_status :ok
    end

    it 'modifies succesfully an existing banner' do
      Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)

      parameters = { name: 'modified_name', url: 'modified_url' }
      put('banners/1', parameters)

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'modified_name',
                              'url' => 'modified_url')
    end

    it 'returns 404 if it tries to modify an unexistent banner' do
      parameters = { name: 'some_name', url: 'some_url' }
      put('banners/1', parameters)

      expect(response).to have_http_status :not_found
    end
  end

  describe 'PATCH /banners' do
    it 'returns 200 if it tries to modify an existent banner' do
      Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)

      parameters = { name: 'some_name', url: 'some_url' }
      patch('banners/1', parameters)

      expect(response).to have_http_status :ok
    end

    it 'modifies succesfully an existing banner' do
      Banner.create(name: 'banner1', url: 'http://somebanner1', id: 1)

      parameters = { name: 'modified_name', url: 'modified_url' }
      patch('banners/1', parameters)

      json = JSON.parse(response.body)

      expect(json).to include('name' => 'modified_name',
                              'url' => 'modified_url')
    end

    it 'returns 404 if it tries to modify an unexistent banner' do
      parameters = { name: 'some_name', url: 'some_url' }
      patch('banners/1', parameters)

      expect(response).to have_http_status :not_found
    end
  end
end
