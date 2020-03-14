from pymongo import MongoClient

class mongodb:
    def __init__(self):
        client = MongoClient("mongodb://gcy:guancongyi@cluster0-shard-00-00-tt8ml.mongodb.net:27017,cluster0-shard-00-01-tt8ml.mongodb.net:27017,cluster0-shard-00-02-tt8ml.mongodb.net:27017/test?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true")
        self.db = client['db']
        self.coll = self.db['test']

    def add(self, name, password):
        #cursor = self.coll.find()
        self.coll.insert_one({'username':name, 'password':password, 'attempts': 3})

    def is_exist(self, name, password):
        if self.coll.find({'username':name, 'password': password}).count()>0:
            return True
        return False

