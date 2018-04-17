
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
Question: How do the NBA players having the best shooting percentage per season
compare with the single game best shooting performances from teams?

Rationale:  This will help tell us if the best shooting players on average
perform better than an a team's overall performance in a game.

Note:  We would be looking at data for the 2014-15 NBA season in the
player_stats dataset using the "Name" and "FG%" columns along with the
teamBoxScore_16-17 dataset using the columns "teamAbbr" and "teamFG%".
;


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

Note:  We will be using the player_stats dataset with the columns "Name",
"AST", and "Team", and the teamBoxScore_16-17 dataset for this analysis while
using the columns "teamAbbr" and "teamAST".  Due to the data in each dataset
being two years apart, some players may not be on the same team in both
datasets.
;


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

Note:  We will be using the columns "Name" and "REB" from the player_stats
dataset along with the columns "HEIGHT_SHOES" and "WEIGHT" in the
nba_combine_anthro dataset.
;
