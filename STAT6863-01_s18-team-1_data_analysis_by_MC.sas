
*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that will generate final analytic file;
%include '.\STAT6863-01_s18-team-1_project_data_preparation';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: How do the NBA players overall shooting percentage for the 2014-15
season compare with the players with the overall shooting percentages for the
2015-16 season?

Rationale:  This will help tell us if the NBA players on average shot better
than in the previous season.

Note:  We would be looking at data for the 2014-15 NBA season in the
players_stats_data dataset using the "Name" and "FG_PCT" columns along with the
players_stats_1516_data dataset using the columns "Player" and "FG_PCT".

Limitations:  .Since we are comparing data over a two year period, we can't
exactly conclude much as far as whether there is a trend from the small
timeline.
;

proc means min q1 median q3 max data=player_stats_all;
	class Name Player;
	var	FG_PCT;
run;

proc sql;
	create table FG_PCT_COMPARE as
	(select
		*
	from
		work.players_stats_all
	)
	;
quit;

*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: Are the NBA players at the top of assists a part of the teams that
were at the top of assists as well?

Rationale:  Ball movement has become more recognized and utilized in recent
years, so it would be important to know which players produce the most assists
over the duration of a season along with which teams generally have the most
assists on a game by game basis.  It will also be interesting to see if the
best assist teams have one of the leaders in that category, or if the team
assists are a more collective team effort.

Note:  We will be using the players_stats_data dataset with the columns "Name",
"AST", and "Team", and the teamBoxScore_16-17 dataset for this analysis while
using the columns "teamAbbr" and "teamAST".  Due to the data in each dataset
being two years apart, some players may not be on the same team in both
datasets.

Limitations:  Given how any stat from a NBA player doesn't exactly correlate
with a team's stat, the conclusions for this experiment may not be entirely
conclusive.  We also aren't comparing with an equal sample size for the two
datasets we are testing on given that this would compare a player's season
average with a team's performance in just one single game
;

proc rank
		groups=10
		data=players_stats_data
		out=players_stats_data_ranked
	;
	var AST;
	ranks AST_rank;
run;
proc rank
		groups=10
		data=teamBoxscore_16_17
		out=teamBoxscore_16_17_ranked
	;
	var teamAST;
	ranks teamAST_rank;
run;

proc compare
		base=players_stats_data
		compare=teamBoxscore_16_17
		novalues
	;
run;
*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;
*
Question: How do the players that average the most rebounds compare with their
height and weight?

Rationale: It will be interesting to analyze whether height or weight is a
larger factor towards producing more rebounds.  General managers of teams could
use this analysis when determining which furture NBA players to draft to the
team.

Note:  We will be using the columns "Name" and "REB" from the
players_stats_data dataset along with the columns "HEIGHT_SHOES" and "WEIGHT" in
the nba_combine_anthro dataset.

Limitations:  Since the player list for the player_anthro data is only showing
heights and weights for players from the NBA combine, the comparision may not
have complete accuracy given the typical height and weight of an NBA player is
much different than one about to enter the league.
;

proc sql outobs=20;
	create table REBOUNDS_SIZE as
		select
			Name
			,REB
			,HEIGHT_SHOES
			,WEIGHT
		from
			players_stats_data_and_anthro_v2
		where
			HEIGHT_SHOES > 100
			and
			WEIGHT > 200
		order by
			REB
		;
quit;

proc print data=REBOUNDS_SIZE;
run;
