from flask import Flask, render_template, send_from_directory, session, request, redirect, url_for
import json, random
import atexit
from flask_socketio import Namespace, SocketIO, emit, join_room, leave_room, \
    close_room, rooms, disconnect
from pyss_db import *
import peewee
import datetime
from hashlib import sha512
import json
from flask import jsonify

app = Flask(__name__)
app.config['SECRET_KEY'] = 'sessioncontroller'

@app.route('/static/<path:path>')
def send_static(path):
    return send_from_directory('static', path)

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404


@app.route("/", methods=["GET", "POST"])
def login():
    if "email" in session and "password" in session:
        print(session)
        email = session["email"]
        password = session["password"]
        print("email postoji u sessionu")
        return log_me_in(email, password)
    elif request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]
        print("email NE postoji")
        return log_me_in(email, password)
    else:
        return render_template('index.html')

@app.route("/logout", methods=["GET"])
def logout():
    session.pop("email", None)
    session.pop("password", None)
    return redirect(url_for('login'))

def log_me_in(email, password):
    print("radim log me in")
    if obavi_check(email, password) is True:
        print("radim log me in kapula")
        session["email"] = email
        user = Users.get(email=email);
        return render_template("ulaz.html", email=user.email, firstname=user.first_name, lastname=user.last_name)
    else:
        print("log me in fail")
        return render_template('index.html', error="<b>pogrešan e-mail ili lozinka</b>")

@app.route("/register", methods=["POST"])
def register():
    print ('HELLO')
    email = request.form["email"]
    print ('IDE IF')
    if Users.select().where(Users.email == email).exists():
        print('USER POSTOJI')
        return render_template('index.html', error = "odabrani email već postoji")
    print('USER NE POSTOJI')
    password = request.form["password"]
    name = request.form["name"]
    lastname = request.form["lastname"]
    dateJoined = datetime.datetime.now()
    Users.create(first_name = name, last_name = lastname, date_joined = dateJoined, locked = False, email = email, password = hashpassword(email, password))

    session["email"] = email
    session["password"] = password
    return redirect(url_for('login'))

def obavi_check(email, password):
    try:
        user = Users.get(email=email)
        hashpass = hashpassword(email, password)
        if hashpass == user.password:
            return True
        else:
            raise peewee.DoesNotExist
    except peewee.DoesNotExist:
        return False

def hashpassword(email, password):
    salt = email[:2].lower()
    return sha512(salt.encode('utf-8') + password.encode('utf-8')).hexdigest()

@app.route("/allData", methods=["POST"])
def allData():
    print("tražim sve podatke preko ajaja")
    if "email" in session:
        email = session["email"]
        print(email + " iz sessiona")
    else:
        print("nema emaila")
        return False
    try:
        schoolid = request.form["schoolid"]
        print("prije query-ja")
        user = Users.get(email=email)
        print("poslije query-ja")
        print("----------" + str(user.id))

        eventi = Events.select().join(Users_Roles, on=(Users_Roles.school == Events.school)).where(Users_Roles.user == user)
        ostali = Users.select(Users, Roles.name.alias("rname")).join(Users_Roles).join(Roles).where(Users_Roles.school == schoolid).order_by(Users.last_name).naive()

        ostalipolje = []
        for korisnik in ostali:
            ostalipolje.append({"ime": korisnik.first_name, "prezime": korisnik.last_name, "rola": korisnik.rname})

        eventpolje = {}
        for event in eventi:
            podacice = []
            for cevent in Child_Events.select().where(Child_Events.parent_event == event.id):
                podacice.append({"ime": cevent.name, "opis": cevent.description})

            eventpolje.update({event.id: {"pocetak": event.date_begin, "kraj": event.date_end, "ime": event.name, "podacice": podacice}})

        rezultati = {"ostali": ostalipolje, "eventi": eventpolje}

        return jsonify(rezultati)

        #test test
        email = user.email
        first_name = user.first_name
        last_name = user.last_name
        date_joined = user.date_joined
        jsonobj = json.dumps({"email": email, "first_name": first_name, "last_name": last_name,
                              "date_joined": date_joined.__str__()}, ensure_ascii=False).encode('utf8')
        # jsonobj = json.dumps({"email" : email})
        print(jsonobj)
        return jsonobj
    except peewee.DoesNotExist:
        return False

@app.route("/test", methods=["POST"])
def test():
    print("primio sam ajax")
    if "email" in session:
        email = session["email"]
        print(email + " iz sessiona")

    elif "email" in request.form:
        email = request.form["email"]
        print("Acces denied")
        return False
    else:
        print("nema emaila")
        redirect(url_for('login'))
    try:
        user = Users.get(email=email)
        email = user.email
        first_name = user.first_name
        last_name = user.last_name
        date_joined = user.date_joined
        jsonobj = json.dumps({"email" : email, "first_name" : first_name, "last_name" : last_name, "date_joined" : str(date_joined)}, ensure_ascii=False).encode('utf8')
        #jsonobj = json.dumps({"email" : email})
        print (jsonobj)
        return jsonobj
    except peewee.DoesNotExist:
        return False

if __name__ == '__main__':
    socketio = SocketIO(app, async_mode="eventlet")
    socketio.run(app, debug=True, host='0.0.0.0', port=5600)


