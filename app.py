#!/usr/bin/env python
import web
from web import form

render = web.template.render('templates/')
db = web.database(dbn='postgres', db='whatson', user='shinra', pw='')

urls = (
    '/', 'index',
    '/query/([^/]+)/(.+)', 'xml_generator'
)
app = web.application(urls, globals())


TIMEZONES = [
    ('eastern', 'Eastern'),
    ('central', 'Central'),
    ('mountain', 'Mountain'),
    ('pacific', 'Pacific')
]
show_form = form.Form(
    form.Textbox('channel', form.notnull, value="Comedy Central", tabindex="1", size=20),
    form.Dropdown('timezone', TIMEZONES, tabindex="2")
)

class index:
    """
    Renders main page of the app. 
    """
    def GET(self):
        form = show_form()
        return render.index(form)

class xml_generator:
    """
    Generates XML data for AJAX requests sent from the index page. 
    """
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

            return render.result("false", "", "", "")
                    
    def get_shows(self, channel, timezone):  
        shows = db.query(
            'select name, start_time, end_time from show where channel=$ch and timezone=$tz', 
            vars={'ch': channel, 'tz': timezone})
        return shows

if __name__ == "__main__":
    app.run()

