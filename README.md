
# AnimeFreak.tv Video File Extractor

This was created for personal use.  Pass the
script the URL of an episode on AnimeFreak.tv and
it will list each mirrors' video file for
downloading the episode directly, instead of
streaming it.

For example:

    $> ./animefreak.rb 'http://www.animefreak.tv/watch/kill-la-kill-episode-8-online'

    # This gives the following output:
    #
    #   "http://37.220.28.202/Kill%20la%20Kill%20Episode%208.mp4?st=V2-WxKN-GK4tx4zCskfzAw&e=1392454958"
    #   "http://78.152.42.216/Kill%20la%20Kill%20Episode%208.mp4?st=ojOeg76SwggxKDHbjslAxQ&e=1392454671&captions="
    #   "http://37.220.28.202/Kill%20la%20Kill%20Episode%208.mp4?st=ojOeg76SwggxKDHbjslAxQ&e=1392454671"
    #
    #   REQUIRES MORE PROCESSING 'http://embed.videoweed.es/embed.php?v=15m8tzwkon3hj&width=550&height=412'
    #   REQUIRES MORE PROCESSING 'http://www.mp4upload.com/embed-gacxlo0hoazi.html'
    #   REQUIRES MORE PROCESSING 'http://embed.novamov.com/embed.php?width=550&height=412&v=jz03z27gck7mt&px=1'
    #

# Note

I did not write this with any intention of demonstrating good coding style.
Some aspects are inefficient.  However, it is a great little script.  I
accomplished my goal in less than 5min.

Also, this won't work for every series.  Which site hosts the files is
important.  I am assuming that the first mirror uses the embed.php player.
As I encounter episodes that aren't compatible I will update the script
accordingly.
