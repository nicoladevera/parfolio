import http.server
import socketserver
import os
import socket
import webbrowser
import threading
import time

PORT = 8080
MARKETING_DIR = os.path.join(os.getcwd(), 'marketing')
APP_DIR = os.path.join(os.getcwd(), 'frontend', 'build', 'web')

class MultiRootHandler(http.server.SimpleHTTPRequestHandler):
    def translate_path(self, path):
        # Abandon query parameters and fragments
        path = path.split('?', 1)[0]
        path = path.split('#', 1)[0]
        
        # Serve the app from /app/
        if path.startswith('/app'):
            # Strip /app and serve from APP_DIR
            relative_path = path[len('/app'):].lstrip('/')
            return os.path.join(APP_DIR, relative_path)
        
        # Default to MARKETING_DIR for other routes
        return os.path.join(MARKETING_DIR, path.lstrip('/'))

def open_browser():
    """Wait for the server to start, then open the browser."""
    time.sleep(1)
    url = f"http://localhost:{PORT}"
    print(f"Opening browser at {url}...")
    webbrowser.open(url)

def check_backend():
    """Check if the backend is running on port 8000."""
    backend_port = 8000
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        try:
            s.settimeout(1)
            s.connect(("localhost", backend_port))
            print(f"✅ Backend detected on port {backend_port}.")
            return True
        except (socket.timeout, ConnectionRefusedError):
            print(f"❌ WARNING: Backend NOT detected on port {backend_port}!")
            print(f"   The app will fail to login or process stories.")
            print(f"   Please start the backend: 'cd backend && ./venv/bin/uvicorn main:app --reload'")
            return False

if __name__ == "__main__":
    if not os.path.exists(MARKETING_DIR):
        print(f"Error: Marketing directory not found at {MARKETING_DIR}")
        exit(1)
    
    if not os.path.exists(APP_DIR):
        print(f"Warning: App build directory NOT found at {APP_DIR}. Navigation to /app will fail.")
        print("Run 'cd frontend && flutter build web --base-href /app/' to build it.")

    # Check backend status
    check_backend()

    # Start browser in a background thread
    threading.Thread(target=open_browser, daemon=True).start()

    # Allow reuse of the address to avoid 'Address already in use' errors on restart
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", PORT), MultiRootHandler) as httpd:
        print(f"Serving at http://localhost:{PORT}")
        print(f"  Landing Page: http://localhost:{PORT}/")
        print(f"  App: http://localhost:{PORT}/app/")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")
            httpd.shutdown()
