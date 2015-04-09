select 
  m.matchid, 
  m.matchname, 
  m.matchdate,
  t1.teamname2,
  t2.teamname2,
  case 
    when m.score1 is null then 'N/A'
    when m.score2 is null then 'N/A'
    else m.score1 || ':' || m.score2 
  end score,  
  m.matchstatus,
  s.cityname, 
  s.stadiumname 
  from tmatches m
  join tstadiums s on (m.stadiumid = s.stadiumid)
  join tteams t1   on (m.teamid1 = t1.teamid)
  join tteams t2   on (m.teamid2 = t2.teamid)
 order by m.matchid;
