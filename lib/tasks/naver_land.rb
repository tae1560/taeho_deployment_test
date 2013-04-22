# coding: utf-8
require 'nokogiri'
require 'open-uri'

#doc = Nokogiri::XML(
#    open("http://fchart.stock.naver.com/sise.nhn?symbol=#{code}&timeframe=day&count=#{count}&requestType=0"), nil,
#    'euc-kr')
#chartdata = doc.css("protocol chartdata")
#if chartdata[0]
#  symbol = chartdata[0]["symbol"]
#end
#items = chartdata.css("item")

class NaverLand
  def self.crawl_naver_land


    naver_land = self.new
    naver_land.crawl_city_informations
  end

  def crawl_city_informations
    # ~시 번호 리스트 크롤링

    # cortarNo : 위치 표기
    cortarNo = 1100000000 # 1100000000 : 서울시

    doc = Nokogiri::XML(
        open("http://land.naver.com/article/divisionInfo.nhn?cortarNo=#{cortarNo}"), nil,
        'utf-8')

    loc_view = doc.css("div.loc_view #loc_view1 select")

    loc_view.css("option").each do |option_tag|
      #@@city_informations[option_tag["value"]] = option_tag.text
      cortarNo = option_tag["value"]
      name = option_tag.text
      unless City.duplicated? cortarNo
        City.create(:name => name, :cortarNo => cortarNo)
      end
    end

  end
end


