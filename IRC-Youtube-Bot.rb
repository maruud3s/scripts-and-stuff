#!/usr/bin/ruby

require 'cinch'
require 'mysql'

con = Mysql.new 'localhost', 'maruu', '<censored>', "maruu_ytbot"

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = "irc.freenode.org"
    c.nick     = "SKJames"
    c.channels = ["#slothkrew"]
  end

  on :message, /youtube.com|youtu.be/ do |m|
    links = m.message.scan(/(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch.+?\bv=[a-zA-Z0-9\-]+|(?:https?:\/\/)?youtu\.be\/[a-zA-Z0-9\-]+/)
    links.each do |link|
      time = Time.new.strftime("%d-%m-%Y %H:%M:%S")
    
      begin
        con.query("INSERT INTO entries(name,time,link) VALUES(\"#{m.user.nick}\",\"#{time}\",\"#{link}\")")
        
      rescue Mysql::Error => e
          m.reply "Something went wrong.."
          puts "[!!!!!!!!!!!!!!]" + e.error + "\n"
          con.close if con
      end

      m.reply "#{m.user.nick} | #{time}: #{link}"
    end
  end

  on :message, /^!yt last(?: \d+)?$/ do |m|
    # take 1 as default value
    count = ["1"]
    if match = m.message.match(/(\d+)$/)
      count = match.captures
    end

    begin
        rs = con.query("SELECT * FROM (SELECT * FROM entries ORDER BY id DESC LIMIT #{count[0]}) as x ORDER BY x.time")

        rs.each_hash do |row|
          m.reply row["name"] + " | " + row["time"] + " | " + row["link"]
        end
      rescue Mysql::Error => e
          m.reply "Something went wrong.."
          puts "\n[!!!!!!!!!!!!!!]" + e.error + "\n\n"
          con.close if con
    end
  end

  on :message, /^!yt info$/ do |m|
    m.reply "This IRC-Bot scans the chat for Youtube links and saves them to a database."
    m.reply "Usage: !yt last (count) - outputs up to $count amount of last saved links (default: 1)"
    m.reply "       !yt info - prints this message."
  end
end

bot.loggers.level = :warn

bot.start