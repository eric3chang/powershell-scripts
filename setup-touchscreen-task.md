# Setup Automatic Touchscreen Disable at Login

This guide explains how to configure Windows Task Scheduler to automatically run the `disable-touchscreen.ps1` script with Administrator privileges every time you log in.

## Prerequisites

- PowerShell script location: `${yourHomeDirectory}\powershell-scripts\disable-touchscreen.ps1`
- Administrator access to your computer
- User account: `${userAccount}`

## Step-by-Step Instructions

### 1. Open Task Scheduler as Administrator

1. Press `Win + R` to open the Run dialog
2. Type `taskschd.msc`
3. Press `Ctrl + Shift + Enter` (this runs it as Administrator)
4. Click "Yes" when prompted by User Account Control

### 2. Create a New Task

1. In Task Scheduler, click **"Create Task..."** in the right panel (not "Create Basic Task")

### 3. Configure General Settings

In the **General** tab:
- **Name:** `DisableTouchscreenAtLogin`
- **Description:** `Automatically disable touchscreen at login`
- **Security options:**
  - ✅ Check **"Run with highest privileges"**
  - ✅ Check **"Run whether user is logged on or not"** (don't do this if you don't remember your Windows password)
- **Configure for:** Windows 10 (or your Windows version)

### 4. Set Up the Trigger

1. Click the **Triggers** tab
2. Click **"New..."**
3. Configure the trigger:
   - **Begin the task:** `At log on`
   - **Settings:** Select **"Specific user"**
   - **User:** `eric3` (or browse to select your user)
   - **Delay task for:** Leave unchecked
4. Click **"OK"**

### 5. Configure the Action

1. Click the **Actions** tab
2. Click **"New..."**
3. Configure the action:
   - **Action:** `Start a program`
   - **Program/script:** `PowerShell.exe`
   - **Add arguments (optional):**
     ```
     -ExecutionPolicy Bypass -WindowStyle Hidden -File "${yourHomeDirectory}\powershell-scripts\disable-touchscreen.ps1"
     ```
   - **Start in (optional):** Leave blank
4. Click **"OK"**

### 6. Adjust Settings (Optional but Recommended)

Click the **Settings** tab and configure:
- ✅ **"Allow task to be run on demand"**
- ✅ **"If the running task does not end when requested, force it to stop"**
- **"If the task is already running, then the following rule applies:"** → `Do not start a new instance`

### 7. Finish Setup

1. Click **"OK"** to save the task
2. You'll be prompted to enter your password - this is normal for tasks that run with elevated privileges. But if you don't remember your password, go back to step 3 and see if adjusting the configurations would prevent asking for your password
3. Enter your Windows password and click **"OK"**

## Verification

### Test the Task
1. In Task Scheduler, find your task: `DisableTouchscreenAtLogin`
2. Right-click it and select **"Run"**
3. Check if the touchscreen is disabled (the script should run silently)

### Check Task History
1. Right-click the task and select **"Properties"**
2. Go to the **History** tab to see execution logs

## Troubleshooting

### Task Doesn't Run at Login
- Ensure the task is **Enabled** (right-click → Enable)
- Check the **History** tab for error messages
- Verify the PowerShell script path is correct

### Script Fails to Run
- Test the script manually by running PowerShell as Administrator
- Check the script's execution policy requirements
- Verify file permissions on the script

### UAC Prompts Still Appear
- Ensure **"Run with highest privileges"** is checked in General tab
- Make sure you entered your password when creating the task

## Removing the Task

To remove the automatic startup:
1. Open Task Scheduler as Administrator
2. Navigate to **Task Scheduler Library**
3. Find **"DisableTouchscreenAtLogin"**
4. Right-click and select **"Delete"**
5. Confirm the deletion

## Notes

- The script will run silently in the background (no visible window)
- The task only runs when the specific user logs in
- Administrator privileges are granted automatically without UAC prompts
- The task will retry if it fails initially (based on settings configured)

## Script Location Reference

The script being executed is located at:
```
${yourHomeDirectory}\powershell-scripts\disable-touchscreen.ps1
```

Make sure this file exists and is accessible before setting up the task.
