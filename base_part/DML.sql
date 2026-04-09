SET search_path TO salon;

COPY Client FROM '/data/client.csv' DELIMITER ',' CSV HEADER;
COPY Master FROM '/data/master.csv' DELIMITER ',' CSV HEADER;
COPY Service FROM '/data/service.csv' DELIMITER ',' CSV HEADER;
COPY Appointment FROM '/data/appointment.csv' DELIMITER ',' CSV HEADER;
COPY AppointmentsDetails FROM '/data/appointmentsDetails.csv' DELIMITER ',' CSV HEADER;
COPY Review FROM '/data/review.csv' DELIMITER ',' CSV HEADER;