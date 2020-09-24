require "unit_spec_helper"

describe Rpush::Client::ActiveRecord::Apns::Notification do
  subject(:notification) { described_class.new }

  it_behaves_like 'Rpush::Client::Apns::Notification'
  it_behaves_like 'Rpush::Client::ActiveRecord::Notification'

  describe "multi_json usage" do
    describe "alert" do
      subject(:notification) { described_class.new(alert: { a: 1 }, alert_is_json: true) }

      it "should call MultiJson.load when multi_json version is 1.3.0" do
        allow(Gem).to receive(:loaded_specs).and_return('multi_json' => Gem::Specification.new('multi_json', '1.3.0'))
        expect(MultiJson).to receive(:load).with(any_args)
        notification.alert
      end

      it "should call MultiJson.decode when multi_json version is 1.2.9" do
        allow(Gem).to receive(:loaded_specs).and_return('multi_json' => Gem::Specification.new('multi_json', '1.2.9'))
        expect(MultiJson).to receive(:decode).with(any_args)
        notification.alert
      end
    end
  end

  it "should default the sound to nil" do
    expect(notification.sound).to be_nil
  end

  it 'does not overwrite the mutable-content flag when setting attributes for the device' do
    notification.mutable_content = true
    notification.data = { 'hi' => 'mom' }
    expect(notification.as_json['aps']['mutable-content']).to eq 1
    expect(notification.as_json['hi']).to eq 'mom'
  end

  it 'does not overwrite the content-available flag when setting attributes for the device' do
    notification.content_available = true
    notification.data = { 'hi' => 'mom' }
    expect(notification.as_json['aps']['content-available']).to eq 1
    expect(notification.as_json['hi']).to eq 'mom'
  end

  it 'does confuse a JSON looking string as JSON if the alert_is_json attribute is not present' do
    allow(notification).to receive_messages(has_attribute?: false)
    notification.alert = "{\"one\":2}"
    expect(notification.alert).to eq('one' => 2)
  end
end if active_record?
