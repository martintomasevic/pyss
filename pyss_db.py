from peewee import *
from playhouse.shortcuts import RetryOperationalError
import sys


class MyRetryDB(RetryOperationalError, MySQLDatabase):
    pass


try:
    pyss_db = MyRetryDB("pyss", user="pyss", passwd="pyss1", host="localhost")
except KeyError:
    sys.exit(1)


class BaseModel(Model):
    # Initialize Peewee's connection
    class Meta:
            database = pyss_db


class Countries(BaseModel):
    id = PrimaryKeyField()
    name = CharField(max_length=50)

class Cities(BaseModel):
    id = PrimaryKeyField()
    name = CharField(max_length=50)
    postal_code = CharField(max_length=15)
    country = ForeignKeyField(Countries)

class Users(BaseModel):
    id = PrimaryKeyField()
    first_name = CharField(max_length=50)
    last_name = CharField(max_length=50)
    phone_number = CharField(max_length=20)
    email = CharField(max_length=50)
    date_joined = DateTimeField()
    locked = SmallIntegerField()
    password = CharField(max_length=200)

class Schools(BaseModel):
    id = PrimaryKeyField()
    oib = CharField(max_length=20)
    name = CharField(max_length=50)
    short_name = CharField(max_length=20)
    phone_number = CharField(max_length=15)
    street_name = CharField(max_length=50)
    street_number = CharField(max_length=5)
    city = ForeignKeyField(Cities)

class Events(BaseModel):
    id = PrimaryKeyField()
    date_begin = DateTimeField()
    date_end = DateTimeField()
    name = CharField(50)
    no_students = IntegerField()
    weekly_classes = IntegerField()
    goal = CharField(max_length=300)
    purpose = CharField(max_length=300)
    realization = CharField(max_length=500)
    evaluation = CharField(max_length=300)
    results = CharField(max_length=300)
    costs = CharField(max_length=300)
    school = ForeignKeyField(Schools)

class Child_Events(BaseModel):
    id = PrimaryKeyField()
    name = CharField(max_length=50)
    description = CharField(max_length=200)
    date_begin = DateTimeField()
    date_end = DateTimeField()
    parent_event = ForeignKeyField(Events)

class Event_Holders(BaseModel):
    id = PrimaryKeyField()
    event = ForeignKeyField(Events)
    holder = ForeignKeyField(Users)

class Event_Users(BaseModel):
    id = PrimaryKeyField()
    event = ForeignKeyField(Child_Events)
    user = ForeignKeyField(Users)

class Roles(BaseModel):
    id = PrimaryKeyField()
    name = CharField(max_length=50)

class Pending_User_Evaluations(BaseModel):
    id = PrimaryKeyField()
    user = ForeignKeyField(Users)
    school = ForeignKeyField(Schools)
    role = ForeignKeyField(Roles)

class Users_Roles(BaseModel):
    id = PrimaryKeyField()
    user = ForeignKeyField(Users)
    school = ForeignKeyField(Schools)
    role = ForeignKeyField(Roles)