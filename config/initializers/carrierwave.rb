require Rails.root + 'lib/wtech'

CarrierWave.configure do |config|
  # carrierwave upload root = /var/opt/APP/data/ENV/
  config.root = (Pathname.new('/var/opt') + Wtech.app + 'data' + Voting::Application.env_str).to_s
end
