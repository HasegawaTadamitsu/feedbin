class SavePages
  include Sidekiq::Worker
  sidekiq_options queue: :low, retry: false

  def perform(entry_id)
    entry = Entry.find(entry_id)

    tweets = [entry.main_tweet]
    tweets.push(entry.main_tweet.quoted_status) if entry.main_tweet.quoted_status?

    urls = find_urls(tweets)

    if url = urls.first
      saved_pages = {}

      key = FeedbinUtils.page_cache_key(url)
      begin
        saved_pages[url] = Rails.cache.fetch(key) do
          Librato.increment 'readability.first_parse'
          MercuryParser.parse(url)
        end
      rescue
      end

      entry.data["saved_pages"] = saved_pages
      entry.save!

      entry.content = ApplicationController.render template: "entries/_tweet_default.html.erb", locals: {entry: entry}, layout: nil
      entry.save!
    end
  end

  def find_urls(tweets)
    tweets.each_with_object([]) do |tweet, array|
      tweet.urls.each do |url|
        url = url.expanded_url
        if url_valid?(url)
          array.push(url.to_s)
        end
      end
    end
  end

  def url_valid?(url)
    if url.host == "twitter.com"
      false
    else
      true
    end
  end

end
