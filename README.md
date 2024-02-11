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

<h2>Power On and Connect to the Raspberry Pi</h2>

<p>Once you've finished with the Raspberry Pi Imager, gently remove the MicroSD card from your computer and slot it into your Pi Zero. It's like inserting the key to a treasure chest!
<p>Connect to Power and Data: Now, grab a USB power and data cable. For now, we're connecting it to your computer, not your Tesla. We're just getting warmed up!

<h3>Choosing the Right Port</h3>
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


