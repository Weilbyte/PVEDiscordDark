# Script to assist with PVEDiscordDark development
#
# By default serves HTTP on port 3000, any *.js request gets the JS script, any *.css request gets the CSS file and any image request gets corresponding image
# Meant to be used with the "Requestly" browser extension to redirect PVEDD requests from PVE server to localhost:3000
#

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os

PORT = 3000
DIR_SASS = os.path.join(os.path.dirname(__file__), "sass")
DIR_IMAGES = os.path.join(os.path.dirname(__file__), "images")
DIR_JS = os.path.join(os.path.dirname(__file__), "js")


class Server(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        return

    def _set_headers(self, status, type):
        self.send_response(status)
        self.send_header("Content-type", type)
        self.end_headers()

    def do_GET(self):
        status = 200
        type = "application/json"
        data = None

        file = self.path.rpartition("/")[2]
        ext = file.rpartition(".")[2]

        if ext == "css":
            data = open(os.path.join(DIR_SASS, "PVEDiscordDark.css"), "rb").read()
            type = "text/css"
        elif ext == "js":
            data = open(os.path.join(DIR_JS, "PVEDiscordDark.js"), "rb").read()
            type = "application/javascript"
        elif ext == "png" or ext == "jpg" or ext == "jpeg":
            try:
                data = open(os.path.join(DIR_IMAGES, file), "rb").read()
                type = f"image/{ext}"
            except FileNotFoundError:
                status = 404
        elif ext == "svg":
            try:
                data = open(os.path.join(DIR_IMAGES, file), "rb").read()
                type = f"image/svg+xml"
            except FileNotFoundError:
                status = 404
        else:
            status = 400
        self._set_headers(status, type)
        if status == 200:
            self.wfile.write(data)
        else:
            self.wfile.write(json.dumps({"error": status}).encode())


if __name__ == "__main__":
    print(f"Serving on localhost:{PORT}")
    server = HTTPServer(server_address=("", PORT), RequestHandlerClass=Server)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        quit()
