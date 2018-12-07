import pika
import uuid


class MQ():
    def __init__(self, IP):
        credentials = pika.PlainCredentials('gcy', 'password')
        self.connection = pika.BlockingConnection(pika.ConnectionParameters(IP,
                                                                            5672,
                                                                            '/',
                                                                            credentials))
        self.channel = self.connection.channel()
        result = self.channel.queue_declare(exclusive=True)
        self.callback_queue = result.method.queue

        self.channel.basic_consume(self.on_response, no_ack=True,
                                   queue=self.callback_queue)

    def on_response(self, ch, method, props, body):
        if self.corr_id == props.correlation_id:
            self.response = body

    def call(self, payload):
        self.response = None
        self.corr_id = str(uuid.uuid4())
        self.channel.basic_publish(exchange='',
                                   routing_key='rpc_queue',
                                   properties=pika.BasicProperties(
                                       reply_to=self.callback_queue,
                                       correlation_id=self.corr_id, ), body=payload)
        while self.response is None:
            self.connection.process_data_events()

        return self.response
