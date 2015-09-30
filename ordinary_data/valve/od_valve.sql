/*
	qWat - QGIS Water Module

	SQL file :: valve table
*/

/* create */
CREATE TABLE qwat_od.valve ();
COMMENT ON TABLE qwat_od.valve IS 'Table for valve. Inherits from node.';

/* columns */
ALTER TABLE qwat_od.valve ADD COLUMN id integer NOT NULL REFERENCES qwat_od.node(id) PRIMARY KEY;
ALTER TABLE qwat_od.valve ADD COLUMN fk_valve_type     		 integer not null ;
ALTER TABLE qwat_od.valve ADD COLUMN fk_valve_function       integer not null ;
ALTER TABLE qwat_od.valve ADD COLUMN fk_actuation      		 integer not null ;
ALTER TABLE qwat_od.valve ADD COLUMN fk_handle_precision     integer ;
ALTER TABLE qwat_od.valve ADD COLUMN fk_handle_precisionalti integer ;
ALTER TABLE qwat_od.valve ADD COLUMN fk_maintenance    		 integer[];
ALTER TABLE qwat_od.valve ADD COLUMN diameter_nominal 		 varchar(10) ;
ALTER TABLE qwat_od.valve ADD COLUMN closed            		 boolean default false ;
ALTER TABLE qwat_od.valve ADD COLUMN networkseparation 		 boolean default false ;
ALTER TABLE qwat_od.valve ADD COLUMN node_altitude      decimal(10,3)  ;
ALTER TABLE qwat_od.valve ADD COLUMN handle_altitude    decimal(10,3)  ;
ALTER TABLE qwat_od.valve ADD COLUMN handle_geometry geometry(PointZ,:SRID);


/* constraints */
ALTER TABLE qwat_od.valve ADD CONSTRAINT valve_fk_type        FOREIGN KEY (fk_valve_type)     REFERENCES qwat_vl.valve_type(id)      MATCH FULL; CREATE INDEX fki_valve_fk_type        ON qwat_od.valve(fk_valve_type)   ;
ALTER TABLE qwat_od.valve ADD CONSTRAINT valve_fk_function    FOREIGN KEY (fk_valve_function) REFERENCES qwat_vl.valve_function(id)  MATCH FULL; CREATE INDEX fki_valve_fk_function    ON qwat_od.valve(fk_valve_function);
ALTER TABLE qwat_od.valve ADD CONSTRAINT valve_fk_actuation   FOREIGN KEY (fk_actuation)      REFERENCES qwat_vl.valve_actuation(id) MATCH FULL; CREATE INDEX fki_valve_fk_actuation   ON qwat_od.valve(fk_actuation)    ;
ALTER TABLE qwat_od.valve ADD CONSTRAINT valve_fk_handle_precision     FOREIGN KEY (fk_handle_precision)     REFERENCES qwat_vl.precision(id)     MATCH FULL; CREATE INDEX fki_valve_fk_handle_precision     ON qwat_od.valve(fk_handle_precision)    ;
ALTER TABLE qwat_od.valve ADD CONSTRAINT valve_fk_handle_precisionalti FOREIGN KEY (fk_handle_precisionalti) REFERENCES qwat_vl.precisionalti(id) MATCH FULL; CREATE INDEX fki_valve_fk_handle_precisionalti ON qwat_od.valve(fk_handle_precisionalti);

/* cannot create constraint on arrays yet
ALTER TABLE qwat_od.valve ADD CONSTRAINT valve_fk_maintenance FOREIGN KEY (fk_maintenance) REFERENCES qwat_vl.valve_maintenance(id) MATCH FULL ; CREATE INDEX fki_valve_fk_maintenance ON qwat_od.valve(fk_maintenance) ;
*/

/* Handle altitude trigger */
CREATE OR REPLACE FUNCTION qwat_od.ft_valve_handle_altitude() RETURNS TRIGGER AS
	$BODY$
	BEGIN
		-- altitude is prioritary on Z value of the geometry (if both changed, only altitude is taken into account)
		IF TG_OP = 'INSERT' THEN
			IF NEW.handle_altitude IS NULL THEN
				NEW.handle_altitude := ST_Z(NEW.handle_geometry);
			END IF;
			IF ST_Z(NEW.handle_geometry) IS NULL THEN
				NEW.handle_geometry := ST_MakePoint( ST_X(NEW.handle_geometry), ST_Y(NEW.handle_geometry), handle_altitude );
			END IF;
		ELSIF TG_OP = 'UPDATE' THEN
			IF NEW.handle_altitude <> OLD.handle_altitude THEN
				NEW.handle_geometry := ST_MakePoint( ST_X(NEW.handle_geometry), ST_Y(NEW.handle_geometry), handle_altitude );
			ELSIF ST_Z(NEW.handle_geometry) <> ST_Z(OLD.handle_geometry) THEN
				NEW.handle_altitude := ST_Z(NEW.handle_geometry);
			END IF;
		END IF;
		RETURN NEW;
	END;
	$BODY$
	LANGUAGE plpgsql;

CREATE TRIGGER valve_handle_altitude_update_trigger
	BEFORE UPDATE OF handle_altitude, handle_geometry ON qwat_od.valve
	FOR EACH ROW
	WHEN (NEW.handle_altitude <> OLD.handle_altitude OR ST_Z(NEW.handle_geometry) <> ST_Z(OLD.handle_geometry))
	EXECUTE PROCEDURE qwat_od.ft_valve_handle_altitude();
COMMENT ON TRIGGER valve_handle_altitude_update_trigger ON qwat_od.valve IS 'Trigger: when updating, check if altitude or Z value of geometry changed and synchronize them.';

CREATE TRIGGER valve_handle_altitude_insert_trigger
	BEFORE INSERT ON qwat_od.valve
	FOR EACH ROW
	EXECUTE PROCEDURE qwat_od.ft_valve_handle_altitude();
COMMENT ON TRIGGER valve_handle_altitude_insert_trigger ON qwat_od.valve IS 'Trigger: when updating, check if altitude or Z value of geometry changed and synchronize them.';
