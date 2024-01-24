<h1> USBTesla</h1>

A simple and quick way to create a wifi usb drive using a Raspberry Pi SBC to easily change your boombox and lockchime sounds over your home network via the browser.

<h2>But wait, why ??</h2>

<p>Tesla recent holiday update allows you to change the sound your car makes when you lock it, this is called the Lock chime. In order to change the sound you need to plug in a USB Drive to your car and have a file called LockChime.wav on the root of your USB.</p>
<p>For vehicles equipmed with the Pedestrian Warning Sound Tesla allows you to change the sound of your Horn. This can be used to play any sound (to the outside) via the external loudspeaker.</p>
<p>All you need to play your own sounds is a USB stick. This can be a "retrofitted" one (IMPORTANT The USB stick must be formatted in ExFAT format), but also the original USB stick supplied by Tesla, which is located in the glove compartment.</p>
<p>But who wants to keep bringing the USB drive inside to change these sounds ? :)</p>

<p>This is really just a script that automates the process to create the USB Drive that can be accessed via your browser. After the instalation is complete you can access the files by poiting your browser to http://USBTesla.local </p>

<h2>Requirements:</h2>

<p>1x Raspberry Pi Zero</p>
<p>1x MicroSD card of at least 32Gb. This script will ask you to choose between 4Gb, 8Gb or 16Gb</p>
<p>1x Power AND Data cable to connect the Raspberry Pi to your Tesla.</p>

<h2> Installation instructions</h2>

<p>There are two steps you'll need to complete before installing USBTesla.</p>
<p>- Prepare the Raspberry Pi</p>
<p>- Power On and Connect to the Raspberry Pi</p>

<p>After these two steps, installation is very simple. </p>
<p>Just run the following command from your Pi</p>
<code>bash -c "$(curl -fsSL https://raw.githubusercontent.com/iFredLouzada/USBTesla/main/USBTesla_setup.sh)"</code>

<h2>Preparing the Raspberry Pi</h2>

<p>Download and install Raspberry Pi Imager to your computer - https://www.raspberrypi.com/software/ </p>
<img width="688" alt="pi1" src="https://github.com/iFredLouzada/USBTesla/assets/1254565/c286cef3-3865-4e26-8e26-22bde1d82728">
<p>Launch Raspberry Pi Imager</p>
<p>Plug your Micro SD card into your computer's card reader.</p>
<p>Click 'Choose device' and scroll to select 'Raspberry Pi Zero' (this covers Zero, Zero W, and Zero WH).</p>
<img width="687" alt="p2" src="https://github.com/iFredLouzada/USBTesla/assets/1254565/775ce1b3-7dbc-48a9-ac8e-75aa599a9385">
<p>Click 'Choose OS'. </p>
<p>Click Raspberry Pi OS (Other) and then 'Raspberry Pi OS Legacy 32 bit lite' – no need for a graphical interface and extra software.</p>
<img width="688" alt="p3" src="https://github.com/iFredLouzada/USBTesla/assets/1254565/7b45b4da-12b4-499a-83b4-163b25c8fcaf">
<img width="687" alt="p4" src="https://github.com/iFredLouzada/USBTesla/assets/1254565/54c71283-6d13-4c35-a68f-069962c8aaec">
<p>Click on 'Storage' and carefully select your MicroSD card from the list. Watch out for the USB symbol indicating an external device. Choose wisely to avoid any mishaps!</p>
<img width="690" alt="p5" src="https://github.com/iFredLouzada/USBTesla/assets/1254565/17ae5029-a785-4d8e-b8f6-8e94b2171885">
<p>After clicking NEXT, the Imager will ask if you want to customize the OS. Hit 'EDIT Settings'</p>
<img width="688" alt="Screenshot 2024-01-23 at 7 43 24 PM" src="https://github.com/iFredLouzada/USBTesla/assets/1254565/a0163ff0-ec9f-4deb-b57c-17519e08d470">
<p>Hostname: Name it something simple like 'USBTesla' for easy access later.</p>
<p>Username and Password: The defaults are “pi” and “raspberry”, but feel free to set your own for added security.</p>
<p>Wireless LAN Details: Enter your Wi-Fi's SSID and password. Set the Wireless LAN country (mine's CA) and adjust the locale settings to match your timezone and keyboard input.</p>
<img width="543" alt="Screenshot 2024-01-23 at 7 43 51 PM" src="https://github.com/iFredLouzada/USBTesla/assets/1254565/1e99c4be-1b9a-4116-96c6-86f20b48cc29">
<p>Select the Services tab and ensure SSH is enabled</p> 
<img width="547" alt="Screenshot 2024-01-23 at 7 43 59 PM" src="https://github.com/iFredLouzada/USBTesla/assets/1254565/bc03a659-6aff-4d0a-983b-eb36ddcf8896">
<p>Hit 'SAVE' once you're done.</p>
<p>Confirm and Install: Click YES to confirm your custom settings. A warning will pop up about erasing the MicroSD card. Proceed with YES, and the Imager will work its magic. When it's done, it'll let you know it's time to remove the MicroSD card.</p>

<h2>Power On and Connect to the Raspberry Pi</h2>

<p>Once you've finished with the Raspberry Pi Imager, gently remove the MicroSD card from your computer and slot it into your Pi Zero. It's like inserting the key to a treasure chest!
<p>Connect to Power and Data: Now, grab a USB power and data cable. For now, we're connecting it to your computer, not your Tesla. We're just getting warmed up!

<h3>Choosing the Right Port</h3>h3>
<p>Take a closer look at your Pi Zero. You'll notice it flaunts two micro USB ports. One is labeled 'PWR' and the other 'USB'.

<p>PWR Port: This one's a one-trick pony – it only provides power.
<p>USB Port: This is your star player. It's a dual-threat, offering both POWER and DATA capabilities. Make sure your cable is up for the task – it needs to handle both power and data.

<h3>Connecting to Your Raspberry Pi</h3>

<p>Remember the hostname you set in the Raspberry Pi Imager? It's showtime for 'USBTesla' (or whatever creative name you chose).</p>
<p>ping usbtesla.local</p>

<p>Replace 'usbtesla' with your hostname if you chose a different one. For example, ping modelx.local for the hostname 'modelx'.</p>
<p>Note the IP Address: If the stars align and your network is feeling friendly, the command will return an IP address, something like 192.168.0.121. Jot this down; it's your golden key.</p>
<p><b>NOTE: Give enough time after plugin in your Raspberry Pi for it to boot. The first time, this process might take 5-10 minutes. Only proceed when the ping command is succesful</b></p>

<p>Remote Connection Time: Still in your command prompt or terminal, it's time to remotely connect to your Pi. Use the following command:</p>

<code>ssh pi@usbtesla.local</code>

<p>Success: If all goes well, you'll be greeted by the welcoming text of your Raspberry Pi's command line. You're in!</p>
<p></p>
<p>Just run the following command from your Pi</p>
<code>bash -c "$(curl -fsSL https://raw.githubusercontent.com/iFredLouzada/USBTesla/main/USBTesla_setup.sh)"</code>

<h2>Credits:</h2>

<p>FileBrowser is a simple, easy to use web interface for file management. https://github.com/filebrowser/filebrowser</p>
<p>MagPi, the official raspberry pi magazine, in particular this article https://magpi.raspberrypi.com/articles/pi-zero-w-smart-usb-flash-drive</p>


