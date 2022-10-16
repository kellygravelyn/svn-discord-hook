require "json"
require "tempfile"
require "time"
require "excon"
require "optparse"
require "yaml"

repo = ""
rev = ""
dry_run = false

OptionParser.new do |parser|
  parser.banner = "Usage: post_to_discord.rb [options]"

  parser.on("--repo PATH", "Path to the SVN repository") { |v| repo = v }
  parser.on("--revision REVISION", "SVN revision to post") { |v| rev = v }
  parser.on("--dry-run", "Runs the logic and prints what would be sent to Discord without actually posting") { || dry_run = true }
end.parse!

config = YAML.load_file(File.join(__dir__, "config.yaml"))

author = %x( svnlook author "#{repo}" -r #{rev} ).strip
log = %x( svnlook log "#{repo}" -r #{rev} ).strip
date = %x( svnlook date "#{repo}" -r #{rev} ).strip

discord_user_id = config.dig("users", author)
if discord_user_id
	author = "<@#{discord_user_id}>"
end

titles = config["titles"]
title = titles[rev.to_i % titles.length]

data = {
  embeds: [
    {
      title: title,
      color: config["color"].to_i(16),
      description: log,
      fields: [
        {
          name: "Author",
          value: author,
          inline: true
        },
        {
          name: "Revision",
          value: rev,
          inline: true
        }
      ],
      timestamp: Time.parse(date).iso8601
    }
  ]
}

puts "JSON to post to Discord:"
puts JSON.pretty_generate(data)

unless dry_run
	puts "Posting to Discord…"
	response = Excon.post(
	  config["hooks"][File.basename(repo)],
	  body: data.to_json,
	  headers: {
	    "Content-Type" => "application/json"
	  }
	)

	if response.status != 204
		puts "Unexpected response from Discord:"
		puts response.status
		puts response.body
	else
		puts "Success! 🎉"
	end
end
