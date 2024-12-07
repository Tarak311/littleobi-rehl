import requests

# URL of the login page
login_url = 'http://10.203.132.1/check.jst'
download = 'http://10.203.132.1/troubleshooting_logs_download.jst'
# URL of the page you want to access after logging in
protected_url = 'http://10.203.132.1/troubleshooting_logs.jst'
urlv2 ="http://10.203.132.1/actionHandler/ajax_troubleshooting_logs.jst?mode=firewall&timef=Last%20month"
# Create a session object
session = requests.Session()

# Login payload (replace with actual form data)
login_payload = {
    'username': 'admin',
    'password': 'Lalohel311'
}

# Headers (optional, can include User-Agent, etc.)
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36'
}
headersv2 = {
    'mode': 'firewall',
    'timef': 'Today'
}
# Send POST request to login
response = session.post(login_url, data=login_payload, headers=headers)
#responsev2 = session.post(urlv2, data=login_payload, headers=headersv2)
# Check if login was successful
if response.ok:
    print('Login successful!')

    # Access the protected page
    protected_response = session.get(urlv2)
    newresp = session.get(download)

    # Check if the request was successful
    if protected_response.ok:
        print('Accessed protected page!')
        print(protected_response.text)  # Print the HTML content of the protected page
    else:
        print('Failed to access protected page')
else:
    print('Login failed')
