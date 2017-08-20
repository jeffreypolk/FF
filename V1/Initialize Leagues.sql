
-- copy managers from last year to this year
declare @Year int = DATEPART(yyyy, getdate());

/*
declare @Year int = DATEPART(yyyy, getdate());
delete from FF.LeagueYear where [Year] = @Year
delete from FF.Team where [Year] = @Year
*/

insert into FF.LeagueYear (LeagueId, [Year], Rounds)
select LeagueId, @Year, Rounds
from FF.LeagueYear
where [Year] = @Year - 2

insert into FF.Team (LeagueId, ManagerId, Name, DraftOrder, [Year], IsCommish)
select LeagueId, ManagerId, Name, 1, @Year, IsCommish
from FF.Team 
where [Year] = @Year - 2

