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
    #naver_land.crawl_city_informations
    #naver_land.crawl_town_informations
    naver_land.crawl_house_informations
  end

  def crawl_city_informations
    # 도/시 번호 리스트 크롤링

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

  def crawl_town_informations
    # 시/군/구 번호 리스트 크롤링

    City.find_each do |city|
      puts "start #{city.name} #{city.cortarNo}"

      # cortarNo : 위치 표기
      cortarNo = city.cortarNo
      doc = Nokogiri::XML(
          open("http://land.naver.com/article/divisionInfo.nhn?cortarNo=#{cortarNo}"), nil,
          'utf-8')

      loc_view = doc.css("div.loc_view #loc_view2 select")

      loc_view.css("option").each do |option_tag|
        #@@city_informations[option_tag["value"]] = option_tag.text
        cortarNo = option_tag["value"]
        name = option_tag.text
        unless Town.duplicated? cortarNo
          town = Town.create(:name => name, :cortarNo => cortarNo)
          city.towns << town
        end
      end

    end
  end

  def crawl_house_informations
    #http://land.naver.com/article/divisionInfo.nhn?cortarNo=1168000000&page=1&articleOrderCode=11

    # 매물 크롤링
    Town.find_each do |town|
      puts "start #{town.name} #{town.cortarNo}"

      # cortarNo : 위치 표기, articleOrderCode : 정렬순서
      cortarNo = town.cortarNo
      articleOrderCode = 11 #11 : 매물 확인 날짜순 정렬렬
      page = 1

      while true
        doc = Nokogiri::HTML(
            open("http://land.naver.com/article/divisionInfo.nhn?cortarNo=#{cortarNo}&page=#{page}&articleOrderCode=#{articleOrderCode}"), nil,
            'utf-8')
        trs = doc.css("table.sale_list tbody tr")
        puts "http://land.naver.com/article/divisionInfo.nhn?cortarNo=#{cortarNo}&page=#{page}&articleOrderCode=#{articleOrderCode}"

        # 페이지 끝나는것 체크
        if trs.length < 2
          break
        end

        trs.each do |tr|
          # 각 매물은 tr 두개로 이루어짐
          if tr.css("td").count == 1
            # 두번째줄

            # 코멘트
            #puts tr.css("td")[0].css("div.inner")[0].css("span")[0].text.strip
          else
            # 첫번째줄

            # 거래종류 : 매매, 전세
            #puts tr.css("td")[0].css("div.inner")[0].text.strip
            trade_type = tr.css("td")[0].css("div.inner")[0].text.strip

            # 매물종류 : 아파트
            #puts tr.css("td")[1].text.strip
            house_type = tr.css("td")[1].text.strip

            # 확인일자
            #puts tr.css("td")[2].css("div.inner")[0].css("span")[0].text.strip
            confirm_date_string = tr.css("td")[2].css("div.inner")[0].css("span")[0].text.strip

            # 매물명
            #puts tr.css("td")[3 + is_thumbnail_exists].css("div.inner")[0].css("a")[0]["title"]

            is_thumbnail_exists = 0;
            unless tr.css("td")[3].css("div.inner")[0].css("a")[0]
              is_thumbnail_exists = 1
            end

            unless tr.css("td")[3 + is_thumbnail_exists].css("div.inner")[0].css("a")[0]
              #puts 3 + is_thumbnail_exists
              #puts tr.css("td")[3].css("div.inner")[0].css("a")[0]
              #puts tr.css("td")[3 + is_thumbnail_exists - 1].css("div.inner")[0]
              #puts tr.css("td")[3 + is_thumbnail_exists].css("div.inner")[0]
            end
            house_name = tr.css("td")[3 + is_thumbnail_exists].css("div.inner")[0].css("a")[0]["title"]

            # 면적 공급면적 / 전용면적 m^2
            #puts tr.css("td")[4 + is_thumbnail_exists].css("div.inner")[0].css("span")[0].text.strip

            # 매물가(만원)
            #puts tr.css("td")[5 + is_thumbnail_exists].css("div.inner")[0].css("strong")[0].text.strip
            house_price = tr.css("td")[5 + is_thumbnail_exists].css("div.inner")[0].css("strong")[0].text.strip

            # 층
            #puts tr.css("td")[6 + is_thumbnail_exists].css("div.inner")[0].text.strip

            # 부동산명
            #puts tr.css("td")[7 + is_thumbnail_exists].css("div.inner")[0].css("a")[0].css("span")[0].text.strip

            # 부동산번호
            #puts tr.css("td")[7 + is_thumbnail_exists].css("div.inner")[0].css("a")[0].css("span")[1].text.strip

            # 날짜가 없는 매물 (직거래)
            if confirm_date_string and confirm_date_string.to_date
              type = house_type
              confirm_date = Utility.kor_str_to_utc_datetime confirm_date_string
              name = house_name
              price = house_price
              unless House.duplicate? trade_type, type, confirm_date, name, price
                house = House.create(:trade_type => trade_type, :type => type, :confirm_date => confirm_date, :name => name, :price => price)
                town.houses << house
              end
            end
          end

        end

        page += 1
      end
    end
  end
end


