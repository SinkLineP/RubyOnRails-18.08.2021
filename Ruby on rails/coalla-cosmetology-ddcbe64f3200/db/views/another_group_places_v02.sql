SELECT row_number() over (partition by course_id, min_begin_practice_date, times, schedule order by title) as group_number, t.* FROM
(SELECT id,
        course_id,
        course_short_name,
        title,
        schedule,
        min(begin_practice_date) as min_begin_practice_date,
        string_agg(practice_date, '\n') as dates,
        string_agg(practice_time, '\n') as times,
        distances_place,
        distances_count,
        (distances_place - distances_count) as remaining_seats_count
FROM
(SELECT trim(groups.schedule_description) as  schedule,
        courses.short_name as course_short_name,
        practices.begin_on as begin_practice_date,
        concat_ws(' - ', TO_CHAR(practices.begin_on, 'dd.mm.yy'), TO_CHAR(practices.end_on, 'dd.mm.yy')) as practice_date,
        concat_ws(' - ', TO_CHAR(practices.start_time, 'HH24:MI'), TO_CHAR(practices.end_time, 'HH24:MI')) as practice_time,
        groups.*
FROM groups
INNER JOIN practices ON practices.group_id = groups.id
INNER JOIN courses ON courses.id = groups.course_id
WHERE groups.deleted_at IS NULL
AND groups.active = true
AND (practices.begin_on <= CURRENT_DATE AND practices.end_on >= CURRENT_DATE)
ORDER BY practices.begin_on, groups.id) c
GROUP BY id, title, course_id, course_short_name, schedule, distances_place, distances_count) t
ORDER BY title
