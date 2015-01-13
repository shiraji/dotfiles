#!/usr/bin/env ruby
# coding: utf-8
require 'open-uri'

CACHE = "/tmp/train.rb.cache"

if File.exist?(CACHE) && (Time.now - File::Stat.new(CACHE).mtime) <= 300
  print File.read(CACHE)
  exit
end


train_info = open('http://traininfo.jreast.co.jp/train_info/kanto.aspx','r',&:read)
unless ''.respond_to?(:encode)
  require 'kconv'
  train_info = train_info.toutf8
end

m = train_info.scan(%r{<td align="left".*?>(?:<font color="White"><b>)?<font class="px12" size="3">(?:<a href="history\.aspx.*?">)?(.+?)(?:</a>)?(?:</font></b>)?</font></td><td align="center".*?>(?:<font class="White"><b>)?<font class="px12" size="3">(.+?)</font>}).uniq.map{|x| x.join(":").gsub(/&nbsp;/,'') }.select{|item| /山手|埼京|湘南新宿/ =~ item }
result = m.empty? ? "" : " #{m.join(", ")} "
open(CACHE, 'w'){|io| io.print result }
print result
