SET search_path TO salon;

-- 1. Заработок мастеров за всё время
SELECT 
    m.FIRST_NM AS first_name, 
    m.LAST_NM AS last_name, 
    SUM(ad.MASTER_EARNING) AS earnings
FROM Master m
JOIN Appointment a ON m.MASTER_ID = a.MASTER_ID
JOIN AppointmentsDetails ad ON a.APPOINTMENT_ID = ad.APPOINTMENT_ID
WHERE a.STATUS_NM = 'completed'
GROUP BY m.MASTER_ID, m.FIRST_NM, m.LAST_NM
ORDER BY earnings DESC;


-- 2. Топ-5 самых популярных услуг
SELECT 
    s.SERVICE_NM AS service_name, 
    COUNT(ad.SERVICE_ID) AS appointment_count
FROM Service s
JOIN AppointmentsDetails ad ON s.SERVICE_ID = ad.SERVICE_ID
JOIN Appointment a ON ad.APPOINTMENT_ID = a.APPOINTMENT_ID
WHERE a.STATUS_NM = 'completed'
GROUP BY s.SERVICE_ID, s.SERVICE_NM
ORDER BY appointment_count DESC
LIMIT 5;


-- 3. Топ-5 клиентов по оставленным деньгам
SELECT 
    c.FIRST_NM AS first_name, 
    c.PHONE_NO AS phone, 
    SUM(ad.FACT_PRICE) AS total_spent
FROM Client c
JOIN Appointment a ON c.CLIENT_ID = a.CLIENT_ID
JOIN AppointmentsDetails ad ON a.APPOINTMENT_ID = ad.APPOINTMENT_ID
WHERE a.STATUS_NM = 'completed'
GROUP BY c.CLIENT_ID, c.FIRST_NM, c.PHONE_NO
ORDER BY total_spent DESC
LIMIT 5;



-- 4. Общая выручка салона и чистая прибыль
SELECT 
    SUM(ad.FACT_PRICE) AS total_revenue,
    SUM(ad.MASTER_EARNING) AS master_salary,
    SUM(ad.FACT_PRICE) - SUM(ad.MASTER_EARNING) AS salon_income
FROM Appointment a
JOIN AppointmentsDetails ad ON a.APPOINTMENT_ID = ad.APPOINTMENT_ID
WHERE a.STATUS_NM = 'completed';



-- 5. Средний рейтинг мастеров по отзывам
SELECT 
    m.FIRST_NM AS first_name, 
    m.LAST_NM AS last_name, 
    ROUND(AVG(r.RATING_VAL), 2) AS avg_rating, 
    COUNT(r.REVIEW_ID) AS review_count
FROM Master m
JOIN Appointment a ON m.MASTER_ID = a.MASTER_ID
JOIN Review r ON a.APPOINTMENT_ID = r.APPOINTMENT_ID
GROUP BY m.MASTER_ID, m.FIRST_NM, m.LAST_NM
ORDER BY avg_rating DESC;


-- 6. Услуги, приносящие больше всего выручки
SELECT 
    s.SERVICE_NM AS service_name, 
    SUM(ad.FACT_PRICE) AS total_revenue
FROM Service s
JOIN AppointmentsDetails ad ON s.SERVICE_ID = ad.SERVICE_ID
JOIN Appointment a ON ad.APPOINTMENT_ID = a.APPOINTMENT_ID
WHERE a.STATUS_NM = 'completed'
GROUP BY s.SERVICE_ID, s.SERVICE_NM
ORDER BY total_revenue DESC
LIMIT 5;


-- 7. Полные данные об одной записи
SELECT 
    a.APPT_DTTM AS appointment_datetime,
    c.FIRST_NM AS client_name,
    m.FIRST_NM AS master_name,
    s.SERVICE_NM AS service_name,
    ad.FACT_PRICE AS list_price,
    a.BONUS_USED AS bonus_used,
    (ad.FACT_PRICE - a.BONUS_USED) AS final_amount_due
FROM Appointment a
JOIN Client c ON a.CLIENT_ID = c.CLIENT_ID
JOIN Master m ON a.MASTER_ID = m.MASTER_ID
JOIN AppointmentsDetails ad ON a.APPOINTMENT_ID = ad.APPOINTMENT_ID
JOIN Service s ON ad.SERVICE_ID = s.SERVICE_ID
WHERE a.APPOINTMENT_ID = 3;

-- 8. Будущее расписание конкретного мастера
SELECT 
    a.APPT_DTTM AS appointment_time, 
    c.FIRST_NM AS client_name, 
    c.PHONE_NO AS phone,
    s.SERVICE_NM AS service_name,
    s.DURATION_MIN AS duration_minutes
FROM Appointment a
JOIN Client c ON a.CLIENT_ID = c.CLIENT_ID
JOIN AppointmentsDetails ad ON a.APPOINTMENT_ID = ad.APPOINTMENT_ID
JOIN Service s ON ad.SERVICE_ID = s.SERVICE_ID
WHERE a.MASTER_ID = 10 AND a.STATUS_NM = 'new'
ORDER BY a.APPT_DTTM;


-- 9. Статистика по статусам записей
SELECT 
    STATUS_NM AS status, 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM Appointment), 0), 1) AS percentage_of_total
FROM Appointment
GROUP BY STATUS_NM;


-- 10. Топ-5 клиентов с наибольшим количеством бонусов
SELECT 
    FIRST_NM AS first_name, 
    PHONE_NO AS phone, 
    BONUS_BALANCE AS available_bonuses
FROM Client
ORDER BY BONUS_BALANCE DESC
LIMIT 5;
