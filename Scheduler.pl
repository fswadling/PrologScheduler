isNextDay(Date, Next) :-
    Date = date(Y,M,D),
    Dnxt is D + 1,
    date_time_stamp(date(Y,M,Dnxt,0,0,0,0,-,-), StampNext),
  	stamp_date_time(StampNext, Dat, 0),
  	date_time_value(date, Dat, DateNxt),
    DateNxt = Next.

isPreviousDay(Date, Next) :- 
    Date = date(Y,M,D),
    Dnxt is D - 1,
    date_time_stamp(date(Y,M,Dnxt,0,0,0,0,-,-), StampNext),
  	stamp_date_time(StampNext, Dat, 0),
  	date_time_value(date, Dat, DateNxt),
    DateNxt = Next.

isNextWeek(Date, Next) :-
    Date = date(Y,M,D),
    Dnxt is D + 7,
    date_time_stamp(date(Y,M,Dnxt,0,0,0,0,-,-), StampNext),
  	stamp_date_time(StampNext, Dat, 0),
  	date_time_value(date, Dat, DateNxt),
    DateNxt = Next.

isPreviousWeek(Date, Next) :-
    Date = date(Y,M,D),
    Dnxt is D - 7,
    date_time_stamp(date(Y,M,Dnxt,0,0,0,0,-,-), StampNext),
  	stamp_date_time(StampNext, Dat, 0),
  	date_time_value(date, Dat, DateNxt),
    DateNxt = Next.

isNextMonth(Date, Next) :-
    Date = date(Y,M,D),
    Mnxt is M + 1,
    date_time_stamp(date(Y,Mnxt,D,0,0,0,0,-,-), StampNext),
  	stamp_date_time(StampNext, Dat, 0),
  	date_time_value(date, Dat, DateNxt),
    DateNxt = Next.

isPreviousMonth(Date, Next) :-
    Date = date(Y,M,D),
    Mnxt is M + 1,
    date_time_stamp(date(Y,Mnxt,D,0,0,0,0,-,-), StampNext),
  	stamp_date_time(StampNext, Dat, 0),
  	date_time_value(date, Dat, DateNxt),
    DateNxt = Next.

isWeekend(Date) :-
    day_of_the_week(Date, Day),
    (Day = 6; Day = 7).

isWeekDay(Date) :- not(isWeekend(Date)).

dateIsAfter(Date, Ref) :-
    Date @> Ref.

dateIsBefore(Date, Ref) :-
    Date @=< Ref.

dateIsRolledIfInvalid(Date, RolledDate, IsValidGoal, RollStratagy) :-
    (call(IsValidGoal, Date), Date = RolledDate) ;
    (call(RollStratagy, Date, NextDate), dateIsRolledIfInvalid(NextDate, RolledDate, IsValidGoal, RollStratagy)), !.

dateIsRolledToNextValidDayIfAWeekend(Date, RolledDate) :- 
    dateIsRolledIfInvalid(Date, RolledDate, isWeekDay, isNextDay).

dateIsRolledToPreviousValidDayIfAWeekend(Date, RolledDate) :- 
    dateIsRolledIfInvalid(Date, RolledDate, isWeekDay, isPreviousDay).

weeklyRolledSchedule(Head, End, Schedule, Accumulator) :-
    dateIsRolledToNextValidDayIfAWeekend(Head, AdjDate),
    dateIsAfter(AdjDate, End),
    reverse(Accumulator, Schedule).

weeklyRolledSchedule(Head, End, Schedule, Accumulator) :-
    dateIsRolledToNextValidDayIfAWeekend(Head, AdjDate),
    not(dateIsAfter(AdjDate, End)),
    isNextWeek(Head, NextDate),
    weeklyRolledSchedule(NextDate, End, Schedule, [AdjDate|Accumulator]).

weeklyRolledSchedule(Start, End, Schedule) :-
    weeklyRolledSchedule(Start, End, Schedule, []), !.

