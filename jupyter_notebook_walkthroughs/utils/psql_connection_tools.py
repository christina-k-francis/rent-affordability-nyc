"""
Functions for PostgreSQL to Python Connections
"""
from sqlalchemy import create_engine
from sqlalchemy_utils import database_exists, create_database

def get_engine(user,pwd,host,port,db):
    url = f"postgresql://{user}:{pwd}@{host}:{port}/{db}"
    if not database_exists(url):
        print(f"{db} DB doesn't exist, created it!")
        create_database(url)
    engine = create_engine(url, pool_size=50, echo=False)
    return engine