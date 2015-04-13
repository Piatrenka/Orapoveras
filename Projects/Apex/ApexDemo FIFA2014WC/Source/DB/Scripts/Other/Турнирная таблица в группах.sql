-- Name         Type           Nullable  Default  Comments
-- MATCHID      NUMBER(6)                         Внутренний номер матча
-- MATCHNAME    VARCHAR2(255)  Y                  Наименование матча
-- MATCHDATE    DATE           Y                  Дата и время матча
-- TEAMID1      NUMBER(6)      Y                  Команда хозяйка
-- TEAMID2      NUMBER(6)      Y                  Команда гость
-- STADIUMID    NUMBER(6)      Y                  Внутренний номер стадиона
-- SCORE1       NUMBER(6)      Y                  Забили хозяева
-- SCORE2       NUMBER(6)      Y                  Забили гости
-- MATCHSTATUS  VARCHAR2(255)  Y                  Состояние матча
-- Нужна команда и все ее результаты собранные по принципу
-- Играла, выиграла, ничья, проиграла, забила, пропустила, разница, очков
create or replace view vGroupsResults as
select t.*,
(select count(*)from vmatches m where (m.teamid1 = t.teamid or m.teamid2 = t.teamid) and m.IsPlayed > 0) Played,
(select count(*)from vmatches m where (m.teamid1 = t.teamid or m.teamid2 = t.teamid) and m.winer_teamid = t.teamid) Wined,
(select count(*)from vmatches m where (m.teamid1 = t.teamid or m.teamid2 = t.teamid) and m.IsDraw > 0) Draw,
(select count(*)from vmatches m where (m.teamid1 = t.teamid or m.teamid2 = t.teamid) and m.loser_teamid = t.teamid) Losed,

(select sum(m.SCORE1) from vmatches m where m.teamid1 = t.teamid) + (select sum(m.SCORE2) from vmatches m where m.teamid2 = t.teamid) Scored,
(select sum(m.SCORE2) from vmatches m where m.teamid1 = t.teamid) + (select sum(m.SCORE1) from vmatches m where m.teamid2 = t.teamid) Missed,

(select sum(m.SCORE1) from vmatches m where m.teamid1 = t.teamid) + (select sum(m.SCORE2) from vmatches m where m.teamid2 = t.teamid) -
((select sum(m.SCORE2) from vmatches m where m.teamid1 = t.teamid) + (select sum(m.SCORE1) from vmatches m where m.teamid2 = t.teamid)) Netto,

((select count(*)from vmatches m where (m.teamid1 = t.teamid or m.teamid2 = t.teamid) and m.winer_teamid = t.teamid) * 3) +
(select count(*)from vmatches m where (m.teamid1 = t.teamid or m.teamid2 = t.teamid) and m.IsDraw > 0) Points

from tteams t
where t.groupid in(1, 2, 3, 4, 5, 6, 7, 8)
and t.teamid <=32;
