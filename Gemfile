# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "faraday"

group :development, :test do
  gem "rspec"
end

group :development do
  gem "guard-rspec", require: false
  gem "pry-byebug"
  gem "rubocop-rspec", require: false
  gem "solargraph"
end
