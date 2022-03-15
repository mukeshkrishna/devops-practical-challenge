import os
import requests
import schedule
import time
from datetime import datetime

PUBLIC_IP = os.environ.get('AWS_EC2_PUBLIC_IP')
PORT = "80"



def healthCheck(url):
    try:
        page = requests.get(url,timeout=5)
        now = datetime.now()
        if page.status_code != 200: # can use if not page.ok, page.ok will be true if the response is not 400 or 500
            print (f"{now} :: Page is NOT REACHABLE : {page.status_code}")
            # we can also implement notification using smtplib module in python
        else:
            print (f"{now} :: Page is reachable : {page.status_code}")
    except requests.exceptions.ConnectionError:
        print(f"{now} :: URL {url} not reachable")

def job():
    url = f"http://{PUBLIC_IP}:{PORT}/"
    healthCheck(url)

if __name__ == "__main__":
    schedule.every(10).seconds.do(job)
    
    while True:
        schedule.run_pending()
        time.sleep(1)
    