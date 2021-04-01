# frozen_string_literal: true

::REDDIT_CLIENT = Reddit::Base::Client.new(user: ENV['REDDIT_USERNAME'], password: ENV['REDDIT_PASSWORD'])
