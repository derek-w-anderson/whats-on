#! /usr/bin/env python
import psycopg2
import re
import time
import urllib

TIMEZONES = (('eastern', 199), ('central', 200), ('mountain', 201), ('pacific', 202))

def main():

    pattern = re.compile(r"""
        <ul[ ]class="shows"><li[ ]class="
        show[ ]dur_(?P<duration>[0-9\.]*)[ ]+
        start_(?P<start>[0-9]*)[ ]+
        tribid_(?P<tribid>[0-9]*)[ ]+
        epId_(?P<epId>[0-9]*)[ ]+
        chNum_(?P<chNum>[0-9]*)[ ]+
        showid_(?P<showid>[0-9]*)[ ]+
        ((before|after)[ ]+)*
        stationId_(?P<stationId>[0-9]*)[ ]+
        callSign_(?P<channel>\S*)[ ]+
        repeat_(?P<repeat>\S*)[ ]+
        cc_(?P<cc>\S*)[ ]+
        mpaa_(?P<rating>\S*)[ ]+
        dvs_(?P<dvs>\S*)[ ]+
        hdtv_(?P<hdtv>[^"]*)"[ ]+
        style="width:[-0-9\.]+px;[ ]+left:[-0-9]+px;"><div><strong>[ ]*
        (?P<start_hour>[0-9]{1,2}):(?P<start_min>[0-9]{2})(?P<start_period>[apm]{2})[ -]*
        (?P<end_hour>[0-9]{1,2}):(?P<end_min>[0-9]{2})(?P<end_period>[apm]{2})</strong>[ ]*
        <a[ ]\S+[ ]*class="showTitle">(?P<show>[^<]+)
        (.*)$
    """, re.VERBOSE)

    fail = re.compile(r""""
        <ul[ ]class="shows"><li[ ]class="
        show[ ]dur_[0-9\.]*[ ]+
        start_[0-9]*[ ]*
        (before|after)*">
        (.*)$
    """, re.VERBOSE)

    conn = psycopg2.connect("dbname='whatson' user='shinra' password=''")
    cur = conn.cursor()
    
    starttime = int(time.time()) # seconds since the epoch
    for tz, tzid in TIMEZONES:
        source = urllib.urlopen('http://tv.yahoo.com/listings?starttime=' + str(starttime) + '&provider=' + str(tzid))
        for line in source:        
            line = line.strip()
            if line.find('<ul class="shows">') != -1 and not fail.match(line):
                line = pattern.match(line)
                channel = line.group('channel').lower()
                show = line.group('show')
                start = line.group('start_hour') + ":" + line.group('start_min') + line.group('start_period')
                end = line.group('end_hour') + ":" + line.group('end_min') + line.group('end_period')
                #print channel, show, start + "-" + end, tz            
                cur.execute("select put_show('%s','%s','%s','%s','%s')" % (channel, show, start, end, tz))

    conn.commit()
    conn.close()
    
if __name__ == '__main__':
    main()
    
