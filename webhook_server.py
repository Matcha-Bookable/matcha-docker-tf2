#!/usr/bin/env python3
from http.server import HTTPServer, BaseHTTPRequestHandler
import subprocess
import os
import sys
import json
import gzip
import requests

BOOKINGID = int(sys.argv[1])
MATCHA_API_KEY = sys.argv[2]
DEMO_PARSER_PATH = "/home/tf2/hlserver/parse_demo"
DEMO_DIR = "/home/tf2/hlserver/tf2/tf/demos"

def parse_demo(demo_path):
    try:
        result = subprocess.run(
            [DEMO_PARSER_PATH, demo_path],
            capture_output=True,
            text=True,
            check=True
        )
        return json.loads(result.stdout)
    except (subprocess.CalledProcessError, json.JSONDecodeError) as e:
        print(f"Failed to parse demo {demo_path}: {e}", file=sys.stderr)
        return None

def upload_demo(demo_path, demo_name, presigned_url, storage_path):
    try:
        parsed_data = parse_demo(demo_path)
        if not parsed_data:
            return False
        
        with open(demo_path, 'rb') as f:
            demo_content = f.read()
        
        compressed = gzip.compress(demo_content)
        file_size = len(demo_content)
        
        # Upload to R2 using presigned URL
        upload_response = requests.put(
            presigned_url,
            data=compressed,
            headers={'Content-Type': 'application/octet-stream'}
        )
        
        if upload_response.status_code not in [200, 204]:
            print(f"Failed to upload {demo_name}: {upload_response.status_code}", file=sys.stderr)
            return False
        
        # Save metadata to storage API
        response = requests.post(
            "https://storage.matcha-bookable.com/api/demos",
            json={
                "bookingID": BOOKINGID,
                "demoName": demo_name,
                "size": file_size,
                "storagePath": storage_path,
                "parsed": parsed_data
            },
            headers={
                "Authorization": f"Bearer {MATCHA_API_KEY}",
                "Content-Type": "application/json"
            }
        )
        
        if response.status_code not in [200, 201]:
            print(f"Failed to save metadata for {demo_name}: {response.text}", file=sys.stderr)
            return False
        
        print(f"Successfully uploaded demo: {demo_name}", file=sys.stderr)
        return True
        
    except Exception as e:
        print(f"Error uploading demo {demo_name}: {e}", file=sys.stderr)
        return False

class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        auth = self.headers.get('Authorization', '')
        
        if self.path == '/upload-storage' and auth == f"Bearer {MATCHA_API_KEY}":
            # Upload logs
            os.chdir('/home/tf2/hlserver/tf2/tf/logs')
            for f in os.listdir("."):
                if os.path.isfile(f):
                    subprocess.run([
                        "curl", "-s", "-X", "POST",
                        "https://storage.matcha-bookable.com/api/logs",
                        "-F", f"bookingID={BOOKINGID}",
                        "-F", f"file=@{f}",
                        "-H", f"Authorization: Bearer {MATCHA_API_KEY}"
                    ])
            
            # Upload demos
            os.chdir(DEMO_DIR)
            for f in os.listdir("."):
                if os.path.isfile(f) and f.endswith('.dem'):
                    # Get presigned URL for this demo
                    try:
                        presigned_response = requests.post(
                            "https://storage.matcha-bookable.com/api/demos/presigned-url",
                            json={"bookingID": BOOKINGID, "fileName": f},
                            headers={"Authorization": f"Bearer {MATCHA_API_KEY}"}
                        )
                        
                        if presigned_response.status_code != 200:
                            print(f"Failed to get presigned URL for {f}: {presigned_response.text}", file=sys.stderr)
                            continue
                        
                        presigned_data = presigned_response.json()
                        presigned_url = presigned_data['presignedUrl']
                        storage_path = presigned_data['storagePath']
                        
                        upload_demo(os.path.join(DEMO_DIR, f), f, presigned_url, storage_path)
                    except Exception as e:
                        print(f"Error getting presigned URL for {f}: {e}", file=sys.stderr)
            
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(b'{"status":"success"}')
            return
        else:
            status = 401 if self.path == '/upload-storage' else 404
            message = b'{"status":"unauthorized"}' if self.path == '/upload-storage' else b'{"status":"not found"}'
            
            self.send_response(status)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(message)
            return
    
    def log_message(self, *args):
        pass

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8080), Handler)
    print(f"Webhook server started on port 8080", file=sys.stderr)
    server.serve_forever()