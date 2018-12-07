from flask import Flask, redirect, render_template, request, session, abort
import os, sys
import dataBase, messageQ
import threading

app = Flask(__name__)
global serverIP
result = ''

@app.route('/')
def home():
    def t2():
        global result
        mq = messageQ.MQ(serverIP)
        response = mq.call('start')
        # convert response to string
        result = response.decode('utf-8')

    def t1():
        pass
        #print(1)
        #render_template('home.html')

    thread1 = threading.Thread(target=t1)
    thread2 = threading.Thread(target=t2)

    thread1.start()
    thread2.start()

    thread1.join()
    thread2.join()

    return render_template('home.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    error = None
    if request.method == 'POST':
        if request.form['button1'] == 'Register':

            # check if the passwords are the same
            if request.form['password'] != request.form['confirm_password']:
                error = 'Password is not consistent'
            else:
                # check if the user exists
                if db.is_exist(request.form['username'], request.form['password']):
                    error = 'Already exists'
                else:
                    db.add(request.form['username'], request.form['password'])
                    return redirect('/')

    return render_template('register.html', error=error)

@app.route('/login', methods=['GET','POST'])
def login():
    global result
    error = None
    if request.method == 'POST':
        if request.form['button1'] == 'Login':
            if db.is_exist(request.form['username'], request.form['password']):
                result = ''
                return redirect('/')
            else:
                error = 'Invalid Username or password'

        elif request.form['button1'] == 'Register':
            return redirect('/register')

    return render_template('login.html', error=error)

@app.route('/status', methods=['GET','POST'])
def status():

    return result

if __name__ == "__main__":
    # initialize message queue and database
    db = dataBase.mongodb()
    serverIP = sys.argv[1]

    app.secret_key = os.urandom(12)
    app.run(debug=True, host='0.0.0.0', port=80)

