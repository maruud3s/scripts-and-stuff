#!/usr/bin/ruby

# This IRC-Bot scans the chat for Youtube links and saves them to a database.
# Usage: !yt last (count) - outputs up to $count amount of last saved links (default: 1)
#        !yt info - prints this message.
#
# Currently information is being logged to a MySQL database. This is subject to change to a SQLite Database, though.
#
# Author: maruu
# Date:   17-06-2014
#
# Libraries used: cinch, mysql
#
# For future expandability, the datetime-format used should be made SQL-compliant, so that one can query for links posted in a timespan
# Furthermore, one should think about the use of Plugins, instead of the "on" methods.
#
# Caution: The SQL query being used is vulnerable to SQL-Injection. (Through the user's IRC nick)
#
# Feel free to change/adapt this Bot to fit your needs.
# For questions, feel free to find me at #slothkrew on irc.freenode.org.


require 'cinch'
require 'mysql'

con = Mysql.new 'localhost', '<censored>', '<censored>', "<censored>"

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
          error "\n[!]" + e.error + "\n"
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
          error "\n[!]" + e.error + "\n\n"
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