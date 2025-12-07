#!/usr/bin/env python3
from http.server import HTTPServer, BaseHTTPRequestHandler
import subprocess
import os
import sys

BOOKINGID = int(sys.argv[1])
MATCHA_API_KEY = sys.argv[2]

class Handler(BaseHTTPRequestHandler):
    def do_POST(self):
        auth = self.headers.get('Authorization', '')
        
        if self.path == '/upload-storage' and auth == f"Bearer {MATCHA_API_KEY}":
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
    
    def log_message(self, *args):
        pass

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 8080), Handler)
    print(f"Webhook server started on port 8080", file=sys.stderr)
    server.serve_forever()
