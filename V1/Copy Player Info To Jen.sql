
delete from FF.PlayerInfo 
where ManagerId = 11
AND PlayerId in (select PlayerId from FF.Player where Year = 2015)

insert into FF.PlayerInfo (ManagerId, PlayerId, Keywords, Comments)
select 11, PlayerId, Keywords, Comments
from FF.PlayerInfo
where ManagerId = 1
AND PlayerId in (select PlayerId from FF.Player where Year = 2015)
