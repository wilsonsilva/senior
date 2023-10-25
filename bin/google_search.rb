# frozen_string_literal: true

require 'google/apis/customsearch_v1'

module GoogleSeach
  def self.search(query)
    # Set up the client
    client = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
    client.key = ENV.fetch('GOOGLE_API_KEY')

    cassette = Utils.to_snake_case(query)
    results = []

    # VCR.use_cassette(cassette) do
      # Perform the search
      results = client.list_cses(
        q: query,
        num: 10,
        cx: ENV.fetch('CUSTOM_SEARCH_ENGINE_ID')
      )
    # end

    results.items.map(&:link)
  end
end
