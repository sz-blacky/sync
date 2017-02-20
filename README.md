# Synchronize.au3
A short script which can be used to automate the starting of FreeFileSync on login.

Setup:

1. Compile Synchronize.au3 with AutoIt

2. Add a label to the device/partition used to transfer data (this will be used to find the device)

3. For every computer synchronized create a set of 2 ffs_batch files using FreeFileSync named COMPUTERNAME-Device_Label (used when logging out of the computer) , Device_Label-COMPUTERNAME (used when logging in to the computer) and create a new Logon and Logout script entry in the local policy.

The logon script entry should be: Synchronize.exe user_name pendrive_label login

The logout script entry should be: Synchronize.exe user_name pendrive_label logout

# Example setup

For example, let's say that my account name is BlackY on the computer WORKCOMPUTER and I set the pendrive label to SYNCDEVICE.

I would need the following files in the root of the pendrive:

* WORKCOMPUTER-SYNCDEVICE.ffs_batch

* SYNCDEVICE-WORKCOMPUTER.ffs_batch

and I would have to set up the following Logon/Logout scripts:

C:\Program Files\Synchronize\Synchronize.exe BlackY SYNCDEVICE login

and

C:\Program Files\Synchronize\Synchronize.exe BlackY SYNCDEVICE logout

# Q&A
Q: Why do I need to specify the user name on the command line?
A: This is used to exit without synchronizing if someone with another user name logs in to the computer.