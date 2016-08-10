from bottle import route, run, static_file, request
import os
import re
import glob

app_path = os.path.dirname(os.path.realpath(__file__ ))
bilder_path = app_path + "/bilder/"
godkjent_path = app_path + "/bilder/godkjent/"

def hent_bilder(path, antall=1):
    files = glob.glob(path + "*.JPG")
    antall = (antall * -1)
    filnavn = [sorted(files, key=os.path.getctime)[int(antall):]]
    sisteliste = []
    for f in filnavn[0]:
        navnet=os.path.basename(f)
        print("FILNAVN " + f)
        print(navnet)
        m = re.search("[0-9]+", navnet)
        id = m.group(0).lstrip('0')
        basepath_ = "/bilde/"
        if (str.find(path,"godkjent") > -1):
            basepath_ = basepath_ + "godkjent/"
        siste = {'path': basepath_ + navnet, "id": id}
        sisteliste.append(siste)
    return sisteliste

@route('/tilgodkjenning')
def tilgodkjennig():
    return {"liste": hent_bilder(path=bilder_path)}

@route('/nyeste')
def nyeste():
    antall= request.params.antall or 1
    sisteliste = hent_bilder(path=godkjent_path, antall=antall)
    return {"liste": sisteliste}

@route('/bilde/<filename:path>')
def send_static(filename):
    return static_file(filename, root=bilder_path)

@route('/static/<filename:path>')
def send_static(filename):
    return static_file(filename, root=app_path)

print(godkjent_path)
run(host='localhost', port=8080, debug=True, reloader=True)
