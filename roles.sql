
/* create roles */
DROP ROLE IF EXISTS qwat_viewer;
DROP ROLE IF EXISTS qwat_user;
DROP ROLE IF EXISTS qwat_manager;
DROP ROLE IF EXISTS qwat_sysadmin;

CREATE ROLE qwat_viewer NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
CREATE ROLE qwat_user NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
CREATE ROLE qwat_manager NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
CREATE ROLE qwat_sysadmin NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

/* Viewer */
GRANT USAGE ON SCHEMA qwat_dr  TO qwat_viewer;
GRANT USAGE ON SCHEMA qwat_od  TO qwat_viewer;
GRANT USAGE ON SCHEMA qwat_sys TO qwat_viewer;
GRANT USAGE ON SCHEMA qwat_vl  TO qwat_viewer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA qwat_dr  TO qwat_viewer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA qwat_od  TO qwat_viewer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA qwat_sys TO qwat_viewer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA qwat_vl  TO qwat_viewer;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA qwat_dr  TO qwat_viewer;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA qwat_od  TO qwat_viewer;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA qwat_sys TO qwat_viewer;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA qwat_vl  TO qwat_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_dr  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO qwat_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_od  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO qwat_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_sys GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO qwat_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_vl  GRANT SELECT, REFERENCES, TRIGGER ON TABLES TO qwat_viewer;

/*
-- Revok
REVOKE ALL ON SCHEMA qwat_dr  FROM qwat_viewer;
REVOKE ALL ON SCHEMA qwat_od  FROM qwat_viewer;
REVOKE ALL ON SCHEMA qwat_sys FROM qwat_viewer;
REVOKE ALL ON SCHEMA qwat_vl  FROM qwat_viewer;
REVOKE ALL ON ALL TABLES IN SCHEMA qwat_dr  FROM qwat_viewer;
REVOKE ALL ON ALL TABLES IN SCHEMA qwat_od  FROM qwat_viewer;
REVOKE ALL ON ALL TABLES IN SCHEMA qwat_sys FROM qwat_viewer;
REVOKE ALL ON ALL TABLES IN SCHEMA qwat_vl  FROM qwat_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_dr  REVOKE ALL ON TABLES  FROM qwat_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_od  REVOKE ALL ON TABLES  FROM qwat_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_sys REVOKE ALL ON TABLES  FROM qwat_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_vl  REVOKE ALL ON TABLES  FROM qwat_viewer;
*/

/* User */
GRANT qwat_viewer TO qwat_user;
GRANT ALL ON SCHEMA qwat_dr TO qwat_user;
GRANT ALL ON SCHEMA qwat_od TO qwat_user;
GRANT ALL ON ALL TABLES IN SCHEMA qwat_dr TO qwat_user;
GRANT ALL ON ALL TABLES IN SCHEMA qwat_od TO qwat_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA qwat_dr TO qwat_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA qwat_od TO qwat_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_dr GRANT ALL ON TABLES TO qwat_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_od GRANT ALL ON TABLES TO qwat_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_dr GRANT ALL ON SEQUENCES TO qwat_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_od GRANT ALL ON SEQUENCES TO qwat_user;

/* Manager */
GRANT qwat_user TO qwat_manager;
GRANT ALL ON SCHEMA qwat_vl TO qwat_manager;
GRANT ALL ON ALL TABLES IN SCHEMA qwat_od TO qwat_manager;
GRANT ALL ON ALL SEQUENCES IN SCHEMA qwat_vl TO qwat_manager;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_vl GRANT ALL ON TABLES TO qwat_manager;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_vl GRANT ALL ON SEQUENCES TO qwat_manager;

/* SysAdmin */
GRANT qwat_manager TO qwat_sysadmin;
GRANT ALL ON SCHEMA qwat_sys TO qwat_sysadmin;
GRANT ALL ON ALL TABLES IN SCHEMA qwat_sys TO qwat_sysadmin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA qwat_sys TO qwat_sysadmin;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_sys GRANT ALL ON TABLES TO qwat_sysadmin;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_sys GRANT ALL ON SEQUENCES TO qwat_sysadmin;
