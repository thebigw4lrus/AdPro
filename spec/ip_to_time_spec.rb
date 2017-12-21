require 'rails_helper'

RSpec.describe AdPro::IpToTime do
  before { Timecop.freeze(DateTime.new(2015, 10, 21)) }
  after { Timecop.return }

  it 'retrieves the datetime of a given timezone thru an external service' do
    body = {
      'data' => {
        'datetime' => { 'date_time_ymd' => '2005-01-01T00:00:00' }
      }
    }.to_json

    response = double('response')
    allow(response).to receive(:code).and_return('200')
    allow(response).to receive(:body).and_return(body)
    allow(Net::HTTP).to receive(:get_response).and_return(response)

    ip_to_time = described_class.new('127.0.0.1', 'http://some_path')
    expect(ip_to_time.get).to eq(DateTime.new(2005, 1, 1))
  end

  it 'retrieves the datetime of the server when the service is down' do
    response = double('response')
    allow(response).to receive(:code).and_return('500')
    allow(Net::HTTP).to receive(:get_response).and_return(response)

    ip_to_time = described_class.new('127.0.0.1', 'http://some_path')
    expect(ip_to_time.get).to eq(DateTime.new(2015, 10, 21))
  end
end
