<h1>Cisco AnyConnect Client with Umbrella Module</h1>
In some circumstances the Cisco Umbrella client clashes with VPN clients as they both work at the application level. In order to resolve this you can use the Cisco AnyConnect client with the Umbrella module. This works at the kernel level and stops the two clients from clashing.

<h1>How to use</h1>
The <b>OrgInfo.json</b> file needs editing - the details you need should be available as part of your Umbrella config. Contact the Umbrella support team if you are unabe to find them.

Running <b>install.cmd</b> will need running. It will uninstall any versions of the Umbrella roaming client first and then install the modules necessary for the AnyConnect client.

Profit.
