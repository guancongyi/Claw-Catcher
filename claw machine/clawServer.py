# server
import pika
import sys
import RPi.GPIO as GPIO
import time
import os
import threading

GPIO_TRIGGER = 18
GPIO_ECHO = 24
gotIt=0

def gpio_setUp():
	# claw catcher
	GPIO.setwarnings(False)
	GPIO.setmode(GPIO.BCM)
	GPIO.setup(23, GPIO.OUT)
	
	# sensor
	#set GPIO Pins

	#set GPIO direction (IN / OUT)
	GPIO.setup(GPIO_TRIGGER, GPIO.OUT)
	GPIO.setup(GPIO_ECHO, GPIO.IN)


def distance():
    # set Trigger to HIGH
    GPIO.output(GPIO_TRIGGER, True)
 
    # set Trigger after 0.01ms to LOW
    time.sleep(0.00001)
    GPIO.output(GPIO_TRIGGER, False)
 
    StartTime = time.time()
    StopTime = time.time()
 
    # save StartTime
    while GPIO.input(GPIO_ECHO) == 0:
        StartTime = time.time()
 
    # save time of arrival
    while GPIO.input(GPIO_ECHO) == 1:
        StopTime = time.time()
 
    # time difference between start and arrival
    TimeElapsed = StopTime - StartTime
    # multiply with the sonic speed (34300 cm/s)
    # and divide by 2, because there and back
    distance = (TimeElapsed * 34300) / 2
 
    return distance

def caught():
	return distance() > 2000


def start():			
	def t1():
		# play music
		os.system("omxplayer clawcatcher.mp3")
	def t2():
		# not caught or time up
		global gotIt
		count = 0
		while not caught():
			now = time.time()
			GPIO.output(23, GPIO.LOW)
			elapsed= time.time() - now
			print(count)
			time.sleep(1.-elapsed)
			if count == 25:			
				print(gotIt)
				GPIO.output(23, GPIO.HIGH)
				return ''

			count+=1
		gotIt = 1
		GPIO.output(23, GPIO.HIGH)
		
		
	
	thread1 = threading.Thread(target=t1)
	thread2 = threading.Thread(target=t2)
	
	thread1.start()
	thread2.start()
	
	thread1.join()
	thread2.join()
	
	ret = ''
	
	if gotIt == 1:
		ret = 'caught'
	else:
		ret = 'try_again'
		
	return ret
	

	
	
	

def on_request(ch, method, props, body):
	# convert bytes to string
	msg = body.decode('utf-8')
	
	ret = ''
	if msg == 'start':
		print(msg)
		ret = start()
	print('off')
	
		
	ch.basic_publish(exchange='', routing_key=props.reply_to, properties=pika.BasicProperties(correlation_id = props.correlation_id),body = str(ret))
	ch.basic_ack(delivery_tag = method.delivery_tag)
                     
                     
if __name__ == "__main__":
	# setup gpio
    gpio_setUp()
    
    # create queue and subscribe message
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()
    channel.queue_declare(queue='rpc_queue')
    channel.basic_qos(prefetch_count=1) 
    channel.basic_consume(on_request, queue='rpc_queue')
    
    channel.start_consuming() # waiting
