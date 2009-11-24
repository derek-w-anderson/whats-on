DROP TABLE IF EXISTS channel CASCADE;
CREATE TABLE channel (
    name            varchar(40),
    PRIMARY KEY (name)
);

DROP TABLE IF EXISTS show;
CREATE TABLE show (
    id              serial,
    name            varchar(240),
    channel         varchar(40),
    start_time      varchar(8),
    end_time        varchar(8),
    timezone        varchar(10),
    PRIMARY KEY (id),
    FOREIGN KEY (channel) REFERENCES channel(name)
);

DROP TABLE IF EXISTS alias;
CREATE TABLE alias (
    alt_name        varchar(40),
    channel         varchar(40),
    PRIMARY KEY (alt_name),
    FOREIGN KEY (channel) REFERENCES channel(name)
);

CREATE LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION put_show(varchar(40), varchar(240), varchar(8), varchar(8), varchar(10))
RETURNS boolean AS $$
DECLARE
    _channel ALIAS FOR $1;
    _name ALIAS FOR $2;
    _start ALIAS FOR $3;
    _end ALIAS FOR $4;
    _tz ALIAS FOR $5;
BEGIN
    UPDATE show SET name=_name, start_time=_start, end_time=_end WHERE channel=_channel AND timezone=_tz;
    IF NOT FOUND THEN
        INSERT INTO show VALUES (DEFAULT, _name, _channel, _start, _end, _tz);
    END IF;
    RETURN true;
END;
$$ LANGUAGE plpgsql;

INSERT INTO channel VALUES ('abc');
INSERT INTO channel VALUES ('cbs');
INSERT INTO channel VALUES ('fox');
INSERT INTO channel VALUES ('tvgn');
INSERT INTO channel VALUES ('ktvd');
INSERT INTO channel VALUES ('kgcw');
INSERT INTO channel VALUES ('wdfx');
INSERT INTO channel VALUES ('abcw');
INSERT INTO channel VALUES ('cbsw');
INSERT INTO channel VALUES ('foxw');
INSERT INTO channel VALUES ('nbcw');
INSERT INTO channel VALUES ('kcop');
INSERT INTO channel VALUES ('pbsw');
INSERT INTO channel VALUES ('cww');
INSERT INTO channel VALUES ('nbc');
INSERT INTO channel VALUES ('bbc');
INSERT INTO channel VALUES ('pbs');
INSERT INTO channel VALUES ('spk');
INSERT INTO channel VALUES ('cw');
INSERT INTO channel VALUES ('a&e');
INSERT INTO channel VALUES ('animal');
INSERT INTO channel VALUES ('ion');
INSERT INTO channel VALUES ('wwor');
INSERT INTO channel VALUES ('amc');
INSERT INTO channel VALUES ('bet');
INSERT INTO channel VALUES ('bravo');
INSERT INTO channel VALUES ('cnbc');
INSERT INTO channel VALUES ('cnn');
INSERT INTO channel VALUES ('comedy');
INSERT INTO channel VALUES ('trutv');
INSERT INTO channel VALUES ('espn');
INSERT INTO channel VALUES ('e!');
INSERT INTO channel VALUES ('abcfam');
INSERT INTO channel VALUES ('fnc');
INSERT INTO channel VALUES ('food');
INSERT INTO channel VALUES ('fx');
INSERT INTO channel VALUES ('kfxp');
INSERT INTO channel VALUES ('we');
INSERT INTO channel VALUES ('we-w');
INSERT INTO channel VALUES ('hgtv');
INSERT INTO channel VALUES ('hist');
INSERT INTO channel VALUES ('histw');
INSERT INTO channel VALUES ('ifc');
INSERT INTO channel VALUES ('life');
INSERT INTO channel VALUES ('oxygn');
INSERT INTO channel VALUES ('msnbc');
INSERT INTO channel VALUES ('mtv');
INSERT INTO channel VALUES ('nik');
INSERT INTO channel VALUES ('syfy');
INSERT INTO channel VALUES ('tbs');
INSERT INTO channel VALUES ('tcm');
INSERT INTO channel VALUES ('telmun');
INSERT INTO channel VALUES ('dsc');
INSERT INTO channel VALUES ('tlc');
INSERT INTO channel VALUES ('tnt');
INSERT INTO channel VALUES ('toon');
INSERT INTO channel VALUES ('travel');
INSERT INTO channel VALUES ('tvland');
INSERT INTO channel VALUES ('twc');
INSERT INTO channel VALUES ('uni');
INSERT INTO channel VALUES ('uni-m');
INSERT INTO channel VALUES ('usa');
INSERT INTO channel VALUES ('vh1');
INSERT INTO channel VALUES ('max');
INSERT INTO channel VALUES ('disney');
INSERT INTO channel VALUES ('enc');
INSERT INTO channel VALUES ('hbo');
INSERT INTO channel VALUES ('sho');
INSERT INTO channel VALUES ('starz');
INSERT INTO channel VALUES ('stzw');
INSERT INTO channel VALUES ('sund');
INSERT INTO channel VALUES ('tmc');

INSERT INTO alias VALUES ('tv guide', 'tvgn');
INSERT INTO alias VALUES ('tv guide network', 'tvgn');
INSERT INTO alias VALUES ('british broadcasting corporation', 'bbc');
INSERT INTO alias VALUES ('british broadcasting corp', 'bbc');
INSERT INTO alias VALUES ('public broadcasting service', 'pbs');
INSERT INTO alias VALUES ('spike', 'spk');
INSERT INTO alias VALUES ('spike tv', 'spk');
INSERT INTO alias VALUES ('the cw', 'cw');
INSERT INTO alias VALUES ('upn', 'cw');
INSERT INTO alias VALUES ('wb', 'cw');
INSERT INTO alias VALUES ('a and e', 'a&e');
INSERT INTO alias VALUES ('animal planet', 'animal');
INSERT INTO alias VALUES ('american movie classics', 'amc');
INSERT INTO alias VALUES ('black entertainment television', 'bet');
INSERT INTO alias VALUES ('black entertainment', 'bet');
INSERT INTO alias VALUES ('black entertainment tv', 'bet');
INSERT INTO alias VALUES ('comedy central', 'comedy');
INSERT INTO alias VALUES ('comety central', 'comedy');
INSERT INTO alias VALUES ('tru tv', 'trutv');
INSERT INTO alias VALUES ('true tv', 'trutv');
INSERT INTO alias VALUES ('truetv', 'trutv');
INSERT INTO alias VALUES ('e', 'e!');
INSERT INTO alias VALUES ('abc family', 'abcfam');
INSERT INTO alias VALUES ('fox news', 'fnc');
INSERT INTO alias VALUES ('fox news channel', 'fnc');
INSERT INTO alias VALUES ('faux news', 'fnc');
INSERT INTO alias VALUES ('faux news channel', 'fnc');
INSERT INTO alias VALUES ('food network', 'food');
INSERT INTO alias VALUES ('we tv', 'we');
INSERT INTO alias VALUES ('home and garden', 'hgtv');
INSERT INTO alias VALUES ('home and garden television', 'hgtv');
INSERT INTO alias VALUES ('home & garden', 'hgtv');
INSERT INTO alias VALUES ('home & garden television', 'hgtv');
INSERT INTO alias VALUES ('history', 'hist');
INSERT INTO alias VALUES ('history channel', 'hist');
INSERT INTO alias VALUES ('the history channel', 'hist');
INSERT INTO alias VALUES ('independent film channel', 'ifc');
INSERT INTO alias VALUES ('lifetime', 'life');
INSERT INTO alias VALUES ('oxygen', 'oxygn');
INSERT INTO alias VALUES ('nick', 'nik');
INSERT INTO alias VALUES ('nickelodeon', 'nik');
INSERT INTO alias VALUES ('scifi', 'syfy');
INSERT INTO alias VALUES ('sci fi', 'syfy');
INSERT INTO alias VALUES ('sci fi channel', 'syfy');
INSERT INTO alias VALUES ('turner', 'tcm');
INSERT INTO alias VALUES ('turner classic movies', 'tcm');
INSERT INTO alias VALUES ('telemundo', 'telmun');
INSERT INTO alias VALUES ('discovery', 'dsc');
INSERT INTO alias VALUES ('discovery channel', 'dsc');
INSERT INTO alias VALUES ('the discovery channel', 'dsc');
INSERT INTO alias VALUES ('cartoon network', 'toon');
INSERT INTO alias VALUES ('travel channel', 'travel');
INSERT INTO alias VALUES ('nick at nite', 'tvland');
INSERT INTO alias VALUES ('nick-at-nite', 'tvland');
INSERT INTO alias VALUES ('tv land', 'tvland');
INSERT INTO alias VALUES ('weather', 'twc');
INSERT INTO alias VALUES ('weather channel', 'twc');
INSERT INTO alias VALUES ('the weather channel', 'twc');
INSERT INTO alias VALUES ('the disney channel', 'disney');
INSERT INTO alias VALUES ('disney channel', 'disney');
INSERT INTO alias VALUES ('home box office', 'hbo');
INSERT INTO alias VALUES ('showtime', 'sho');
INSERT INTO alias VALUES ('sundance', 'sund');
INSERT INTO alias VALUES ('the movie channel', 'tmc');

