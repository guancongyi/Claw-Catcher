# Claw-Catcher
**An internet-based claw catcher**

# Demo 
Please see this short youtube video for full demo:smiley:: https://youtu.be/82ttiICEKp4

![Alt Text](demo.gif)

# Introduction
This project consists of three components:

* Flask Web Server:  
Used Flask micro web application framework to not only serve different web pages to client, but also send/receive message to/from rabbitMQ broker. Be able to store user and game information in MongoDB Atlas cloud storage.

* Claw Machine (Raspberry Pi):  
For the claw machine end, A script is implemented to get message from RabbitMQ broker. Base on different message, the script will send ON/OFF signal to the pins on raspberry pi. Once an "ON" signal is received, the claw machine will start and music started playing. 


* Client Mobile Application (IOS):   
The IOS application will responsible for scanning QR code, and retrieve game status from time to time.

