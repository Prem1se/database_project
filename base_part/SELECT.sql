SET search_path TO salon;

-- 1. Заработок мастеров за всё время
SELECT 
    m.FIRST_NM AS Имя, 
    m.LAST_NM AS Фамилия, 
    SUM(ad.MASTER_EARNING) AS Заработок
FROM Master m
JOIN Appointment a ON m.MASTER_ID = a.MASTER_ID
JOIN AppointmentsDetails ad ON a.APPOINTMENT_ID = ad.APPOINTMENT_ID
WHERE a.STATUS_NM = 'completed'
GROUP BY m.MASTER_ID, m.FIRST_NM, m.LAST_NM
ORDER BY Заработок DESC;


-- 2. Топ-5 самых популярных услуг
SELECT 
    s.SERVICE_NM AS Услуга, 
    COUNT(ad.SERVICE_ID) AS Количество_записей
FROM Service s
JOIN AppointmentsDetails ad ON s.SERVICE_ID = ad.SERVICE_ID
JOIN Appointment a ON ad.APPOINTMENT_ID = a.APPOINTMENT_ID
WHERE a.STATUS_NM = 'completed'
GROUP BY s.SERVICE_ID, s.SERVICE_NM
ORDER BY Количество_записей DESC
LIMIT 5;


-- 3. Топ-5 клиентов по оставленным деньгам
SELECT 
    c.FIRST_NM AS Имя_клиента, 
    c.PHONE_NO AS Телефон, 
    SUM(ad.FACT_PRICE) AS Оставлено_денег
FROM Client c
JOIN Appointment a ON c.CLIENT_ID = a.CLIENT_ID
JOIN AppointmentsDetails ad ON a.APPOINTMENT_ID = ad.APPOINTMENT_ID
WHERE a.STATUS_NM = 'completed'
GROUP BY c.CLIENT_ID, c.FIRST_NM, c.PHONE_NO
ORDER BY Оставлено_денег DESC
LIMIT 5;



-- 4. Общая выручка салона и чистая прибыль
SELECT 
    SUM(ad.FACT_PRICE) AS Общая_выручка,
    SUM(ad.MASTER_EARNING) AS Зарплата_мастеров,
    SUM(ad.FACT_PRICE) - SUM(ad.MASTER_EARNING) AS Доход_салона
FROM Appointment a
JOIN AppointmentsDetails ad ON a.APPOINTMENT_ID = ad.APPOINTMENT_ID
WHERE a.STATUS_NM = 'completed';



-- 5. Средний рейтинг мастеров по отзывам
SELECT 
    m.FIRST_NM AS Имя, 
    m.LAST_NM AS Фамилия, 
    ROUND(AVG(r.RATING_VAL), 2) AS Средний_рейтинг, 
    COUNT(r.REVIEW_ID) AS Количество_отзывов
FROM Master m
JOIN Appointment a ON m.MASTER_ID = a.MASTER_ID
JOIN Review r ON a.APPOINTMENT_ID = r.APPOINTMENT_ID
GROUP BY m.MASTER_ID, m.FIRST_NM, m.LAST_NM
ORDER BY Средний_рейтинг DESC;


-- 6. Услуги, приносящие больше всего выручки
SELECT 
    s.SERVICE_NM AS Услуга, 
    SUM(ad.FACT_PRICE) AS Суммарная_выручка
FROM Service s
JOIN AppointmentsDetails ad ON s.SERVICE_ID = ad.SERVICE_ID
JOIN Appointment a ON ad.APPOINTMENT_ID = a.APPOINTMENT_ID
WHERE a.STATUS_NM = 'completed'
GROUP BY s.SERVICE_ID, s.SERVICE_NM
ORDER BY Суммарная_выручка DESC
LIMIT 5;


-- 7. Полные данные об одной записи
SELECT 
    a.APPT_DTTM AS Дата_записи,
    c.FIRST_NM AS Клиент,
    m.FIRST_NM AS Мастер,
    s.SERVICE_NM AS Услуга,
    ad.FACT_PRICE AS Цена_по_прайсу,
    a.BONUS_USED AS Списано_бонусов,
    (ad.FACT_PRICE - a.BONUS_USED) AS Итого_к_оплате
FROM Appointment a
JOIN Client c ON a.CLIENT_ID = c.CLIENT_ID
JOIN Master m ON a.MASTER_ID = m.MASTER_ID
JOIN AppointmentsDetails ad ON a.APPOINTMENT_ID = ad.APPOINTMENT_ID
JOIN Service s ON ad.SERVICE_ID = s.SERVICE_ID
WHERE a.APPOINTMENT_ID = 3;

-- 8. Будущее расписание конкретного мастера
SELECT 
    a.APPT_DTTM AS Время_записи, 
    c.FIRST_NM AS Клиент, 
    c.PHONE_NO AS Телефон,
    s.SERVICE_NM AS Услуга,
    s.DURATION_MIN AS Длительность_мин
FROM Appointment a
JOIN Client c ON a.CLIENT_ID = c.CLIENT_ID
JOIN AppointmentsDetails ad ON a.APPOINTMENT_ID = ad.APPOINTMENT_ID
JOIN Service s ON ad.SERVICE_ID = s.SERVICE_ID
WHERE a.MASTER_ID = 10 AND a.STATUS_NM = 'new'
ORDER BY a.APPT_DTTM;


-- 9. Статистика по статусам записей
SELECT 
    STATUS_NM AS Статус, 
    COUNT(*) AS Количество,
    ROUND(COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM Appointment), 0), 1) AS Процент_от_всех
FROM Appointment
GROUP BY STATUS_NM;


-- 10. Топ-5 клиентов с наибольшим количеством бонусов
SELECT 
    FIRST_NM AS Имя, 
    PHONE_NO AS Телефон, 
    BONUS_BALANCE AS Доступные_бонусы
FROM Client
ORDER BY BONUS_BALANCE DESC
LIMIT 5;
