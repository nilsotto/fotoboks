from bottle import route, run, static_file
import os
import re
import glob

app_path = os.path.dirname(os.path.realpath(__file__ ))
godkjent_path = app_path + "/bilder/godkjent/"

@route('/hello')
def hello():
    return "Hello World!"

@route('/siste')
def siste():
    files=glob.glob(godkjent_path + "*")
    filnavn = os.path.basename(sorted(files,key=os.path.getctime)[-1])
    m = re.search("[0-9]+",filnavn)
    id = m.group(0).lstrip('0')
    print(filnavn)
    siste = {'path': "/bilde/"+filnavn, "id": id}
    return siste

@route('/bilde/<filename:path>')
def send_static(filename):
    return static_file(filename, root=godkjent_path)

@route('/static/<filename:path>')
def send_static(filename):
    return static_file(filename, root=app_path)

print(godkjent_path)
run(host='localhost', port=8080, debug=True, reloader=True)
