# TODO: Get realpath of the symlink to use as our directory. Not sure how to do
# this on Windows but also I don't run my SVN server on Windows. I'll see if I
# can figure this out later.
ruby "%~dp0\post_to_discord.rb" --repo %1 --revision %2
