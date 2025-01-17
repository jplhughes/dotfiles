#!/bin/bash

# Add public keys to authorized_keys
if [ -n "$PUBLIC_KEY" ]; then
    mkdir -p /root/.ssh
    echo "$PUBLIC_KEY" > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

# Login to huggingface
source .venv/bin/activate
python -c "from huggingface_hub.hf_api import HfFolder; import os; HfFolder.save_token(os.environ['HF_TOKEN'])"

# Generate SSH host keys
ssh-keygen -A
# Start SSH service
service ssh start


# Print sshd logs to stdout
tail -f /var/log/auth.log &

# Start a simple server that serves the content of main.log on port 10101
# Create main.log if it doesn't exist
touch main.log

# Start a simple Python HTTP server to serve main.log
python -c '
import http.server
import socketserver

class LogHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        with open("main.log", "rb") as f:
            self.wfile.write(f.read())

with socketserver.TCPServer(("", 10101), LogHandler) as httpd:
    httpd.serve_forever()
' &

# keep the container running by default
if [ -n "$USE_ZSH" ] && [ "$USE_ZSH" = "true" ]; then
    /bin/zsh
else
    exec tail -f /dev/null
fi

