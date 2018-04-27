*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
[Dataset Name] player_stats

[Dataset Description] Stats for each NBA player in 2014-2015 that, along with
player stats, includes personal variables such as height, weight, college, and
others.

[Experimental Unit Description] Each player that played during the 2014-2015
NBA season.

[Number of Observations] 491

[Number of Features] 34

[Data Source]
https://github.com/stat6863/team-1_project_repo/blob/master/data/
players_stats.xls

[Data Dictionary] https://www.kaggle.com/drgilermo/nba-players-stats-20142015/
data

[Unique ID Schema] Name is a primary key for the unique id.
;
%let inputDataset1DSN = player_stats_raw;
%let inputDataset1URL =
https://github.com/stat6863/team-1_project_repo/blob/master/data/players_stats.csv?raw=true
;
%let inputDataset1Type = CSV;


*
[Dataset 2 Name] 2016-17_officialBoxScore

[Dataset Description] All NBA Team Statistics for Every Game, AY,2016-17

[Experimental Unit Description] Has the combined statistics for every team and
every game that was played in the regular season.

[Number of Observations] 2,461

[Number of Features] 124

[Data Source] https://www.kaggle.com/pablote/nba-enhanced-stats/data

[Data Dictionary] https://basketball.realgm.com/info/glossary

[Unique ID Schema] The column “gmDate” and “TeamAbrv” would combine to make
a unique ID.
;
%let inputDataset2DSN = teamBoxScore_16_17_raw;
%let inputDataset2URL =
https://github.com/stat6863/team-1_project_repo/blob/master/data/teamBoxScore_16_17.csv?raw=true
;
%let inputDataset2Type = CSV;


*
[Dataset 3 Name] PLAYER_ANTHRO

[Dataset Description] Anthropology of NBA draft players participating in the NBA
combine.

[Experimental Unit Description] NBA players

[Number of Observations] 479

[Number of Features] 11

[Data Source] https://stats.nba.com/draft/combine-anthro/ (copy/paste into Excel)

[Data Dictionary] https://stats.nba.com/draft/combine-anthro/

[Unique ID Schema] The columns "PLAYER” and “YEAR” can be combined to create
an unique identifier.
;
%let inputDataset3DSN = player_anthro;
%let inputDataset3URL =
https://github.com/stat6863/team-1_project_repo/blob/master/data/nba_combine_anthro.csv?raw=true
;
%let inputDataset3Type = CSV;

*set global system options;
options fullstimer;

* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename
                tempfile
                "%sysfunc(getoption(work))/tempfile.&filetype."
            ;
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%macro loadDatasets;
*change the 3 to 4 if we decide to add another dataset;
%do i = 1 %to 3;
        %loadDataIfNotAlreadyAvailable(
            &&inputDataset&i.DSN.,
            &&inputDataset&i.URL.,
            &&inputDataset&i.Type.
        )
    %end;
%mend;
%loadDatasets

/*
*Begin Data Integrity Checks and Data Integrity Mitigation;

proc sql;
	select
		PLAYER,POS
	from
		work.player_anthro
	where
		PLAYER is missing
	;
quit;

proc sql;
	select
		Name,Pos
	from
		work.Player_stats_raw
	where
		Name is missing
	;
quit;

proc sql;
	select
		offFNm1
	from
		work.Teamboxscore_16_17_raw
	where
		offFNm1 is missing
	;
quit;

*For our all three of our datasets we can see that we have no missing ID values,
which in our case is Name, or a combination of name and position. No rows are
selected when we query missing values for names.
;

proc sql;
	select
		PLAYER
 		,POS
		,YEAR
		,count(*) as row_count
	from
		work.player_anthro
	group by
		PLAYER
 		,POS
		,YEAR
	having
		row_count > 1
	;
quit;

*Using Player, Position and Year, we can succesfully have unduplicated counts
for our Anthro Data.
;

proc sql;
	select
		Name
		,Pos
		,count(*) as row_count
	from
		work.Player_stats_raw
	group by
		Name
		,Pos
	having
		row_count > 1
	;
quit;


*Again with the the above query we can see that no player names are duplicated,
and therefore our ID value is also unduplicated.
;

proc sql;
	select
		teamAbbr
		,gmDate
		,count(*) as row_count
	from
		work.Teamboxscore_16_17_raw
	group by
		teamAbbr
		,gmDate
	having
		row_count > 1
	;
quit;

*Every team only plays once a day and therefore using team and date variables as
a unique identifier, we can get unduplicated counts for our ID.
;


*Inspecting Team Assists in our team box score data;

title "Assists in teamBoxscore_16_17";
proc sql;
	select
		min(teamAST) as min
		,max(teamAST) as max
		,mean(teamAST) as average
		,median(teamAST) as median
	from
		work.TeamBoxscore_16_17_raw
	;
quit;
title;


*Inspecting Height in our player Anthro Data;


title "Inspect Height in player_anthro";
proc sql;
	select
		min(HEIGHT_SHOES) as min
		,max(HEIGHT_SHOES) as max
		,mean(HEIGHT_SHOES) as average
		,median(HEIGHT_SHOES) as median
	from
		work.player_anthro
	;
quit;
title;


*Inspecting # points made in our player statistics data;

title "Inspect 3PM in player_stats_raw";
proc sql;
	select
		min(_3PM) as min
		,max(_3PM) as max
		,mean(_3PM) as average
		,median(_3PM) as median
	from
		work.player_stats_raw
	;
quit;
title;

*/

/*

proc sql;
  create table player_stats_and_anthro as
  select
          coalesce(pa.PLAYER,ps.Name)
  from
          work.player_anthro as pa
          ,work.player_stats_raw as ps
  where
          PLAYER = Name
  order by
          PLAYER;
quit;

*/
