# coding: utf-8
require 'tasks/naver_land'

namespace :crawler do
  task :naver => :environment do
    puts "start task :naver_Land => :environment do"
    NaverLand.crawl_naver_land
  end
end