# Advent of Code 2017 - rellem's solutions in CFML

My solutions for the Advent of Code 2017 puzzles, written in [ColdFusion Markup Language](https://en.wikipedia.org/wiki/ColdFusion_Markup_Language). Tested on [Lucee](http://lucee.org/) 5.2.4.37 and Adobe ColdFusion 2016.0.0.298074.

## Running the solutions

* `git clone https://github.com/rellem/advent_of_code_2017.git rellem-cfml`
* `docker pull lucee/lucee52`
* `docker run -d -p 14000:8888 -e "LUCEE_JAVA_OPTS=-Xmx4096m" -v /path/to/rellem-cfml:/var/www/rellem-cfml lucee/lucee52`
* Go to http://localhost:14000/rellem-cfml/

The big heap is required by several solutions because of Lucee bug [LDEV-1623](https://luceeserver.atlassian.net/browse/LDEV-1623).
