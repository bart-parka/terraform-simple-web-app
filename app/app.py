#!/usr/bin/python
import flask
import pandas
import os
import requests
import json
app = flask.Flask(__name__)


def get_top_stories():
    r = requests.get("https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty")
    return json.loads(r.text)


def get_story_detail(story_id):
    r = requests.get("https://hacker-news.firebaseio.com/v0/item/{}.json?print=pretty".format(story_id))
    return json.loads(r.text)


@app.route("/")
def main():
    top_stories = get_top_stories()[:20]  # Only interested in top 20

    stories_dict = {}  # To be converted to html table

    for story_id in top_stories:
        story_detail = get_story_detail(story_id)
        stories_dict[story_id] = {
            "Title": story_detail["title"],
            "URL": story_detail.get("url", "URL Not Found")
        }

    df = pandas.DataFrame.from_dict(stories_dict, orient='index')

    resp = flask.Response("""
    <h1 style='color:blue'>Hacker News!</h1>
    <form action="{}">
      <input type="submit" value="Reload Top Hacker News" />
    </form>
    {}
    """.format(flask.url_for('main'), df.to_html(render_links=True, escape=False)))
    return resp


if __name__ == "__main__":
    port = int(os.environ.get('PORT', 5050))
    app.run(host='0.0.0.0', port=port)
