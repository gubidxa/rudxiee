SELECT
	j.journal_id, j.action_type, j.code,
	b.lat, b.lon, b.name, b.city, b.state, b.country
FROM airports.airports_journal j
LEFT JOIN airports.airports b ON b.code = j.code
WHERE j.journal_id > :sql_last_value
	AND j.action_time < NOW()
ORDER BY j.journal_id