alter table farm.Excludes
	add column DoNotShow tinyint(1) not null default '0',
	add column CreatedOn DateTime not null,
	add column LastUsedOn DateTime not null
; 
