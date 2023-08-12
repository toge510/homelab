from prometheus_client import start_http_server, Gauge
import random
import time
import yaml
import requests

with open("config.yaml") as f:
    cfg = yaml.load(f, Loader=yaml.FullLoader)
BRIDGE_IP_ADDRESS = cfg['BRIDGE_IP_ADDRESS']
USERNAME = cfg['USERNAME']
LIGHT_NO = cfg['LIGHT_NO']
API_URL = f"http://{BRIDGE_IP_ADDRESS}/api/{USERNAME}/lights/{LIGHT_NO}"

light_up_metric = Gauge('light_up', 'Light Status (ON: 1, OFF: 0)')

def update_light_status():
    while True:
        r = requests.get(API_URL)
        light_status = int(r.json()['state']['on'])
        light_up_metric.set(light_status)
        time.sleep(5)  

if __name__ == '__main__':
    start_http_server(8000)
    update_light_status()