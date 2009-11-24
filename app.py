#!/usr/bin/env python
import web
from web import form

urls = (
    '/', 'index',
    '/query/([^/]+)/(.+)', 'xml_generator')
app = web.application(urls, globals())

render = web.template.render('templates/')
db = web.database(dbn='postgres', db='whatson', user='shinra', pw='')

showform = form.Form(
    form.Textbox('channel', 
        form.notnull,
        id="channel",
        value="Comedy Central",
        tabindex="1",
        size=20),
    form.Dropdown('timezone', [
        ('eastern','Eastern'), 
        ('central','Central'), 
        ('mountain','Mountain'), 
        ('pacific','Pacific')],
        tabindex="2"))

class index:

    def GET(self):
        form = showform()
        return render.index(form)

class xml_generator:

    def GET(self, channel, timezone):
        web.header('Content-Type', 'text/xml')
        channel = channel.lower()
        shows = self.get_shows(channel, timezone)
        if shows:
            show = shows[0]
            return render.result("true", show.name.replace(" s ","\'s "), show.start_time, show.end_time)
        else:
            channels = db.query('select channel from alias where alt_name=$ch', vars={'ch': channel})
            if channels:
                shows = self.get_shows(channels[0].channel, timezone)
                if shows:
                    show = shows[0]
                    return render.result("true", show.name.replace(" s ","\'s "), show.start_time, show.end_time)           
                else:
                    return render.result("false", "", "", "")
            else: 
                return render.result("false", "", "", "")
                    
    def get_shows(self, channel, timezone):  
        shows = db.query(
            'select name, start_time, end_time from show where channel=$ch and timezone=$tz', 
            vars={'ch': channel, 'tz': timezone})
        return shows

if __name__ == "__main__":
    app.run()

