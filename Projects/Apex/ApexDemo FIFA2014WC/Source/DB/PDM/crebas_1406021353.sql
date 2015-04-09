/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     02.06.2014 14:41:58                          */
/*==============================================================*/



-- Type package declaration
create or replace package PDTypes  
as
    TYPE ref_cursor IS REF CURSOR;
end;

-- Integrity package declaration
create or replace package IntegrityPackage AS
 procedure InitNestLevel;
 function GetNestLevel return number;
 procedure NextNestLevel;
 procedure PreviousNestLevel;
 end IntegrityPackage;
/

-- Integrity package definition
create or replace package body IntegrityPackage AS
 NestLevel number;

-- Procedure to initialize the trigger nest level
 procedure InitNestLevel is
 begin
 NestLevel := 0;
 end;


-- Function to return the trigger nest level
 function GetNestLevel return number is
 begin
 if NestLevel is null then
     NestLevel := 0;
 end if;
 return(NestLevel);
 end;

-- Procedure to increase the trigger nest level
 procedure NextNestLevel is
 begin
 if NestLevel is null then
     NestLevel := 0;
 end if;
 NestLevel := NestLevel + 1;
 end;

-- Procedure to decrease the trigger nest level
 procedure PreviousNestLevel is
 begin
 NestLevel := NestLevel - 1;
 end;

 end IntegrityPackage;
/


drop trigger tBets_bi_x
/

alter table tBets
   drop constraint FK_REFERENCE_2
/

alter table tMatches
   drop constraint FK_REFERENCE_1
/

alter table tMatches
   drop constraint FK_REFERENCE_3
/

alter table tMatches
   drop constraint FK_REFERENCE_4
/

alter table tTeams
   drop constraint FK_REFERENCE_5
/

alter table tTeams
   drop constraint FK_REFERENCE_6
/

drop index tMatches_tBets
/

drop table tBets cascade constraints
/

drop table tGroups cascade constraints
/

drop index tTeams2_tMatches
/

drop index tTeams1_tMatches
/

drop index tStadiums_tMatches
/

drop table tMatches cascade constraints
/

drop table tStadiums cascade constraints
/

drop index tTeams_tTeams
/

drop index tGroups_tTeams
/

drop table tTeams cascade constraints
/

drop sequence tBets_seq
/

create sequence tBets_seq
/

/*==============================================================*/
/* Table: tBets                                                 */
/*==============================================================*/
create table tBets 
(
   BetID                NUMBER(6)            not null,
   BetDate              DATE                 default SYSDATE,
   PlayerAccount        VARCHAR2(30)         default 'USER',
   MatchID              NUMBER(6),
   Score1               NUMBER(6),
   Score2               NUMBER(6),
   constraint PK_TBETS primary key (BetID)
)
/

comment on column tBets.BetID is
'Внутренний номер ставки'
/

comment on column tBets.BetDate is
'Дата и время ставки'
/

comment on column tBets.PlayerAccount is
'Логин игрока'
/

comment on column tBets.MatchID is
'Внутренний номер матча'
/

comment on column tBets.Score1 is
'Забили хозяева'
/

comment on column tBets.Score2 is
'Забили гости'
/

/*==============================================================*/
/* Index: tMatches_tBets                                        */
/*==============================================================*/
create index tMatches_tBets on tBets (
   MatchID ASC
)
/

/*==============================================================*/
/* Table: tGroups                                               */
/*==============================================================*/
create table tGroups 
(
   GroupID              NUMBER(6)            not null,
   GroupName            VARCHAR2(255),
   constraint PK_TGROUPS primary key (GroupID)
)
/

comment on column tGroups.GroupID is
'Внутренний номер группы'
/

comment on column tGroups.GroupName is
'Наименование группы'
/

/*==============================================================*/
/* Table: tMatches                                              */
/*==============================================================*/
create table tMatches 
(
   MatchID              NUMBER(6)            not null,
   MatchName            VARCHAR2(255),
   MatchDate            DATE,
   TeamID1              NUMBER(6),
   TeamID2              NUMBER(6),
   StadiumID            NUMBER(6),
   Score1               NUMBER(6),
   Score2               NUMBER(6),
   MatchStatus          VARCHAR2(255),
   constraint PK_TMATCHES primary key (MatchID)
)
/

comment on column tMatches.MatchID is
'Внутренний номер матча'
/

comment on column tMatches.MatchName is
'Наименование матча'
/

comment on column tMatches.MatchDate is
'Дата и время матча'
/

comment on column tMatches.TeamID1 is
'Команда хозяйка'
/

comment on column tMatches.TeamID2 is
'Команда гость'
/

comment on column tMatches.StadiumID is
'Внутренний номер стадиона'
/

comment on column tMatches.Score1 is
'Забили хозяева'
/

comment on column tMatches.Score2 is
'Забили гости'
/

comment on column tMatches.MatchStatus is
'Состояние матча'
/

/*==============================================================*/
/* Index: tStadiums_tMatches                                    */
/*==============================================================*/
create index tStadiums_tMatches on tMatches (
   StadiumID ASC
)
/

/*==============================================================*/
/* Index: tTeams1_tMatches                                      */
/*==============================================================*/
create index tTeams1_tMatches on tMatches (
   TeamID1 ASC
)
/

/*==============================================================*/
/* Index: tTeams2_tMatches                                      */
/*==============================================================*/
create index tTeams2_tMatches on tMatches (
   TeamID2 ASC
)
/

/*==============================================================*/
/* Table: tStadiums                                             */
/*==============================================================*/
create table tStadiums 
(
   StadiumID            NUMBER(6)            not null,
   StadiumName          VARCHAR2(255),
   CityName             VARCHAR2(255),
   constraint PK_TSTADIUMS primary key (StadiumID)
)
/

comment on column tStadiums.StadiumID is
'Внутренний номер стадиона'
/

comment on column tStadiums.StadiumName is
'Наименование стадиона'
/

comment on column tStadiums.CityName is
'Наименование города'
/

/*==============================================================*/
/* Table: tTeams                                                */
/*==============================================================*/
create table tTeams 
(
   TeamID               NUMBER(6)            not null,
   TeamName             VARCHAR2(255),
   TeamName2            VARCHAR2(255),
   GroupID              NUMBER(6),
   ParentID             NUMBER(6),
   constraint PK_TTEAMS primary key (TeamID)
)
/

comment on column tTeams.TeamID is
'Внутренний номер команды'
/

comment on column tTeams.TeamName is
'Наименование команды'
/

comment on column tTeams.TeamName2 is
'Наименование команды по русски'
/

comment on column tTeams.GroupID is
'Ссылка на внутренний номер фактической команды'
/

comment on column tTeams.ParentID is
'Фактическая команда'
/

/*==============================================================*/
/* Index: tGroups_tTeams                                        */
/*==============================================================*/
create index tGroups_tTeams on tTeams (
   GroupID ASC
)
/

/*==============================================================*/
/* Index: tTeams_tTeams                                         */
/*==============================================================*/
create index tTeams_tTeams on tTeams (
   ParentID ASC
)
/

alter table tBets
   add constraint FK_REFERENCE_2 foreign key (MatchID)
      references tMatches (MatchID)
/

alter table tMatches
   add constraint FK_REFERENCE_1 foreign key (StadiumID)
      references tStadiums (StadiumID)
/

alter table tMatches
   add constraint FK_REFERENCE_3 foreign key (TeamID1)
      references tTeams (TeamID)
/

alter table tMatches
   add constraint FK_REFERENCE_4 foreign key (TeamID2)
      references tTeams (TeamID)
/

alter table tTeams
   add constraint FK_REFERENCE_5 foreign key (ParentID)
      references tTeams (TeamID)
/

alter table tTeams
   add constraint FK_REFERENCE_6 foreign key (GroupID)
      references tGroups (GroupID)
/


create or replace trigger tBets_bi_x before insert on tBets for each row
begin
  if :new.BetID
  is null then  
    select tBets_seq.nextval into :new.BetID
      from dual;
  end if;  
end;
/

