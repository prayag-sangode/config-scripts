import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

def send_test_email(smtp_server, port, username, password, from_email, to_email):
    try:
        # Create the email message
        msg = MIMEMultipart()
        msg['From'] = 'prayag.rhce@gmail.com'  # Corrected this line
        msg['To'] = 'prayag.rhce@gmail.com'      # Corrected this line
        msg['Subject'] = 'SMTP Test Email'

        body = 'This is a test email sent from the SMTP test script.'
        msg.attach(MIMEText(body, 'plain'))

        # Connect to the SMTP server
        server = smtplib.SMTP(smtp_server, port)
        server.starttls()  # Upgrade to a secure connection
        server.login(username, password)
        server.sendmail(from_email, to_email, msg.as_string())
        server.quit()

        print(f'Email sent successfully to {to_email}')
    except Exception as e:
        print(f'Failed to send email: {e}')

if __name__ == '__main__':
    # SMTP server configuration
    smtp_server = 'smtp.gmail.com'  # Replace with your SMTP server
    port = 587  # Common port for SMTP with TLS
    username = 'prayag.rhce@gmail.com'  # Replace with your email address
    password = 'fgsi mzvr dpqn gymx'  # Replace with your app password
    from_email = 'prayag.rhce@gmail.com'  # Replace with your email address
    to_email = 'prayag.rhce@gmail.com'  # Replace with the recipient's email address

    send_test_email(smtp_server, port, username, password, from_email, to_email)
