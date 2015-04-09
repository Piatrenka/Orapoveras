create or replace view vmatches as
-- Плюс внутренний номер команды победителя плюс признак что сыграли в ничью
select m.*,
       case
         when m.score1 > m.score2 then m.teamid1
         when m.score1 < m.score2 then m.teamid2
         else null
       end winer_teamid,
       case
         when m.score1 = m.score2 then 1
         else 0
       end IsDraw,
       case
         when m.score1 is null or m.score2 is null then 0
         else 1
       end IsPlayed
  from TMATCHES m
