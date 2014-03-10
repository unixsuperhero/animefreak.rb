#!/Users/MacbookPro/.rbenv/versions/2.0.0-p247/bin/ruby

require 'uri'
require 'net/http'
require 'pp'

class AnimeFreak
  attr_accessor :url

  def sample_file
    'sample.html'
  end

  def sample_exists?
    Dir.glob(sample_file).any?
  end

  def initialize(url)
    @url = url.gsub(/\s/, '%20')
  end

  def uri
    @uri ||= URI(url)
  end

  def response
    pp "Downloading '#{url}'..."
    @response ||= Net::HTTP.get_response(uri)
  end

  def body
    @body ||= response.body
  end

  def upload2
    body.scan(/[?&]video=(https?:..[^&?]*[.](?:mp4|flv)[^&?]*)/i).uniq.sort
  end

  def videoweed
    vw_file = body.scan(/(?:filekey|fkz)="([^"]*)"/i).flatten.first
    vw_key  = body.scan(/[.]file="([^"]*)"/i).flatten.first
    "http://www.videoweed.es/api/player.api.php?key=%s&pass=undefined&cid2=1004&user=undefined&cid3=undefined&cid=1&numOfErrors=0&file=%s" % [vw_key, vw_file]
  end

  def self.file(link)
    response = Net::HTTP.get_response(URI(link.gsub(/\s/, '%20')))
    body = response.body
    files = body.scan(/file=(http[^'"<>]*)/i).flatten
    files.map{|m| URI.decode(m).gsub(/[+]/, ' ') }.uniq
  end

  def mirror_regex
    /(https?:..[^'"<>]*?(?:flv|mp4|embed)[^'"<>]*)/i
  end

  def mirrors
    URI.decode(body).scan(mirror_regex).flatten.map do |m|
      m.gsub(/[+]/, ' ')
    end
  end

  def targetted_mirrors
    mirrors = body.scan(/coz\("(http[^"]*)"/i) + body.scan(/javascript.loadparts..([^']*)'/i)

    mirrors.flatten.map{|m|
      URI.decode(m).scan(/https?:..[^'"<>]*/i)
    }.flatten.map{|m|
      m.gsub(/[+]/, ' ')
    }
  end
end

def run
  pp({
    argv_zero: ARGV[0],
    argv_one: ARGV[1],
    argv: ARGV,
  })

  #return false

  link = ARGV[0]
  anime = AnimeFreak.new(link)

  episode_number = '%02d' % link.scan(/episode-?(\d\d*)/i).flatten.first.to_i
  episode_name = link.split('/').last.sub(/-?episode.*/i,'')
  outfile = '%s-%02d' % [episode_name, episode_number]

  puts anime.mirrors.map{|mirror|
    if mirror =~ /\/[^\/]*[.](flv|mp4)([?]|$)/i
      #'( cd ~/Downloads; wget -cb "%s" )' % mirror
      extension = mirror.scan(/[.](mp4|flv)/i).flatten.first
      'download "%s" "%s.%s"' % [mirror,outfile,extension]
    elsif (file = AnimeFreak.file(mirror)).any?
      file.map{|m|
        extension = m.scan(/[.](mp4|flv)/i).flatten.first
        'download "%s" "%s.%s"' % [m,outfile,extension]
      }
    elsif mirror =~ /upload2/i
      file = AnimeFreak.new(mirror).upload2
      file.flatten.map{|m|
        extension = m.scan(/[.](mp4|flv)/i).flatten.first
        'download "%s" "%s.%s"' % [m,outfile,extension]
      }
    elsif mirror =~ /videoweed/i
      m = AnimeFreak.new(mirror).videoweed
      extension = m.scan(/[.](mp4|flv)/i).flatten.first
      'download "%s" "%s.%s"' % [m,outfile,extension]
    else
      "# REQUIRES MORE PROCESSING '%s'" % mirror
    end
  }.flatten.group_by{|l|
    l =~ /REQUIRES MORE PROCESSING/
  }.values.map{|g| g.join("\n") }.join("\n\n")
end

pp({
  calling_run: 'calling it...',
  run_returns: run,
})

