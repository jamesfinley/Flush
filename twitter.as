/* ====================================================================== //
// = Copyright © 2009 James Finley
// = ==================================================================== //
// = This is a demo of how to use the JSON method in Flush
// = to load out a list of tweets from Twitter.
// ====================================================================== */

#include "flush.as"
#include "flush-json.as"

/* load out all tweets from @thefinley */
$().json('http://search.twitter.com/search.json?q=from%3Athefinley', function (json) {
	/* loop through results */
	$().each(json.results, function (i, tweet) {
		/* trace the tweet */
		trace(tweet.from_user + ': ' + tweet.text);
	})
});