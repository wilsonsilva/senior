# frozen_string_literal: true

Senior.configure do |config|
  config.open_ai.access_token = ENV.fetch('OPEN_AI_ACCESS_TOKEN')
  config.open_ai.organization_id = ENV.fetch('OPEN_AI_ORGANIZATION_ID') # Optional
end
