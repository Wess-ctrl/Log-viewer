# Log viewer
Just a log viewer to keep track of ssh login attempts, CPU temperature, RAM and disk usage.

I created and tested it mainly on Debian 13, but after installing the dependencies, the programme should be accessible on any distro. The ntfy.sh file sends the notification to the mobile phone via NTFY, which must be previously installed on the device and subscribed to a topic chosen by the user and an IP address with an open port if using your own server, otherwise you can use the default one provided by NTFY.

In order for notifications to be sent, you must change this line of code to add your own URL and topic. (The port can be opened with "sudo ufw allow (port)/tcp>" or its corresponding equivalent command).

<img width="481" height="50" alt="image" src="https://github.com/user-attachments/assets/915533f3-f402-401c-9e21-d46c477cc5bb" />

To customize notifications and the values according to which they are sent, simply change the "Notifications" section to your liking in the ntfy.sh file: 

<img width="1071" height="114" alt="image" src="https://github.com/user-attachments/assets/cb36818f-dc9f-42fa-b8f3-1509ae43c91d" />


On the other hand, the log-manager.sh script simply collects parameters such as RAM usage, temperature, etc. It displays them in the terminal in a simple style:

<img width="617" height="199" alt="image" src="https://github.com/user-attachments/assets/84e1fbf5-d76d-4815-a097-b7a8342d2db9" />

I created this mainly to learn bash scripting. It has been a great educational experience for me :)
