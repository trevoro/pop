---
layout: post
title: "Integraing PoP with JIRA"
date:  2017-06-19 16:00:00
---
This post describes how to integrate PoP with JIRA so that you may import Epics into PoP. High level, there are three steps, each of which is described in detail further below:

1. Setting up a JIRA Application Link that describes how PoP will access JIRA

2. Configuring your instance of PoP to access JIRA via the Application Link

3. Testing that your configuration is properly set up

# Setting up the Application Link for PoP in JIRA

1. Using your JIRA Administration account, navigate to **Applications**	![people per team]({{site.baseurl}}/assets/2017/image_0.png)
	{: style="text-align: center;"}

2. On the Applications administration page, in the left nav, click on **Application Links**
3. Enter the URL of your PoP development instance (ex. [http://localhost:3000](http://localhost:3000)) and click **Create New Link**.

4. Enter details in the **Link Applications** dialog, being sure to specify **Application Name**, *Generic Application* as the **Application Type** and leaving the **Create Incoming link** checkbox *unchecked*. You can leave other settings blank at this step.	![people per team]({{site.baseurl}}/assets/2017/image_1.png)	{: style="text-align: center;"}
5. Click **Continue**. Your Application Link should now be listed in the Application Links list.6. In the list of links, click **Edit** for your Application which will show the Configuration dialog for your AppLink:	![people per team]({{site.baseurl}}/assets/2017/image_2.png)
	{: style="text-align: center;"}

7. Click the **Incoming Authentication** link:	![people per team]({{site.baseurl}}/assets/2017/image_3.png)
	{: style="text-align: center;"}

8. Within the Incoming Authentication configuration section, enter a **Consumer Key**, **Consumer Name**, and **Public Key**.

	* More information about how to create a Private/Public key pair for your JIRA application is available from Atlassian [here](https://confluence.atlassian.com/jirakb/how-to-generate-public-key-to-application-link-3rd-party-applications-913214098.html).

9. Click the **Save** button at the bottom of the configuration section, and then **Close**.

# Configuring PoP with your new AppLink settings

1. In a text editor, open this file: **/app/config/application.yml**

2. Set the **JIRA_URL** value to the root domain URL of your JIRA instance

3. Set the **JIRA_CONSUMER_KEY** value the Consumer Key you specified for the Application LInk in JIRA

4. Set the **JIRA_PRIVATE_KEY_FILE** value to the relative path for the private key file that corresponds to the public key you specified in the JIRA Application Link definition

5. Set the **JIRA_OAUTH_TOKEN** value to a random 32 character value to be used as your app’s default OAuth token

6. Set the **JIRA_OAUTH_KEY** value to a random 32 character value to be used as your app’s default OAuth key

7. Save the file

# Testing Your PoP JIRA Configuration

1. Restart your development instance of PoP

2. In JIRA, create or locate an Epic to be imported into PoP and identify the key for the Epic that you will import. Epics in JIRA take the form *PROJ_ID-EPIC_ID*.

3. Go to **Epics > Import JIRA Epics**

4. Leave the **Import Type** field set to Epic

5. In the **Jira ID** field, specify the Epic key

6. Click Import

7. You should be prompted to Allow PoP to access JIRA using your JIRA user account via a dialog that looks like this:	![people per team]({{site.baseurl}}/assets/2017/image_4.png)
	{: style="text-align: center;"}

8. After allowing the app, got to **Epics > This Week**

9. You should now see the Epic you imported listed in the set of Epics imported into PoP for the week, which confirms that your instance of PoP is properly connected to JIRA!
